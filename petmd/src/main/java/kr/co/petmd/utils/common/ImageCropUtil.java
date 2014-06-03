package kr.co.petmd.utils.common;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import javax.imageio.ImageIO;

/**
 * 이미지 CROP 유틸
 * @author moo
 *
 */
public class ImageCropUtil {
	private BufferedImage buffer;
	 
    public ImageCropUtil(File file) throws IOException {
        buffer = ImageIO.read(file);
    }
 
    public ImageCropUtil(URL url) throws IOException {
        buffer = ImageIO.read(url);
    }
 
    public ImageCropUtil(InputStream stream) throws IOException {
        buffer = ImageIO.read(stream);
    }
 
    public ImageCropUtil(BufferedImage buffer) {
        this.buffer = buffer;
    }
 
    public int getWidth() {
        return buffer.getWidth();
    }
 
    public int getHeight() {
        return buffer.getHeight();
    }
    
    public ImageCropUtil resize(int width, int height, boolean resultNewInstance) {
        BufferedImage dest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = dest.createGraphics();
        g.setComposite(AlphaComposite.Src);
        g.drawImage(buffer, 0, 0, width, height, null);
        g.dispose();
        if(resultNewInstance)
        	return new ImageCropUtil(dest);
        else{
        	this.buffer = dest;
        	return this;
        }
    }
 
    public ImageCropUtil resize(int width, int height) {
    	return resize(width, height, true);
    }
    
    public ImageCropUtil resize(int width, boolean resultNewInstance) {
    	
    	int resizedHeight = (width * buffer.getHeight()) / buffer.getWidth();
        return resize(width, resizedHeight, resultNewInstance);
    }
 
    public ImageCropUtil resize(int width) {
        int resizedHeight = (width * buffer.getHeight()) / buffer.getWidth();
        return resize(width, resizedHeight, true);
    }
 
    public ImageCropUtil crop(int x, int y, int width, int height) {
        return crop(x, y, width, height, true);
    }
    
    public ImageCropUtil crop(int x, int y, int width, int height, boolean resultNewInstance) {
        BufferedImage dest = new BufferedImage(width, height,
            BufferedImage.TYPE_INT_RGB);
        Graphics2D g = dest.createGraphics();
        g.setComposite(AlphaComposite.Src);
        g.drawImage(buffer, 0, 0, width, height, x, y, x + width, y + height,
            null);
        g.dispose();
        if(resultNewInstance)
        	return new ImageCropUtil(dest);
        else{
        	this.buffer = dest;
        	return this;
        }
    }
    
    public BufferedImage getBufferedImage(){
    	
    	return this.buffer;
    }
 
    public void writeTo(OutputStream stream, String formatName)
            throws IOException {
        ImageIO.write(buffer, formatName, stream);
    }
 
    public boolean isSuppoprtedImageFormat() {
        return buffer != null ? true : false;
    }

    
    public static void main(String[] args) {
    	try {
    		File ori = new File("d:/747_1000.jpg");
    		ImageCropUtil icu = new ImageCropUtil(ori);
    		icu = icu.crop(100, 100, 150, 250);
    		
    		File out = new File("d:/747_1000_2.jpg");
    		FileOutputStream fos = new FileOutputStream(out);
    		
    		icu.writeTo(fos, "jpg");
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
	}
}
