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
	<title>Add/edit availability</title>
</head>
<body class="bg-grey">
	<!-- Add session -->
	<%	response.setHeader("Cache-Control","no-cache");
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		Integer role = (Integer)session.getAttribute("role");
		if(role == null || role != 1) {
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
		    		<li><a href="doctor.jsp">My appointments</a></li>
		    		<li><a href="my_availability.jsp">My availability</a></li>
		    		<li><a href="profile.jsp"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
		    		<li><a href="/healthbeat/LogoutServlet"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
			    </ul>
			</div>
		</div>
	</nav>
	
	<!-- Availability form -->
	<div class="container">
		<div class="row">
			<div class="col-sm-offset-2 col-sm-8">
				<div class="panel panel-default">
    				<div class="panel-heading">
    					<h3 class="text-center">Add/edit weekly availability</h3>
    				</div>
    				<div class="panel-body">
    					<form class="col-sm-offset-2 col-sm-8 form-padding" method="post" action="/healthbeat/AvailabilityServlet">
    						<%	String msg_header = (String)session.getAttribute("msg_header");
					        	String msg = (String)session.getAttribute("msg");
					        	if (msg_header != null && msg != null) {
					        		out.println("<div class='alert alert-success alert-dismissible fade in'><a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a><strong>" +msg_header+ " </strong>" +msg+ "</div>");
					        	}
					        	session.setAttribute("msg_header", null);
					        	session.setAttribute("msg", null);
					        %>
    						<p><strong>Monday</strong></p>
    						<div class="row">
    							<div class="form-group col-xs-6 col-sm-3">
    								<label for="monday_start_h">From</label>
		        					<select class="form-control" name="monday_start_h" id="monday_start_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="monday_start_m">From</label>
									<select class="form-control" name="monday_start_m" id="monday_start_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
						    	<div class="form-group col-xs-6 col-sm-3">
									<label for="monday_end_h">To</label>
						        	<select class="form-control" name="monday_end_h" id="monday_end_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="monday_end_m">To</label>
									<select class="form-control" name="monday_end_m" id="monday_end_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
    						</div>
    						<div class="checkbox">
					        	<label><input type="checkbox" name="monday" id="monday"> Not available</label>
					        </div><br/>
					        <p><strong>Tuesday</strong></p>
    						<div class="row">
    							<div class="form-group col-xs-6 col-sm-3">
    								<label for="tuesday_start_h">From</label>
		        					<select class="form-control" name="tuesday_start_h" id="tuesday_start_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="tuesday_start_m">From</label>
									<select class="form-control" name="tuesday_start_m" id="tuesday_start_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
						    	<div class="form-group col-xs-6 col-sm-3">
									<label for="tuesday_end_h">To</label>
						        	<select class="form-control" name="tuesday_end_h" id="tuesday_end_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="tuesday_end_m">To</label>
									<select class="form-control" name="tuesday_end_m" id="tuesday_end_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
    						</div>
    						<div class="checkbox">
					        	<label><input type="checkbox" name="tuesday" id="tuesday"> Not available</label>
					        </div><br/>
    						<p><strong>Wednesday</strong></p>
    						<div class="row">
    							<div class="form-group col-xs-6 col-sm-3">
    								<label for="wednesday_start_h">From</label>
		        					<select class="form-control" name="wednesday_start_h" id="wednesday_start_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="wednesday_start_m">From</label>
									<select class="form-control" name="wednesday_start_m" id="wednesday_start_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
						    	<div class="form-group col-xs-6 col-sm-3">
									<label for="wednesday_end_h">To</label>
						        	<select class="form-control" name="wednesday_end_h" id="wednesday_end_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="wednesday_end_m">To</label>
									<select class="form-control" name="wednesday_end_m" id="wednesday_end_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
    						</div>
    						<div class="checkbox">
					        	<label><input type="checkbox" name="wednesday" id="wednesday"> Not available</label>
					        </div><br/>
    						<p><strong>Thursday</strong></p>
    						<div class="row">
    							<div class="form-group col-xs-6 col-sm-3">
    								<label for="thursday_start_h">From</label>
		        					<select class="form-control" name="thursday_start_h" id="thursday_start_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="thursday_start_m">From</label>
									<select class="form-control" name="thursday_start_m" id="thursday_start_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
						    	<div class="form-group col-xs-6 col-sm-3">
									<label for="thursday_end_h">To</label>
						        	<select class="form-control" name="thursday_end_h" id="thursday_end_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="thursday_end_m">To</label>
									<select class="form-control" name="thursday_end_m" id="thursday_end_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
    						</div>
    						<div class="checkbox">
					        	<label><input type="checkbox" name="thursday" id="thursday"> Not available</label>
					        </div><br/>
    						<p><strong>Friday</strong></p>
    						<div class="row">
    							<div class="form-group col-xs-6 col-sm-3">
    								<label for="friday_start_h">From</label>
		        					<select class="form-control" name="friday_start_h" id="friday_start_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="friday_start_m">From</label>
									<select class="form-control" name="friday_start_m" id="friday_start_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
						    	<div class="form-group col-xs-6 col-sm-3">
									<label for="friday_end_h">To</label>
						        	<select class="form-control" name="friday_end_h" id="friday_end_h" required="required">
						        		<option selected>Hour</option>
						        		<option>08</option>
						        		<option>09</option>
						        		<option>10</option>
						        		<option>11</option>
						        		<option>12</option>
						        		<option>13</option>
						        		<option>14</option>
								        <option>15</option>
								        <option>16</option>
								    	<option>17</option>
								    	<option>18</option>
								    	<option>19</option>
								    	<option>20</option>
									</select>
						    	</div>
						    	<div class="form-group col-xs-6 col-sm-3">
						    		<label for="friday_end_m">To</label>
									<select class="form-control" name="friday_end_m" id="friday_end_m" required="required">
						        		<option selected>Min</option>
						        		<option>00</option>
						        		<option>15</option>
						        		<option>30</option>
						        		<option>45</option>
									</select>
								</div>
    						</div>
    						<div class="checkbox">
					        	<label><input type="checkbox" name="friday" id="friday"> Not available</label>
					        </div><br/>
    						<div class="row">
    							<div class="form-group col-sm-12">
									<button class="btn btn-success" type="reset" id="reset">Clear</button>
					          		<button class="btn btn-primary pull-right" type="submit">Submit</button>
					        	</div>
    						</div>
    					</form>
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
    
	<script type="text/javascript">
		document.getElementById('monday').onchange = function() {
		    document.getElementById('monday_start_h').disabled = this.checked;
		    document.getElementById('monday_start_m').disabled = this.checked;
		    document.getElementById('monday_end_h').disabled = this.checked;
		    document.getElementById('monday_end_m').disabled = this.checked;
		    document.getElementById("monday_start_h").value = "Hour";
		    document.getElementById("monday_start_m").value = "Min";
		    document.getElementById("monday_end_h").value = "Hour";
		    document.getElementById("monday_end_m").value = "Min";
		};
		
		document.getElementById('tuesday').onchange = function() {
		    document.getElementById('tuesday_start_h').disabled = this.checked;
		    document.getElementById('tuesday_start_m').disabled = this.checked;
		    document.getElementById('tuesday_end_h').disabled = this.checked;
		    document.getElementById('tuesday_end_m').disabled = this.checked;
		    document.getElementById("tuesday_start_h").value = "Hour";
		    document.getElementById("tuesday_start_m").value = "Min";
		    document.getElementById("tuesday_end_h").value = "Hour";
		    document.getElementById("tuesday_end_m").value = "Min";
		};
		
		document.getElementById('wednesday').onchange = function() {
		    document.getElementById('wednesday_start_h').disabled = this.checked;
		    document.getElementById('wednesday_start_m').disabled = this.checked;
		    document.getElementById('wednesday_end_h').disabled = this.checked;
		    document.getElementById('wednesday_end_m').disabled = this.checked;
		    document.getElementById("wednesday_start_h").value = "Hour";
		    document.getElementById("wednesday_start_m").value = "Min";
		    document.getElementById("wednesday_end_h").value = "Hour";
		    document.getElementById("wednesday_end_m").value = "Min";
		};
		
		document.getElementById('thursday').onchange = function() {
		    document.getElementById('thursday_start_h').disabled = this.checked;
		    document.getElementById('thursday_start_m').disabled = this.checked;
		    document.getElementById('thursday_end_h').disabled = this.checked;
		    document.getElementById('thursday_end_m').disabled = this.checked;
		    document.getElementById("thursday_start_h").value = "Hour";
		    document.getElementById("thursday_start_m").value = "Min";
		    document.getElementById("thursday_end_h").value = "Hour";
		    document.getElementById("thursday_end_m").value = "Min";
		};
		
		document.getElementById('friday').onchange = function() {
		    document.getElementById('friday_start_h').disabled = this.checked;
		    document.getElementById('friday_start_m').disabled = this.checked;
		    document.getElementById('friday_end_h').disabled = this.checked;
		    document.getElementById('friday_end_m').disabled = this.checked;
		    document.getElementById("friday_start_h").value = "Hour";
		    document.getElementById("friday_start_m").value = "Min";
		    document.getElementById("friday_end_h").value = "Hour";
		    document.getElementById("friday_end_m").value = "Min";
		};
	</script>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#reset").click(function(){
		    	$(":disabled").prop('disabled', false);
			});
		});
	</script>
</body>
</html>