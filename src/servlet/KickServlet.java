package servlet;

import listener.SessionListener;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/kick")
public class KickServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sessionId = request.getParameter("sessionId");

        if (sessionId != null && !sessionId.isEmpty()) {
            SessionListener.kickUser(sessionId);
            System.out.println("[管理员操作] 踢出用户 Session: " + sessionId);
        }

        response.sendRedirect(request.getContextPath() + "/online.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}