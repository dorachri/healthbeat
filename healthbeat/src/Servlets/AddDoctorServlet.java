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
import com.mysql.jdbc.Statement;
import Mainpackage.Passwords;

/**
 * Servlet implementation class AddDoctorServlet
 */
@WebServlet("/AddDoctorServlet")
public class AddDoctorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddDoctorServlet() {
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
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String name = request.getParameter("fn");
		String surname = request.getParameter("ln");
		Integer gender = Integer.parseInt(request.getParameter("gender"));
		String email = request.getParameter("email");
		String amka = request.getParameter("amka");
		String telephone = request.getParameter("telephone");
		String mobile = request.getParameter("mobile");
		String region = request.getParameter("region");
		String location = request.getParameter("location");
		String address = request.getParameter("address");
		String zip_code = request.getParameter("zip_code");
		String specialty = request.getParameter("specialty");
		Double cost = Double.parseDouble(request.getParameter("cost"));
		
		ArrayList<String> usernames = new ArrayList<>();
		ArrayList<String> amkas = new ArrayList<>();
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
				
				if (username.equals(username2)) {
					usernames.add(rs.getString("username"));
				}
				
				if (email.equals(email2)) {
					emails.add(rs.getString("email"));
				}
			}
			
			rs.close(); 
			ps.close();
			
			query = "SELECT amka FROM mydb.doctors WHERE amka=?"; //secure for SQL injection
			PreparedStatement ps2 = con.prepareStatement(query);
			ps2.setString(1, amka); //input validation and escaping any special character
			ResultSet rs2 = ps2.executeQuery();
			
			while (rs2.next()) {
				amkas.add(rs2.getString("amka"));
			}
			
			rs2.close(); 
			ps2.close();

			if (!usernames.isEmpty() && !amkas.isEmpty() && !emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username, AMKA and email already exist!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!usernames.isEmpty() && !amkas.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username and AMKA already exists!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!usernames.isEmpty() && !emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username and email already exists!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!amkas.isEmpty() && !emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "AMKA and email already exists!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!usernames.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Username already exists!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!amkas.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Incorrect AMKA! Please try again.");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else if (!emails.isEmpty()) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Email already exists! Please use a different one.");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			else {
				
				int keyId = 0;
				byte salt[] = Passwords.getNextSalt();
				char[] passwordChar = password.toCharArray();
				byte[] hashedPassword = Passwords.hash(passwordChar, salt);
				
				query = "INSERT INTO mydb.users (username, salt, password, name, surname, gender, email, role) VALUES (?,?,?,?,?,?,?,?)";
				PreparedStatement registerUser = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
				registerUser.setString(1, username);
				registerUser.setBytes(2, salt);
				registerUser.setBytes(3, hashedPassword);
				registerUser.setString(4, name);
				registerUser.setString(5, surname);
				registerUser.setInt(6, gender);
				registerUser.setString(7, email);
				registerUser.setInt(8, 1);
				registerUser.executeUpdate();
				
				ResultSet rsk = registerUser.getGeneratedKeys();
				if (rsk.next()) {
					keyId = rsk.getInt(1);   
				}
				
				registerUser.close();
				rsk.close();
				
				query = "INSERT INTO mydb.doctors (doctor_id, amka, telephone, mobile, region, location, address, zip_code, specialty, cost) VALUES (?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement registerDoctor = con.prepareStatement(query);
				registerDoctor.setInt(1, keyId);
				registerDoctor.setString(2, amka);
				registerDoctor.setString(3, telephone);
				registerDoctor.setString(4, mobile);
				registerDoctor.setString(5, region);
				registerDoctor.setString(6, location);
				registerDoctor.setString(7, address);
				registerDoctor.setString(8, zip_code);
				registerDoctor.setString(9, specialty);
				registerDoctor.setDouble(10, cost);
				registerDoctor.executeUpdate();
				registerDoctor.close();
				
				session.setAttribute("msg_header", "Success!");
				session.setAttribute("msg", "Successful registration!");
				request.getRequestDispatcher("add_doctor.jsp").include(request, response);
			}
			
			con.close();
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}
	
}