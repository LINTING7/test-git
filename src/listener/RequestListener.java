package listener;

import javax.servlet.ServletRequest;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.concurrent.atomic.AtomicLong;

@WebListener
public class RequestListener implements ServletRequestListener {

    // 请求计数器
    private static AtomicLong requestCount = new AtomicLong(0);
    private static AtomicLong totalRequestCount = new AtomicLong(0);

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        ServletRequest request = sre.getServletRequest();

        if (request instanceof HttpServletRequest) {
            HttpServletRequest req = (HttpServletRequest) request;

            // 记录请求开始时间
            long startTime = System.currentTimeMillis();
            request.setAttribute("startTime", startTime);

            // 记录请求信息
            String uri = req.getRequestURI();
            String method = req.getMethod();
            String clientIp = getClientIp(req);

            // 增加请求计数
            long currentCount = requestCount.incrementAndGet();
            totalRequestCount.incrementAndGet();

            System.out.println("[请求开始] " + new Date() +
                    " | IP: " + clientIp +
                    " | " + method + " " + uri +
                    " | 当前并发: " + currentCount);
        }
    }

    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        ServletRequest request = sre.getServletRequest();

        if (request instanceof HttpServletRequest) {
            HttpServletRequest req = (HttpServletRequest) request;

            // 计算请求耗时
            Long startTime = (Long) request.getAttribute("startTime");
            long duration = System.currentTimeMillis() - (startTime != null ? startTime : 0);

            String uri = req.getRequestURI();
            String method = req.getMethod();

            // 减少请求计数
            long currentCount = requestCount.decrementAndGet();

            System.out.println("[请求结束] " + uri +
                    " | 耗时: " + duration + "ms" +
                    " | 当前并发: " + currentCount +
                    " | 总请求数: " + totalRequestCount.get());
        }
    }

    // 获取客户端真实 IP
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    // 获取当前请求并发数
    public static long getCurrentRequestCount() {
        return requestCount.get();
    }

    // 获取总请求数
    public static long getTotalRequestCount() {
        return totalRequestCount.get();
    }
}