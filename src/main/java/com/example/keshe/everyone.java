package com.example.keshe;

import java.sql.*;
import java.util.ArrayList;

public class everyone {
    private Connection conn = null;

    public everyone() {
        String driver = "com.mysql.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/keshe?useUnicode=true&characterEncoding=utf-8";
        String user = "root";
        String password = "123456";
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Connection getConn() {
        return conn;
    }

    public int charu(String table, ArrayList<String> data) throws SQLException {
        Statement stmt = conn.createStatement();
        switch (table) {
            case "kehu":
                String sql3 = "select * from kehu where wang='" + data.get(3) + "'";
                ResultSet rs = stmt.executeQuery(sql3);
                if (rs.next()) {
                    return 0;
                } else {
                    String sql = "insert into kehu(username,passwords,phone,wang) " +
                            "values(?,?,?,?)";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, data.get(0));
                    ps.setString(2, data.get(1));
                    ps.setString(3, data.get(2));
                    ps.setString(4, data.get(3));
                    ps.executeUpdate();
                    return 1;
                }
            case "zhaoping":
                String sql4 = "select * from zhaoping where wang='" + data.get(7) + "'";
                ResultSet rs1 = stmt.executeQuery(sql4);
                if (rs1.next()) {
                    return 0;
                } else {
                    String sql1 = "insert into zhaoping(username,passwords,phone,zhiwei,xueli,jinyan,jieshao,wang) " +
                            "values(?,?,?,?,?,?,?,?)";
                    PreparedStatement ps1 = conn.prepareStatement(sql1);
                    ps1.setString(1, data.get(0));
                    ps1.setString(2, data.get(1));
                    ps1.setString(3, data.get(2));
                    ps1.setString(4, data.get(3));
                    ps1.setString(5, data.get(4));
                    ps1.setString(6, data.get(5));
                    ps1.setString(7, data.get(6));
                    ps1.setString(8, data.get(7));
                    ps1.executeUpdate();
                    String sql2 = "insert into yisheng(username,passwords,phone,zhiwei,wang) " +
                            "values(?,?,?,?,?)";
                    PreparedStatement ps2 = conn.prepareStatement(sql2);
                    ps2.setString(1, data.get(0));
                    ps2.setString(2, data.get(1));
                    ps2.setString(3, data.get(2));
                    ps2.setString(4, data.get(3));
                    ps2.setString(5, data.get(7));
                    ps2.executeUpdate();
                    return 1;
                }
            case "yuyue": {
                String checkSql = "SELECT COUNT(*) FROM yuyue WHERE kewang = ?";
                try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                    psCheck.setString(1, data.get(0));
                    ResultSet rsCheck = psCheck.executeQuery();
                    if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                        return 0; // 已有预约
                    }
                }


                String yiSql = "SELECT username, phone FROM yisheng WHERE wang = ?";
                String yiUsername, yiPhone;
                try (PreparedStatement psYi = conn.prepareStatement(yiSql)) {
                    psYi.setString(1, data.get(1));
                    ResultSet rsYi = psYi.executeQuery();
                    if (!rsYi.next()) return -1;
                    yiUsername = rsYi.getString("username");
                    yiPhone = rsYi.getString("phone");
                }

                String kehuSql = "SELECT username, phone FROM kehu WHERE wang = ?";
                String keUsername, kePhone;
                try (PreparedStatement psKehu = conn.prepareStatement(kehuSql)) {
                    psKehu.setString(1, data.get(0));
                    ResultSet rsKehu = psKehu.executeQuery();
                    if (!rsKehu.next()) return -1; // 客户不存在
                    keUsername = rsKehu.getString("username");
                    kePhone = rsKehu.getString("phone");
                }


                String insertSql = "INSERT INTO yuyue(yiwang, yiusername, yiphone, kewang, keusername, kephone, yuzhuangtai) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setString(1, data.get(1));
                    psInsert.setString(2, yiUsername);
                    psInsert.setString(3, yiPhone);
                    psInsert.setString(4, data.get(0));
                    psInsert.setString(5, keUsername);
                    psInsert.setString(6, kePhone);
                    psInsert.setString(7, "预约中");
                    psInsert.executeUpdate();
                    return 1;
                }
            }
            case "cizhi":
                String sql6 = "select * from cizhi where weizhi='" + data.get(4) + "'";
                ResultSet rs2 = stmt.executeQuery(sql6);
                if (rs2.next()) {
                    return 0;
                }
                else {
                String sql5 = "insert into cizhi(username,yiphone,zhiwei,weizhi,yuanyin) " +
                        "values(?,?,?,?,?)";
                PreparedStatement ps5 = conn.prepareStatement(sql5);
                ps5.setString(1, data.get(0));
                ps5.setString(2, data.get(1));
                ps5.setString(3, data.get(2));
                ps5.setString(4, data.get(3));
                ps5.setString(5, data.get(4));
                ps5.executeUpdate();
                return 1;
                }
            default:
                return 0;
        }
    }

    public ResultSet chaxun(String table, ArrayList<String> data) throws SQLException {
        Statement st = conn.createStatement();
        switch (table) {
            case "kehu":
                String sql = "select * from " + table + " where wang=? and passwords=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, data.get(0));
                ps.setString(2, data.get(1));
                return ps.executeQuery();
            case "yisheng":
                String sql1 = "select * from " + table + " where wang=? and passwords=?";
                PreparedStatement ps1 = conn.prepareStatement(sql1);
                ps1.setString(1, data.get(0));
                ps1.setString(2, data.get(1));
                return ps1.executeQuery();
            case "guanli":
                String sql3 = "select * from zhaoping";
                return st.executeQuery(sql3);
            case "yuyue":
                String sql4 = "select * from " + table + " where yiwang=?";
                PreparedStatement ps4 = conn.prepareStatement(sql4);
                ps4.setString(1, data.get(0));
                return ps4.executeQuery();
            case "yisheng1":
                String sql5 = "select * from yisheng  where wang=?";
                PreparedStatement ps5 = conn.prepareStatement(sql5);
                ps5.setString(1, data.get(0));
                return ps5.executeQuery();
            case "cizhi":
                String sql6 = "select * from " + table;
                return st.executeQuery(sql6);
        }
        return null;
    }
}
 