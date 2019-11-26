package team.project.service;

import team.project.validate.RegisterRequest;

public interface UserService {
	void register(RegisterRequest regReq) throws Exception;
	
	int idcheck(String id)throws Exception;
}
