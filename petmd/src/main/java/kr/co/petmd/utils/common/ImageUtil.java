package kr.co.petmd.utils.common;

import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;

import sun.misc.BASE64Encoder;

import com.sun.image.codec.jpeg.ImageFormatException;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class ImageUtil {

	/**
	 * 디스크에서 이미지 파일을 읽어 BufferdImage를 반환, 실패시 null
	 * 
	 * @param filePath
	 * @return
	 */
	@SuppressWarnings("finally")
	public static BufferedImage getImageInstance(String filePath){
		
		File f = new File(filePath);
		InputStream input = null;
		BufferedImage bufferedImage = null;
		try {
			input = new FileInputStream(f);
			bufferedImage = ImageIO.read(input);
			//input.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			
			if(input != null)
				try {
					input.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			return bufferedImage;
		}
	}
	
	/**
	 * 이미지를 base64문자열로 변환(JPG 이미지로 변환 후 BASE64로 변환)
	 * 
	 * @param image 원본 이미지
	 * @param quality JPG이미지 품질 (최대100)
	 * @return
	 */
	
	public static String getBase64String(BufferedImage image, int quality){
		
		ByteArrayOutputStream bao = new ByteArrayOutputStream(8196);
		JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(bao);
		JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(image);
		quality = Math.max(0, Math.min(quality, 100));
		param.setQuality((float)quality / 100.0f, false);
		encoder.setJPEGEncodeParam(param);
		try {
			encoder.encode(image);
			bao.close();
		} catch (ImageFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		BASE64Encoder base64encoder = new BASE64Encoder();
		
		return base64encoder.encode(bao.toByteArray());
	}
	
	/**
	 * 이미지를 디스크에 저장(JPG로 변환하여 저장)
	 * 
	 * @param image 원본 이미지
	 * @param filePath 파일 경로
	 * @param newFileName 파일 이름
	 * @param quality JPG이미지 품질 (최대 100)
	 * @return
	 */
	
	public static int writeImage(BufferedImage image, String filePath, String newFileName, int quality) {
		try {
			
			File targetFile = new File(filePath + newFileName);
			if(targetFile.exists() == false){
				targetFile.getParentFile().mkdirs();
			}
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(targetFile));
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(bos);
			JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(image);
			quality = Math.max(0, Math.min(quality, 100));
			param.setQuality((float)quality / 100.0f, false);
			encoder.setJPEGEncodeParam(param);
			encoder.encode(image);
			bos.close();

			return 1;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (ImageFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return -1;
	}
}
