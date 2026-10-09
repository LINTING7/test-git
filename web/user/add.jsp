<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加管理者</title>
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
        }

        .nav-links a:hover {
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
            max-width: 500px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .form-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 32px;
        }

        .form-title {
            font-size: 20px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 28px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input, .form-group select {
            width: 100%;
            height: 44px;
            padding: 0 12px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            background: #fff;
            transition: all 0.2s;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 2px rgba(59,130,246,0.1);
        }

        .error-msg {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #dc2626;
        }

        .hint-text {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 6px;
        }

        .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 32px;
        }

        .btn-submit {
            padding: 10px 24px;
            background: #1e293b;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-submit:hover {
            background: #0f172a;
        }

        .btn-cancel {
            padding: 10px 24px;
            background: transparent;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            text-align: center;
        }

        .btn-cancel:hover {
            border-color: #cbd5e1;
            color: #334155;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">企业管理系统<span> · 添加管理者</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
        <a href="${pageContext.request.contextPath}/user-manager?method=list">管理者列表</a>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <div class="form-title">添加管理者账号</div>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg">⚠️ ${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user-manager?method=addSubmit" method="post">
            <div class="form-group">
                <label>用户名 *</label>
                <input type="text" name="username" value="${username}" placeholder="请输入用户名" required>
                <div class="hint-text">登录系统时使用的账号</div>
            </div>

            <div class="form-group">
                <label>密码 *</label>
                <input type="password" name="password" placeholder="请输入密码" required>
                <div class="hint-text">密码长度建议6-20位</div>
            </div>

            <div class="form-group">
                <label>角色</label>
                <select name="role">
                    <option value="user" ${role == 'user' ? 'selected' : ''}>普通用户</option>
                    <option value="admin" ${role == 'admin' ? 'selected' : ''}>管理员</option>
                </select>
                <div class="hint-text">管理员拥有所有权限，普通用户仅可查看</div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-submit">添加账号</button>
                <a href="${pageContext.request.contextPath}/user-manager?method=list" class="btn-cancel">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>