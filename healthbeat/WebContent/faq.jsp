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
	<title>FAQ</title>
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
		        	<li class="active"><a href="faq.jsp">FAQ</a></li>
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
	
	<!-- FAQ -->
    <div class="container bg-white">
    	<div class="page-header">
            <h2 class="col-sm-offset-1">Frequently Asked Questions - FAQ</h2>
        </div>

        <div class="panel-group col-sm-offset-1 col-sm-9" id="accordion">
            <h4 class="text-primary">General questions</h4>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">
                            Is the service free?
                        </a>
                    </h4>
                </div>
                <div id="collapse1" class="panel-collapse collapse ">
                    <div class="panel-body">
                        The service is 100% free for the patients.
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">
                            In order to use the application should I create an account?
                        </a>
                    </h4>
                </div>
                <div id="collapse2" class="panel-collapse collapse">
                    <div class="panel-body">
                        The user should first create an account and then login in order to use the application.
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse3">
                            How can I contact for more information?
                        </a>
                    </h4>
                </div>
                <div id="collapse3" class="panel-collapse collapse">
                    <div class="panel-body">
                        For more information you can email us at <a href="mailto:support@healthbeat.gr">support@healthbeat.gr</a> or via <a href="contact.jsp">contact form</a>.
                    </div>
                </div>
            </div><br/><br/>

            <h4 class="text-primary">Patient</h4>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse5">
                            How can I subscribe to the service?
                        </a>
                    </h4>
                </div>
                <div id="collapse5" class="panel-collapse collapse">
                    <div class="panel-body">
                        You can subscribe to Healthbeat via <a href="signup.jsp">sign up</a> form or <a href="contact.jsp">contact us</a> to do it for you. 
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse6">
                            How can I make an appointment?
                        </a>
                    </h4>
                </div>
                <div id="collapse6" class="panel-collapse collapse">
                    <div class="panel-body">
                        In order to make an appointment you should first search for the doctor you need. You could choose a doctor from the results list and then choose the day and hour you like, from the doctor's weekly availability list.
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse7">
                            For how long can I cancel an appointment?
                        </a>
                    </h4>
                </div>
                <div id="collapse7" class="panel-collapse collapse">
                    <div class="panel-body">
                        Cancellation of an appointment is valid until 1 day before the appointment.
                    </div>
                </div>
            </div></br></br>

            <h4 class="text-primary">Doctor</h4>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse8">
                            How can I subscribe to the service?
                        </a>
                    </h4>
                </div>
                <div id="collapse8" class="panel-collapse collapse">
                    <div class="panel-body">
                        In order to subscribe to Healthbeat as a doctor, you should first <a href="contact.jsp">contact us</a> to ask you for the necessary information.
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse9">
                            For how long can I cancel an appointment?
                        </a>
                    </h4>
                </div>
                <div id="collapse9" class="panel-collapse collapse">
                    <div class="panel-body">
                        Cancellation of an appointment is valid until 1 day before the appointment.
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