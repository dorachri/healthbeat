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
import Mainpackage.Availability;

/**
 * Servlet implementation class BookServlet
 */
@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookServlet() {
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
		Integer doctor_id = Integer.parseInt(request.getParameter("book"));
		String[] daily_av = {null, null, null, null, null};
		
		ArrayList<String> monday_av = new ArrayList<>();
		ArrayList<String> tuesday_av = new ArrayList<>();
		ArrayList<String> wednesday_av = new ArrayList<>();
		ArrayList<String> thursday_av = new ArrayList<>();
		ArrayList<String> friday_av = new ArrayList<>();
		
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT * FROM mydb.availability WHERE doctor_id=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setInt(1, doctor_id); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				daily_av[0] = rs.getString("monday_av");
				daily_av[1] = rs.getString("tuesday_av");
				daily_av[2] = rs.getString("wednesday_av");
				daily_av[3] = rs.getString("thursday_av");
				daily_av[4] = rs.getString("friday_av");
			}
			
			rs.close();
		    ps.close();
			con.close();
			
			if (daily_av[0] != null && !daily_av[0].equals("-")) {
				monday_av = Availability.splitTimeInterval(daily_av[0], 30);
			}
			
			if (daily_av[1] != null && !daily_av[1].equals("-")) {
				tuesday_av = Availability.splitTimeInterval(daily_av[1], 30);
			}
			
			if (daily_av[2] != null && !daily_av[2].equals("-")) {
				wednesday_av = Availability.splitTimeInterval(daily_av[2], 30);
			}
			
			if (daily_av[3] != null && !daily_av[3].equals("-")) {
				thursday_av = Availability.splitTimeInterval(daily_av[3], 30);
			}
			
			if (daily_av[4] != null && !daily_av[4].equals("-")) {
				friday_av = Availability.splitTimeInterval(daily_av[4], 30);
			}
			
			
			session.setAttribute("doctor_id", doctor_id);
			session.setAttribute("monday_av", monday_av);
			session.setAttribute("tuesday_av", tuesday_av);
			session.setAttribute("wednesday_av", wednesday_av);
			session.setAttribute("thursday_av", thursday_av);
			session.setAttribute("friday_av", friday_av);
			
			//redirect to book page
			request.getRequestDispatcher("book.jsp").include(request, response);
			
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}