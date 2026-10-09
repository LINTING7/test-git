<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="listener.SessionListener, javax.servlet.http.HttpSession, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 获取在线用户信息
    Map<String, HttpSession> sessionMap = SessionListener.getSessionMap();
    List<Map<String, Object>> onlineUsers = new ArrayList<>();

    for (Map.Entry<String, HttpSession> entry : sessionMap.entrySet()) {
        HttpSession httpSession = entry.getValue();  // 改名：session -> httpSession
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("sessionId", entry.getKey());
        userInfo.put("username", httpSession.getAttribute("username"));
        userInfo.put("loginTime", httpSession.getAttribute("loginTime"));
        userInfo.put("creationTime", new Date(httpSession.getCreationTime()));
        userInfo.put("lastAccessTime", new Date(httpSession.getLastAccessedTime()));
        onlineUsers.add(userInfo);
    }

    request.setAttribute("onlineUsers", onlineUsers);
    request.setAttribute("onlineCount", onlineUsers.size());
%>
<html>
<head>
    <title>在线用户管理</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f5f7fa;
            color: #1a1a1a;
        }

        .navbar {
            background: #ffffff;
            border-bottom: 1px solid #e8ecf0;
            padding: 0 48px;
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            font-size: 22px;
            font-weight: 600;
            color: #1e293b;
        }

        .logo span {
            font-weight: 400;
            color: #94a3b8;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 48px;
        }

        .nav-links a {
            color: #475569;
            text-decoration: none;
            font-size: 18px;
            font-weight: 500;
            transition: color 0.2s;
            padding: 8px 0;
        }

        .nav-links a:hover {
            color: #3b82f6;
        }

        .nav-links a.active {
            color: #3b82f6;
        }

        .user-info {
            font-size: 14px;
            color: #94a3b8;
            background: #f1f5f9;
            padding: 8px 18px;
            border-radius: 30px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 48px;
        }

        .page-header {
            margin-bottom: 32px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #0f172a;
        }

        .stats-card {
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 32px;
            border: 1px solid #e2e8f0;
            display: flex;
            gap: 32px;
        }

        .stat-item {
            flex: 1;
            text-align: center;
        }

        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #3b82f6;
        }

        .stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 8px;
        }

        .table-container {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 16px 20px;
            background: #f8fafc;
            font-weight: 600;
            font-size: 14px;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 14px 20px;
            font-size: 14px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .kick-btn {
            padding: 4px 12px;
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
        }

        .kick-btn:hover {
            background: #dc2626;
        }

        .footer {
            margin-top: 48px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
            text-align: center;
            font-size: 13px;
            color: #94a3b8;
        }

        @media (max-width: 1024px) {
            .container {
                padding: 20px;
            }
            .navbar {
                padding: 0 20px;
            }
            .nav-links {
                gap: 24px;
            }
            .nav-links a {
                font-size: 15px;
            }
            .stats-card {
                flex-direction: column;
                gap: 16px;
            }
            .table-container {
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">企业管理系统<span> · 极简版</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp"> 员工管理</a>
        <a href="${pageContext.request.contextPath}/address/manager.jsp"> 家庭住址管理</a>
        <a href="${pageContext.request.contextPath}/dept?method=list"> 部门管理</a>
        <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
        <a href="${pageContext.request.contextPath}/stats">数据统计</a>
        <a href="${pageContext.request.contextPath}/online.jsp" class="active"> 在线用户</a>
        <div style="display: flex; align-items: center; gap: 16px;">
            <span class="user-info"> ${sessionScope.user.username}</span>
            <a href="${pageContext.request.contextPath}/logout" style="color: #94a3b8; text-decoration: none; font-size: 14px;"> 退出</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <h1>在线用户监控</h1>
    </div>

    <div class="stats-card">
        <div class="stat-item">
            <div class="stat-number">${onlineCount}</div>
            <div class="stat-label">当前在线人数</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${applicationScope.onlineCount != null ? applicationScope.onlineCount : 0}</div>
            <div class="stat-label">系统统计在线</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">${applicationScope.appVersion}</div>
            <div class="stat-label">系统版本</div>
        </div>
    </div>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Session ID</th>
                <th>用户名</th>
                <th>登录时间</th>
                <th>最后访问时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${onlineUsers}" var="user">
                <tr>
                    <td style="font-family: monospace; font-size: 12px;">${user.sessionId}</td>
                    <td><strong>${user.username != null ? user.username : '未登录'}</strong></td>
                    <td>${user.loginTime != null ? user.loginTime : user.creationTime}</td>
                    <td>${user.lastAccessTime}</td>
                    <td>
                        <button class="kick-btn" onclick="kickUser('${user.sessionId}')">踢出</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty onlineUsers}">
                <tr class="empty-row">
                    <td colspan="5" style="text-align: center; padding: 48px; color: #94a3b8;">
                        暂无在线用户
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="footer">
        <p>在线用户监控 · 支持强制踢出用户</p>
    </div>
</div>

<script>
    function kickUser(sessionId) {
        if (confirm('确定要踢出该用户吗？')) {
            window.location.href = '${pageContext.request.contextPath}/kick?sessionId=' + sessionId;
        }
    }
</script>
</body>
</html>