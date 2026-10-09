<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>管理者管理</title>
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
      border-bottom: 2px solid #3b82f6;
    }

    .user-info {
      font-size: 14px;
      color: #94a3b8;
      background: #f1f5f9;
      padding: 8px 18px;
      border-radius: 30px;
    }

    .container {
      max-width: 1000px;
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
      font-size: 14px;
      color: #64748b;
      margin-top: 8px;
    }

    .btn-add {
      padding: 10px 24px;
      background: #1e293b;
      color: #fff;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      border-radius: 8px;
      transition: all 0.2s;
    }

    .btn-add:hover {
      background: #0f172a;
    }

    .btn-add-disabled {
      padding: 10px 24px;
      background: #cbd5e1;
      color: #94a3b8;
      font-size: 14px;
      font-weight: 500;
      border-radius: 8px;
      cursor: not-allowed;
    }

    .table-container {
      background: #fff;
      border-radius: 16px;
      border: 1px solid #e2e8f0;
      overflow: hidden;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th {
      text-align: left;
      padding: 14px 20px;
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

    .role-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
    }

    .role-admin {
      background: #fef3c7;
      color: #d97706;
    }

    .role-user {
      background: #e0e7ff;
      color: #4f46e5;
    }

    .action-links a {
      color: #94a3b8;
      text-decoration: none;
      margin-right: 16px;
      font-size: 13px;
    }

    .action-links a:hover {
      color: #3b82f6;
    }

    .action-links a.delete:hover {
      color: #ef4444;
    }

    .action-links span.disabled {
      color: #cbd5e1;
      margin-right: 16px;
      font-size: 13px;
    }

    .empty-row td {
      text-align: center;
      padding: 48px;
      color: #94a3b8;
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

    .footer {
      margin-top: 48px;
      padding-top: 24px;
      border-top: 1px solid #e2e8f0;
      text-align: center;
      font-size: 13px;
      color: #94a3b8;
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
    <a href="${pageContext.request.contextPath}/user-manager?method=list" class="active"> 管理者管理</a>
    <a href="${pageContext.request.contextPath}/stats">数据统计</a>
    <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
  </div>
  <div style="display: flex; align-items: center; gap: 16px;">
    <span class="user-info"> ${sessionScope.user.username}</span>
    <a href="${pageContext.request.contextPath}/logout" style="color: #94a3b8; text-decoration: none; font-size: 14px;"> 退出</a>
  </div>
</div>

<div class="container">
  <div class="page-header">
    <div>
      <h1> 管理者管理</h1>
      <p>管理系统登录账号 · 支持增删改查</p>
    </div>
    <!-- 根据权限显示添加按钮 -->
    <c:choose>
      <c:when test="${sessionScope.user.role == 'admin'}">
        <a href="${pageContext.request.contextPath}/user-manager?method=add" class="btn-add">+ 添加管理者</a>
      </c:when>
      <c:otherwise>
        <span class="btn-add-disabled">+ 添加管理者 (仅管理员)</span>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- 错误提示 -->
  <c:if test="${not empty errorMsg}">
    <div class="error-msg">
      ⚠️ ${errorMsg}
    </div>
  </c:if>

  <div class="table-container">
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>用户名</th>
        <th>密码</th>
        <th>角色</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${userList}" var="u">
        <tr>
          <td>${u.id}</td>
          <td><strong>${u.username}</strong></td>
          <td>••••••</td>
          <td>
                        <span class="role-badge ${u.role == 'admin' ? 'role-admin' : 'role-user'}">
                            ${u.role == 'admin' ? '管理员' : '普通用户'}
                        </span>
          </td>
          <td class="action-links">
            <!-- 根据权限显示操作按钮 -->
            <c:choose>
              <c:when test="${sessionScope.user.role == 'admin'}">
                <a href="${pageContext.request.contextPath}/user-manager?method=edit&id=${u.id}">编辑</a>
                <c:if test="${sessionScope.user.id != u.id}">
                  <a href="javascript:void(0)" onclick="deleteUser(${u.id})" class="delete">删除</a>
                </c:if>
                <c:if test="${sessionScope.user.id == u.id}">
                  <span class="disabled">不能删除自己</span>
                </c:if>
              </c:when>
              <c:otherwise>
                <span class="disabled">无权操作</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty userList}">
        <tr class="empty-row">
          <td colspan="5">暂无管理者数据，点击上方按钮添加</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <div class="footer">
    <p>管理者管理 · 只有管理员可以添加/删除账号</p>
  </div>
</div>

<script>
  function deleteUser(id) {
    if (confirm('确定要删除该管理者账号吗？删除后将无法登录系统。')) {
      window.location.href = '${pageContext.request.contextPath}/user-manager?method=delete&id=' + id;
    }
  }
</script>
</body>
</html>