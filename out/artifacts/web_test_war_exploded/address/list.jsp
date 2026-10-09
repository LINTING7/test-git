<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<html>
<head>
  <title>家庭住址 · ${emp.name}</title>
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
      max-width: 800px;
      margin: 0 auto;
      padding: 40px;
    }

    .back-link {
      display: inline-block;
      margin-bottom: 24px;
      color: #888;
      text-decoration: none;
      font-size: 13px;
    }

    .back-link:hover {
      color: #111;
    }

    .emp-card {
      background: #fff;
      border: 1px solid #eaeaea;
      padding: 20px 28px;
      margin-bottom: 32px;
    }

    .emp-name {
      font-size: 20px;
      font-weight: 500;
      color: #111;
    }

    .emp-meta {
      font-size: 13px;
      color: #888;
      margin-top: 6px;
    }

    .address-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 12px;
      border-bottom: 1px solid #eaeaea;
    }

    .address-header h2 {
      font-size: 16px;
      font-weight: 500;
      color: #333;
    }

    .btn-add {
      padding: 6px 18px;
      background: #111;
      color: #fff;
      text-decoration: none;
      font-size: 12px;
      transition: opacity 0.2s;
    }

    .btn-add:hover {
      opacity: 0.8;
    }

    .address-item {
      background: #fff;
      border: 1px solid #eaeaea;
      padding: 20px 28px;
      margin-bottom: 16px;
    }

    .address-header-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 14px;
      padding-bottom: 10px;
      border-bottom: 1px solid #f0f0f0;
    }

    .address-date {
      font-size: 12px;
      color: #bbb;
    }

    .default-badge {
      font-size: 11px;
      color: #888;
    }

    .address-text {
      font-size: 14px;
      color: #444;
      line-height: 1.6;
    }

    .address-actions {
      margin-top: 16px;
    }

    .address-actions a {
      color: #888;
      text-decoration: none;
      margin-right: 20px;
      font-size: 12px;
    }

    .address-actions a:hover {
      color: #111;
    }

    .empty-state {
      text-align: center;
      padding: 48px;
      background: #fff;
      border: 1px solid #eaeaea;
      color: #bbb;
    }

    .footer {
      margin-top: 48px;
      padding-top: 24px;
      border-top: 1px solid #eaeaea;
      text-align: center;
      font-size: 12px;
      color: #bbb;
    }
  </style>
</head>
<body>

<div class="navbar">
  <div class="logo">企业管理系统<span> · 住址</span></div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
    <a href="${pageContext.request.contextPath}/emp?method=list">员工</a>
    <a href="${pageContext.request.contextPath}/address/manager.jsp"> 家庭住址管理</a>
    <a href="${pageContext.request.contextPath}/dept?method=list"> 部门管理</a>
    <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
    <a href="${pageContext.request.contextPath}/stats">数据统计</a>
    <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
  </div>
</div>

<div class="container">
  <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">← 返回首页</a>

  <div class="emp-card">
    <div class="emp-name">${emp.name}</div>
    <div class="emp-meta">${emp.deptName != null ? emp.deptName : '未分配部门'} · 年龄 ${emp.age} · 薪资 ¥${emp.salary}</div>
  </div>

  <div class="address-header">
    <h2>家庭住址</h2>
    <c:if test="${empty addressList}">
      <a href="${pageContext.request.contextPath}/address?method=addPage&empId=${emp.id}" class="btn-add">+ 添加地址</a>
    </c:if>
  </div>

  <c:forEach items="${addressList}" var="addr">
    <div class="address-item">
      <div class="address-header-item">
        <span class="address-date">${addr.createTime}</span>
      </div>
      <div class="address-text">
        <c:if test="${not empty addr.province}">${addr.province} </c:if>
        <c:if test="${not empty addr.city}">${addr.city} </c:if>
        <c:if test="${not empty addr.district}">${addr.district}</c:if>
        <c:if test="${not empty addr.street}"><br>${addr.street}</c:if>
        <c:if test="${not empty addr.detail}"> ${addr.detail}</c:if>
        <c:if test="${not empty addr.postalCode}"><br>邮编：${addr.postalCode}</c:if>
      </div>
      <div class="address-actions">
        <a href="${pageContext.request.contextPath}/address?method=editPage&id=${addr.id}&empId=${emp.id}">编辑</a>
        <a href="javascript:void(0)" onclick="deleteAddress(${addr.id})">删除</a>
      </div>
    </div>
  </c:forEach>

  <c:if test="${empty addressList}">
    <div class="empty-state">
      <p>暂无家庭住址信息</p>
      <p style="margin-top: 12px; font-size: 13px;">点击上方按钮添加住址</p>
    </div>
  </c:if>

  <div class="footer">
    <p>家庭住址管理 · 简约设计</p>
  </div>
</div>

<script>
  function deleteAddress(id) {
    if (confirm('确定删除这个地址吗？')) {
      window.location.href = '${pageContext.request.contextPath}/address?method=delete&id=' + id + '&empId=${emp.id}';
    }
  }
</script>
</body>
</html>