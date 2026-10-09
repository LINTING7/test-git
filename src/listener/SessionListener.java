package listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class SessionListener implements HttpSessionListener, HttpSessionAttributeListener {

    // 存储所有在线用户 Session
    private static final ConcurrentHashMap<String, HttpSession> sessionMap = new ConcurrentHashMap<>();

    // ==================== HttpSessionListener ====================

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        sessionMap.put(session.getId(), session);

        System.out.println("[Session创建] ID: " + session.getId() +
                ", 总Session数: " + sessionMap.size());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        String username = (String) session.getAttribute("username");

        sessionMap.remove(session.getId());

        System.out.println("[Session销毁] ID: " + session.getId() +
                ", 用户: " + (username != null ? username : "未登录") +
                ", 剩余Session数: " + sessionMap.size());
    }

    // ==================== HttpSessionAttributeListener ====================

    @Override
    public void attributeAdded(HttpSessionBindingEvent se) {
        HttpSession session = se.getSession();
        String name = se.getName();
        Object value = se.getValue();

        // 当用户登录时（添加了 user 属性）
        if ("user".equals(name) && value != null) {
            System.out.println("[用户登录] Session: " + session.getId() +
                    ", 用户: " + value);
            session.setAttribute("username", value.toString());
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent se) {
        HttpSession session = se.getSession();
        String name = se.getName();
        Object value = se.getValue();

        // 当用户退出时（移除了 user 属性）
        if ("user".equals(name) && value != null) {
            System.out.println("[用户退出] Session: " + session.getId() +
                    ", 用户: " + value);
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent se) {
        // 属性被替换时触发
        String name = se.getName();
        if ("user".equals(name)) {
            System.out.println("[用户信息更新] Session: " + se.getSession().getId());
        }
    }

    // ==================== 公共方法 ====================

    // 获取在线 Session 数量
    public static int getSessionCount() {
        return sessionMap.size();
    }

    // 获取所有在线 Session
    public static ConcurrentHashMap<String, HttpSession> getSessionMap() {
        return sessionMap;
    }

    // 根据 Session ID 获取 Session
    public static HttpSession getSession(String sessionId) {
        return sessionMap.get(sessionId);
    }

    // 强制踢出用户
    public static void kickUser(String sessionId) {
        HttpSession session = sessionMap.get(sessionId);
        if (session != null) {
            session.invalidate();
        }
    }
}