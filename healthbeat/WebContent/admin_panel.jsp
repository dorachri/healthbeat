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
	<title>Admin panel</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer role = (Integer)session.getAttribute("role");
		if(role == null || role != 2) {
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
		    		<li><a href="add_doctor.jsp">Add doctor</a></li>
		    		<li><a href="add_patient.jsp">Add patient</a></li>
		    		<li class="active"><a href="admin_panel.jsp"><span class="glyphicon glyphicon-cog"></span> Admin panel</a></li>
		    		<li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Content -->
	<div class="container-fluid2">
		<div class="row">
			<div class="col-sm-offset-1 col-sm-2">
				<h3 class="text-center">Total</h3>
				<ul class="list-group">
					<%	DataSource datasource = null;
					
						try {
							InitialContext ctx = new InitialContext();
							datasource = (DataSource)ctx.lookup("java:comp/env/jdbc/LiveDataSource");
						}
						catch (Exception e) {
							throw new ServletException(e.toString());
						}
						
						int users = 0;
						int patients = 0;
						int doctors = 0;
						int admins = 0;
						
						try {
							Connection con = datasource.getConnection();
							String query = "SELECT count(user_id) AS users FROM mydb.users";
							PreparedStatement ps = con.prepareStatement(query);
							ResultSet rs = ps.executeQuery();
							
							while (rs.next()) {
								users = rs.getInt("users");
							}
							
							rs.close();
						    ps.close();
							
							query = "SELECT count(patient_id) AS patients FROM mydb.patients";
							PreparedStatement ps2 = con.prepareStatement(query);
							ResultSet rs2 = ps2.executeQuery();
							
							while (rs2.next()) {
								patients = rs2.getInt("patients");
							}
							
							rs2.close();
						    ps2.close();
							
							query = "SELECT count(doctor_id) AS doctors FROM mydb.doctors";
							PreparedStatement ps3 = con.prepareStatement(query);
							ResultSet rs3 = ps3.executeQuery();
							
							while (rs3.next()) {
								doctors = rs3.getInt("doctors");
							}
							
							rs3.close();
						    ps3.close();
							
							query = "SELECT count(user_id) AS admins FROM mydb.users WHERE role=2";
							PreparedStatement ps4 = con.prepareStatement(query);
							ResultSet rs4 = ps4.executeQuery();
							
							while (rs4.next()) {
								admins = rs4.getInt("admins");
							}
							
							rs4.close();
						    ps4.close();
							con.close();
							
							out.println("<li class='list-group-item'>Users <span class='badge'>" +users+ "</span></li>");
							out.println("<li class='list-group-item'>Patients <span class='badge'>" +patients+ "</span></li>");
							out.println("<li class='list-group-item'>Doctors <span class='badge'>" +doctors+ "</span></li>");
							out.println("<li class='list-group-item'>Admins <span class='badge'>" +admins+ "</span></li>");
						}
						catch (SQLException sqle) {
							sqle.printStackTrace();
						}
		        	%>
				</ul><br/>
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
		        <br/>
			</div>
			<div class="col-sm-8">
				<h3>Database records</h3>
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#users">Users</a></li>
					<li><a data-toggle="tab" href="#patients">Patients</a></li>
					<li><a data-toggle="tab" href="#doctors">Doctors</a></li>
					<li><a data-toggle="tab" href="#admins">Admins</a></li>
				</ul>
				<div class="tab-content">
			    	<div id="users" class="tab-pane fade in active">
			      		<h3>Users</h3>
			      		<input class="form-control" id="users_input" type="text" placeholder="Search.."/><br/>
			      		<div class="table-responsive text-center">
			      			<table class="table table-bordered table-striped bg-white">
				      			<thead>
							      	<tr>
								        <th>ID</th>
								        <th>First name</th>
								        <th>Last name</th>
								        <th>Username</th>
								        <th>Email</th>
								        <th>Info</th>
								        <th>Delete</th>
							      	</tr>
						    	</thead>
						    	<tbody id="users_table">
						    		<%	String name, surname, username, email;
							    		int id;
							    		try {
											Connection con = datasource.getConnection();
											String query = "SELECT * FROM mydb.users";
											PreparedStatement ps = con.prepareStatement(query);
											ResultSet rs = ps.executeQuery();
											
											while (rs.next()) {
												id = rs.getInt("user_id");
												name = rs.getString("name");
												surname = rs.getString("surname");
												username = rs.getString("username");
												email = rs.getString("email");
												out.println("<tr><td>" +id+ "</td>");
												out.println("<td>" +name+ "</td>");
												out.println("<td>" +surname+ "</td>");
												out.println("<td>" +username+ "</td>");
												out.println("<td>" +email+ "</td>");
												out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +id+ "' class='btn btn-primary btn-sm'><span class='glyphicon glyphicon-info-sign'></span></button></form></td>");
												out.println("<td><form method='post' action='/healthbeat/DeleteUserServlet'><button name='delete' type='submit' value='" +id+ "' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-trash'></span></button></form></td></tr>");
											}
											
											rs.close();
										    ps.close();
											con.close();
											
										}
										catch (SQLException sqle) {
											sqle.printStackTrace();
										}
						        	%>
						    	</tbody>
				      		</table>
			      		</div>
			    	</div>
			    	<div id="patients" class="tab-pane fade">
			      		<h3>Patients</h3>
			      		<input class="form-control" id="patients_input" type="text" placeholder="Search.."/><br/>
			      		<div class="table-responsive text-center">
			      			<table class="table table-bordered table-striped bg-white">
				      			<thead>
							      	<tr>
								        <th>ID</th>
								        <th>First name</th>
								        <th>Last name</th>
								        <th>AMKA</th>
								        <th>Info</th>
								        <th>Delete</th>
							      	</tr>
						    	</thead>
						    	<tbody id="patients_table">
						    		<%	String amka;
							    		try {
											Connection con = datasource.getConnection();
											String query = "SELECT * FROM mydb.users";
											PreparedStatement ps = con.prepareStatement(query);
											ResultSet rs = ps.executeQuery();
											
											while (rs.next()) {
												id = rs.getInt("user_id");
												name = rs.getString("name");
												surname = rs.getString("surname");
												
												query = "SELECT * FROM mydb.patients WHERE patient_id=?";
												PreparedStatement ps2 = con.prepareStatement(query);
												ps2.setInt(1, id);
												ResultSet rs2 = ps2.executeQuery();
												
												while (rs2.next()) {
													amka = rs2.getString("amka");
													out.println("<tr><td>" +id+ "</td>");
													out.println("<td>" +name+ "</td>");
													out.println("<td>" +surname+ "</td>");
													out.println("<td>" +amka+ "</td>");
													out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +id+ "' class='btn btn-primary btn-sm'><span class='glyphicon glyphicon-info-sign'></span></button></form></td>");
													out.println("<td><form method='post' action='/healthbeat/DeleteUserServlet'><button name='delete' type='submit' value='" +id+ "' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-trash'></span></button></form></td></tr>");
												}
												
												rs2.close();
											    ps2.close();
												
											}
											
											rs.close();
										    ps.close();
											con.close();
											
										}
										catch (SQLException sqle) {
											sqle.printStackTrace();
										}
						        	%>
						    	</tbody>
				      		</table>
			      		</div>
			    	</div>
			    	<div id="doctors" class="tab-pane fade">
			      		<h3>Doctors</h3>
			      		<input class="form-control" id="doctors_input" type="text" placeholder="Search.."/><br/>
			      		<div class="table-responsive text-center">
			      			<table class="table table-bordered table-striped bg-white">
				      			<thead>
							      	<tr>
								        <th>ID</th>
								        <th>First name</th>
								        <th>Last name</th>
								        <th>Specialty</th>
								        <th>AMKA</th>
								        <th>Info</th>
								        <th>Delete</th>
							      	</tr>
						    	</thead>
						    	<tbody id="doctors_table">
						    		<%	String specialty;
							    		try {
											Connection con = datasource.getConnection();
											String query = "SELECT * FROM mydb.users";
											PreparedStatement ps = con.prepareStatement(query);
											ResultSet rs = ps.executeQuery();
											
											while (rs.next()) {
												id = rs.getInt("user_id");
												name = rs.getString("name");
												surname = rs.getString("surname");
												
												query = "SELECT * FROM mydb.doctors WHERE doctor_id=?";
												PreparedStatement ps2 = con.prepareStatement(query);
												ps2.setInt(1, id);
												ResultSet rs2 = ps2.executeQuery();
												
												while (rs2.next()) {
													amka = rs2.getString("amka");
													specialty = rs2.getString("specialty");
													
													out.println("<tr><td>" +id+ "</td>");
													out.println("<td>" +name+ "</td>");
													out.println("<td>" +surname+ "</td>");
													out.println("<td>" +specialty+ "</td>");
													out.println("<td>" +amka+ "</td>");
													out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +id+ "' class='btn btn-primary btn-sm'><span class='glyphicon glyphicon-info-sign'></span></button></form></td>");
													out.println("<td><form method='post' action='/healthbeat/DeleteUserServlet'><button name='delete' type='submit' value='" +id+ "' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-trash'></span></button></form></td></tr>");
												}
												
												rs2.close();
											    ps2.close();
												
											}
											
											rs.close();
										    ps.close();
											con.close();
											
										}
										catch (SQLException sqle) {
											sqle.printStackTrace();
										}
						        	%>
						    	</tbody>
				      		</table>
			      		</div>
			    	</div>
			    	<div id="admins" class="tab-pane fade">
			      		<h3>Admins</h3>
			      		<input class="form-control" id="admins_input" type="text" placeholder="Search.."/><br/>
			      		<div class="table-responsive text-center">
			      			<table class="table table-bordered table-striped bg-white">
				      			<thead>
							      	<tr>
								        <th>ID</th>
								        <th>First name</th>
								        <th>Last name</th>
								        <th>Username</th>
								        <th>Email</th>
								        <th>Info</th>
								        <th>Delete</th>
							      	</tr>
						    	</thead>
						    	<tbody id="admins_table">
						    		<%	try {
						    				Connection con = datasource.getConnection();
											String query = "SELECT * FROM mydb.users WHERE role=2";
											PreparedStatement ps = con.prepareStatement(query);
											ResultSet rs = ps.executeQuery();
											
											while (rs.next()) {
												id = rs.getInt("user_id");
												name = rs.getString("name");
												surname = rs.getString("surname");
												username = rs.getString("username");
												email = rs.getString("email");
												out.println("<tr><td>" +id+ "</td>");
												out.println("<td>" +name+ "</td>");
												out.println("<td>" +surname+ "</td>");
												out.println("<td>" +username+ "</td>");
												out.println("<td>" +email+ "</td>");
												out.println("<td><form method='post' action='/healthbeat/UserDetailsServlet'><button name='details' type='submit' value='" +id+ "' class='btn btn-primary btn-sm'><span class='glyphicon glyphicon-info-sign'></span></button></form></td>");
												out.println("<td><form method='post' action='/healthbeat/DeleteUserServlet'><button name='delete' type='submit' value='" +id+ "' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-trash'></span></button></form></td></tr>");
											}
											
											rs.close();
										    ps.close();
											con.close();
											
										}
										catch (SQLException sqle) {
											sqle.printStackTrace();
										}
						        	%>
						    	</tbody>
				      		</table>
			      		</div>
			    	</div>
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
	    	$("#users_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#users_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
	    	
	    	$("#patients_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#patients_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
	    	
	    	$("#doctors_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#doctors_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
	    	
	    	$("#admins_input").on("keyup", function() {
	    		var value = $(this).val().toLowerCase();
	    		$("#admins_table tr").filter(function() {
	    	    	$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    		});
	    	});
		});
	</script>
</body>
</html>