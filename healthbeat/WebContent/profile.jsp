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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mystyle.css">
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/Images/favicon.ico"/>
	<title>My profile</title>
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
		    		<li class="active"><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>


	<!-- Profile form -->
	<div class="container">
		<div class="panel panel-default">
			<div class="panel-heading">
				<%	String name = (String)session.getAttribute("name");
	        		String surname = (String)session.getAttribute("surname");
	        		out.println("<h3 class='text-center'>" +name+ " " +surname+ "</h3>");
	        	%>
			</div>
			<div class="panel-body">
				<div class="col-sm-offset-1 col-sm-3">
					<%	Integer gender = (Integer)session.getAttribute("gender");
						String specialty = (String)session.getAttribute("specialty");
		        		if (gender != null && gender == 0) {
		        			out.println("<br/><img alt='User default picture' src='Images/man.jpg' class='img-circle img-responsive'><br/>");
		        		}
		        		else if (gender != null && gender == 1) {
		        			out.println("<br/><img alt='User default picture' src='Images/woman.jpg' class='img-circle img-responsive'><br/>");
		        		}
		        		
		        		if (role != null && role == 1) {
		        			out.println("<h4 class='text-center'>" +specialty+ "</h4>");
		        		}
		        	%>
				</div><br/>
				<form class="col-sm-7 form-horizontal" method="post" action="/healthbeat/UpdateServlet">
					<%	String msg_header = (String)session.getAttribute("msg_header");
		        		String msg = (String)session.getAttribute("msg");
		        		if (msg_header != null && msg != null) {
		        			if (msg_header.equals("Error!")) {
		        				out.println("<div class='row col-sm-offset-2 col-sm-10'><div class='alert alert-danger alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div></div>");
		        			}
		        			else if (msg_header.equals("Success!")) {
		        				out.println("<div class='row col-sm-offset-2 col-sm-10'><div class='alert alert-success alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div></div>");
		        			}
		        		}
		        		session.setAttribute("msg_header", null);
		        		session.setAttribute("msg", null);
		        	%>
					<div class="form-group">
						<label class="control-label col-sm-4" for="fn">Username</label>  
						<div class="col-sm-7">
							<div class="input-group">
								<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
								<input name="username" type="text" class="form-control" value="<%=session.getAttribute("username")%>" required="required"/>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-4" for="email">Email</label>  
						<div class="col-sm-7">
							<div class="input-group">
								<span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
								<input name="email" type="email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" class="form-control" value="<%=session.getAttribute("email")%>" required="required"/>
							</div>
						</div>
					</div>
					<%	String amka = (String)session.getAttribute("amka");
						String telephone = (String)session.getAttribute("telephone");
						String mobile = (String)session.getAttribute("mobile");
						String region = (String)session.getAttribute("region");
						String location = (String)session.getAttribute("location");
						String address = (String)session.getAttribute("address");
						String zip_code = (String)session.getAttribute("zip_code");
						Double cost = (Double)session.getAttribute("cost");
	        			if (role != null && role == 0) {
	        				out.println("<div class='form-group'><label class='control-label col-sm-4' for='amka'>AMKA</label><div class='col-sm-7'><input name='amka' type='text' class='form-control' value='" +amka+ "' disabled/></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='mobile'>Mobile</label><div class='col-sm-7'><div class='input-group'><span class='input-group-addon'><i class='glyphicon glyphicon-phone'></i></span><input name='mobile' type='text' class='form-control' value='" +mobile+ "' required='required'/></div></div></div>");
	        			}
	        			else if (role != null && role == 1) {
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='amka'>AMKA</label><div class='col-sm-7'><input name='amka' type='text' class='form-control' value='" +amka+ "' disabled/></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='telephone'>Telephone</label><div class='col-sm-7'><div class='input-group'><span class='input-group-addon'><i class='glyphicon glyphicon-earphone'></i></span><input name='telephone' type='text' class='form-control' value='" +telephone+ "' required='required'/></div></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='mobile'>Mobile</label><div class='col-sm-7'><div class='input-group'><span class='input-group-addon'><i class='glyphicon glyphicon-phone'></i></span><input name='mobile' type='text' class='form-control' value='" +mobile+ "' required='required'/></div></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='cost'>Cost</label><div class='col-sm-7'><div class='input-group'><span class='input-group-addon'>&euro;</span><input name='cost' type='text' class='form-control' value='" +cost+ "' required='required'/></div></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='region'>Region</label><div class='col-sm-7'><input name='region' type='text' class='form-control' value='" +region+ "' required='required'/></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='location'>City/Commune</label><div class='col-sm-7'><input name='location' type='text' class='form-control' value='" +location+ "' required='required'/></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='address'>Address</label><div class='col-sm-7'><input name='address' type='text' class='form-control' value='" +address+ "' required='required'/></div></div>");
							out.println("<div class='form-group'><label class='control-label col-sm-4' for='zip_code'>Zip code</label><div class='col-sm-7'><input name='zip_code' type='text' class='form-control' value='" +zip_code+ "' required='required'/></div></div>");
		        		}
		        	%>
		        	<br/>
		        	<div class="form-group">
						<div class="col-sm-offset-4 col-sm-7">
							<button name="update" type="submit" class="btn btn-primary">Update</button>
							<a class="btn btn-danger pull-right" href="password.jsp"><span class="glyphicon glyphicon-pencil"></span> Password</a>
						</div>
					</div>
				</form>
			</div><br/>
			<%	if (role != null && role == 0) {
					out.println("<div class='panel-footer text-center'><form method='post' action='/healthbeat/DeleteUserServlet'><button name='delete' type='submit' value='" +user_id+ "' class='btn btn-link'>Click here to delete your profile</button></form></div>");
				}
	        %>
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