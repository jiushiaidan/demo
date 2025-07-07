<%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/17
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <title>德权医疗</title>
</head>
<jsp:include page="header.jsp"/>
<body>
<div class="center-container">
    <h2 class="artistic-text">欢迎来到德权医疗！</h2>
    <h2 class="artistic-text">想加入德权吗？快来填写下面的简历吧！</h2>
    <form action="zhaojie" method="post">
        <p>请填写您的信息(姓名,位置必填)解聘结果在系统查看</p>
        <input type="hidden" name="sourse" value="jieping">
        <input type="text" name="username" placeholder="姓名"><br>
        <input type="text" name="phone" placeholder="电话"><br>
        <input type="text" name="zhiwei" placeholder="职位"><br>
        <input type="text" name="weizhi" placeholder="工号"><br>
        <input type="text" name="jieshao" placeholder="辞职原因"><br>
        <input type="submit" value="提交">
    </form>
</div>

</body>
</html>
