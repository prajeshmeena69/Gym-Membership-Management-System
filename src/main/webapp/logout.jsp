<!-- logout.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Destroy the session
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>