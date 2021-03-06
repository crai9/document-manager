<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="navbar-wrapper">
    <div class="container">
		<c:if test='${empty sessionScope.id}'>
			<script type="text/javascript">
			var userId = 0;
			</script>
		</c:if>
		<c:if test='${!empty sessionScope.id}'>
			<script type="text/javascript">
			var userId = ${sessionScope.id}
			</script>
		</c:if>
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <div>
                  	  <a href="#menu"><img class="move-logo-right navbar-brand doc-logo" src="<c:url value='/resources/img/DocMan.png' />" /></a>
                	</div>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                
                <c:choose>
      				<c:when test="${authenticated == false || empty authenticated}">
					<ul class="nav navbar-nav navbar-right">
                        <li><a href="<c:url value='/loginPage' />">Login</a>
                        </li>
                        <li><a href="">Sign Up</a>
                        </li>
                    </ul>
     			 	</c:when>

      				<c:otherwise>
      				<audio id="sound">
					  <source src="<c:url value='/resources/sound/sound.mp3' />" type="audio/mpeg">
					</audio>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><img class="pointer" src="<c:url value='/resources/img/notification.png' />" height="20px"><span id="count" style="display: none;" class="color pointer badge">4</span></a>
						<ul id="notifications" class="dropdown-menu notification-padding" role="menu">
                  		</ul>
						</li>
                        <li><a href="<c:url value='/dashboard' />">Dashboard</a></li>
                        <li class="dropdown">
                  			<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><c:if test="${admin == true}">
							<span class="badge">Admin</span>
						</c:if> ${username}<span class="caret"></span></a>
                  			<ul class="dropdown-menu" role="menu">
                    			<li><a href="<c:url value='/account' />">Account</a></li>
                    			<li class="divider"></li>
                    			<li><a href="<c:url value='/logout' />">Log out</a></li>
                  			</ul>
                		</li>
                    </ul>
      				</c:otherwise>
				</c:choose>

                </div>
            </div>
        </nav>

    </div>
</div>
