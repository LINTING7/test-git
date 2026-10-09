<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>部门管理 - 新增部门</title>
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

        .user-info {
            font-size: 14px;
            color: #94a3b8;
            background: #f1f5f9;
            padding: 8px 18px;
            border-radius: 30px;
        }

        .container {
            max-width: 700px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .form-card {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }

        .form-title {
            font-size: 24px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 32px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            background: #fff;
            transition: all 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }

        .form-group input::placeholder {
            color: #cbd5e1;
        }

        .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 32px;
        }

        .btn-submit {
            padding: 12px 32px;
            background: #3b82f6;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-submit:hover {
            background: #2563eb;
            transform: translateY(-1px);
        }

        .btn-cancel {
            padding: 12px 32px;
            background: transparent;
            color: #64748b;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            text-align: center;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            border-color: #cbd5e1;
            color: #334155;
        }

        .error-msg {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #dc2626;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">企业管理系统<span> </span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp"> 员工管理</a>
        <a href="${pageContext.request.contextPath}/address/manager.jsp"> 家庭住址管理</a>
        <a href="${pageContext.request.contextPath}/dept?method=list"> 部门管理</a>
        <span class="user-info">${sessionScope.user.username}</span>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <div class="form-title">新建部门</div>

        <c:if test="${not empty msg}">
            <div class="error-msg">${msg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/dept" method="post">
            <input type="hidden" name="method" value="add">
            <div class="form-group">
                <label>部门名称 *</label>
                <input type="text" name="name" placeholder="请输入部门名称" required>
            </div>
            <div class="form-group">
                <label>主管人</label>
                <input type="text" name="manager" placeholder="请输入主管人姓名">
            </div>
            <div class="form-group">
                <label>联系方式</label>
                <input type="text" name="phone" placeholder="请输入联系电话" maxlength="11" pattern="\d{11}" title="请输入11位手机号码">
            </div>
            <div class="btn-group">
                <button type="submit" class="btn-submit">保存</button>
                <a href="${pageContext.request.contextPath}/dept?method=list" class="btn-cancel">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>