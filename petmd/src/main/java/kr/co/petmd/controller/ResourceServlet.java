package kr.co.petmd.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.petmd.GlobalContext;
import kr.co.petmd.utils.admin.Config;


public class ResourceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		if(pathInfo == null)
			return;
		
		String fileSystemPath = Config.IMAGE_PATH_ROOT;
		
		// 사진 폴더 생성
		File portraitDirectory = new File(fileSystemPath);		
		if(!portraitDirectory.exists() || !portraitDirectory.isDirectory())
			portraitDirectory.mkdirs();
				
		
		String srcName = fileSystemPath + File.separator + pathInfo;
//		System.out.println("원본 이미지 요청 : " + srcName);
		File srcFile = new File(srcName);
		
		if(srcFile.exists() && srcFile.isFile()){
			OutputStream out = null;
			try{
				out = response.getOutputStream();
				BufferedImage bi = ImageIO.read(srcFile);
				
				int pos = pathInfo.lastIndexOf('.');
				if(pos > -1){
					String ext = pathInfo.substring(pos);
					
					if( ext.startsWith("png")){
						response.setContentType("image/png");
						ImageIO.write(bi, "png", out);					
					}else if(ext.startsWith("gif")) {
						response.setContentType("image/gif");
						ImageIO.write(bi, "gif", out);					
					}else{
						response.setContentType("image/jpg");
						ImageIO.write(bi, "jpg", out);
					}
				}
			}finally{
				if(out != null){
					out.close();
					out = null;
				}
			}
		}
	}

}
