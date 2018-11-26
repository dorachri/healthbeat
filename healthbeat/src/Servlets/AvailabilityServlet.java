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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet implementation class AvailabilityServlet
 */
@WebServlet("/AvailabilityServlet")
public class AvailabilityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AvailabilityServlet() {
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
		Integer doctor_id = (Integer)session.getAttribute("id");
		int av_id = -1;
		
		//selects
		String monday_start_h = request.getParameter("monday_start_h");
		String monday_start_m = request.getParameter("monday_start_m");
		String monday_end_h = request.getParameter("monday_end_h");
		String monday_end_m = request.getParameter("monday_end_m");
		String tuesday_start_h = request.getParameter("tuesday_start_h");
		String tuesday_start_m = request.getParameter("tuesday_start_m");
		String tuesday_end_h = request.getParameter("tuesday_end_h");
		String tuesday_end_m = request.getParameter("tuesday_end_m");
		String wednesday_start_h = request.getParameter("wednesday_start_h");
		String wednesday_start_m = request.getParameter("wednesday_start_m");
		String wednesday_end_h = request.getParameter("wednesday_end_h");
		String wednesday_end_m = request.getParameter("wednesday_end_m");
		String thursday_start_h = request.getParameter("thursday_start_h");
		String thursday_start_m = request.getParameter("thursday_start_m");
		String thursday_end_h = request.getParameter("thursday_end_h");
		String thursday_end_m = request.getParameter("thursday_end_m");
		String friday_start_h = request.getParameter("friday_start_h");
		String friday_start_m = request.getParameter("friday_start_m");
		String friday_end_h = request.getParameter("friday_end_h");
		String friday_end_m = request.getParameter("friday_end_m");
		
		//checkboxes
		String monday = request.getParameter("monday");
		String tuesday = request.getParameter("tuesday");
		String wednesday = request.getParameter("wednesday");
		String thursday = request.getParameter("thursday");
		String friday = request.getParameter("friday");
		
		//create format hh:mm-hh:mm
		String monday_av = monday_start_h + ":" + monday_start_m + "-" + monday_end_h + ":" + monday_end_m;
		String tuesday_av = tuesday_start_h + ":" + tuesday_start_m + "-" + tuesday_end_h + ":" + tuesday_end_m;
		String wednesday_av = wednesday_start_h + ":" + wednesday_start_m + "-" + wednesday_end_h + ":" + wednesday_end_m;
		String thursday_av = thursday_start_h + ":" + thursday_start_m + "-" + thursday_end_h + ":" + thursday_end_m;
		String friday_av = friday_start_h + ":" + friday_start_m + "-" + friday_end_h + ":" + friday_end_m;
		
		//check if not available or something wrong
		if (monday != null || monday_start_h.equals("Hour") || monday_start_m.equals("Min") || monday_end_h.equals("Hour") || monday_end_m.equals("Min")) {
			monday_av = "-";
		}
		
		if (tuesday != null || tuesday_start_h.equals("Hour") || tuesday_start_m.equals("Min") || tuesday_end_h.equals("Hour") || tuesday_end_m.equals("Min")) {
			tuesday_av = "-";
		}
		
		if (wednesday != null || wednesday_start_h.equals("Hour") || wednesday_start_m.equals("Min") || wednesday_end_h.equals("Hour") || wednesday_end_m.equals("Min")) {
			wednesday_av = "-";
		}
		
		if (thursday != null || thursday_start_h.equals("Hour") || thursday_start_m.equals("Min") || thursday_end_h.equals("Hour") || thursday_end_m.equals("Min")) {
			thursday_av = "-";
		}
		
		if (friday != null || friday_start_h.equals("Hour") || friday_start_m.equals("Min") || friday_end_h.equals("Hour") || friday_end_m.equals("Min")) {
			friday_av = "-";
		}
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT av_id FROM mydb.availability WHERE doctor_id=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, doctor_id); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				av_id = rs.getInt("av_id");
			}
			
			if (av_id == -1) {
				query = "INSERT INTO mydb.availability (doctor_id, monday_av, tuesday_av, wednesday_av, thursday_av, friday_av) VALUES (?,?,?,?,?,?)";
				PreparedStatement insertAvailability = con.prepareStatement(query);
				insertAvailability.setInt(1, doctor_id);
				insertAvailability.setString(2, monday_av);
				insertAvailability.setString(3, tuesday_av);
				insertAvailability.setString(4, wednesday_av);
				insertAvailability.setString(5, thursday_av);
				insertAvailability.setString(6, friday_av);
				insertAvailability.executeUpdate();
				insertAvailability.close();
				
			}
			else {
				query = "UPDATE mydb.availability SET monday_av=?, tuesday_av=?, wednesday_av=?, thursday_av=?, friday_av=? WHERE av_id=?"; //secure for SQL injection
				PreparedStatement updateAvailability = con.prepareStatement(query);
				updateAvailability.setString(1, monday_av); //input validation and escaping any special character
				updateAvailability.setString(2, tuesday_av); //input validation and escaping any special character
				updateAvailability.setString(3, wednesday_av); //input validation and escaping any special character
				updateAvailability.setString(4, thursday_av); //input validation and escaping any special character
				updateAvailability.setString(5, friday_av); //input validation and escaping any special character
				updateAvailability.setInt(6, av_id); //input validation and escaping any special character
				updateAvailability.executeUpdate();
				con.setAutoCommit(false);
				con.commit();
				updateAvailability.close();
				
			}
			
			con.close();
			session.setAttribute("msg_header", "Success!");
			session.setAttribute("msg", "Your availability is updated.");
			request.getRequestDispatcher("availability.jsp").include(request, response);
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}
	
}