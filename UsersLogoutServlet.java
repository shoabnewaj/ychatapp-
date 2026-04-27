package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/UsersLogoutServlet")
public class UsersLogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public UsersLogoutServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// ログアウト処理
		
		// sessionインスタンスを取得する
		HttpSession session = request.getSession();
		
		// sessionを破棄する
		session.invalidate();
		
		// Logoutメッセージを作成
		String logoutMsg = 
				"<p style=\"color:red\">※ ログアウトしました</p>";
		
		// Logoutメッセージをリクエストスコープにset
		request.setAttribute("logoutMsg", logoutMsg);
		 
		// ログイン画面にforwardする
		RequestDispatcher rd = 
				request.getRequestDispatcher
				("WEB-INF/jsp/login.jsp");
		
		rd.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
