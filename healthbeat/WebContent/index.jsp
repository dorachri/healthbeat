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
	<title>Healthbeat</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
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
	
	<!-- Search doctor form -->
	<div class="container bg-white">
		<form method="post" action="/healthbeat/SearchServlet">
			<div class="page-header">
				<h2 class="text-center text-primary">Search for available appointments</h2>
			</div><br/>
			<%	String msg_header = (String)session.getAttribute("msg_header");
        		String msg = (String)session.getAttribute("msg");
        		if (msg_header != null && msg != null) {
        			out.println("<div class='row col-sm-offset-3'><div class='col-sm-8 alert alert-danger alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div></div>");
        		}
        		session.setAttribute("msg_header", null);
        		session.setAttribute("msg", null);
        	%>
			<div class="row text-center">
				<p>Fill out the form below to make a quick and easy appointment with a doctor near you.</p>
			</div><br/>
        	<div class="row col-sm-offset-1 text-center">
        		<div class="form-group col-sm-3">
					<label for="specialty">Doctor's specialty</label>
		        	<select class="form-control" name="specialty" required="required">
		        		<option selected>Select</option>
		        		<option>Cardiologist</option>
		        		<option>Dentist</option>
		        		<option>Dermatologist - Αphrodisiacologist</option>
		        		<option>Endocrinologist</option>
		        		<option>Gastroenterologist</option>
		        		<option>General practitioner</option>
		        		<option>Νephrologist</option>
		        		<option>Neurologist</option>
		        		<option>Obstetrician - Gynecologist</option>
				        <option>Ophthalmologist</option>
				        <option>Orthopedist</option>
				        <option>Otolaryngologist</option>
				    	<option>Pathologist</option>
				    	<option>Pediatrician</option>
				    	<option>Psychiatrist</option>
				    	<option>Surgeon</option>
				    	<option>Urologist - Andrologist</option>
					</select>
		    	</div>
		    	<div class="form-group col-sm-3">
					<label for="region">Region</label>
		        	<select class="form-control" name="region" required="required">
		        		<option selected>Select</option>
		        		<option>Attica</option>
		        		<option>Central Macedonia</option>
		        		<option>Western Greece</option>
		        		<option>Thrace</option>
		        		<option>Macedonia</option>
		        		<option>Thessaly</option>
		        		<option>Epirus</option>
				        <option>Central Greece</option>
				        <option>Peloponnese</option>
				    	<option>Aegean Islands</option>
				    	<option>Ionian Islands</option>
				    	<option>Crete</option>
					</select>
		    	</div>
		    	<div class="form-group col-sm-2">
		    		<label for="location">City/Commune</label>
		    		<input class="form-control" name="location" type="text" placeholder="Enter" required="required"/>
		    	</div>
		    	<div class="form-group col-sm-2">
		    		<label for="price">Max price</label>
		    		<div class="input-group">
		    			<span class="input-group-addon">&euro;</span>
		    			<input class="form-control" name="price" type="text" placeholder="Enter" required="required"/>
		    		</div>
		    	</div>
			</div><br/>
			<div class="row col-sm-offset-4 col-sm-4">
				<div class="form-group">
					<button class="btn btn-success" type="reset">Clear</button>
	          		<button class="btn btn-primary pull-right" type="submit">Search</button>
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