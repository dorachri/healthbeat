<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, javax.sql.DataSource, javax.naming.InitialContext"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mystyle.css"/>
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/Images/favicon.ico"/>
	<title>My availability</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer role = (Integer)session.getAttribute("role");
		if(role == null || role != 1) {
			response.sendRedirect("index.jsp");
		}
	%>
	
	<!-- Navigation -->
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
		      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </button>
		      <a class="navbar-brand" href="index.jsp">Healthbeat</a>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		    	<ul class="nav navbar-nav">
		    		<li><a href="about.jsp">About</a></li>
		        	<li><a href="faq.jsp">FAQ</a></li>
		    	</ul>
		    	<ul class="nav navbar-nav navbar-right">
		    		<li><a href="doctor.jsp">My appointments</a></li>
		    		<li class="active"><a href="my_availability.jsp">My availability</a></li>
		    		<li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Weekly availability -->
	<div class="container">
		<h3 class="text-center">Weekly availability</h3><br/>
		<div class="table-responsive text-center">
			<table class="table table-bordered table-striped vertical-align2 bg-white">
				<thead>
					<tr class="tr-bigger">
						<th>Monday</th>
						<th>Tuesday</th>
						<th>Wednesday</th>
						<th>Thursday</th>
						<th>Friday</th>
						<th>Edit</th>
					</tr>
				</thead>
				<tbody>
					<tr class="tr-bigger">
					<%	DataSource datasource = null;
					
						try {
							InitialContext ctx = new InitialContext();
							datasource = (DataSource)ctx.lookup("java:comp/env/jdbc/LiveDataSource");
						}
						catch (Exception e) {
							throw new ServletException(e.toString());
						}
						
						Integer doctor_id = (Integer)session.getAttribute("id");
						String monday_av = null;
						String tuesday_av = null;
						String wednesday_av = null;
						String thursday_av = null;
						String friday_av = null;
						boolean flag = false;
						
						try {
							if (doctor_id != null) {
								Connection con = datasource.getConnection();
								String query = "SELECT * FROM mydb.availability WHERE doctor_id=?";
								PreparedStatement ps = con.prepareStatement(query);
								ps.setInt(1, doctor_id);
								ResultSet rs = ps.executeQuery();
								
								while (rs.next()) {
									monday_av = rs.getString("monday_av");
									tuesday_av = rs.getString("tuesday_av");
									wednesday_av = rs.getString("wednesday_av");
									thursday_av = rs.getString("thursday_av");
									friday_av = rs.getString("friday_av");
									flag = true;
								}
								
								rs.close();
							    ps.close();
								con.close();
								
								if (flag == false) {
									for (int i=0; i<5; i++) {
										out.println("<td>-</td>");
									}
								}
								else {
									out.println("<td>" +monday_av+ "</td>");
									out.println("<td>" +tuesday_av+ "</td>");
									out.println("<td>" +wednesday_av+ "</td>");
									out.println("<td>" +thursday_av+ "</td>");
									out.println("<td>" +friday_av+ "</td>");
								}
								
								out.println("<td><a class='btn btn-primary btn-sm' href='availability.jsp'><span class='glyphicon glyphicon-pencil'></span></a></td>");
							}
							
						}
						catch (SQLException sqle) {
							sqle.printStackTrace();
						}
		        	%>
		        	</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<!-- Footer -->
	<footer class="container-fluid text-center space-up">
        <div class="row">
            <div class="col-sm-6">
            	<p>Copyright &copy; 2018 <a href="http://www.unipi.gr/unipi/el/"> University of Piraeus</a> - <a href="http://www.cs.unipi.gr/">Department of Informatics</a></p>
            </div>
            <div class="col-sm-6">
            	<ul class="list-inline">
            		<li><a href="about_us.jsp">About us</a></li>
            		<li><a href="terms.jsp">Terms</a></li>
            		<li><a href="contact.jsp">Contact</a></li>
            	</ul>
            </div>
        </div>
    </footer>
</body>
</html>