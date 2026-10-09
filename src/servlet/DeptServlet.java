package servlet;

import bean.Dept;
import dao.DeptDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dept")
public class DeptServlet extends HttpServlet {
    private DeptDao dao = new DeptDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getParameter("method");
        System.out.println("method = " + method); // 调试输出

        // 处理新增（POST请求）
        if ("add".equals(method)) {
            String name = request.getParameter("name");
            String manager = request.getParameter("manager");
            String phone = request.getParameter("phone");

            System.out.println("name = " + name); // 调试输出

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("msg", "部门名称不能为空");
                request.getRequestDispatcher("/dept/add.jsp").forward(request, response);
                return;
            }

            // 检查部门名称是否已存在
            if (dao.isNameExists(name.trim())) {
                request.setAttribute("msg", "该部门名称已存在，不能重复创建");
                request.getRequestDispatcher("/dept/add.jsp").forward(request, response);
                return;
            }

            // 校验联系方式长度（非必填，若填写则必须为11位）
            if (phone != null && !phone.trim().isEmpty() && phone.trim().length() != 11) {
                request.setAttribute("msg", "联系方式必须为11位");
                request.getRequestDispatcher("/dept/add.jsp").forward(request, response);
                return;
            }

            // 检查主管人是否已被其他部门使用
            if (manager != null && !manager.trim().isEmpty() && dao.isManagerExists(manager.trim())) {
                request.setAttribute("msg", "该主管人已属于其他部门，不能重复");
                request.getRequestDispatcher("/dept/add.jsp").forward(request, response);
                return;
            }

            Dept dept = new Dept();
            dept.setName(name);
            dept.setManager(manager);
            dept.setPhone(phone);
            dao.add(dept);
            response.sendRedirect(request.getContextPath() + "/dept?method=list");
            return;
        }

        // 处理删除
        if ("delete".equals(method)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    if (dao.hasEmployees(id)) {
                        request.setAttribute("msg", "该部门下存在员工，无法删除！");
                        request.setAttribute("list", dao.findAll());
                        request.getRequestDispatcher("/dept/list.jsp").forward(request, response);
                    } else {
                        dao.delete(id);
                        response.sendRedirect(request.getContextPath() + "/dept?method=list");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("msg", "部门ID格式错误");
                    request.setAttribute("list", dao.findAll());
                    request.getRequestDispatcher("/dept/list.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/dept?method=list");
            }
            return;
        }

        // 处理编辑页面
        if ("edit".equals(method)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Dept dept = dao.findById(id);
                    request.setAttribute("dept", dept);
                    request.getRequestDispatcher("/dept/edit.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dept?method=list");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/dept?method=list");
            }
            return;
        }

        // 处理更新
        if ("update".equals(method)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    String name = request.getParameter("name");
                    String manager = request.getParameter("manager");
                    String phone = request.getParameter("phone");

                    if (name == null || name.trim().isEmpty()) {
                        Dept original = dao.findById(id);
                        request.setAttribute("msg", "部门名称不能为空");
                        request.setAttribute("dept", original);
                        request.getRequestDispatcher("/dept/edit.jsp").forward(request, response);
                        return;
                    }

                    // 检查部门名称是否已存在（排除自身）
                    if (dao.isNameExistsExcludeSelf(name.trim(), id)) {
                        Dept original = dao.findById(id);
                        request.setAttribute("msg", "该部门名称已存在，不能重复");
                        request.setAttribute("dept", original);
                        request.getRequestDispatcher("/dept/edit.jsp").forward(request, response);
                        return;
                    }

                    // 校验联系方式长度（非必填，若填写则必须为11位）
                    if (phone != null && !phone.trim().isEmpty() && phone.trim().length() != 11) {
                        Dept original = dao.findById(id);
                        request.setAttribute("msg", "联系方式必须为11位");
                        request.setAttribute("dept", original);
                        request.getRequestDispatcher("/dept/edit.jsp").forward(request, response);
                        return;
                    }

                    // 检查主管人是否已被其他部门使用（排除自身）
                    if (manager != null && !manager.trim().isEmpty() && dao.isManagerExistsExcludeSelf(manager.trim(), id)) {
                        Dept original = dao.findById(id);
                        request.setAttribute("msg", "该主管人已属于其他部门，不能重复");
                        request.setAttribute("dept", original);
                        request.getRequestDispatcher("/dept/edit.jsp").forward(request, response);
                        return;
                    }

                    Dept dept = new Dept();
                    dept.setId(id);
                    dept.setName(name);
                    dept.setManager(manager);
                    dept.setPhone(phone);
                    dao.update(dept);
                    response.sendRedirect(request.getContextPath() + "/dept?method=list");
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dept?method=list");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/dept?method=list");
            }
            return;
        }

        // 默认显示列表
        request.setAttribute("list", dao.findAll());
        request.getRequestDispatcher("/dept/list.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}