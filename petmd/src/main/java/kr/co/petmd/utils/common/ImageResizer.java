package kr.co.petmd.utils.common;

import java.awt.Color;
import java.awt.Container;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import sun.misc.BASE64Encoder;

import com.sun.image.codec.jpeg.ImageFormatException;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class ImageResizer {
	
	/**
	 * 이미지 크기를 조절.
	 * 
	 * @param src 원본이미지
	 * @param newWidth 0보다 작을 경우 무시
	 * @param newHeight 0보다 작을 경우 무시
	 * @param allowReduce 원본이미지보다 작게 resize할 경우, 축소 허락함
	 * @param allowExpand 원본이미지보다 크게 resize할 경우, 확대 허락함
	 * @param rateFixed 비율 유지 (2014-02-05 기준, 옵션 적용 미구현)
	 * @return
	 */
	
	public static BufferedImage resize(BufferedImage src, int newWidth, int newHeight, boolean allowReduce, boolean allowExpand){
		
		return ImageResizer.resize(src, newWidth, newHeight, allowReduce, allowExpand, false);
	}
	
	/*
	 * rateFixed 무조건 resize크기로 맞춤
	 */
	
	public static BufferedImage resize(BufferedImage src, int newWidth, int newHeight, boolean allowReduce, boolean allowExpand, boolean rateFixed){
		
		int imageWidth = src.getWidth();
		int imageHeight = src.getHeight();
		
		int canvasW = newWidth;
		int canvasH = newHeight;
		
		/* 사이즈 확인용
		System.out.println("newWidth :" + newWidth);
		System.out.println("newHeight :" + newHeight);
		System.out.println("imageWidth :" + imageWidth);
		System.out.println("imageHeight :" + imageHeight);
		 */
		
		// 가로를 기준으로 맞춤
		if(newWidth > 0 && newHeight < 0){
			
			// resize 너비가 이미지보다 작을 경우
			// 축소를 허락하지 않으면 newWidth = 원본width
			if(!allowReduce && newWidth < imageWidth)
				newWidth = imageWidth;
			
			// resize 너비가 이미지보다 클 경우
			// 확대를 허락하지 않으면 newWidth = 원본width
			if(!allowExpand && newWidth > imageWidth)
				newWidth = imageWidth;
			
//			if(rateFixed){
				newHeight = (int)((double)newWidth * (double)imageHeight / (double)imageWidth + 0.5);
//			}
//			else{
//				newHeight = imageHeight;
//			}
		}
		// 세로를 기준으로 맞춤
		else if(newWidth < 0 && newHeight > 0){
			
			if(!allowReduce && newHeight < imageHeight)
				newHeight = imageHeight;
			
			if(!allowExpand && newHeight > imageHeight)
				newHeight = imageHeight;
			
			newWidth = newHeight * imageWidth / imageHeight;
		}
		// 둘 다 맞춤
		else if(newWidth > 0 && newHeight > 0){
			
			if(!allowReduce && newWidth < imageWidth)
				newWidth = imageWidth;
			
			if(!allowExpand && newWidth > imageWidth)
				newWidth = imageWidth;
			
			if(!allowReduce && newHeight < imageHeight)
				newHeight = imageHeight;
			
			if(!allowExpand && newHeight > imageHeight)
				newHeight = imageHeight;
			
//			if(rateFixed){
//				
//				if(newWidth < imageWidth){
//					newWidth = imageWidth;
//
//					newHeight = (int)((double)newWidth * (double)imageHeight / (double)imageWidth + 0.5);
//				}
//				
//				if(newHeight > imageHeight){
//					newHeight = imageHeight;
//				
//					newWidth = (int)((double)newHeight * (double)imageWidth / (double)imageHeight + 0.5);
//				}
//				
//				if(!allowExpand && newWidth > imageWidth){
//					newWidth = imageWidth;
//				
//					newHeight = (int)((double)newWidth * (double)imageHeight / (double)imageWidth + 0.5);
//				}
//				
//				if(!allowExpand && newHeight > imageHeight){
//					newHeight = imageHeight;
//					
//					newWidth = (int)((double)newHeight * (double)imageWidth / (double)imageHeight + 0.5);
//				}
//			}
		}
		// 아무것도 아님
		else{
			//newWidth = imageWidth;
			//newHeight = imageHeight;
		}
		
		canvasW = newWidth;
		canvasH = newHeight;

//		BufferedImage thumbImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
		BufferedImage thumbImage = new BufferedImage(canvasW, canvasH, BufferedImage.TYPE_INT_RGB);

		Graphics2D graphics2D = thumbImage.createGraphics();
		graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
		graphics2D.setBackground(Color.BLACK);
		graphics2D.clearRect(0, 0, newWidth, newHeight);
		graphics2D.drawImage(src, 0, 0, newWidth, newHeight, null);
		
		return thumbImage;
	}
	
	
}
