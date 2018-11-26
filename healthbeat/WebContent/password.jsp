<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>Change password</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer user_id = (Integer)session.getAttribute("id");
		if(user_id == null) {
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
		    		<%	Integer role = (Integer)session.getAttribute("role");
			    		if (role != null && role == 2) {
	        				out.println("<li><a href='add_doctor.jsp'>Add doctor</a></li>");
	        				out.println("<li><a href='add_patient.jsp'>Add patient</a></li>");
	        				out.println("<li><a href='admin_panel.jsp'><span class='glyphicon glyphicon-cog'></span> Admin panel</a></li>");
	        			}
			    		else if (role != null && role == 1) {
			    			out.println("<li><a href='doctor.jsp'>My appointments</a></li>");
	        				out.println("<li><a href='my_availability.jsp'>My availability</a></li>");
	        			}
			    		else if (role != null && role == 0) {
	        				out.println("<li><a href='patient.jsp'>My appointments</a></li>");
	        			}
		        	%>
		        	<li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Change password form -->
	<div class="wrapper">
		<form class="form-horizontal form-md bg-white" method="post" action="/healthbeat/ChangePasswordServlet">
			<input type="hidden" name="requestType" value="Insert"/>
			<div class="page-header">
            	<h2 class="text-center">Change password</h2>
        	</div>
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
        	<div class="form-group">
				<label class="control-label col-sm-3" for="old_password">Old pass</label>  
				<div class="col-sm-7">
					<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
						<input name="old_password" type="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}" placeholder="Type your old password" 
							class="form-control" required="required"/>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-3" for="password">New pass</label>  
				<div class="col-sm-7">
					<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
						<input name="password" type="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}" placeholder="At least 8 digits password" 
							title="The password must contain 1 uppercase , 1 lowercase and a number." class="form-control" required="required"/>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-3" for="password2">Verify</label>  
				<div class="col-sm-7">
					<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
						<input name="password2" type="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}" placeholder="Repeat new password" 
					  		class="form-control" required="required"/>
					</div>
				</div>
			</div><br/>
			<div class="form-group">
				<div class="col-sm-offset-3 col-sm-7">
					<button name="reset" type="reset" class="btn btn-success">Clear</button>
					<button name="submit" type="submit" class="btn btn-primary pull-right">Update</button>
				</div>
			</div>
		</form>
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