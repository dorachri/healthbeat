package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import Mainpackage.Passwords;

/**
 * Servlet implementation class ChangePasswordServlet
 */
@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangePasswordServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    private DataSource datasource = null;

	public void init() throws ServletException {
		
		try {
			InitialContext ctx = new InitialContext();
			datasource = (DataSource)ctx.lookup("java:comp/env/jdbc/LiveDataSource");
		}
		catch (Exception e) {
			throw new ServletException(e.toString());
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setHeader("Cache-Control","no-cache");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","-1");
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		HttpSession session = request.getSession();
		String username = (String)session.getAttribute("username");
		String old_password = request.getParameter("old_password");
		String password = request.getParameter("password");
		String password2 = request.getParameter("password2");
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT username, salt, password FROM mydb.users WHERE username=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, username); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			byte[] passdb = null;
			byte[] salt = null;
			
			while (rs.next()) {
				passdb = rs.getBytes("password");
				salt = rs.getBytes("salt");
			}
			
			rs.close();
			ps.close();
			
			byte[] passToTest = null;
			char[] pass = old_password.toCharArray();
			
			if (!(passdb == null)) {
				passToTest = Passwords.hash(pass, salt); //salted given password
			}
			
			if (Arrays.toString(passToTest).equals(Arrays.toString(passdb)) && !(passToTest == null)) {
				if (!password.equals(password2)) {
					session.setAttribute("msg_header", "Error!");
					session.setAttribute("msg", "Passwords don't match! Please try again.");
					request.getRequestDispatcher("password.jsp").include(request, response);
				}
				else {
					byte newsalt[] = Passwords.getNextSalt();
					char[] newpass = password.toCharArray();
					byte[] hashedPassword = Passwords.hash(newpass, newsalt);
					
					query = "UPDATE mydb.users SET salt=?, password=? WHERE username=?"; //secure for SQL injection
					PreparedStatement updateUser = con.prepareStatement(query);
					updateUser.setBytes(1, newsalt); //input validation and escaping any special character
					updateUser.setBytes(2, hashedPassword); //input validation and escaping any special character
					updateUser.setString(3, username); //input validation and escaping any special character
					updateUser.executeUpdate();
					con.setAutoCommit(false);
					con.commit();
					updateUser.close();
					
					session.setAttribute("msg_header", "Success!");
					session.setAttribute("msg", "Password has changed!");
					request.getRequestDispatcher("password.jsp").include(request, response);
				}
			}
			else {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Wrong password! Please try again.");
				request.getRequestDispatcher("password.jsp").include(request, response);
			}
			
			con.close();
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}
	
}