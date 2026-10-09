<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>编辑家庭住址</title>
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
      max-width: 700px;
      margin: 60px auto;
      padding: 0 20px;
    }

    .emp-card {
      background: #fff;
      border: 1px solid #eaeaea;
      padding: 20px 28px;
      margin-bottom: 28px;
    }

    .emp-name {
      font-size: 18px;
      font-weight: 500;
      color: #111;
    }

    .emp-meta {
      font-size: 13px;
      color: #888;
      margin-top: 6px;
    }

    .form-card {
      background: #fff;
      border: 1px solid #eaeaea;
      padding: 32px;
    }

    .form-title {
      font-size: 18px;
      font-weight: 400;
      color: #111;
      margin-bottom: 28px;
      padding-bottom: 16px;
      border-bottom: 1px solid #eaeaea;
    }

    .form-group {
      margin-bottom: 22px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-size: 13px;
      color: #666;
    }

    .form-group input {
      width: 100%;
      height: 44px;
      padding: 0 12px;
      border: 1px solid #ddd;
      font-size: 14px;
      font-family: inherit;
      background: #fff;
      transition: border-color 0.2s;
    }

    .form-group input:focus {
      outline: none;
      border-color: #999;
    }

    .form-row {
      display: flex;
      gap: 16px;
    }

    .form-row .form-group {
      flex: 1;
    }

    .checkbox-group {
      display: flex;
      align-items: center;
      margin: 20px 0 28px;
    }

    .checkbox-group input {
      width: 18px;
      height: 18px;
      margin-right: 10px;
      cursor: pointer;
    }

    .checkbox-group label {
      margin-bottom: 0;
      cursor: pointer;
      color: #666;
      font-size: 13px;
    }

    .btn-group {
      display: flex;
      gap: 16px;
      margin-top: 8px;
    }

    .btn-submit {
      padding: 10px 28px;
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
      padding: 10px 28px;
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

    .delete-link {
      margin-top: 24px;
      padding-top: 20px;
      border-top: 1px solid #f0f0f0;
      text-align: right;
    }

    .delete-link a {
      color: #bbb;
      text-decoration: none;
      font-size: 12px;
    }

    .delete-link a:hover {
      color: #999;
    }

    .error-msg {
      background: #fef2f2;
      border: 1px solid #fecaca;
      border-radius: 8px;
      padding: 12px 16px;
      margin-bottom: 20px;
      font-size: 14px;
      color: #dc2626;
    }
  </style>
</head>
<body>

<div class="navbar">
  <div class="logo">企业管理系统<span> · 编辑住址</span></div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
    <a href="${pageContext.request.contextPath}/emp?method=list">员工</a>
    <a href="${pageContext.request.contextPath}/address?method=list&empId=${empId}">返回住址</a>
  </div>
</div>

<div class="container">
  <div class="form-card">
    <div class="form-title">编辑家庭住址</div>

    <c:if test="${not empty errorMsg}">
      <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/address?method=update" method="post">
      <input type="hidden" name="id" value="${address.id}">
      <input type="hidden" name="empId" value="${empId}">

      <div class="form-row">
        <div class="form-group">
          <label>省份 <span style="color:red;">*</span></label>
          <input type="text" name="province" value="${address.province}" required pattern=".*[^\d].*" title="不能为纯数字" autocomplete="off">
        </div>
        <div class="form-group">
          <label>城市 <span style="color:red;">*</span></label>
          <input type="text" name="city" value="${address.city}" required pattern=".*[^\d].*" title="不能为纯数字" autocomplete="off">
        </div>
        <div class="form-group">
          <label>区/县 <span style="color:red;">*</span></label>
          <input type="text" name="district" value="${address.district}" required pattern=".*[^\d].*" title="不能为纯数字" autocomplete="off">
        </div>
      </div>

      <div class="form-group">
        <label>街道 <span style="color:red;">*</span></label>
        <input type="text" name="street" value="${address.street}" required pattern=".*[^\d].*" title="不能为纯数字" autocomplete="off">
      </div>

      <div class="form-group">
        <label>详细地址 <span style="color:red;">*</span></label>
        <input type="text" name="detail" value="${address.detail}" required pattern=".*[^\d].*" title="不能为纯数字" autocomplete="off">
      </div>

      <div class="form-group">
        <label>邮政编码</label>
        <input type="text" name="postalCode" value="${address.postalCode}" maxlength="6" pattern="\d{6}" title="请输入6位数字邮政编码" autocomplete="off">
      </div>

      <div class="btn-group">
        <button type="submit" class="btn-submit">保存修改</button>
        <a href="${pageContext.request.contextPath}/address?method=list&empId=${empId}" class="btn-cancel">取消</a>
      </div>
    </form>

    <div class="delete-link">
      <a href="javascript:void(0)" onclick="deleteAddress(${address.id})">删除此地址</a>
    </div>
  </div>
</div>

<script>
  function deleteAddress(id) {
    if (confirm('确定要删除这个家庭住址吗？')) {
      window.location.href = '${pageContext.request.contextPath}/address?method=delete&id=' + id + '&empId=${empId}';
    }
  }
</script>
</body>
</html>