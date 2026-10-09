<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>部门管理</title>
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
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
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
            position: relative;
        }

        .nav-links a:hover {
            color: #3b82f6;
        }

        .nav-links a.active {
            color: #3b82f6;
        }

        .nav-links a.active::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            right: 0;
            height: 2px;
            background: #3b82f6;
            border-radius: 2px;
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #0f172a;
        }

        .page-header p {
            font-size: 15px;
            color: #64748b;
            margin-top: 8px;
        }

        .btn-add {
            padding: 12px 28px;
            background: #3b82f6;
            color: #fff;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            border-radius: 10px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add:hover {
            background: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(59,130,246,0.35);
        }

        .table-container {
            background: #fff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 18px 20px;
            background: #f8fafc;
            font-weight: 600;
            font-size: 14px;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #fafcff;
        }

        .action-links {
            display: flex;
            gap: 20px;
        }

        .action-links a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.2s;
        }

        .action-links a:hover {
            color: #3b82f6;
        }

        .action-links a.delete:hover {
            color: #ef4444;
        }

        .empty-row td {
            text-align: center;
            color: #94a3b8;
            padding: 64px;
        }

        .error-msg {
            margin-top: 20px;
            padding: 16px;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 12px;
            color: #dc2626;
            font-size: 14px;
            text-align: center;
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
            .table-container {
                overflow-x: auto;
            }
            .navbar {
                padding: 0 20px;
            }
            .nav-links {
                gap: 28px;
            }
            .nav-links a {
                font-size: 16px;
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
        <a href="${pageContext.request.contextPath}/dept?method=list" class="active">部门管理</a>
        <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
        <a href="${pageContext.request.contextPath}/stats.jsp"> 数据统计</a>
        <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
        <div style="display: flex; align-items: center; gap: 16px;">
            <span class="user-info"> ${sessionScope.user.username}</span>
            <a href="${pageContext.request.contextPath}/logout" style="color: #94a3b8; text-decoration: none; font-size: 14px;"> 退出</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <h1>部门管理</h1>
            <p>管理企业部门信息 </p>
        </div>
        <a href="${pageContext.request.contextPath}/dept/add.jsp" class="btn-add">+ 新建部门</a>
    </div>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>部门名称</th>
                <th>主管人</th>
                <th>联系方式</th>
                <th style="width: 150px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="d">
                <tr>
                    <td>${d.id}</td>
                    <td><strong>${d.name}</strong></td>
                    <td>${d.manager != null ? d.manager : '-'}</td>
                    <td>${d.phone != null ? d.phone : '-'}</td>
                    <td class="action-links">
                        <a href="${pageContext.request.contextPath}/dept?method=edit&id=${d.id}">编辑</a>
                        <a href="javascript:void(0)" onclick="delDept(${d.id})" class="delete">删除</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr class="empty-row">
                    <td colspan="5">暂无部门数据</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${not empty msg}">
        <div class="error-msg">
            ⚠️ ${msg}
        </div>
    </c:if>

    <div class="footer">
        <p>共 ${list.size()} 个部门</p>
    </div>
</div>

<script>
    function delDept(id) {
        if (confirm('确定要删除该部门吗？删除后无法恢复。')) {
            window.location.href = "${pageContext.request.contextPath}/dept?method=delete&id=" + id;
        }
    }
</script>
</body>
</html>