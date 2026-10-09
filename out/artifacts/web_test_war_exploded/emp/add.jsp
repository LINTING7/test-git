<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>新增员工</title>
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
            max-width: 600px;
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

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
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
    <div class="logo">企业管理系统<span> · 新增员工</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
        <a href="${pageContext.request.contextPath}/emp?method=list">员工列表</a>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <div class="form-title">新增员工</div>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg"> ${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/emp?method=addSubmit" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label>姓名 *</label>
                <input type="text" name="name" id="name" placeholder="请输入姓名" required>
                <div class="hint-text">️ 同一部门下不能有同名员工</div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>年龄 *</label>
                    <input type="number" name="age" id="age" placeholder="年龄" min="18" max="60" step="1" required>
                    <div class="hint-text">年龄需在 18~60 岁之间</div>
                </div>
                <div class="form-group">
                    <label>薪资 *</label>
                    <input type="number" name="salary" id="salary" placeholder="薪资" min="2000" max="100000" step="100" required>
                    <div class="hint-text">月薪需在 2000~100000 元之间</div>
                </div>
            </div>

            <div class="form-group">
                <label>所属部门 *</label>
                <select name="deptId" id="deptId" required>
                    <option value="">请选择部门</option>
                    <c:forEach items="${deptList}" var="d">
                        <option value="${d.id}">${d.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-submit">保存</button>
                <a href="${pageContext.request.contextPath}/emp?method=list" class="btn-cancel">取消</a>
            </div>
        </form>
    </div>
</div>

<script>
    function validateForm() {
        var name = document.getElementById('name').value.trim();
        var age = document.getElementById('age').value;
        var salary = document.getElementById('salary').value;
        var deptId = document.getElementById('deptId').value;

        if (name === '') {
            alert('请输入姓名');
            return false;
        }

        if (deptId === '') {
            alert('请选择部门');
            return false;
        }

        if (age === '' || isNaN(age)) {
            alert('请输入有效的年龄');
            return false;
        }

        var ageNum = parseInt(age);
        if (ageNum <= 0) {
            alert('年龄必须大于0');
            return false;
        }
        if (ageNum > 60) {
            alert('年龄不能超过60岁');
            return false;
        }

        if (salary === '' || isNaN(salary)) {
            alert('请输入有效的薪资');
            return false;
        }

        var salaryNum = parseFloat(salary);
        if (salaryNum < 0) {
            alert('薪资不能为负数');
            return false;
        }
        if (salaryNum > 100000) {
            alert('薪资不能超过10万元');
            return false;
        }

        return true;
    }
</script>
</body>
</html>