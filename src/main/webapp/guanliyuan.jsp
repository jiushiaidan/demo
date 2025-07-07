<%@ page import="com.example.keshe.everyone" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/15
  Time: 17:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <title>德权医疗</title>
</head>
<jsp:include page="header.jsp"/>
<body>
<% if (request.getAttribute("message") != null) { %>
<script>
    alert("<%= request.getAttribute("message") %>");
    window.location.href = "guanliyuan.jsp"; // 跳转到登录页或其他目标页
</script>
<% } %>
<div class="center-container">
    <h2 class="artistic-text">欢迎 管理员！</h2>
    <table border="5px">
        <caption>招聘信息</caption>
        <tr>
            <th>姓名</th>
            <th>电话</th>
            <th>职位</th>
            <th>学历</th>
            <th>工作经验</th>
            <th>个人介绍</th>
        </tr>
        <%
            everyone everyone = new everyone();
            try {
                ResultSet rs = everyone.chaxun("guanli", null);
                while (rs.next()) {
                    out.print("<tr>");
                    for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                        if (i == 2 || i == 8) {
                            continue;
                        } else
                            out.print("<td>" + rs.getString(i) + "</td>");

                    }%>
        <form action="zhaojie" method="post">
            <input type="hidden" name="sourse" value="guanliyuan">
            <input type="hidden" name="wang" value="<%=rs.getString(8)%>">
            <td> 如聘用请填写位置 <input type="text" name="weizhi"></td>
            <td><input type="submit" name="action" value="聘用"></td>
            <td><input type="submit" name="action" value="拒绝"></td>
        </form>
        <%
                    out.print("</tr>");
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        %>
        <table border="5px">
            <caption>辞职信息</caption>
            <tr>
                <th>姓名</th>
                <th>电话</th>
                <th>职位</th>
                <th>位置</th>
                <th>辞职原因</th>
            </tr>
            <%
                everyone everyone1 = new everyone();
                try {
                    ResultSet rs1 = everyone1.chaxun("cizhi", null);
                    while (rs1.next()) {
                        out.print("<tr>");
                        for (int i = 1; i <= rs1.getMetaData().getColumnCount(); i++) {
                                out.print("<td>" + rs1.getString(i) + "</td>");
                        }%>
            <form action="zhaojie" method="post">
                <input type="hidden" name="sourse" value="guanliyuanci">
                <input type="hidden" name="weizhi" value="<%=rs1.getString(4)%>">
                <td><input type="submit" name="action" value="解聘"></td>
            </form>
            <%
                        out.print("</tr>");
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            %>
    </table>
    <form action="zhaojie" method="post">
        <input type="hidden" name="sourse" value="guanliyuanbiao">
        <input type="submit" name="action" value="在职医生信息">
        <input type="submit" name="action" value="预约信息">
        <input type="submit" name="action" value="药品信息">
    </form>
    <table border="5px">
    <%ResultSet rs = (ResultSet) request.getAttribute("rs");
    if(rs!=null)
    {
    try {
        int j=1;
        while (rs.next()) {
            if(j==1){
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++)
                    out.print("<th>" + rs.getMetaData().getColumnName(i) + "</th>");}
                    j++;
            out.print("<tr>");
            for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                out.print("<td>" + rs.getString(i) + "</td>");
            }
            out.print("</tr>");
    }}
    catch (SQLException e) {
        throw new RuntimeException(e);
    }}
    %>
    </table>
</div>
</body>
</html>
