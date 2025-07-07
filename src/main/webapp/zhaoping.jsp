<%@ page import="com.mysql.cj.Session" %>
<%@ page import="com.example.keshe.everyone" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/15
  Time: 12:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="onepage.css">
    <title>德权医疗</title>
</head>
<%
    session.removeAttribute("zhaoping");
    session.removeAttribute("jianjie");
    session.removeAttribute("gonggao");
    session.removeAttribute("login");
    session.setAttribute("shouye", "shouye");
%>
<jsp:include page="header.jsp"/>
<body>
<link rel="icon" href="图标.ico" type="image/x-icon">
<% if (request.getAttribute("message") != null) { %>
<script>
    alert("<%= request.getAttribute("message") %>");
    window.location.href = "zhaoping.jsp"; // 跳转到登录页或其他目标页
</script>
<% } %>
<div class="center-container">
    <h2 class="artistic-text">欢迎来到德权医疗！</h2>
    <h2 class="artistic-text">想加入德权吗？快来填写下面的简历吧！</h2>
    <form action="zhaoping" method="post">
        <p>请填写您的信息(姓名,密码必填招聘结果在系统查看(一周内没通知为不聘用))</p>
        <input type="text" name="wang" placeholder="用户名"><br>
        <input type="text" name="username" placeholder="姓名"><br>
        <input type="password" name="password" placeholder="密码"><br>
        <input type="text" name="phone" placeholder="电话"><br>
        <input type="text" name="zhiwei" placeholder="应聘职位"><br>
        <input type="text" name="xueli" placeholder="学历"><br>
        <input type="text" name="jingyan" placeholder="经验"><br>
        <input type="text" name="jieshao" placeholder="个人介绍"><br>
        <input type="submit" value="提交">
    </form>
</div>
</body>
</html>
