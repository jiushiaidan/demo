<%@ page import="com.example.keshe.everyone" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: guowe
  Date: 2025/6/16
  Time: 17:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <!-- jQuery and Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="icon" href="图标.ico" type="image/x-icon">
    <title>德权医疗</title>
</head>
<% if (request.getAttribute("message") != null) { %>
<script>
    alert("<%= request.getAttribute("message") %>");
</script>
<% } %>
<%
    session.setAttribute("jieping", "jieping");
    session.setAttribute("outlogin", "outlogin");
    session.removeAttribute("zhaoping");
%>
<body>
<jsp:include page="header.jsp"/>
<link rel="icon" href="图标.ico" type="image/x-icon">
<div class="center-container">
    <h2 class="artistic-text">欢迎来到德权医疗！</h2>

    <%
        everyone everyone = new everyone();
        String id = request.getAttribute("wang").toString();
        ArrayList<String> data = new ArrayList<>();
        data.add(id);
        ResultSet rs = null;
        try {
            rs = everyone.chaxun("yisheng1", data);
            rs.next();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            if (rs.getString("zhuangtai") == null) {
    %>
    <h2>请耐心等待消息</h2>
    <%
    } else if (rs.getString("zhuangtai").equals("拒绝")) {
    %>
    <h2>您被拒绝了</h2>
    <form action="zhaojie" method="post">
        <input type="hidden" name="sourse" value="yisheng">
        <input type="hidden" name="juid" value="<%=id%>">
        <input type="submit" value="确认">
    </form>
    <%
    } else if(rs.getString("zhuangtai").equals("聘用")){
    %>
    <h2>您工号和位置为：<%=rs.getString("weizhi")%>
    </h2>
    <h2>恭喜您被聘用</h2>
    <table border="5px">

        <caption>预约出诊时间安排</caption>
        <tr>
            <th>你的姓名</th>
            <th>你的电话</th>
            <th>客户姓名</th>
            <th>客户电话</th>
        </tr>
        <%
            ArrayList<String> data1 = new ArrayList<>();
            data1.add(rs.getString("wang"));
            ResultSet rs1 = everyone.chaxun("yuyue", data1);
            while (rs1.next()) {
                if (rs1.getString(7).equals("预约中")) {%>
        <tr>
            <td><%=rs1.getString(2)%>
            </td>
            <td><%=rs1.getString(3)%>
            </td>
            <td><%=rs1.getString(5)%>
            </td>
            <td><%=rs1.getString(6)%>
            </td>
            <td>
                <form action="kehu" method="post">
                    <input type="hidden" name="action" value="yiyuyue">
                    <input type="hidden" name="yiwang" value="<%=rs1.getString(1)%>">
                    请填写出诊时间：<input type="text" name="time">
                    如取消请填写理由(11字以内)：<input type="text" name="reason">
                    <input type="submit" name="select" value="确认">
                    <input type="submit" name="select" value="取消">
                </form>
            </td>
        <tr>
                <%}else if(rs1.getString(7).equals("预约成功")){%>
        <tr>
            <td><%=rs1.getString(2)%>
            </td>
            <td><%=rs1.getString(3)%>
            </td>
            <td><%=rs1.getString(5)%>
            </td>
            <td><%=rs1.getString(6)%>
            </td>
            <td><%=rs1.getString(7)%>
            </td>
            <td><%=rs1.getString(8)%>
            </td>
            <td>
                <button type="button" data-toggle="modal" data-target="#prescriptionModal">
                    药方开出
                </button>
            </td>
        </tr> <!-- 按钮触发模态框 -->
        <!-- Modal 弹窗 -->
        <div class="modal fade" id="prescriptionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <form action="kehu" method="post">
                        <input type="hidden" name="action" value="chufan">
                        <input type="hidden" name="yiwang" value="<%=rs1.getString(1)%>">

                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">填写药方信息（可添加多个药品）</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body" id="prescriptionFields">
                            <!-- 默认一行药品输入 -->
                            <div class="form-group row mb-2 drug-entry">
                                <div class="col-md-5">
                                    <input type="text" class="form-control" name="drugName[]" placeholder="药品名称"
                                           required>
                                </div>
                                <div class="col-md-5">
                                    <input type="number" class="form-control" name="quantity[]" placeholder="数量" min="1"
                                           required>
                                </div>
                                <div class="col-md-2">
                                    <button type="button" class="btn btn-danger remove-drug">删除</button>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" class="form-control" name="drugName[]" placeholder="药品名称"
                                           required>
                                </div>
                                <div class="col-md-5">
                                    <input type="number" class="form-control" name="quantity[]" placeholder="数量" min="1"
                                           required>
                                </div>
                                <div class="col-md-2">
                                    <button type="button" class="btn btn-danger remove-drug">删除</button>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" id="addDrug">+ 添加药品</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                            <button type="submit" class="btn btn-primary">提交</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
                        }
                    }
                }
            else if(rs.getString("zhuangtai").equals("辞职中")){
                %>
                <h2>辞职处理中请耐心等待消息</h2>
        <%
            }else{
                %>
                <h2>您已被辞职</h2>
                <form action="zhaojie" method="post">
                    <input type="hidden" name="sourse" value="yisheng">
                    <input type="hidden" name="juid" value="<%=id%>">
                    <input type="submit" value="确认">
                </form>

                <%
            }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        %>
    </table>
</div>

</body>
</html>
