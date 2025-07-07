package com.example.keshe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/shibie")
public class shibie extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String select = req.getParameter("select");
        req.setAttribute("select", select);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String select = req.getParameter("select");
        everyone everyone = new everyone();
        switch (select) {

            case "zhuce":
                ArrayList<String> data = new ArrayList<>();
                data.add(req.getParameter("username"));
                data.add(req.getParameter("password"));
                data.add(req.getParameter("phone"));
                data.add(req.getParameter("wang"));
                try {
                    int i = everyone.charu("kehu", data);
                    if (i == 1) {
                        req.setAttribute("message", "注册成功，返回页面登录");
                        req.getRequestDispatcher("login.jsp").forward(req, resp);
                    } else {
                        req.setAttribute("message", "用户名已存在，返回页面注册");
                        req.getRequestDispatcher("login.jsp").forward(req, resp);
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "kehu":
                ArrayList<String> data1 = new ArrayList<>();
                data1.add(req.getParameter("username"));
                data1.add(req.getParameter("password"));
                try {
                    ResultSet resultSet = everyone.chaxun("kehu", data1);
                    if (resultSet != null && resultSet.next()) {
                        req.setAttribute("wang", data1.get(0));
                        PrintWriter out = resp.getWriter();
                        req.setAttribute("wang", req.getParameter("username"));
                        req.getRequestDispatcher("kehu.jsp").forward(req, resp);
                    } else {
                        req.setAttribute("message", "用户名不唯一或密码错误，返回页面登录");
                        req.getRequestDispatcher("login.jsp").forward(req, resp);
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "yisheng":
                ArrayList<String> data2 = new ArrayList<>();
                data2.add(req.getParameter("username"));
                data2.add(req.getParameter("password"));
                try {
                    ResultSet resultSet = everyone.chaxun("yisheng", data2);
                    if (resultSet != null && resultSet.next()) {
                        req.setAttribute("wang", resultSet.getString("wang"));
                        req.getRequestDispatcher("yisheng.jsp").forward(req, resp);
                    } else {
                        req.setAttribute("message", "姓名或密码或错误，返回页面登录");
                        req.getRequestDispatcher("login.jsp").forward(req, resp);
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "guanliyuan":
                String password = req.getParameter("password");
                if (password.equals("123456")) {
                    req.getRequestDispatcher("/guanliyuan.jsp").forward(req, resp);
                } else {
                    req.setAttribute("message", "密码错误，返回页面登录");
                    req.getRequestDispatcher("login.jsp").forward(req, resp);
                }
        }
    }
}

