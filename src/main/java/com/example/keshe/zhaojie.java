package com.example.keshe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Objects;

@WebServlet("/zhaojie")
public class zhaojie extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        everyone everyone = new everyone();
        Connection conn = everyone.getConn();
        try {
            Statement stmt = conn.createStatement();
            if (req.getParameter("sourse").equals("guanliyuan")) {
                ResultSet rs = stmt.executeQuery("select * from yisheng where weizhi='" + req.getParameter("weizhi") + "'");
                if (!rs.next()&& !Objects.equals(req.getParameter("weizhi"), "")) {
                    String sql = "delete from zhaoping where wang='" + req.getParameter("wang") + "'";
                    stmt.executeUpdate(sql);
                    String sql1 = "update yisheng set zhuangtai = '" + req.getParameter("action") + "',weizhi='" + req.getParameter("weizhi") + "' where wang = '" + req.getParameter("wang") + "'";
                    stmt.executeUpdate(sql1);
                    req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                } else {
                    req.setAttribute("message", "该位置已有医生或未填写位置，请重新选择位置");
                    req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                }
            } else if (req.getParameter("sourse").equals("yisheng")) {
                String sql2 = "delete from yisheng where wang='" + req.getParameter("juid") + "'";
                stmt.executeUpdate(sql2);
                req.getRequestDispatcher("onepage.jsp").forward(req, resp);
            }
            else if (req.getParameter("sourse").equals("guanliyuanbiao")) {
                switch (req.getParameter("action"))
                    {
                        case "在职医生信息":
                            String sql="select * from yisheng";
                            ResultSet rs=stmt.executeQuery(sql);
                            req.setAttribute("rs",rs);
                            req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                            break;
                        case "预约信息":
                            String sql1="select * from yuyue";
                            ResultSet rs1=stmt.executeQuery(sql1);
                            req.setAttribute("rs",rs1);
                            req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                            break;
                        case "药品信息":
                            String sql2="select * from yaoku";
                            ResultSet rs2=stmt.executeQuery(sql2);
                            req.setAttribute("rs",rs2);
                            req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                            break;
                    }
            }
            else if (req.getParameter("sourse").equals("jieping")) {
                ArrayList<String> data = new ArrayList<>();
                data.add(req.getParameter("username"));
                data.add(req.getParameter("phone"));
                data.add(req.getParameter("zhiwei"));
                data.add(req.getParameter("weizhi"));
                data.add(req.getParameter("jieshao"));
                try {
                   int i= everyone.charu("cizhi",data);
                   if(i==0){
                       req.setAttribute("message","辞职已填写");}
                   else{
                    req.setAttribute("message","辞职提交成功");
                    String sql="select wang from yisheng where weizhi='"+req.getParameter("weizhi")+"'";
                    ResultSet rs=stmt.executeQuery(sql);
                    rs.next();
                    req.setAttribute("wang",rs.getString("wang"));
                    String sql1="update yisheng set zhuangtai='辞职中' where weizhi='"+req.getParameter("weizhi")+"'";
                    stmt.executeUpdate(sql1);
                    req.getRequestDispatcher("yisheng.jsp").forward(req, resp);}
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            else if (req.getParameter("sourse").equals("guanliyuanci")) {String selectWangSql = "SELECT wang FROM yisheng WHERE weizhi = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(selectWangSql)) {
                    String weizhi = req.getParameter("weizhi");
                    if (weizhi == null || weizhi.trim().isEmpty()) {
                        req.setAttribute("message", "位置信息不能为空");
                        req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                        return;
                    }
                    pstmt.setString(1, weizhi);
                    ResultSet rs1 = pstmt.executeQuery();

                    if (!rs1.next()) {
                        req.setAttribute("message", "该位置没有医生");
                        req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                        return;
                    }
                    String wang = rs1.getString("wang");
                    // 更新预约状态
                    String updateYuyueSql = "UPDATE yuyue SET yuzhuangtai = '预约失败该医生已辞职' WHERE yiwang = ?";
                    try (PreparedStatement pstmt1 = conn.prepareStatement(updateYuyueSql)) {
                        pstmt1.setString(1, wang);
                        pstmt1.executeUpdate();
                    }

                    // 更新医生状态为“辞职完成”
                    String updateYishengSql = "UPDATE yisheng SET zhuangtai = '辞职完成' WHERE wang = ?";
                    try (PreparedStatement pstmt2 = conn.prepareStatement(updateYishengSql)) {
                        pstmt2.setString(1, wang);
                        pstmt2.executeUpdate();
                    }

                    // 删除辞职申请记录
                    String deleteCizhiSql = "DELETE FROM cizhi WHERE weizhi = ?";
                    try (PreparedStatement pstmt3 = conn.prepareStatement(deleteCizhiSql)) {
                        pstmt3.setString(1, weizhi);
                        pstmt3.executeUpdate();
                    }

                } catch (SQLException | ServletException | IOException e) {
                    e.printStackTrace();
                    req.setAttribute("message", "操作过程中发生错误，请稍后再试");
                    req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
                }

                req.getRequestDispatcher("guanliyuan.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
