package team.project.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
	
	@RequestMapping("/register/step1")
	public String step1() throws Exception{
		return "/register/step1";
	}
	@RequestMapping("/register/step2")
	public ModelAndView step2(@RequestParam(value="agree", defaultValue="false") Boolean agree) {
		if(!agree) {
			ModelAndView mv = new ModelAndView("/register/step1");
			return mv;
		}
		ModelAndView mv = new ModelAndView("/register/step2");
		mv.addObject("registerRequest", new RegisterRequest());
		return mv;
	}
	@RequestMapping("/register/step3")
	public ModelAndView step3(RegisterRequest regReq, Errors errors) throws Exception{
		new RegisterRequestValidator().validate(regReq, errors);
		ModelAndView mv = new ModelAndView();
		
		if(errors.hasErrors()) {
			mv.setViewName("/register/step2");
			return mv;
		}
		
		try {
			userSer.register(regReq);
			
		}catch(AlreadyExistingEmailException e) {
			errors.rejectValue("email", "duplicate", "이미 가입된 이메일 입니다.");
			mv.setViewName("/register/step2");
			return mv;
			
		}catch(AlreadyExistingIdException e) {
			errors.rejectValue("id", "duplicate", "이미 가입된 아이디 입니다.");
			mv.setViewName("/register/step2");
			return mv;
		}
		mv.setViewName("/register/step3");
		return mv;
	}
	
}
