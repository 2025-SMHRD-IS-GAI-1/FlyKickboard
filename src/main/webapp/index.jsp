<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
   <c:choose>
      <c:when test="${not empty login}">
         <c:redirect url="/GoMain.do" />
      </c:when>
      <c:otherwise>
         <c:redirect url="/GoLogin.do" />
      </c:otherwise>
   </c:choose>
</body>
</html>