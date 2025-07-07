package com.example.keshe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;

@WebServlet("/kehu")
public class kehu extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action) {
            case "通用信息表查询":
                req.setAttribute("table", "通用信息表");
                req.setAttribute("wang", req.getParameter("wang"));
                req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                break;
            case "出诊预约":
                req.setAttribute("wang", req.getParameter("wang"));
                req.setAttribute("table", "出诊预约");
                req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                break;
            case "yuyue":
                everyone everyone = new everyone();
                String kewang = req.getParameter("kewang");
                String yiwang = req.getParameter("yiwang");
                req.setAttribute("wang", kewang);
                ArrayList<String> data = new ArrayList<>();
                data.add(kewang);
                data.add(yiwang);
                try {
                    int i = everyone.charu("yuyue", data);
                    if (i == 1)
                        req.setAttribute("message", "预约中等待医生回复");
                    else {
                        req.setAttribute("message", "你已有预约");
                    }
                    req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "yiyuyue":
                String select = req.getParameter("select");
                req.setAttribute("wang", req.getParameter("yiwang"));
                if (select.equals("确认")) {
                    String time = req.getParameter("time");
                    if (time == null || time.trim().isEmpty()) {
                        req.setAttribute("message", "请填写时间");
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    } else {
                        try {
                            everyone everyone1 = new everyone();
                            Connection conn = everyone1.getConn();
                            String sql2 = "update yuyue set yuzhuangtai=?,yidata=?,zizhuangtai=? where yiwang=?";
                            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
                            pstmt2.setString(1, "预约成功");
                            pstmt2.setString(2, time);
                            pstmt2.setString(3, "治疗中");
                            pstmt2.setString(4, req.getParameter("yiwang"));
                            pstmt2.executeUpdate();
                        } catch (SQLException e) {
                            throw new RuntimeException(e);
                        }
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    }
                } else if (select.equals("取消")) {
                    String resion = req.getParameter("reason");
                    if (resion == null || resion.trim().isEmpty()) {
                        req.setAttribute("message", "请填写理由");
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    } else {
                        com.example.keshe.everyone everyone2 = new everyone();
                        Connection conn = everyone2.getConn();
                        String sql2 = "update yuyue set yuzhuangtai=? where yiwang=?";
                        try {
                            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
                            pstmt2.setString(1, resion + "预约失败");
                            pstmt2.setString(2, req.getParameter("yiwang"));
                            pstmt2.executeUpdate();
                            req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                        } catch (SQLException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
                break;
            case "quxiao":
                String sql = "delete from yuyue where yiwang=?";
                com.example.keshe.everyone everyone1 = new everyone();
                Connection conn = everyone1.getConn();
                req.setAttribute("wang", req.getParameter("kewang"));
                try {
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, req.getParameter("yiwang"));
                    pstmt.executeUpdate();
                    req.setAttribute("message", "取消成功");
                    req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "chufan":
                String yiwang1 = req.getParameter("yiwang");
                String[] yaoname = req.getParameterValues("drugName[]");
                String[] yaonum = req.getParameterValues("quantity[]");
                for (int i = 0; i < yaoname.length; i++) {
                    System.out.println(yaoname[i]);
                    System.out.println(yaonum[i]);
                }
                req.setAttribute("wang", req.getParameter("yiwang"));
                com.example.keshe.everyone everyone2 = new everyone();
                Connection conn2 = everyone2.getConn();
                try {
                    Statement stmt = conn2.createStatement();
                    String sql5 = "select id from yuyue where yiwang=?";
                    PreparedStatement pstmt = conn2.prepareStatement(sql5);
                    pstmt.setString(1, yiwang1);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        String id = rs.getString("id");


                        String sql4 = "insert into yao(id,yaoname,yaosum) values(?,?,?)";
                        PreparedStatement pstmt1 = conn2.prepareStatement(sql4);
                        for (int i = 0; i < yaoname.length; i++) {
                            pstmt1.setString(1, id);
                            pstmt1.setString(2, yaoname[i]);
                            pstmt1.setInt(3, Integer.parseInt(yaonum[i]));
                            pstmt1.executeUpdate();
                        }
                        String sql6 = "update yao,yaoku set yao.price=yaoku.yaoprice where yao.yaoname=yaoku.yaoname";
                        PreparedStatement pstmt3 = conn2.prepareStatement(sql6);
                        pstmt3.executeUpdate();
                        String sqlSelect = "SELECT yaoname, yaosum FROM yao WHERE id=?";
                        PreparedStatement pstmtSelect = conn2.prepareStatement(sqlSelect);
                        pstmtSelect.setString(1, id);
                        ResultSet rs5 = pstmtSelect.executeQuery();

                        while (rs5.next()) {
                            String drugName = rs5.getString("yaoname");
                            int requiredQuantity = rs5.getInt("yaosum");

                            // 查询库存数量
                            String sqlCheckStock = "SELECT yaosum FROM yaoku WHERE yaoname=?";
                            PreparedStatement pstmtCheckStock = conn2.prepareStatement(sqlCheckStock);
                            pstmtCheckStock.setString(1, drugName);
                            ResultSet rsStock = pstmtCheckStock.executeQuery();

                            if (rsStock.next()) {
                                int stockQuantity = rsStock.getInt("yaosum");

                                if (stockQuantity >= requiredQuantity) {
                                    // 库存足够，执行更新操作
                                    String sqlUpdate = "UPDATE yaoku SET yaosum=yaosum-? WHERE yaoname=?";
                                    PreparedStatement pstmtUpdate = conn2.prepareStatement(sqlUpdate);
                                    pstmtUpdate.setInt(1, requiredQuantity);
                                    pstmtUpdate.setString(2, drugName);
                                    pstmtUpdate.executeUpdate();
                                } else {
                                    // 库存不足，提示错误信息
                                    req.setAttribute("message", "药品库存不足: " + drugName);
                                    req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                                    return; // 停止后续操作
                                }
                            }
                        }
                        String sql2 = "update yuyue set yuzhuangtai=? where yiwang=?";
                        PreparedStatement pstmt4 = conn2.prepareStatement(sql2);
                        pstmt4.setString(1, "预约完成");
                        pstmt4.setString(2, yiwang1);
                        pstmt4.executeUpdate();
                        req.setAttribute("message", "处方开出成功");
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    } else {
                        req.setAttribute("message", "请先预约");
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "wanyu":
                String yuyiwang = req.getParameter("yiwang");
                req.setAttribute("wang", req.getParameter("kewang"));
                com.example.keshe.everyone everyone3 = new everyone();
                Connection conn3 = everyone3.getConn();
                String sql7 = "select id from yuyue where yiwang=?";
                try {
                    PreparedStatement pstmt = conn3.prepareStatement(sql7);
                    pstmt.setString(1, yuyiwang);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        String id = rs.getString("id");
                        String sql8 = "delete from yao where id=?";
                        PreparedStatement pstmt1 = conn3.prepareStatement(sql8);
                        pstmt1.setString(1, id);
                        pstmt1.executeUpdate();
                        String sql9 = "delete from yuyue where id=?";
                        PreparedStatement pstmt2 = conn3.prepareStatement(sql9);
                        pstmt2.setString(1, id);
                        pstmt2.executeUpdate();
                        req.setAttribute("message", "预约完成成功");
                        req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                    } else {
                        req.setAttribute("message", "预约失败");
                        req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                    }
                } catch (SQLException e) {

                }
                break;
        }
    }
}
