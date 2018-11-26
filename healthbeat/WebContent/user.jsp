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
	<title>User card</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer user_id2 = (Integer)session.getAttribute("id2");
		if(user_id2 == null) {
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
	
	<!-- User card -->
	<div class="container">
		<div class="row">
			<div class="col-sm-offset-3 col-sm-6">
				<div class="panel panel-default">
    				<div class="panel-heading">
    					<%	String name = (String)session.getAttribute("name2");
			        		String surname = (String)session.getAttribute("surname2");
			        		out.println("<h3 class='text-center'>" +name+ " " +surname+ "</h3>");
			        	%>
    				</div>
    				<div class="panel-body">
    					<div class="col-sm-offset-3 col-sm-6 text-center">
    						<%	Integer gender = (Integer)session.getAttribute("gender2");
    							Integer role2 = (Integer)session.getAttribute("role2");
								String mobile = (String)session.getAttribute("mobile2");
								
				        		if (gender != null && gender == 0) {
				        			out.println("<br/><img alt='User default picture' src='Images/man.jpg' class='img-circle img-responsive'><br/>");
				        		}
				        		else if (gender != null && gender == 1) {
				        			out.println("<br/><img alt='User default picture' src='Images/woman.jpg' class='img-circle img-responsive'><br/>");
				        		}
				        		
				        		if (role2 != null && role2 == 0) {
				        			out.println("<p><span class='glyphicon glyphicon-phone'></span> " +mobile+ "</p>");
				        		}
				        		else if (role2 != null && role2 == 1) {
				        			String specialty = (String)session.getAttribute("specialty2");
	    							String telephone = (String)session.getAttribute("telephone2");
	    							String region = (String)session.getAttribute("region2");
	    							String location = (String)session.getAttribute("location2");
	    							String address = (String)session.getAttribute("address2");
	    							String zip_code = (String)session.getAttribute("zip_code2");
				        			out.println("<h4>" +specialty+ "</h4><br/>");
				        			out.println("<p><span class='glyphicon glyphicon-map-marker'></span> " +address+ ", " +zip_code+ ", " +location+ ", " +region+ "</p>");
				        			out.println("<p><span class='glyphicon glyphicon-earphone'></span> " +telephone+ "</p>");
				        			out.println("<p><span class='glyphicon glyphicon-phone'></span> " +mobile+ "</p>");
				        		}
				        		
				        		session.setAttribute("id2", null);
				        	%>
      						<p><span class="glyphicon glyphicon-envelope"></span> <a href="mailto:<%=session.getAttribute("email2")%>"><%=session.getAttribute("email2")%></a></p>
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