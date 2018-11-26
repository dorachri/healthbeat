<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.ArrayList, javax.naming.InitialContext, javax.sql.DataSource"%>
<%@ page import="Mainpackage.User, Mainpackage.Doctor"%>
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
	<title>Book</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer doctor_id = (Integer)session.getAttribute("doctor_id");
		if(doctor_id == null) {
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
			    	<%	Integer user_id = (Integer)session.getAttribute("id");
			    		Integer role = (Integer)session.getAttribute("role");
		        		if (user_id == null) {
		        			out.println("<li><a href='signup.jsp'>Sign up</a></li>");
		        			out.println("<li><a href='login.jsp'><span class='glyphicon glyphicon-log-in'></span> Login</a></li>");
		        		}
		        		else {
		        			if (role == 2) {
		        				out.println("<li><a href='add_doctor.jsp'>Add doctor</a></li>");
		        				out.println("<li><a href='add_patient.jsp'>Add patient</a></li>");
		        				out.println("<li><a href='admin_panel.jsp'><span class='glyphicon glyphicon-cog'></span> Admin panel</a></li>");
		        			}
		        			else if (role == 1) {
		        				out.println("<li><a href='doctor.jsp'>My appointments</a></li>");
		        				out.println("<li><a href='my_availability.jsp'>My availability</a></li>");
		        			}
		        			else if (role == 0) {
		        				out.println("<li><a href='patient.jsp'>My appointments</a></li>");
		        			}
		        			out.println("<li><a href='profile.jsp'><span class='glyphicon glyphicon-user'></span> Profile</a></li>");
		        			out.println("<li><a href='/healthbeat/LogoutServlet'><span class='glyphicon glyphicon-log-out'></span> Logout</a></li>");
		        		}
		        	%>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Choose appointment time form -->
	<div class="container">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="text-center">Make your appointment</h3>
			</div>
			<div class="panel-body">
				<div class="row">
					<div class="col-sm-offset-2 col-sm-2">
						<%	DataSource datasource = null;
							
							try {
								InitialContext ctx = new InitialContext();
								datasource = (DataSource)ctx.lookup("java:comp/env/jdbc/LiveDataSource");
							}
							catch (Exception e) {
								throw new ServletException(e.toString());
							}
							
							int docGender = -1;
							String docName = null;
							String docSurname = null;
							String specialty = null;
							String region = null;
							String location = null;
							String address = null;
								
							try {
								Connection con = datasource.getConnection();
									
								PreparedStatement ps = con.prepareStatement(User.findUserNameSurnameGender());
								ps.setInt(1, doctor_id);
								ResultSet rs = ps.executeQuery();
									
								while (rs.next()) {
									docGender = rs.getInt("gender");
									docName = rs.getString("name");
									docSurname = rs.getString("surname");
								}
									
								rs.close();
								ps.close();
									
								PreparedStatement ps2 = con.prepareStatement(Doctor.findOfficeAndSpecialty());
								ps2.setInt(1, doctor_id);
								ResultSet rs2 = ps2.executeQuery();
									
								while (rs2.next()) {
									specialty = rs2.getString("specialty");
									region = rs2.getString("region");
									location = rs2.getString("location");
									address = rs2.getString("address");
								}
									
								rs2.close();
								ps2.close();
								con.close();
								
								if (docGender == 0) {
					        		out.println("<br/><img alt='User default picture' src='Images/man.jpg' class='img-circle img-responsive'><br/>");
					        	}
					        	else {
					        		out.println("<br/><img alt='User default picture' src='Images/woman.jpg' class='img-circle img-responsive'><br/>");
					        	}
									
							}
							catch (Exception e) {
								e.printStackTrace();
							}
				    	%>
					</div>
					<div class="col-sm-7">
						<%	try {
							
							out.println("<br/><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-lg btn-block'>" +docName+ " " +docSurname+ "</button></form>");
							out.println("<p class='text-center'><strong>" +specialty+ "</strong></p>");
							
							String office = address + ", " + location + ", " + region;
							out.println("<p class='text-center'><span class='glyphicon glyphicon-map-marker'></span> " +office+ "</p>");
							
							}
							catch (Exception e) {
								e.printStackTrace();
							}
				        %>
					</div>
				</div><br/>
				<div class="row">
					<h4 class="text-center">Choose appointment time</h4>
				</div><br/>
				<div class="table-responsive text-center">
					<table class="table table-bordered table-striped vertical-align bg-white">
						<tbody>
							<%	try {
								
								ArrayList<String> monday_av = (ArrayList<String>)session.getAttribute("monday_av");
								ArrayList<String> tuesday_av = (ArrayList<String>)session.getAttribute("tuesday_av");
								ArrayList<String> wednesday_av = (ArrayList<String>)session.getAttribute("wednesday_av");
								ArrayList<String> thursday_av = (ArrayList<String>)session.getAttribute("thursday_av");
								ArrayList<String> friday_av = (ArrayList<String>)session.getAttribute("friday_av");
								
								int monday = -1;
								int tuesday = -1;
								int wednesday = -1;
								int thursday = -1;
								int friday = -1;
								
								if (!monday_av.isEmpty()) {
									monday = monday_av.size();
								}
								
								if (!tuesday_av.isEmpty()) {
									tuesday = tuesday_av.size();
								}
								
								if (!wednesday_av.isEmpty()) {
									wednesday = wednesday_av.size();
								}
								
								if (!thursday_av.isEmpty()) {
									thursday = thursday_av.size();
								}
								
								if (!friday_av.isEmpty()) {
									friday = friday_av.size();
								}
								
								int maximum = Math.max(monday,Math.max(tuesday,Math.max(wednesday,Math.max(thursday,friday))));
								
								out.println("<tr><th>Monday<br/></th>");
								if (!monday_av.isEmpty()) {
									for (int i = 0; i<monday; i++) {
										out.print("<td><form method='post' action='/healthbeat/AppointmentServlet'><input type='hidden' name='day' value='Monday'/>"
											+ "<button name='time' type='submit' value='" +monday_av.get(i)+ "' class='btn btn-link'>" +monday_av.get(i)+ "</button></form></td>");
									}
									if (monday != maximum) {
										for (int i = 0; i<maximum-monday; i++) {
											out.print("<td>-</td>");
										}
									}
								}
								else {
									for (int i = 0; i<maximum; i++) {
										out.print("<td>-</td>");
									}
								}
								out.println("</tr>");
								
								out.println("<tr><th>Tuesday<br/></th>");
								if (!tuesday_av.isEmpty()) {
									for (int i = 0; i<tuesday; i++) {
										out.println("<td><form method='post' action='/healthbeat/AppointmentServlet'><input type='hidden' name='day' value='Tuesday'/>"
											+ "<button name='time' type='submit' value='" +tuesday_av.get(i)+ "' class='btn btn-link'>" +tuesday_av.get(i)+ "</button></form></td>");
									}
									if (tuesday != maximum) {
										for (int i = 0; i<maximum-tuesday; i++) {
											out.print("<td>-</td>");
										}
									}
								}
								else {
									for (int i = 0; i<maximum; i++) {
										out.print("<td>-</td>");
									}
								}
								out.println("</tr>");
								
								out.println("<tr><th>Wednesday<br/></th>");
								if (!wednesday_av.isEmpty()) {
									for (int i = 0; i<wednesday; i++) {
										out.println("<td><form method='post' action='/healthbeat/AppointmentServlet'><input type='hidden' name='day' value='Wednesday'/>"
											+ "<button name='time' type='submit' value='" +wednesday_av.get(i)+ "' class='btn btn-link'>" +wednesday_av.get(i)+ "</button></form></td>");
									}
									if (wednesday != maximum) {
										for (int i = 0; i<maximum-wednesday; i++) {
											out.print("<td>-</td>");
										}
									}
								}
								else {
									for (int i = 0; i<maximum; i++) {
										out.print("<td>-</td>");
									}
								}
								out.println("</tr>");
								
								out.println("<tr><th>Thursday<br/></th>");
								if (!thursday_av.isEmpty()) {
									for (int i = 0; i<thursday; i++) {
										out.println("<td><form method='post' action='/healthbeat/AppointmentServlet'><input type='hidden' name='day' value='Thursday'/>"
											+ "<button name='time' type='submit' value='" +thursday_av.get(i)+ "' class='btn btn-link'>" +thursday_av.get(i)+ "</button></form></td>");
									}
									if (thursday != maximum) {
										for (int i = 0; i<maximum-thursday; i++) {
											out.print("<td>-</td>");
										}
									}
								}
								else {
									for (int i = 0; i<maximum; i++) {
										out.print("<td>-</td>");
									}
								}
								out.println("</tr>");
								
								out.println("<tr><th>Friday<br/></th>");
								if (!friday_av.isEmpty()) {
									for (int i = 0; i<friday; i++) {
										out.println("<td><form method='post' action='/healthbeat/AppointmentServlet'><input type='hidden' name='day' value='Friday'/>"
											+ "<button name='time' type='submit' value='" +friday_av.get(i)+ "' class='btn btn-link'>" +friday_av.get(i)+ "</button></form></td>");
									}
									if (friday != maximum) {
										for (int i = 0; i<maximum-friday; i++) {
											out.print("<td>-</td>");
										}
									}
								}
								else {
									for (int i = 0; i<maximum; i++) {
										out.print("<td>-</td>");
									}
								}
								out.println("</tr>");
								
								monday_av.clear();
								tuesday_av.clear();
								wednesday_av.clear();
								thursday_av.clear();
								friday_av.clear();
								
								session.setAttribute("monday_av", monday_av);
								session.setAttribute("tuesday_av", tuesday_av);
								session.setAttribute("wednesday_av", wednesday_av);
								session.setAttribute("thursday_av", thursday_av);
								session.setAttribute("friday_av", friday_av);
								
								}
								catch (Exception e) {
									e.printStackTrace();
								}
				        	%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Footer -->
	<footer class="container-fluid text-center">
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