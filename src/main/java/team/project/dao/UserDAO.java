package team.project.dao;

import org.springframework.stereotype.Repository;

import team.project.validate.RegisterRequest;
import team.project.vo.UserVO;

@Repository("userDAO")
public class UserDAO extends AbstractDAO{
	
	public UserVO selectByEmail(String email) {
		return (UserVO)selectOne("user.selectByEmail", email);	
	}
	
	public UserVO selectById(String id) {
		return (UserVO) selectOne("user.selectById", id);
	}
	
	public void insertUser(RegisterRequest regReq) {
		insert("user.register", regReq);
	}
}
