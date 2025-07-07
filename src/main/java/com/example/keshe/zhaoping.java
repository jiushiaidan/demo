package com.example.keshe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/zhaoping")
public class zhaoping extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        everyone everyone = new everyone();
        ArrayList<String> data = new ArrayList<>();
        data.add(req.getParameter("username"));
        data.add(req.getParameter("password"));
        data.add(req.getParameter("phone"));
        data.add(req.getParameter("zhiwei"));
        data.add(req.getParameter("xueli"));
        data.add(req.getParameter("jingyan"));
        data.add(req.getParameter("jieshao"));
        data.add(req.getParameter("wang"));
        try {
            int i = everyone.charu("zhaoping", data);
            if (i == 1) {
                req.setAttribute("message", "简历发送成功，前往登录等待消息");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            } else {
                req.setAttribute("message", "用户名已存在请重新填写");
                req.getRequestDispatcher("zhaoping.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
