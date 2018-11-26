package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
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
 * Servlet implementation class AppointmentServlet
 */
@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AppointmentServlet() {
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
		Integer patient_id = (Integer)session.getAttribute("id");
		Integer doctor_id = (Integer)session.getAttribute("doctor_id");
		String day = request.getParameter("day");
		String time = request.getParameter("time");
		
		LocalDate date = Appointment.findDate(day);
		ArrayList<Integer> AppointmentsIds = new ArrayList<>();
		
		try {
			
			if (patient_id == null) {
				session.setAttribute("doctor_id", null);
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "You have to be logged in to make an appointment.");
				request.getRequestDispatcher("login.jsp").include(request, response);
			}
			else {
				Connection con = datasource.getConnection(); //connect to database
				
				PreparedStatement ps = con.prepareStatement(Appointment.findPatAppointment());
				ps.setInt(1, patient_id); //input validation and escaping any special character
				ps.setString(2, time); //input validation and escaping any special character
				ps.setDate(3, java.sql.Date.valueOf(date)); //input validation and escaping any special character
				ps.setInt(4, 0); //input validation and escaping any special character
				ResultSet rs = ps.executeQuery();
				
				while (rs.next()) {
					AppointmentsIds.add(rs.getInt("app_id"));
				}
				
				rs.close();
				ps.close();
				
				PreparedStatement ps2 = con.prepareStatement(Appointment.findDocAppointment());
				ps2.setInt(1, doctor_id); //input validation and escaping any special character
				ps2.setString(2, time); //input validation and escaping any special character
				ps2.setDate(3, java.sql.Date.valueOf(date)); //input validation and escaping any special character
				ps2.setInt(4, 0); //input validation and escaping any special character
				ResultSet rs2 = ps2.executeQuery();
				
				while (rs2.next()) {
					AppointmentsIds.add(rs2.getInt("app_id"));
				}
				
				rs2.close();
				ps2.close();
			
				if (AppointmentsIds.isEmpty()) {
					
					session.setAttribute("doctor_id", doctor_id);
					session.setAttribute("day", day);
					session.setAttribute("time", time);
					session.setAttribute("date", date);
					
					//redirect to appointment page
					request.getRequestDispatcher("appointment.jsp").include(request, response);
				}
				else {
					
					int weeks = 1;
					LocalDate date2 = LocalDate.now();
					
					while (!AppointmentsIds.isEmpty()) {
						
						date2 = Appointment.findNextDate(weeks, date);
						AppointmentsIds.clear();
						
						PreparedStatement ps3 = con.prepareStatement(Appointment.findPatAppointment());
						ps3.setInt(1, patient_id); //input validation and escaping any special character
						ps3.setString(2, time); //input validation and escaping any special character
						ps3.setDate(3, java.sql.Date.valueOf(date2)); //input validation and escaping any special character
						ps3.setInt(4, 0); //input validation and escaping any special character
						ResultSet rs3 = ps3.executeQuery();
						
						while (rs3.next()) {
							AppointmentsIds.add(rs3.getInt("app_id"));
						}
						
						rs3.close();
						ps3.close();
						
						PreparedStatement ps4 = con.prepareStatement(Appointment.findDocAppointment());
						ps4.setInt(1, doctor_id); //input validation and escaping any special character
						ps4.setString(2, time); //input validation and escaping any special character
						ps4.setDate(3, java.sql.Date.valueOf(date2)); //input validation and escaping any special character
						ps4.setInt(4, 0); //input validation and escaping any special character
						ResultSet rs4 = ps4.executeQuery();
						
						while (rs4.next()) {
							AppointmentsIds.add(rs4.getInt("app_id"));
						}
						
						rs4.close();
						ps4.close();
						
						weeks += 1;
					}
					
					if (AppointmentsIds.isEmpty()) {
						
						session.setAttribute("doctor_id", doctor_id);
						session.setAttribute("day", day);
						session.setAttribute("time", time);
						session.setAttribute("date", date2);
						
						//redirect to appointment page
						request.getRequestDispatcher("appointment.jsp").include(request, response);
					}
				}
				
				con.close();
				
			}
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}