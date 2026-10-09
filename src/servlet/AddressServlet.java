package servlet;

import dao.AddressDao;
import dao.EmpDao;
import entity.Address;
import entity.Emp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {
    private final AddressDao addressDao = new AddressDao();  // 加 final
    private final EmpDao empDao = new EmpDao();              // 加 final

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getParameter("method");

        if ("list".equals(method)) {
            int empId = getIntParam(request, "empId");
            Emp emp = empDao.loadEmp(empId);
            List<Address> addressList = addressDao.findByEmpId(empId);
            request.setAttribute("emp", emp);
            request.setAttribute("addressList", addressList);
            request.getRequestDispatcher("/address/list.jsp").forward(request, response);

        } else if ("addPage".equals(method)) {
            int empId = getIntParam(request, "empId");
            Emp emp = empDao.loadEmp(empId);
            request.setAttribute("emp", emp);
            request.getRequestDispatcher("/address/add.jsp").forward(request, response);

        } else if ("addSubmit".equals(method)) {
            Address address = buildAddressFromRequest(request);

            // 校验地址字段
            String errorMsg = validateAddress(address);
            if (errorMsg != null) {
                int empId = address.getEmpId();
                Emp emp = empDao.loadEmp(empId);
                request.setAttribute("emp", emp);
                request.setAttribute("errorMsg", errorMsg);
                request.setAttribute("address", address);
                request.getRequestDispatcher("/address/add.jsp").forward(request, response);
                return;
            }

            addressDao.add(address);
            response.sendRedirect(request.getContextPath() + "/address?method=list&empId=" + address.getEmpId());

        } else if ("editPage".equals(method)) {
            int id = getIntParam(request, "id");
            int empId = getIntParam(request, "empId");
            Address address = addressDao.findById(id);
            request.setAttribute("address", address);
            request.setAttribute("empId", empId);
            request.getRequestDispatcher("/address/edit.jsp").forward(request, response);

        } else if ("update".equals(method)) {
            Address address = buildAddressFromRequest(request);
            address.setId(getIntParam(request, "id"));

            // 校验地址字段
            String errorMsg = validateAddress(address);
            if (errorMsg != null) {
                request.setAttribute("address", address);
                request.setAttribute("empId", address.getEmpId());
                request.setAttribute("errorMsg", errorMsg);
                request.getRequestDispatcher("/address/edit.jsp").forward(request, response);
                return;
            }

            addressDao.update(address);
            response.sendRedirect(request.getContextPath() + "/address?method=list&empId=" + address.getEmpId());

        } else if ("delete".equals(method)) {
            int id = getIntParam(request, "id");
            int empId = getIntParam(request, "empId");
            addressDao.delete(id);
            response.sendRedirect(request.getContextPath() + "/address?method=list&empId=" + empId);

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 抽取公共方法：获取整数参数
    private int getIntParam(HttpServletRequest request, String name) {
        return Integer.parseInt(request.getParameter(name));
    }

    // 抽取公共方法：从请求构建Address对象
    private Address buildAddressFromRequest(HttpServletRequest request) {
        Address address = new Address();
        address.setEmpId(getIntParam(request, "empId"));
        address.setProvince(request.getParameter("province"));
        address.setCity(request.getParameter("city"));
        address.setDistrict(request.getParameter("district"));
        address.setStreet(request.getParameter("street"));
        address.setDetail(request.getParameter("detail"));
        address.setPostalCode(request.getParameter("postalCode"));
        return address;
    }

    // 校验地址字段，返回错误信息，null 表示校验通过
    private String validateAddress(Address address) {
        if (address.getProvince() == null || address.getProvince().trim().isEmpty()) {
            return "省份不能为空";
        }
        if (address.getProvince().trim().matches("\\d+")) {
            return "省份不能为纯数字";
        }
        if (address.getCity() == null || address.getCity().trim().isEmpty()) {
            return "城市不能为空";
        }
        if (address.getCity().trim().matches("\\d+")) {
            return "城市不能为纯数字";
        }
        if (address.getDistrict() == null || address.getDistrict().trim().isEmpty()) {
            return "区/县不能为空";
        }
        if (address.getDistrict().trim().matches("\\d+")) {
            return "区/县不能为纯数字";
        }
        if (address.getStreet() == null || address.getStreet().trim().isEmpty()) {
            return "街道不能为空";
        }
        if (address.getStreet().trim().matches("\\d+")) {
            return "街道不能为纯数字";
        }
        if (address.getDetail() == null || address.getDetail().trim().isEmpty()) {
            return "详细地址不能为空";
        }
        if (address.getDetail().trim().matches("\\d+")) {
            return "详细地址不能为纯数字";
        }
        // 邮政编码非必填，若填写则必须为6位数字
        String postalCode = address.getPostalCode();
        if (postalCode != null && !postalCode.trim().isEmpty()) {
            if (!postalCode.trim().matches("\\d{6}")) {
                return "邮政编码必须为6位数字";
            }
        }
        return null;
    }
}