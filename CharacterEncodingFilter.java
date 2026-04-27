package ychatapp.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter("/*")
public class CharacterEncodingFilter 
				extends HttpFilter implements Filter{
	
	public void doFilter
	(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
	
			throws IOException, ServletException{
		
		request.setCharacterEncoding("UTF-8");
		
		chain.doFilter(request, response);
		
	}

}
