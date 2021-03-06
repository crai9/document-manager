<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>List of users</title>
    <link href="<c:url value='/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<c:url value='/resources/css/formValidation.min.css' />" rel="stylesheet">
    <link href="<c:url value='/resources/css/global.css' />" rel="stylesheet">
    <link href="<c:url value='/resources/css/jquery.mmenu.all.css' />" rel="stylesheet">
    <link href="<c:url value='/resources/css/sweet-alert.css' />" rel="stylesheet">
    <link href="<c:url value='/resources/css/typeahead.css' />" rel="stylesheet">

</head>

<body>
    <%@ include file="menu.jsp" %>
        <div class="container top">
            <div class="page-header">
                <h1>User List</h1>
            </div>
            <h4><a class="btn btn-warning" href="<c:url value='/dashboard' />">Dashboard</a></h4>
            <h4><a class="btn btn-success" href="<c:url value='/registerPage' />">Add new</a></h4>
            <c:choose>
                <c:when test="${!empty list}">
                    <form id="search">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-xs-6">
                                    <input id="query" type="text" name="search" class="form-control" placeholder="Search usernames here...." />
                                </div>
                                <button type="submit" class="btn btn-primary">Search</button>
                                <c:choose>
                                    <c:when test="${!empty search}">
                                        <a href="<c:url value='/users/page/1' />" class="btn btn-primary">&laquo; Go Back</a>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </form>
                    <br>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered">
                            <tr>
                                <th>UserId</th>
                                <th>Username</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Email</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            <c:forEach items="${list}" var="user">
                                <tr id="${user.id}">
                                    <td>${user.id}</td>
                                    <td>${user.username}</td>
                                    <td>${user.firstName}</td>
                                    <td>${user.lastName}</td>
                                    <td>${user.email}</td>
                                    <td><a href="<c:url value='/user/edit/${user.id}' />" class="btn btn-primary btn-sm">Edit</a></td>
                                    <td><a class="btn btn-sm btn-danger" id="delete" onclick="confirmDelete(${user.id})">Delete</a></td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    <c:if test="${pageNo == 1}"></c:if>
                    <c:if test="${nextPage != 0}">
                    <div class="container">
                        <nav class="centered-nav">
                            <ul class="pagination">
                                <li>
                                    <a <c:if test="${pageNo > 1}">href="${prevPage}"</c:if> aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" varStatus="loop">
                                	<li class='<c:if test="${pageNo == loop.index}">active</c:if>'><a href="${loop.index}">${loop.index}</a></li>
                                </c:forEach>
                                <li>
                                    <a <c:if test="${pageNo < totalPages}">href="${nextPage}"</c:if> aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                    </c:if>
                </c:when>

                <c:otherwise>
                    <a href="<c:url value='/users/page/1' />" class="btn btn-primary" role="button">&laquo; Go back</a>
                    <br>
                    <br>
                    <div class="alert alert-danger btn-sm" role="alert">
                        No results!
                    </div>
                </c:otherwise>
            </c:choose>
            <%@ include file="footer.jsp" %>
            <%@ include file="sidemenu.jsp" %>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="<c:url value='/resources/js/bootstrap.min.js' />"></script>
        <script src="<c:url value='/resources/js/formValidation.min.js' />"></script>
        <script src="<c:url value='/resources/js/framework/bootstrap.min.js' />"></script>
     	<script src="<c:url value='/resources/js/typeahead.js' />"></script>
        <script src="<c:url value='/resources/js/main.js' />"></script>
        <script src="<c:url value='/resources/js/users.js' />"></script>
		<script src="<c:url value='/resources/js/jquery.mmenu.min.all.js' />"></script>
        <script src="<c:url value='/resources/js/sweet-alert.min.js' />"></script>
</body>

</html>