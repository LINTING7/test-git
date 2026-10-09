package servlet;

import bean.User;
import dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/user-manager")
public class UserManagerServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 检查用户是否登录以及是否有管理员权限
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User loginUser = (User) session.getAttribute("user");
        boolean isAdmin = "admin".equals(loginUser.getRole());

        String method = request.getParameter("method");

        if (method == null || method.isEmpty()) {
            method = "list";
        }

        // 列表页面所有人都可以查看
        if ("list".equals(method)) {
            listUsers(request, response);
            return;
        }

        // 以下操作需要管理员权限
        if (!isAdmin) {
            // 普通用户没有权限，提示错误并跳转
            request.setAttribute("errorMsg", "您没有权限执行此操作，只有管理员可以管理用户账号");
            listUsers(request, response);
            return;
        }

        switch (method) {
            case "add":
                showAddPage(request, response);
                break;
            case "addSubmit":
                addUser(request, response);
                break;
            case "edit":
                showEditPage(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 用户列表
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> userList = userDao.findAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/user/list.jsp").forward(request, response);
    }

    // 显示添加页面
    private void showAddPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/user/add.jsp").forward(request, response);
    }

    // 添加用户
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // 校验
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "用户名不能为空");
            request.getRequestDispatcher("/user/add.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "密码不能为空");
            request.setAttribute("username", username);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/user/add.jsp").forward(request, response);
            return;
        }
        if (userDao.isUsernameExists(username)) {
            request.setAttribute("errorMsg", "用户名已存在，请更换用户名");
            request.setAttribute("username", username);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/user/add.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role != null ? role : "user");

        boolean success = userDao.addUser(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
        } else {
            request.setAttribute("errorMsg", "添加失败，请重试");
            request.getRequestDispatcher("/user/add.jsp").forward(request, response);
        }
    }

    // 显示编辑页面
    private void showEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            User user = userDao.findUserById(id);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
        }
    }

    // 更新用户
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
            return;
        }

        int id = Integer.parseInt(idStr);

        // 校验
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "用户名不能为空");
            request.setAttribute("user", userDao.findUserById(id));
            request.getRequestDispatcher("/user/edit.jsp").forward(request, response);
            return;
        }
        if (userDao.isUsernameExistsExcludeId(username, id)) {
            request.setAttribute("errorMsg", "用户名已存在，请更换用户名");
            request.setAttribute("user", userDao.findUserById(id));
            request.getRequestDispatcher("/user/edit.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setId(id);
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role != null ? role : "user");

        boolean success = userDao.updateUser(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
        } else {
            request.setAttribute("errorMsg", "更新失败，请重试");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/edit.jsp").forward(request, response);
        }
    }

    // 删除用户
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);

            // 防止管理员删除自己
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("user");
            if (loginUser != null && loginUser.getId() == id) {
                request.setAttribute("errorMsg", "不能删除自己的账号");
                listUsers(request, response);
                return;
            }

            userDao.deleteUser(id);
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user-manager?method=list");
        }
    }
}