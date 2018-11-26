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
 * Servlet implementation class searchServlet
 */
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchServlet() {
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
		String specialty = request.getParameter("specialty");
		String region = request.getParameter("region");
		String location = request.getParameter("location");
		Double price = Double.parseDouble(request.getParameter("price"));
		
		ArrayList<Integer> doctorsIds = new ArrayList<>();
			
		try {
			Connection con = datasource.getConnection(); //connect to database
			String query = "SELECT doctor_id FROM mydb.doctors WHERE specialty=? AND region=? AND location=? AND cost<=?"; //secure for SQL injection
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, specialty); //input validation and escaping any special character
			ps.setString(2, region); //input validation and escaping any special character
			ps.setString(3, location); //input validation and escaping any special character
			ps.setDouble(4, price); //input validation and escaping any special character
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				doctorsIds.add(rs.getInt("doctor_id"));
			}
			
			rs.close();
			ps.close();
			
			if (!doctorsIds.isEmpty()) {
				session.setAttribute("doctorsIds", doctorsIds);
				
				//redirect to results page
				request.getRequestDispatcher("results.jsp").include(request, response);
			}
			else {
				session.setAttribute("msg_header", "Error!");
				session.setAttribute("msg", "No results found matching the criteria given.");
				request.getRequestDispatcher("index.jsp").include(request, response);
			}
			
			con.close();
				
		}
		catch (SQLException sqle) {
			sqle.printStackTrace();
		}
		
	}

}