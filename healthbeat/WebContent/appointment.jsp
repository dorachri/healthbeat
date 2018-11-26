<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, java.util.ArrayList, javax.naming.InitialContext, javax.sql.DataSource, java.time.LocalDate, java.time.format.DateTimeFormatter"%>
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
	<title>Appointment</title>
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
	
	<!-- Appointment card -->
	<div class="container">
		<div class="row">
			<div class="col-sm-offset-3 col-sm-6">
				<div class="panel panel-default">
    				<div class="panel-heading">
    					<h3 class="text-center">My appointment</h3>
    				</div>
    				<div class="panel-body">
    					<%	String msg_header = (String)session.getAttribute("msg_header");
			        		String msg = (String)session.getAttribute("msg");
			        		if (msg_header != null && msg != null) {
			        			if (msg_header.equals("Error!")) {
			        				out.println("<div class='row col-sm-offset-1 col-sm-10'><div class='alert alert-danger alert-dismissible fade in'>"
			        					+ "<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div></div>");
			        			}
			        			else if (msg_header.equals("Success!")) {
			        				out.println("<div class='row col-sm-offset-1 col-sm-10'><div class='alert alert-success alert-dismissible fade in'>"
			        					+ "<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div></div>");
			        			}
			        		}
			        		session.setAttribute("msg_header", null);
			        		session.setAttribute("msg", null);
			        	%>
    					<div class="col-sm-offset-3 col-sm-6 text-center">
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
									
									out.println("<br/><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-lg btn-block'>" +docName+ " " +docSurname+ "</button></form>");
									out.println("<p class='text-center'><strong>" +specialty+ "</strong></p>");
									
									String office = address + ", " + location + ", " + region;
									out.println("<p class='text-center'><span class='glyphicon glyphicon-map-marker'></span> " +office+ "</p>");
									
									String day = (String)session.getAttribute("day");
									LocalDate date = (LocalDate)session.getAttribute("date");
									String time = (String)session.getAttribute("time");
									DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-YYYY");
									out.println("<p class='text-center'><span class='glyphicon glyphicon-calendar'></span> <strong>" +day+ " " +formatter.format(date)+ ", " +time+ "</strong></p>");
									
									out.println("<br/>");
									out.println("<form method='post' action='/healthbeat/ConfirmServlet'><button name='confirm' type='submit' class='btn btn-danger btn-lg btn-block'>Confirm</button></form>");
									out.println("<br/>");
										
								}
								catch (Exception e) {
									e.printStackTrace();
								}
					    	%>
    					</div>
    				</div>
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