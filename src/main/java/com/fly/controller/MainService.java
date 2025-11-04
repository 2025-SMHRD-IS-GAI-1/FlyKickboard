package com.fly.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fly.frontcontroller.Command;

public class MainService implements Command {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		return "redirect:/GoMain.do";
	}

}
