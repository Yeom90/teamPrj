package team.project.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

// 참고: https://to-dy.tistory.com/21?category=700248
public class Interceptor extends HandlerInterceptorAdapter{
	
	protected Logger logger = LoggerFactory.getLogger(Interceptor.class);//== Interceptor.class
	
	@Override
	// 클라이언트에서 컨트롤러로 요청할 때 가로챔(컨트롤러 호출전 실행)
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("========== START ================================");
			//현재 호출 URL 로그출력
			logger.debug(" Request URI \t: " + request.getRequestURI());
			//클라이언트 IP 로그출력
			String ip = request.getHeader("X-FORWARDED-FOR");
			if(ip==null) ip = request.getRemoteAddr();
			logger.debug(" Request IP \t: " + ip);
		}
		return super.preHandle(request, response, handler);
	}

	@Override
	// 컨트롤러 호출 후 실행
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		//컨트롤러가 끝남을 알리는 로그 출력
		if(logger.isDebugEnabled()) {
			logger.debug("=========== END ================================");
		}
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	// 컨트롤러 처리가 끝나고 화면처리까지 모두 끝나면 실행
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!! afterCompletion 호출 됨 !!!!!!!!!!!!!!!!!!!!!!!");
		super.afterCompletion(request, response, handler, ex);
	}
	
	
}
