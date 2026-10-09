package servlet;

import dao.EmpDao;
import dao.DeptDao;
import entity.Emp;
import bean.Dept;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/emp")
public class EmpServlet extends HttpServlet {
    private EmpDao empDao = new EmpDao();
    private DeptDao deptDao = new DeptDao();
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getParameter("method");

        if ("list".equals(method)) {
            // 分页参数
            int pageNo = 1;
            int pageSize = 10;

            String pageNoStr = request.getParameter("pageNo");
            if (pageNoStr != null && !pageNoStr.trim().isEmpty()) {
                try {
                    pageNo = Integer.parseInt(pageNoStr);
                    if (pageNo < 1) pageNo = 1;
                } catch (NumberFormatException e) {
                    pageNo = 1;
                }
            }

            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize < 1) pageSize = 1;
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            // 获取总记录数
            int totalCount = empDao.getTotalCount();

            // 如果没有数据，返回空列表
            if (totalCount == 0) {
                request.setAttribute("list", new ArrayList<Emp>());
                request.setAttribute("totalCount", 0);
                request.setAttribute("totalPages", 0);
                request.setAttribute("currentPage", 1);
                request.setAttribute("pageSize", pageSize);
                request.getRequestDispatcher("/emp/list.jsp").forward(request, response);
                return;
            }

            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            if (pageNo > totalPages && totalPages > 0) {
                pageNo = totalPages;
            }

            // 分页查询
            List<Emp> list = empDao.findByPage(pageNo, pageSize);

            request.setAttribute("list", list);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageNo);
            request.setAttribute("pageSize", pageSize);

            request.getRequestDispatcher("/emp/list.jsp").forward(request, response);

        } else if ("add".equals(method)) {
            List<Dept> deptList = deptDao.findAll();
            request.setAttribute("deptList", deptList);
            request.getRequestDispatcher("/emp/add.jsp").forward(request, response);

        } else if ("addSubmit".equals(method)) {
            // 获取参数
            String name = request.getParameter("name");
            String ageStr = request.getParameter("age");
            String salaryStr = request.getParameter("salary");
            String deptIdStr = request.getParameter("deptId");

            List<Dept> deptList = deptDao.findAll();
            request.setAttribute("deptList", deptList);

            // 校验姓名
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMsg", "姓名不能为空");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }
            if (name.trim().matches("\\d+")) {
                request.setAttribute("errorMsg", "姓名不能为纯数字");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }

            // 校验年龄
            int age = 0;
            try {
                age = Integer.parseInt(ageStr);
                if (age <= 0) {
                    request.setAttribute("errorMsg", "年龄必须大于0");
                    request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                    return;
                }
                if (age < 18 || age > 60) {
                    request.setAttribute("errorMsg", "员工年龄必须在18至60岁之间");
                    request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "年龄格式不正确");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }

            // 校验薪资
            double salary = 0;
            try {
                salary = Double.parseDouble(salaryStr);
                if (salary < 0) {
                    request.setAttribute("errorMsg", "薪资不能为负数");
                    request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                    return;
                }
                if (salary < 2000 || salary > 100000) {
                    request.setAttribute("errorMsg", "员工月薪必须在2000至100000元之间");
                    request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "薪资格式不正确");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }

            // 校验部门
            int deptId = 0;
            try {
                deptId = Integer.parseInt(deptIdStr);
                if (deptId <= 0) {
                    request.setAttribute("errorMsg", "请选择部门");
                    request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "请选择部门");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }

            // 校验同一部门下是否有同名员工
            if (empDao.isNameExistsInDept(name, deptId)) {
                request.setAttribute("errorMsg", "该部门下已存在同名员工，请更换姓名或部门");
                request.getRequestDispatcher("/emp/add.jsp").forward(request, response);
                return;
            }

            Emp emp = new Emp();
            emp.setName(name);
            emp.setAge(age);
            emp.setSalary(salary);
            emp.setDeptId(deptId);
            empDao.addEmp(emp);
            response.sendRedirect(request.getContextPath() + "/emp?method=list");

        } else if ("delete".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            empDao.deleteEmp(id);
            response.sendRedirect(request.getContextPath() + "/emp?method=list");

        } else if ("edit".equals(method)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Emp emp = empDao.loadEmp(id);
            List<Dept> deptList = deptDao.findAll();
            request.setAttribute("emp", emp);
            request.setAttribute("deptList", deptList);
            request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);

        } else if ("update".equals(method)) {
            // 获取参数
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String ageStr = request.getParameter("age");
            String salaryStr = request.getParameter("salary");
            String deptIdStr = request.getParameter("deptId");

            // 校验ID
            int id = 0;
            try {
                id = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/emp?method=list");
                return;
            }

            Emp originalEmp = empDao.loadEmp(id);
            List<Dept> deptList = deptDao.findAll();

            // 校验姓名
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMsg", "姓名不能为空");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }
            if (name.trim().matches("\\d+")) {
                request.setAttribute("errorMsg", "姓名不能为纯数字");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }

            // 校验年龄
            int age = 0;
            try {
                age = Integer.parseInt(ageStr);
                if (age <= 0) {
                    request.setAttribute("errorMsg", "年龄必须大于0");
                    request.setAttribute("emp", originalEmp);
                    request.setAttribute("deptList", deptList);
                    request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                    return;
                }
                if (age < 18 || age > 60) {
                    request.setAttribute("errorMsg", "员工年龄必须在18至60岁之间");
                    request.setAttribute("emp", originalEmp);
                    request.setAttribute("deptList", deptList);
                    request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "年龄格式不正确");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }

            // 校验薪资
            double salary = 0;
            try {
                salary = Double.parseDouble(salaryStr);
                if (salary < 0) {
                    request.setAttribute("errorMsg", "薪资不能为负数");
                    request.setAttribute("emp", originalEmp);
                    request.setAttribute("deptList", deptList);
                    request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                    return;
                }
                if (salary < 2000 || salary > 100000) {
                    request.setAttribute("errorMsg", "员工月薪必须在2000至100000元之间");
                    request.setAttribute("emp", originalEmp);
                    request.setAttribute("deptList", deptList);
                    request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "薪资格式不正确");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }

            // 校验部门
            int deptId = 0;
            try {
                deptId = Integer.parseInt(deptIdStr);
                if (deptId <= 0) {
                    request.setAttribute("errorMsg", "请选择部门");
                    request.setAttribute("emp", originalEmp);
                    request.setAttribute("deptList", deptList);
                    request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "请选择部门");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }

            // 校验同一部门下是否有同名员工（排除当前员工自己）
            if (empDao.isNameExistsInDeptExcludeSelf(name, deptId, id)) {
                request.setAttribute("errorMsg", "该部门下已存在同名员工，请更换姓名或部门");
                request.setAttribute("emp", originalEmp);
                request.setAttribute("deptList", deptList);
                request.getRequestDispatcher("/emp/edit.jsp").forward(request, response);
                return;
            }

            Emp emp = new Emp();
            emp.setId(id);
            emp.setName(name);
            emp.setAge(age);
            emp.setSalary(salary);
            emp.setDeptId(deptId);
            empDao.updateEmp(emp);
            response.sendRedirect(request.getContextPath() + "/emp?method=list");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}