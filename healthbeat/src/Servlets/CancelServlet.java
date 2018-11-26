package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import Mainpackage.Appointment;

/**
 * Servlet implementation class CancelServlet
 */
@WebServlet("/CancelServlet")
public class CancelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CancelServlet() {
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
		Integer role = (Integer)session.getAttribute("role");
		LocalDate date = LocalDate.parse(request.getParameter("date"));
		String time = request.getParameter("time");
		LocalDate today = LocalDate.now();
		int app_id = -1;
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			
			if (role == 0) {
				
				PreparedStatement ps = con.prepareStatement(Appointment.findPatAppointment());
				ps.setInt(1, user_id); //input validation and escaping any special character
				ps.setString(2, time); //input validation and escaping any special character
				ps.setDate(3, java.sql.Date.valueOf(date)); //input validation and escaping any special character
				ps.setInt(4, 0); //input validation and escaping any special character
				ResultSet rs = ps.executeQuery();
					
				while (rs.next()) {
					app_id = rs.getInt("app_id");
				}
					
				rs.close();
				ps.close();
			}
			else if (role == 1) {
				
				PreparedStatement ps2 = con.prepareStatement(Appointment.findDocAppointment());
				ps2.setInt(1, user_id); //input validation and escaping any special character
				ps2.setString(2, time); //input validation and escaping any special character
				ps2.setDate(3, java.sql.Date.valueOf(date)); //input validation and escaping any special character
				ps2.setInt(4, 0); //input validation and escaping any special character
				ResultSet rs2 = ps2.executeQuery();
				
				while (rs2.next()) {
					app_id = rs2.getInt("app_id");
				}
				
				rs2.close();
				ps2.close();
			}
			
			if (date.isAfter(today) && app_id != -1) {
				String query = "UPDATE mydb.appointments SET canceled=? WHERE app_id=?"; //secure for SQL injection
				PreparedStatement updateAppointment = con.prepareStatement(query);
				updateAppointment.setInt(1, 1); //input validation and escaping any special character
				updateAppointment.setInt(2, app_id); //input validation and escaping any special character
				updateAppointment.executeUpdate();
				con.setAutoCommit(false);
				con.commit();
				updateAppointment.close();
				
				session.setAttribute("msg_header", "Success!");
				session.setAttribute("msg", "Your appointment has been canceled.");
				if (role == 0) {
					request.getRequestDispatcher("patient.jsp").include(request, response);
				}
				else if (role == 1) {
					request.getRequestDispatcher("doctor.jsp").include(request, response);
				}
				
			}
			else if (date.isEqual(today)) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "Cancellation of an appointment is valid until 1 day before the appointment.");
				if (role == 0) {
					request.getRequestDispatcher("patient.jsp").include(request, response);
				}
				else if (role == 1) {
					request.getRequestDispatcher("doctor.jsp").include(request, response);
				}
			}
			
			con.close();
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}