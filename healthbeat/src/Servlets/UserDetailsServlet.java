package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 * Servlet implementation class UserDetailsServlet
 */
@WebServlet("/UserDetailsServlet")
public class UserDetailsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserDetailsServlet() {
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
		Integer id = Integer.parseInt(request.getParameter("details"));
		String name, surname, email, amka, telephone, mobile, region, location, address, zip_code, specialty;
		int gender, role;
		double cost;
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT * FROM mydb.users WHERE user_id=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, id); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				name = rs.getString("name");
				surname = rs.getString("surname");
				gender = rs.getInt("gender");
				email = rs.getString("email");
				role = rs.getInt("role");
				
				//session attributes
				session.setAttribute("id2", id);
				session.setAttribute("name2", name);
				session.setAttribute("surname2", surname);
				session.setAttribute("gender2", gender);
				session.setAttribute("email2", email);
				session.setAttribute("role2", role);
				
				if (role == 0) {
					query = "SELECT * FROM mydb.patients WHERE patient_id=?"; //secure for SQL injection
					PreparedStatement ps2 = con.prepareStatement(query);
					ps2.setInt(1, id); //input validation and escaping any special character
					ResultSet rs2 = ps2.executeQuery();
					
					while (rs2.next()) {
						amka = rs2.getString("amka");
						mobile = rs2.getString("mobile");
						
						//session attributes
						session.setAttribute("amka2", amka);
						session.setAttribute("mobile2", mobile);
					}
					
					rs2.close();
				    ps2.close();
				}
				else if (role == 1) {
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
						session.setAttribute("amka2", amka);
						session.setAttribute("telephone2", telephone);
						session.setAttribute("mobile2", mobile);
						session.setAttribute("region2", region);
						session.setAttribute("location2", location);
						session.setAttribute("address2", address);
						session.setAttribute("zip_code2", zip_code);
						session.setAttribute("specialty2", specialty);
						session.setAttribute("cost2", cost);
					}
					
					rs3.close();
				    ps3.close();
				}
				
			}
			
			rs.close();
		    ps.close();
			con.close();
			
			//redirect to user card page
			request.getRequestDispatcher("user.jsp").include(request, response);
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}