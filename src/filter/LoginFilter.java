package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")  // 过滤所有请求
public class LoginFilter implements Filter {

    // 不需要登录就可以访问的页面（白名单）
    private static final String[] WHITE_LIST = {
            "/login.jsp",
            "/login",
            "/css/",
            "/js/",
            "/images/",
            "/favicon.ico"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("登录过滤器初始化成功");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 获取请求的路径
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        System.out.println("请求路径: " + path);  // 调试输出

        // 检查是否在白名单中
        if (isInWhiteList(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 检查用户是否已登录
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // 已登录，继续访问
            chain.doFilter(request, response);
        } else {
            // 未登录，重定向到登录页面
            System.out.println("未登录用户访问: " + path + "，跳转到登录页");
            resp.sendRedirect(contextPath + "/login.jsp");
        }
    }

    // 判断是否在白名单中
    private boolean isInWhiteList(String path) {
        for (String white : WHITE_LIST) {
            if (path.equals(white) || path.startsWith(white)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        System.out.println("登录过滤器销毁");
    }
}