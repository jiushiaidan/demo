<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="stylesheet" href="onepage.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>德权医疗</title>
</head>
<body>
<header class="header" id="shouye">
    <div class="container">
        <div class="hospital-info">
            <img src="图标.ico" alt="医院图片" class="hospital-image">
            <div class="info-text">
                <h2>德权护理</h2>
                <div class="tags">
                    <span class="tag">医疗</span>
                    <span class="tag">护理</span>
                </div>
            </div>
        </div>
        <div class="contact-info">
            <p><strong>门诊：</strong> 上午：8:00-12:00（挂号时间7:30-11:00）</p>
            <p><strong>地址：</strong> 月球街26</p>
            <p><strong>电话：</strong> 1587851234</p>
            <p class="note">(时间以当日官方公告为准)</p>
        </div>
        <div class="container">
            <%if (session.getAttribute("shouye") != null) {%>
            <a href="onepage.jsp" class="nav-link">首页</a><%}%>
            <%if (session.getAttribute("jianjie") != null) {%>
            <a href="#jianjie" class="nav-link">简介</a><%}%>
            <%if (session.getAttribute("gonggao") != null) {%>
            <a href="#公告" class="nav-link">公告</a><%}%>
            <%
                if (session.getAttribute("zhaoping") != null) {
                    session.removeAttribute("zhaoping");
            %>
            <a href="zhaoping.jsp" class="nav-link">医生招聘</a><%}%>
            <%if (session.getAttribute("jieping") != null) {%>
            <a href="jieping.jsp" class="nav-link">医生解聘</a><%
                session.removeAttribute("jieping");
            }
        %>
            <%if (session.getAttribute("login") != null) {%>
            <a href="login.jsp" class="nav-link">登录</a><%}%>
            <%
                if (session.getAttribute("outlogin") != null) {
                    session.removeAttribute("outlogin");
            %>
            <a href="login.jsp" class="nav-link">退出登录</a><%}%>
        </div>
    </div>
</header>
</body>
</html>