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
import Mainpackage.Doctor;

/**
 * Servlet implementation class ConfirmServlet
 */
@WebServlet("/ConfirmServlet")
public class ConfirmServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfirmServlet() {
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
		Integer role = (Integer)session.getAttribute("role");
		String amka = (String)session.getAttribute("amka");
		Integer doctor_id = (Integer)session.getAttribute("doctor_id");
		LocalDate date = (LocalDate)session.getAttribute("date");
		String time = (String)session.getAttribute("time");
		int id = -1;
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			
			PreparedStatement ps = con.prepareStatement(Doctor.findID());
			ps.setString(1, amka);
			ResultSet rs = ps.executeQuery();
				
			while (rs.next()) {
				id = rs.getInt("doctor_id");
			}
				
			rs.close();
			ps.close();
			
			if ((role == 0 && id == -1) || (role == 0 && id != doctor_id)) {
				String query = "INSERT INTO mydb.appointments (date, time, doctor_id, patient_id, canceled) VALUES (?,?,?,?,?)";
				PreparedStatement registerAppointment = con.prepareStatement(query);
				registerAppointment.setDate(1, java.sql.Date.valueOf(date));
				registerAppointment.setString(2, time);
				registerAppointment.setInt(3, doctor_id);
				registerAppointment.setInt(4, patient_id);
				registerAppointment.setInt(5, 0);
				registerAppointment.executeUpdate();
				registerAppointment.close();
				
				session.setAttribute("msg_header", "Success!");
				session.setAttribute("msg", "Your appointment has been registered.");
				request.getRequestDispatcher("appointment.jsp").include(request, response);
			}
			else if (role == 0 && id != -1 && id == doctor_id) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "You can't make an appointment with yourself.");
				request.getRequestDispatcher("appointment.jsp").include(request, response);
			}
			else if (role != 0) {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "You have to be logged in as a patient to make an appointment.");
				request.getRequestDispatcher("appointment.jsp").include(request, response);
			}
			
			con.close();
			session.setAttribute("doctor_id", null);
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}