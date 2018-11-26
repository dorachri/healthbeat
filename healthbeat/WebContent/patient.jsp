<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, javax.sql.DataSource, javax.naming.InitialContext, java.time.LocalDate, java.time.format.DateTimeFormatter, java.sql.Date"%>
<%@ page import="Mainpackage.User"%>
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
	<title>My appointments</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer role = (Integer)session.getAttribute("role");
		if(role == null || role != 0) {
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
		    		<li class="active"><a href="patient.jsp">My appointments</a></li>
		    		<li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Patient appointments -->
	<div class="container">
		<h3>My appointments</h3><br/>
		<%	String msg_header = (String)session.getAttribute("msg_header");
        	String msg = (String)session.getAttribute("msg");
        	if (msg_header != null && msg != null) {
        		if (msg_header.equals("Error!")) {
        			out.println("<div class='alert alert-danger alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div>");
        		}
        		else if (msg_header.equals("Success!")) {
        			out.println("<div class='alert alert-success alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div>");
        		}
        	}
        	session.setAttribute("msg_header", null);
        	session.setAttribute("msg", null);
        %>
		<ul class="nav nav-tabs">
			<li class="active"><a data-toggle="tab" href="#future">Future</a></li>
			<li><a data-toggle="tab" href="#past">Past</a></li>
			<li><a data-toggle="tab" href="#canceled">Canceled</a></li>
		</ul><br/>
		<%	DataSource datasource = null;
			
			try {
				InitialContext ctx = new InitialContext();
				datasource = (DataSource)ctx.lookup("java:comp/env/jdbc/LiveDataSource");
			}
			catch (Exception e) {
				throw new ServletException(e.toString());
			}
			
			Integer patient_id = (Integer)session.getAttribute("id");
			LocalDate today = LocalDate.now();
			String query, time, name, surname;
			Date date;
		    int doctor_id;
		%>
		<div class="tab-content">
			<div id="future" class="tab-pane fade in active">
				<h3>Future appointments</h3>
			    <input class="form-control" id="future_input" type="text" placeholder="Search.."/><br/>
			    <div class="table-responsive text-center">
			    	<table class="table table-bordered table-striped vertical-align bg-white">
				    	<thead>
							<tr>
								<th>Date</th>
								<th>Time</th>
								<th>Doctor</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody id="future_table">
							<%	try {
							    	Connection con = datasource.getConnection();
									query = "SELECT * FROM mydb.appointments WHERE patient_id=? AND date>=? AND canceled=0 ORDER BY date, time";
									PreparedStatement ps = con.prepareStatement(query);
									ps.setInt(1, patient_id);
									ps.setDate(2, java.sql.Date.valueOf(today));
									ResultSet rs = ps.executeQuery();
									
									while (rs.next()) {
										date = rs.getDate("date");
										time = rs.getString("time");
										doctor_id = rs.getInt("doctor_id");
										
										PreparedStatement ps2 = con.prepareStatement(User.findUserNameSurnameGender());
										ps2.setInt(1, doctor_id);
										ResultSet rs2 = ps2.executeQuery();
										
										while (rs2.next()) {
											name = rs2.getString("name");
											surname = rs2.getString("surname");
											
											LocalDate localdate = date.toLocalDate();
											DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-YYYY");
											out.println("<tr><td>" +formatter.format(localdate)+ "</td>");
											out.println("<td>" +time+ "</td>");
											out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-block'>" +name+ " " +surname+ "</button></form></td>");
											out.println("<td><form method='post' action='/healthbeat/CancelServlet'><input type='hidden' name='date' value='" +date+ "'/><input type='hidden' name='time' value='" +time+ "'/>"
												+ "<button name='cancel' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-block'>Cancel</button></form></td></tr>");
										}
										
										rs2.close();
									    ps2.close();
										
									}
										
									rs.close();
								    ps.close();
								    con.close();
										
								}
								catch (Exception e) {
									e.printStackTrace();
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<div id="past" class="tab-pane fade">
				<h3>Past appointments</h3>
			    <input class="form-control" id="past_input" type="text" placeholder="Search.."/><br/>
			    <div class="table-responsive text-center">
			    	<table class="table table-bordered table-striped vertical-align bg-white">
				    	<thead>
							<tr>
								<th>Date</th>
								<th>Time</th>
								<th>Doctor</th>
							</tr>
						</thead>
						<tbody id="past_table">
							<%	try {
									Connection con = datasource.getConnection();
									query = "SELECT * FROM mydb.appointments WHERE patient_id=? AND date<? AND canceled=0 ORDER BY date, time DESC";
									PreparedStatement ps = con.prepareStatement(query);
									ps.setInt(1, patient_id);
									ps.setDate(2, java.sql.Date.valueOf(today));
									ResultSet rs = ps.executeQuery();
									
									while (rs.next()) {
										date = rs.getDate("date");
										time = rs.getString("time");
										doctor_id = rs.getInt("doctor_id");
										
										PreparedStatement ps2 = con.prepareStatement(User.findUserNameSurnameGender());
										ps2.setInt(1, doctor_id);
										ResultSet rs2 = ps2.executeQuery();
										
										while (rs2.next()) {
											name = rs2.getString("name");
											surname = rs2.getString("surname");
											
											LocalDate localdate = date.toLocalDate();
											DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-YYYY");
											out.println("<tr><td>" +formatter.format(localdate)+ "</td>");
											out.println("<td>" +time+ "</td>");
											out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-block'>" +name+ " " +surname+ "</button></form></td>");
										}
											
										rs2.close();
									    ps2.close();
										
									}
										
									rs.close();
								    ps.close();
								    con.close();
									
								}
								catch (Exception e) {
									e.printStackTrace();
								}
							%>
						</tbody>
					</table>
			 	</div>
			</div>
			<div id="canceled" class="tab-pane fade">
				<h3>Canceled appointments</h3>
			    <input class="form-control" id="canceled_input" type="text" placeholder="Search.."/><br/>
			    <div class="table-responsive text-center">
			    	<table class="table table-bordered table-striped vertical-align bg-white">
				    	<thead>
							<tr>
								<th>Date</th>
								<th>Time</th>
								<th>Doctor</th>
							</tr>
						</thead>
						<tbody id="canceled_table">
							<%	try {
									Connection con = datasource.getConnection();
									query = "SELECT * FROM mydb.appointments WHERE patient_id=? AND canceled=1 ORDER BY date, time DESC";
									PreparedStatement ps = con.prepareStatement(query);
									ps.setInt(1, patient_id);
									ResultSet rs = ps.executeQuery();
									
									while (rs.next()) {
										date = rs.getDate("date");
										time = rs.getString("time");
										doctor_id = rs.getInt("doctor_id");
										
										PreparedStatement ps2 = con.prepareStatement(User.findUserNameSurnameGender());
										ps2.setInt(1, doctor_id);
										ResultSet rs2 = ps2.executeQuery();
										
										while (rs2.next()) {
											name = rs2.getString("name");
											surname = rs2.getString("surname");
											
											LocalDate localdate = date.toLocalDate();
											DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-YYYY");
											out.println("<tr><td>" +formatter.format(localdate)+ "</td>");
											out.println("<td>" +time+ "</td>");
											out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +doctor_id+ "' class='btn btn-link btn-block'>" +name+ " " +surname+ "</button></form></td>");
										}
											
										rs2.close();
									    ps2.close();
												
									}
									
									rs.close();
								    ps.close();
								    con.close();
											
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
    
    <script>
		$(document).ready(function(){
	    	$("#future_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#future_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
	    	
	    	$("#past_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#past_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
	    	
	    	$("#canceled_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#canceled_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
		});
	</script>
</body>
</html>