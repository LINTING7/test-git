package listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    // 在线用户计数器
    private static int onlineCount = 0;

    // ==================== ServletContextListener 方法 ====================

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        System.out.println("=========================================");
        System.out.println("  企业管理系统启动成功！");
        System.out.println("  启动时间: " + new Date());
        System.out.println("  项目名称: " + context.getContextPath());
        System.out.println("  服务器信息: " + context.getServerInfo());
        System.out.println("=========================================");

        // 设置初始化参数到 application 域
        context.setAttribute("appStartTime", new Date());
        context.setAttribute("appVersion", "1.0.0");
        context.setAttribute("onlineCount", 0);

        // 启动一个定时任务，每分钟输出一次系统状态
        startMonitorTask(context);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("  企业管理系统关闭！");
        System.out.println("  关闭时间: " + new Date());
        System.out.println("=========================================");
    }

    // ==================== HttpSessionListener 方法 ====================

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        onlineCount++;

        // 获取 ServletContext
        ServletContext context = session.getServletContext();
        context.setAttribute("onlineCount", onlineCount);

        // 记录登录信息到 session
        session.setAttribute("loginTime", new Date());
        session.setAttribute("sessionId", session.getId());

        System.out.println("[会话创建] Session ID: " + session.getId() +
                ", 当前在线人数: " + onlineCount);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        onlineCount--;

        // 获取 ServletContext
        ServletContext context = session.getServletContext();
        context.setAttribute("onlineCount", onlineCount);

        String username = (String) session.getAttribute("username");
        if (username == null) {
            username = "未登录用户";
        }

        System.out.println("[会话销毁] 用户: " + username +
                ", Session ID: " + session.getId() +
                ", 当前在线人数: " + onlineCount);
    }

    // ==================== 私有方法 ====================

    // 启动监控定时任务
    private void startMonitorTask(ServletContext context) {
        Timer timer = new Timer(true);
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                System.out.println("[系统监控] " + new Date() +
                        " - 在线用户数: " + onlineCount +
                        " - 活动Session数: " + getActiveSessionCount(context));
            }
        }, 60000, 60000); // 延迟60秒后开始，每60秒执行一次
    }

    // 获取活跃 Session 数量
    private int getActiveSessionCount(ServletContext context) {
        // 这个方法仅用于日志输出，实际使用 session 监听器统计
        return onlineCount;
    }

    // 获取当前在线人数（静态方法，供其他类调用）
    public static int getOnlineCount() {
        return onlineCount;
    }
}