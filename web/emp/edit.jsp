<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑员工</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f5f5f5;
            color: #1a1a1a;
        }

        .navbar {
            background: #ffffff;
            border-bottom: 1px solid #eaeaea;
            padding: 0 40px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            font-size: 18px;
            font-weight: 500;
            color: #111;
        }

        .logo span {
            font-weight: 300;
            color: #888;
        }

        .nav-links a {
            color: #555;
            text-decoration: none;
            margin-left: 32px;
            font-size: 14px;
        }

        .nav-links a:hover {
            color: #111;
        }

        .container {
            max-width: 600px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .form-card {
            background: #fff;
            border: 1px solid #eaeaea;
            padding: 32px;
        }

        .form-title {
            font-size: 20px;
            font-weight: 400;
            color: #111;
            margin-bottom: 28px;
            padding-bottom: 16px;
            border-bottom: 1px solid #eaeaea;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            color: #666;
        }

        .form-group input, .form-group select {
            width: 100%;
            height: 42px;
            padding: 0 12px;
            border: 1px solid #ddd;
            font-size: 14px;
            font-family: inherit;
            background: #fff;
            transition: border-color 0.2s;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #999;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 32px;
        }

        .btn-submit {
            padding: 10px 24px;
            background: #111;
            color: #fff;
            border: none;
            font-size: 13px;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .btn-submit:hover {
            opacity: 0.8;
        }

        .btn-cancel {
            padding: 10px 24px;
            background: transparent;
            color: #888;
            text-decoration: none;
            font-size: 13px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .btn-cancel:hover {
            border-color: #999;
            color: #333;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">企业管理系统<span> · 编辑员工</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
        <a href="${pageContext.request.contextPath}/emp?method=list">员工列表</a>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <div class="form-title">编辑员工信息</div>
        <form action="${pageContext.request.contextPath}/emp?method=update" method="post">
            <input type="hidden" name="id" value="${emp.id}">

            <div class="form-group">
                <label>姓名</label>
                <input type="text" name="name" value="${emp.name}" required pattern=".*[^\d].*" title="姓名不能为纯数字">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>年龄</label>
                    <input type="number" name="age" value="${emp.age}" min="18" max="60" step="1" required>
                </div>
                <div class="form-group">
                    <label>薪资</label>
                    <input type="number" step="0.01" name="salary" value="${emp.salary}" min="2000" max="100000" required>
                </div>
            </div>

            <div class="form-group">
                <label>所属部门</label>
                <select name="deptId">
                    <option value="">请选择部门</option>
                    <c:forEach items="${deptList}" var="d">
                        <option value="${d.id}" ${emp.deptId == d.id ? 'selected' : ''}>${d.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-submit">保存修改</button>
                <a href="${pageContext.request.contextPath}/emp?method=list" class="btn-cancel">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>