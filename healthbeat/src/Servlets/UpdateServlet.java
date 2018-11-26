package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 * Servlet implementation class UpdateServlet
 */
@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateServlet() {
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
		Integer role = (Integer)session.getAttribute("role");
		Integer id = (Integer)session.getAttribute("id");
		String old_username = (String)session.getAttribute("username");
		String old_email = (String)session.getAttribute("email");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String telephone, mobile, region, location, address, zip_code;
		double cost;
		
		ArrayList<String> usernames = new ArrayList<>();
		ArrayList<String> emails = new ArrayList<>();
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT username, email FROM mydb.users WHERE username=? OR email=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, username); //input validation and escaping any special character
			ps.setString(2, email); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				String username2 = rs.getString("username");
				String email2 = rs.getString("email");
				
				if (!old_username.equals(username2)) {
					usernames.add(username2);
				}
				
				if (!old_email.equals(email2)) {
					emails.add(email2);
				}
			}
			
			rs.close();
			ps.close();
			
			if (!usernames.isEmpty() && !emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username and email already exists!");
				request.getRequestDispatcher("profile.jsp").include(request, response);
			}
			else if (!usernames.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username already exists!");
				request.getRequestDispatcher("profile.jsp").include(request, response);
			}
			else if (!emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Email already exists! Please use a different one.");
				request.getRequestDispatcher("profile.jsp").include(request, response);
			}
			else {
				query = "UPDATE mydb.users SET username=?, email=? WHERE user_id=?"; //secure for SQL injection
				PreparedStatement updateUser = con.prepareStatement(query);
				updateUser.setString(1, username); //input validation and escaping any special character
				updateUser.setString(2, email); //input validation and escaping any special character
				updateUser.setInt(3, id); //input validation and escaping any special character
				updateUser.executeUpdate();
				con.setAutoCommit(false);
				con.commit();
				updateUser.close();
				
				//update session attributes
				session.setAttribute("username", username);
				session.setAttribute("email", email);
				
				if (role == 0) {
					mobile = request.getParameter("mobile");
					query = "UPDATE mydb.patients SET mobile=? WHERE patient_id=?"; //secure for SQL injection
					PreparedStatement updatePatient = con.prepareStatement(query);
					updatePatient.setString(1, mobile); //input validation and escaping any special character
					updatePatient.setInt(2, id); //input validation and escaping any special character
					updatePatient.executeUpdate();
					con.setAutoCommit(false);
					con.commit();
					updatePatient.close();
					
					//update session attributes
					session.setAttribute("mobile", mobile);
				}
				else if (role == 1) {
					telephone = request.getParameter("telephone");
					mobile = request.getParameter("mobile");
					region = request.getParameter("region");
					location = request.getParameter("location");
					address = request.getParameter("address");
					zip_code = request.getParameter("zip_code");
					cost = Double.parseDouble(request.getParameter("cost"));
					
					//secure for SQL injection
					query = "UPDATE mydb.doctors SET telephone=?, mobile=?, region=?, location=?, address=?, zip_code=?, cost=? WHERE doctor_id=?";
					PreparedStatement updateDoctor = con.prepareStatement(query);
					
					//input validation and escaping any special character
					updateDoctor.setString(1, telephone);
					updateDoctor.setString(2, mobile);
					updateDoctor.setString(3, region);
					updateDoctor.setString(4, location);
					updateDoctor.setString(5, address);
					updateDoctor.setString(6, zip_code);
					updateDoctor.setDouble(7, cost);
					updateDoctor.setInt(8, id);
					updateDoctor.executeUpdate();
					con.setAutoCommit(false);
					con.commit();
					updateDoctor.close();
					
					//update session attributes
					session.setAttribute("telephone", telephone);
					session.setAttribute("mobile", mobile);
					session.setAttribute("region", region);
					session.setAttribute("location", location);
					session.setAttribute("address", address);
					session.setAttribute("zip_code", zip_code);
					session.setAttribute("cost", cost);
				}
				
				session.setAttribute("msg_header", "Success!");
				session.setAttribute("msg", "Data updated!");
				request.getRequestDispatcher("profile.jsp").include(request, response);
			}
			
			con.close();
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}