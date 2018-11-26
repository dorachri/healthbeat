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
 * Servlet implementation class DeleteUserServlet
 */
@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteUserServlet() {
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
		Integer user_id = (Integer)session.getAttribute("id");
		Integer id = Integer.parseInt(request.getParameter("delete"));
		int role = -1;
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT role FROM mydb.users WHERE user_id =?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, id); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				role = rs.getInt("role");
			}
			
			rs.close();
			ps.close();
			
			if (user_id == id && role == 2) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "You can't delete yourself!");
				request.getRequestDispatcher("admin_panel.jsp").include(request, response);
			}
			else {
				query = "DELETE FROM mydb.users WHERE user_id =?"; //secure for SQL injection
				PreparedStatement ps2 = con.prepareStatement(query);
				ps2.setInt(1, id); //input validation and escaping any special character
				ps2.executeUpdate();
				ps2.close();
			}
			
			if (role == 0) {
				query = "DELETE FROM mydb.patients WHERE patient_id =?"; //secure for SQL injection
				PreparedStatement ps3 = con.prepareStatement(query);
				ps3.setInt(1, id); //input validation and escaping any special character
				ps3.executeUpdate();
				ps3.close();
			}
			else if (role == 1) {
				query = "DELETE FROM mydb.doctors WHERE doctor_id =?"; //secure for SQL injection
				PreparedStatement ps4 = con.prepareStatement(query);
				ps4.setInt(1, id); //input validation and escaping any special character
				ps4.executeUpdate();
				ps4.close();
			}
			
			if (user_id == id && role != 2) {
				session.removeAttribute("id");
				session.removeAttribute("role");
			    session.invalidate();
			    response.setHeader("Cache-Control","no-cache"); 
			    response.setHeader("Cache-Control","no-store"); 
			    response.setHeader("Pragma","no-cache");
			    response.setDateHeader("Expires",0); 
			    response.sendRedirect("index.jsp");
			}
			else if (user_id != id) {
				session.setAttribute("msg_header", "Success!");
				session.setAttribute("msg", "The user has been deleted!");
				request.getRequestDispatcher("admin_panel.jsp").include(request, response);
			}
			
			con.close();
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}