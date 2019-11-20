package team.project.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import team.project.dao.UserDAO;
import team.project.exception.AlreadyExistingEmailException;
import team.project.exception.AlreadyExistingIdException;
import team.project.validate.RegisterRequest;
import team.project.vo.UserVO;

@Service("userService")
public class UserServiceImp implements UserService{
	
	@Resource(name="userDAO")
	private UserDAO userDAO;
	
	@Override
	public void register(RegisterRequest regReq) throws Exception {
		UserVO email = userDAO.selectByEmail(regReq.getEmail());
		if(email!=null) {
			throw new AlreadyExistingEmailException(regReq.getEmail()+" is duplicate email.");
		}
		UserVO id = userDAO.selectById(regReq.getId());
		if(id!=null) {
			throw new AlreadyExistingIdException(regReq.getId()+" is duplicate id.");
		}
		userDAO.insertUser(regReq);
	}
	
}
