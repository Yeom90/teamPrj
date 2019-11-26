package team.project.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import team.project.exception.AlreadyExistingEmailException;
import team.project.exception.AlreadyExistingIdException;
import team.project.service.UserService;
import team.project.validate.RegisterRequest;
import team.project.validate.RegisterRequestValidator;

@Controller
public class UserController {
	
	@Resource(name="userService")
	private UserService userSer;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String index() {
		return "index";
	}
	
	@RequestMapping(value = "/register/step2", method = RequestMethod.GET)
	public ModelAndView signUp() {
		ModelAndView mv = new ModelAndView("/register/signUp");
		mv.addObject("registerRequest", new RegisterRequest());
		return mv;
	}

	@RequestMapping(value = "/register/step2", method = RequestMethod.POST)
	public ModelAndView check(@RequestParam(value="agree", defaultValue="false") Boolean agree, RegisterRequest regReq, Errors errors) throws Exception{
		new RegisterRequestValidator().validate(regReq, errors);
		ModelAndView mv = new ModelAndView();
		
		if(!agree) {
			mv = new ModelAndView("/register/signUp");
			errors.rejectValue("agree", "disagree", "약관 동의가 필요합니다.");
			return mv;
		}
		
		if(errors.hasErrors()) {
			mv.setViewName("/register/signUp");
			return mv;
		}
		
		try {
			userSer.register(regReq);
			
		}catch(AlreadyExistingIdException e) {
			errors.rejectValue("id", "duplicate", "이미 가입된 아이디 입니다.");
			mv.setViewName("/register/signUp");
			return mv;
		}catch(AlreadyExistingEmailException e) {
			errors.rejectValue("email", "duplicate", "이미 가입된 이메일 입니다.");
			mv.setViewName("/register/signUp");
			return mv;
		}
		mv.setViewName("/register/signOk");
		return mv;
	}
	//id 중복 체크(ajax)
	@RequestMapping(value="register/idcheck", method=RequestMethod.POST)
	@ResponseBody
	public int idcheck(RegisterRequest regReq, Errors errors)throws Exception {
		String id = new RegisterRequestValidator().idcheck(regReq, errors);
		System.out.println(id);
		if(errors.hasErrors()) {
			if(errors.getFieldError("id").getCode().equals("required")) {
				return 2;
			}else if(errors.getFieldError("id").getCode().equals("bad")) {
				System.out.println("bad");
				return 3;
			}
		}
		int idchecked = userSer.idcheck(id);
		System.out.println(idchecked);
		return idchecked;
	}
	
	//id 중복 체크
//	@RequestMapping(value="register/idcheck", method=RequestMethod.GET)
//	@ResponseBody
//	public ModelAndView idcheck(RegisterRequest regReq, Errors errors)throws Exception {
//		String id = new RegisterRequestValidator().idcheck(regReq, errors);
//		System.out.println(id);
//		ModelAndView mv = new ModelAndView();
//		if(errors.hasErrors()) {
//			System.out.println("에러::::");
//			System.out.println(errors.getFieldError("id").getDefaultMessage());
//			return mv;
//		}
//		int idchecked = userSer.idcheck(id);
//		System.out.println(idchecked);
//		mv.addObject("id", idchecked);
//		mv.setViewName("/register/signUp");
//		return mv;
//		}
	
}
