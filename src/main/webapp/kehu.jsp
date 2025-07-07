<%@ page import="java.sql.Connection" %>
<%@ page import="com.example.keshe.everyone" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Objects" %><%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/15
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <title>德权医疗</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            border: 1px solid #000;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        .center-container {
            text-align: center;
            margin-top: 50px;
        }

        .artistic-text {
            font-size: 24px;
            font-weight: bold;
        }

        form {
            margin-top: 20px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
        }

        @media (max-width: 768px) {
            table {
                font-size: 14px;
            }

            th, td {
                padding: 6px;
            }
        }
    </style>
</head>
<%
    everyone everyone6 = new everyone();
    Connection conn6 = everyone6.getConn();
    String sql6 = "select * from yuyue where kewang='"+request.getAttribute("wang")+"'";
    try {
        Statement stmt = conn6.createStatement();
        ResultSet rs6 = stmt.executeQuery(sql6);
        if (rs6.next() && !rs6.getString(7).equals("预约成功") && !rs6.getString(7).equals("预约完成")&& !rs6.getString(7).equals("预约中")) {
            String sql5="delete  from yuyue where kewang='"+request.getAttribute("wang")+"'";
            stmt.executeUpdate(sql5);
     %>
          <script>
    alert("您预约的医生已经辞职了");
          </script>
<% } %>
<%
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>

<% if (request.getAttribute("message") != null) { %>
<script>
    alert("<%= request.getAttribute("message") %>");
</script>
<% } %>
<%
    session.setAttribute("outlogin", "outlogin");
%>
<jsp:include page="header.jsp"/>
<body>
<link rel="icon" href="图标.ico" type="image/x-icon">

<div class="center-container">
    <h2 class="artistic-text">欢迎来到德权医疗！</h2>
    <form action="kehu" method="post">
        <input type="hidden" name="wang" value="<%=request.getAttribute("wang")%>">
        <input type="submit" name="action" value="通用信息表查询">
        <input type="submit" name="action" value="出诊预约">
    </form>

    <%
        String table = (String) request.getAttribute("table");
        if ("通用信息表".equals(table)) {
    %>
    <table border="5px">
        <tr>
            <td>预约流程</td>
        </tr>
        <tr>
            <td>挂号 → 就诊 → 检查/化验 → 诊断 → 处方/治疗 → 缴费 → 取药</td>
        </tr>
        <tr>
            <td>预约流程</td>
        </tr>
        <tr>
            <td>点击下方预约按钮 -> 选择医生 -> 填写信息 -> 预约成功</td>
        </tr>
    </table>
    <table style="border: 5px solid black; margin-top: 50px;">
        <th>医生姓名</th>
        <th>医生电话</th>
        <th>医生职位</th>
        <th>医生位置</th>
        <%
            everyone everyone = new everyone();
            Connection conn = everyone.getConn();
            String sql = "select * from yisheng";
            try {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    if (rs.getString(5) != null && rs.getString(5).equals("聘用")) {
        %>
        <tr>
            <td><%= rs.getString(1) %>
            </td>
            <td><%= rs.getString(3) %>
            </td>
            <td><%= rs.getString(4) %>
            </td>
            <td><%= rs.getString(6) %>
            </td>
        </tr>
        <%
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        %>
    </table>
    <%
    } else if ("出诊预约".equals(table)) {
    %>
    <table style="border: 5px solid black; margin-top: 50px;">
        <tr>
            <th>医生姓名</th>
            <th>医生电话</th>
            <th>医生职位</th>
            <th>医生位置</th>
        </tr>
        <%
            everyone everyone = new everyone();
            Connection conn = everyone.getConn();
            String sql = "SELECT * FROM yisheng WHERE NOT EXISTS (SELECT * FROM yuyue WHERE yisheng.wang = yuyue.yiwang)";
            try {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {if(Objects.equals(rs.getString(5), "聘用")){
        %>
        <tr>
            <td><%= rs.getString(1) %>
            </td>
            <td><%= rs.getString(3) %>
            </td>
            <td><%= rs.getString(4) %>
            </td>
            <td><%= rs.getString(6) %>
            </td>
            <td>
                <form action="kehu" method="post">
                    <input type="hidden" name="action" value="yuyue">
                    <input type="hidden" name="kewang" value="<%= request.getAttribute("wang")%>">
                    <input type="hidden" name="yiwang" value="<%= rs.getString(7) %>">
                    <input type="submit" value="预约">
                </form>
            </td>
        </tr>
        <%
                }}
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        %>
    </table>
    <table style="border: 5px solid black; margin-top: 50px;">
        <caption>预约记录</caption>
        <tr>
            <th>医生姓名</th>
            <th>医生电话</th>
            <th>医生职位</th>
            <th>医生位置</th>
            <th>预约状态</th>
            <th>预约时间</th>
            <th>操作</th>
        </tr>
        <%
            everyone everyone1 = new everyone();
            Connection conn1 = everyone.getConn();
            String sql1 = "SELECT username, phone, zhiwei, weizhi, yuzhuangtai, yidata, yiwang, kewang, id " +
                    "FROM yisheng, yuyue " +
                    "WHERE wang = yiwang AND kewang = '" + request.getAttribute("wang") + "'";
            try {
                Statement stmt1 = conn1.createStatement();
                ResultSet rs1 = stmt1.executeQuery(sql1);
                while (rs1.next()) {
        %>
        <tr>
            <td><%= rs1.getString(1) %>
            </td>
            <td><%= rs1.getString(2) %>
            </td>
            <td><%= rs1.getString(3) %>
            </td>
            <td><%= rs1.getString(4) %>
            </td>
            <td><%= rs1.getString(5) %>
            </td>
            <td><%= rs1.getString(6) %>
            </td>
            <td>
                <% if (!rs1.getString(5).equals("预约成功") && !rs1.getString(5).equals("预约完成")) { %>
                <form action="kehu" method="post">
                    <input type="hidden" name="action" value="quxiao">
                    <input type="hidden" name="kewang" value="<%= rs1.getString(8) %>">
                    <input type="hidden" name="yiwang" value="<%= rs1.getString(7) %>">
                    <input type="submit" value="取消">
                </form>
                <% } else { %>
                <table style="border: 5px solid black; margin-top: 10px;">
                    <tr>
                        <th>药品名称</th>
                        <th>药品数量</th>
                        <th>药品价格</th>
                    </tr>
                    <%
                        String sql2 = "SELECT * FROM yao WHERE id = '" + rs1.getString(9) + "'";
                        Statement stmt2 = conn1.createStatement();
                        ResultSet rs2 = stmt2.executeQuery(sql2);
                        while (rs2.next()) {
                    %>
                    <tr>
                        <td><%= rs2.getString(2) %>
                        </td>
                        <td><%= rs2.getInt(3) %>
                        </td>
                        <td><%= rs2.getInt(4) %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">总价: <%= rs2.getInt(3) * rs2.getInt(4) %>
                        </td>
                    </tr>
                    <% } %>
                    <tr>
                        <td colspan="3">
                            <form action="kehu" method="post">
                                <input type="hidden" name="action" value="wanyu">
                                <input type="hidden" name="kewang" value="<%= rs1.getString(8) %>">
                                <input type="hidden" name="yiwang" value="<%= rs1.getString(7) %>">
                                <input type="submit" value="完成预约">
                            </form>
                        </td>
                    </tr>
                </table>
                <% } %>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                out.println("<p style='color: red;'>数据库操作失败，请稍后重试。</p>");
                e.printStackTrace();
            }
        %>
    </table>
    <%
        }
    %>
</div>
</body>
</html>