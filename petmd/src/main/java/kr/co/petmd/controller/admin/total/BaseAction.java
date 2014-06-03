package kr.co.petmd.controller.admin.total;

import java.util.Map;

import javax.servlet.http.HttpSession;

import kr.co.petmd.dao.SqlDao;
import kr.co.petmd.utils.admin.Config;
import kr.co.petmd.utils.common.Common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;


/**
 * 샵과 통합관리자 레이아웃과 공통 사용
 * @author HanYongil
 *
 */
public class BaseAction {
	
	protected String shopViewName = "/shop/layout/layout"; 
	protected String totalViewName = "admin/total/layout/layout";
	protected static final Logger logger = LoggerFactory.getLogger(BaseAction.class);
	
	/**
	 * page layout setting
	 * @param model	map으로 셋팅 값 put
	 * @param mainMenu	상단 메뉴
	 * @param leftMenu	왼쪽 메뉴
	 * @param body	내용
	 * @param containerName	왼쪽 메뉴 상단 제목
	 */
	protected void setLayout(Model model, String mainMenu, String leftMenu, String body, String containerName) {
		if (Common.isValid(mainMenu))
			model.addAttribute("mainMenu", "/WEB-INF/views/admin/total/" +mainMenu);
		if (Common.isValid(leftMenu))
			model.addAttribute("leftMenu", "/WEB-INF/views/admin/total/" +leftMenu);
		if (Common.isValid(body))
			model.addAttribute("body", "/WEB-INF/views/admin/total/" + body);
		model.addAttribute("containerName", containerName);
	}
}
