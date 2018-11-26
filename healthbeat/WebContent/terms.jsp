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
	<title>Terms of use</title>
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
	
	<!-- Content -->
	<div class="container bg-white">
		<div class="page-header">
            <h2 class="col-sm-offset-1">Terms of use</h2>
        </div>
        
		<div class="col-sm-offset-1 col-sm-10">
			<h3 class="text-primary">Services</h3>
			<p>The Services provided by Healthbeat enable you to use the Site to select health providers and book appointments as well as other activities that we may introduce from time to time (collectively, the "Services"). You acknowledge and agree that, as further specified herein, Healthbeat does not provide any medical services or advice and does not make any representations, warranties, guarantees or endorsements regarding any medical services or advice that you may obtain through the Site and/or the services. Any Services, as well as the Site, can be modified, replaced or terminated at any time in Healthbeat&apos;s sole discretion, for any reason or no reason, and without notice to you.</p><br/>
			
			<h3 class="text-primary">User accounts</h3>
			<p>Subject to the conditions set forth herein and prior to being able to use our Services, Healthbeat requires you to become a member and register with your valid email address and a password. You are responsible for all activities that occur in connection with your account. You may not impersonate someone else, create or use an account for anyone other than yourself, provide an email address other than your own, or create multiple accounts. At the time of registration, you will be asked to provide certain information about yourself. You agree to provide Healthbeat with your current contact information and to take all reasonable steps to promptly notify Healthbeat if and when this information changes. We reserve the right, in our sole discretion, to terminate your account at any time, and to prohibit your access to the Site and/or the Services, for any reason or no reason and without notice to you.</p><br/>
			
			<h3 class="text-primary">Content</h3>
			<p><strong class="text-muted">Healthbeat Content.</strong> As between you and Healthbeat, all Healthbeat Content, including all intellectual property rights therein, is owned by Healthbeat. Furthermore, the Healthbeat Content is subject to a variety of legal protections, including copyright, trademark, trade dress, patent and/or contract, with all applicable rights being hereby reserved. Nothing in these Terms is intended to or shall convey to you any right or license in or to any Healthbeat Content, unless specifically provided for herein.</p>
			<p><strong class="text-muted">User-Generated Content.</strong> By contributing or submitting any User-Generated Content to the Site, you warrant that you are the author and owner of the intellectual property rights thereto or have the appropriate license and sublicense rights from the owner. In addition, you warrant that all rights that you may have in such User-Generated Content have been voluntarily waived by you. Healthbeat reserves the right to change, condense or delete any Content, including User-Generated Content, on the Site that Healthbeat deems, in its sole discretion, to violate the Content guidelines or any other provision of these Terms.</p><br/>
			
			<h3 class="text-primary">Your responsibilities</h3>
			<p>In contributing or submitting any User-generated content to the site, you agree not to use a false or misleading email address, impersonate any person or entity, or otherwise provide any misleading information as to the origin of any content that you submit.</p><br/>
			
			<h3 class="text-primary">Data</h3>
			<p><strong class="text-muted">Security.</strong> Healthbeat takes the security of Personal Data and the privacy of its users very seriously. The User agrees that the User shall not do anything to prejudice the security or privacy of the Healthbeat&apos;s systems or the information on them.</p>
			<p><strong class="text-muted">Transmission.</strong> Healthbeat shall do all things reasonable to ensure that the transmission of data occurs according to accepted industry standards. It is up to the User to ensure that any transmission standards meet the User&apos;s operating and legal requirements.</p>
			<p><strong class="text-muted">Storage and Backup.</strong> Healthbeat may limit the amount of data that the User stores, and shall advise the User of such. Data that is stored shall be stored according to accepted industry standards. Healthbeat shall perform backups in as reasonable manner at such times and intervals as are reasonable for its business purposes. Healthbeat does not warrant that it is able to backup or recover specific User Content from any period of time unless so stated in writing by Healthbeat.</p><br/>
			
			<h3 class="text-primary">Address for notices</h3>
			<p>Notices to Healthbeat can be emailed to <a href="mailto:support@healthbeat.gr">support@healthbeat.gr</a> or via <a href="contact.jsp">contact form</a>.</p>
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