<%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/15
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <title>德权医疗</title>
</head>
<body>

<% if (request.getAttribute("message") != null) { %>
<script>
    alert("<%= request.getAttribute("message") %>");
    window.location.href = "login.jsp"; // 跳转到登录页或其他目标页
</script>
<% } %>
<%
    session.removeAttribute("jianjie");
    session.removeAttribute("gonggao");
    session.removeAttribute("zhaoping");
    session.removeAttribute("login");
    session.setAttribute("shouye", "shouye");
%>
<jsp:include page="header.jsp"/>
<%if (request.getAttribute("select") == null) {%>
<div class="center-container">
    <div class="form-and-image">
        <img src="图标.ico" alt="登录图示">
        <form method="get" action="shibie">
            <select name="select">
                <option value="kehu">客户登录</option>
                <option value="yisheng">医生登录</option>
                <option value="guanliyuan">管理员登录</option>
                <option value="zhuce" selected>用户注册</option>
            </select>
            <br>
            <input type="submit" value="确认">
        </form>
    </div>
</div>
<%} else {%>
<%if (request.getAttribute("select").equals("zhuce")) {%>
<div class="center-container">
    <div class="form-and-image">
        <img src="图标.ico" alt="登录图示">
        <form method="post" action="shibie">
            <input type="hidden" name="select" value="zhuce">
            用户名：<input type="text" name="wang" placeholder="wangming"> <br>
            姓名：<input type="text" name="username" placeholder="name"> <br>
            密码：<input type="password" name="password" placeholder="password"> <br>
            电话：<input type="text" name="phone" placeholder="phone"><br>
            <input type="submit" value="注册">
        </form>
    </div>
</div>
<%
    }
    if (request.getAttribute("select").equals("kehu")) {
%>
<div class="center-container">
    <div class="form-and-image">
        <img src="图标.ico" alt="登录图示">
        <form method="post" action="shibie">
            <input type="hidden" name="select" value="<%=request.getAttribute("select")%>">
            用户名：<input type="text" name="username" placeholder="name"><br>
            密码：<input type="password" name="password" placeholder="password"><br>
            <input type="checkbox" name="rememberMe">记住密码<br>
            <input type="submit" value="登录">
        </form>
    </div>
</div>

<%
    }
    if (request.getAttribute("select").equals("yisheng")) {
%>
<div class="center-container">
    <div class="form-and-image">
        <img src="图标.ico" alt="登录图示">
        <form method="post" action="shibie">
            <input type="hidden" name="select" value="yisheng">
            用户名：<input type="text" name="username" placeholder="name"><br>
            密码：<input type="password" name="password" placeholder="password"><br>
            电话：<input type="text" name="mihao" placeholder="mimao"><br>
            <input type="submit" value="登录">
        </form>
    </div>
</div>
<%
    }
    if (request.getAttribute("select").equals("guanliyuan")) {
%>
<div class="center-container">
    <div class="form-and-image">
        <img src="图标.ico" alt="登录图示">
        <form method="post" action="shibie">
            <input type="hidden" name="select" value="guanliyuan">
            <p>请输入管理员唯一标识串</p><br>
            <input type="password" name="password" value="password">
            <br>
            <input type="submit" value="登陆">
        </form>
    </div>
</div>
<%
        }
    }
%>
</body>
</html>
