package Servlets;

import java.io.IOException;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import Mainpackage.Passwords;
import java.util.Arrays;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;


/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
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
		session.invalidate(); //delete old session
		session = request.getSession(true); //initialize a session
		
		String username = request.getParameter("username"); //get username from login form
		String password = request.getParameter("password"); //get password from login form
		String name, surname, email, amka, telephone, mobile, region, location, address, zip_code, specialty;
		int gender, role, id;
		double cost;
		role = -1;

		try {
			Connection con = datasource.getConnection(); //connect to database
			
			//access user data
			String query = "SELECT * FROM mydb.users WHERE username=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, username); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			byte[] passdb = null;
			byte[] salt = null;
			
			while (rs.next()) { //for all users
				passdb = rs.getBytes("password");
				salt = rs.getBytes("salt");
				name = rs.getString("name");
				surname = rs.getString("surname");
				gender = rs.getInt("gender");
				email = rs.getString("email");
				role = rs.getInt("role");
				id = rs.getInt("user_id");
				
				//session attributes
				session.setAttribute("username", username);
				session.setAttribute("name", name);
				session.setAttribute("surname", surname);
				session.setAttribute("gender", gender);
				session.setAttribute("email", email);
				session.setAttribute("role", role);
				session.setAttribute("id", id);
				
				if (role == 0) { //user = patient
					
					query = "SELECT * FROM mydb.patients WHERE patient_id=?"; //secure for SQL injection
					PreparedStatement ps2 = con.prepareStatement(query);
					ps2.setInt(1, id); //input validation and escaping any special character
					ResultSet rs2 = ps2.executeQuery();
					
					while (rs2.next()) {
						amka = rs2.getString("amka");
						mobile = rs2.getString("mobile");
						
						//session attributes
						session.setAttribute("amka", amka);
						session.setAttribute("mobile", mobile);
					}
					
					rs2.close();
				    ps2.close();
				}
				else if (role == 1) { //user = doctor
					
					query = "SELECT * FROM mydb.doctors WHERE doctor_id=?"; //secure for SQL injection
					PreparedStatement ps3 = con.prepareStatement(query);
					ps3.setInt(1, id); //input validation and escaping any special character
					ResultSet rs3 = ps3.executeQuery();
					
					while (rs3.next()) {
						amka = rs3.getString("amka");
						telephone = rs3.getString("telephone");
						mobile = rs3.getString("mobile");
						region = rs3.getString("region");
						location = rs3.getString("location");
						address = rs3.getString("address");
						zip_code = rs3.getString("zip_code");
						specialty = rs3.getString("specialty");
						cost = rs3.getDouble("cost");
						
						//session attributes
						session.setAttribute("amka", amka);
						session.setAttribute("telephone", telephone);
						session.setAttribute("mobile", mobile);
						session.setAttribute("region", region);
						session.setAttribute("location", location);
						session.setAttribute("address", address);
						session.setAttribute("zip_code", zip_code);
						session.setAttribute("specialty", specialty);
						session.setAttribute("cost", cost);
					}
					
					rs3.close();
				    ps3.close();
				}
			}
			
			rs.close();
		    ps.close();
			con.close();
			
			byte[] passToTest = null;
			char[] pass = password.toCharArray();
			
			if (!(passdb == null)) {
				passToTest = Passwords.hash(pass, salt); //salted given password
			}
			
			if (Arrays.toString(passToTest).equals(Arrays.toString(passdb)) && !(passToTest == null)) {
				
				request.getRequestDispatcher("index.jsp").include(request, response);
				
			} //wrong password
			else {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Wrong username or password! Please try again.");
				session.removeAttribute("id");
				request.getRequestDispatcher("login.jsp").include(request, response);
			}
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}
	
}