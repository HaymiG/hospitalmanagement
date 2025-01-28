<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session.invalidate();
    
    // Redirect to login page
    response.setContentType("text/html");
    out.println("<script type='text/javascript'>");
    out.println("alert('Logged out successfully!');");
    out.println("window.location.href='index.jsp';");
    out.println("</script>");
%>
