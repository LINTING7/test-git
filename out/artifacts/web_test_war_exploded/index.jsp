<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.EmpDao, dao.AddressDao, entity.Emp, entity.Address, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  // 获取分页参数
  int pageNo = 1;
  int pageSize = 6; // 每页显示6个卡片

  String pageNoStr = request.getParameter("pageNo");
  if (pageNoStr != null && !pageNoStr.trim().isEmpty()) {
    try {
      pageNo = Integer.parseInt(pageNoStr);
      if (pageNo < 1) pageNo = 1;
    } catch (NumberFormatException e) {
      pageNo = 1;
    }
  }

  EmpDao empDao = new EmpDao();
  AddressDao addressDao = new AddressDao();

  // 获取总记录数和总页数
  int totalCount = empDao.getTotalCount();
  int totalPages = (int) Math.ceil((double) totalCount / pageSize);

  // 分页查询员工
  List<Emp> empList = empDao.findByPage(pageNo, pageSize);

  // 构建 empId -> Address 的映射
  Map<Integer, Address> empAddressMap = new HashMap<>();
  for (Emp emp : empList) {
    List<Address> addresses = addressDao.findByEmpId(emp.getId());
    if (!addresses.isEmpty()) {
      empAddressMap.put(emp.getId(), addresses.get(0));
    }
  }

  request.setAttribute("empList", empList);
  request.setAttribute("empAddressMap", empAddressMap);
  request.setAttribute("totalCount", totalCount);
  request.setAttribute("totalPages", totalPages);
  request.setAttribute("currentPage", pageNo);
  request.setAttribute("pageSize", pageSize);
%>
<html>
<head>
  <title>企业管理系统 · 员工管理</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
      background-color: #f5f7fa;
      color: #1a1a1a;
      line-height: 1.5;
    }

    /* 顶部导航 - 大号菜单 */
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
      letter-spacing: 0.3px;
      color: #1e293b;
    }

    .logo span {
      font-weight: 400;
      color: #94a3b8;
    }

    /* 导航菜单 - 放大字体 */
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
      transition: all 0.2s;
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

    /* 主容器 */
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 32px 48px;
    }

    /* 页面头部 */
    .page-header {
      margin-bottom: 32px;
      padding-bottom: 16px;
      border-bottom: 1px solid #e2e8f0;
    }

    .page-header h1 {
      font-size: 28px;
      font-weight: 600;
      color: #0f172a;
      letter-spacing: -0.3px;
    }

    .page-header p {
      font-size: 15px;
      color: #64748b;
      margin-top: 8px;
    }

    /* 统计卡片 */
    .stats-grid {
      display: flex;
      gap: 24px;
      margin-bottom: 36px;
    }

    .stat-card {
      background: #fff;
      border-radius: 20px;
      padding: 24px 28px;
      flex: 1;
      border: 1px solid #e2e8f0;
      transition: all 0.2s;
    }

    .stat-card:hover {
      border-color: #cbd5e1;
      box-shadow: 0 6px 16px rgba(0,0,0,0.05);
      transform: translateY(-2px);
    }

    .stat-number {
      font-size: 36px;
      font-weight: 700;
      color: #0f172a;
    }

    .stat-label {
      font-size: 14px;
      color: #64748b;
      margin-top: 8px;
    }

    /* 员工卡片网格 */
    .employee-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
      gap: 24px;
    }

    /* 卡片样式 */
    .employee-card {
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
      border: 1px solid #e2e8f0;
      transition: all 0.25s ease;
      overflow: hidden;
    }

    .employee-card:hover {
      border-color: #cbd5e1;
      box-shadow: 0 8px 20px rgba(0,0,0,0.06);
      transform: translateY(-2px);
    }

    /* 卡片头部 */
    .card-header {
      padding: 20px 24px 12px 24px;
      border-bottom: 1px solid #f1f5f9;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      background: #fafcff;
    }

    .employee-name {
      font-size: 18px;
      font-weight: 600;
      color: #0f172a;
    }

    .employee-dept {
      font-size: 12px;
      color: #64748b;
      margin-top: 4px;
    }

    .employee-id {
      font-size: 12px;
      color: #94a3b8;
      font-family: monospace;
      background: #f1f5f9;
      padding: 4px 8px;
      border-radius: 20px;
    }

    /* 员工详情 */
    .card-details {
      padding: 16px 24px;
      background: #ffffff;
      border-bottom: 1px solid #f1f5f9;
      display: flex;
      gap: 24px;
    }

    .detail-item {
      display: flex;
      align-items: baseline;
      gap: 6px;
      font-size: 13px;
    }

    .detail-label {
      color: #94a3b8;
    }

    .detail-value {
      color: #334155;
      font-weight: 500;
    }

    /* 住址区域 */
    .address-section {
      padding: 16px 24px;
      background: #ffffff;
      border-bottom: 1px solid #f1f5f9;
    }

    .address-label {
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #94a3b8;
      margin-bottom: 10px;
    }

    .address-content {
      font-size: 13px;
      color: #475569;
      line-height: 1.6;
    }

    .address-empty {
      font-size: 13px;
      color: #cbd5e1;
      font-style: italic;
    }

    .address-full {
      color: #334155;
    }

    .default-badge {
      display: inline-block;
      background: #e6f7e6;
      color: #2e7d32;
      font-size: 10px;
      padding: 2px 8px;
      border-radius: 16px;
      margin-left: 8px;
    }

    /* 操作按钮 */
    .card-actions {
      padding: 16px 24px;
      display: flex;
      gap: 24px;
      background: #fafcff;
    }

    .btn {
      font-size: 13px;
      text-decoration: none;
      padding: 6px 0;
      transition: all 0.2s;
      background: none;
      border: none;
      cursor: pointer;
    }

    .btn-primary {
      color: #475569;
      border-bottom: 1px solid #e2e8f0;
    }

    .btn-primary:hover {
      color: #3b82f6;
      border-bottom-color: #3b82f6;
    }

    .btn-address {
      color: #475569;
      border-bottom: 1px solid #e2e8f0;
    }

    .btn-address:hover {
      color: #3b82f6;
      border-bottom-color: #3b82f6;
    }

    .btn-danger {
      color: #94a3b8;
      border-bottom: 1px solid #e2e8f0;
    }

    .btn-danger:hover {
      color: #ef4444;
      border-bottom-color: #ef4444;
    }

    /* 分页组件样式 */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-top: 48px;
      padding: 20px 0;
    }

    .pagination a, .pagination span {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 40px;
      height: 40px;
      padding: 0 12px;
      border-radius: 10px;
      font-size: 14px;
      text-decoration: none;
      transition: all 0.2s;
    }

    .pagination a {
      color: #475569;
      background: #fff;
      border: 1px solid #e2e8f0;
    }

    .pagination a:hover {
      background: #f1f5f9;
      border-color: #cbd5e1;
      color: #3b82f6;
    }

    .pagination .current {
      background: #3b82f6;
      color: #fff;
      border: 1px solid #3b82f6;
    }

    .pagination .disabled {
      color: #cbd5e1;
      background: #fff;
      border: 1px solid #e2e8f0;
      cursor: not-allowed;
    }

    .pagination .page-info {
      color: #64748b;
      background: transparent;
      border: none;
      font-size: 13px;
    }

    /* 页脚 */
    .footer {
      margin-top: 60px;
      padding-top: 28px;
      border-top: 1px solid #e2e8f0;
      text-align: center;
      font-size: 13px;
      color: #94a3b8;
    }

    /* 响应式 */
    @media (max-width: 1024px) {
      .container {
        padding: 24px 20px;
      }
      .stats-grid {
        flex-direction: column;
        gap: 16px;
      }
      .employee-grid {
        grid-template-columns: 1fr;
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
      .pagination a, .pagination span {
        min-width: 34px;
        height: 34px;
        font-size: 12px;
      }
    }
  </style>
</head>
<body>

<div class="navbar">
  <div class="logo">企业管理系统<span></span></div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/emp/list.jsp" class="active"> 员工管理</a>
    <a href="${pageContext.request.contextPath}/address/manager.jsp"> 家庭住址管理</a>
    <a href="${pageContext.request.contextPath}/dept?method=list"> 部门管理</a>
    <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
    <a href="${pageContext.request.contextPath}/stats">数据统计</a>
    <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
    <div style="display: flex; align-items: center; gap: 16px;">
      <span class="user-info"> ${sessionScope.user.username}</span>
      <a href="${pageContext.request.contextPath}/logout" style="color: #94a3b8; text-decoration: none; font-size: 14px;"> 退出</a>
    </div>
  </div>
</div>

<!-- 主内容 -->
<div class="container">
  <div class="page-header">
    <h1>员工管理</h1>
    <p>管理企业员工信息</p>
  </div>

  <!-- 统计卡片 -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-number">${totalCount}</div>
      <div class="stat-label">总员工数</div>
    </div>
    <div class="stat-card">
      <div class="stat-number">
        <%
          // 计算已填写住址的员工数
          long hasAddressCount = 0;
          for (Emp emp : empList) {
            if (empAddressMap.containsKey(emp.getId())) {
              hasAddressCount++;
            }
          }
          out.print(hasAddressCount);
        %>
      </div>
      <div class="stat-label">当前页面已填写住址</div>
    </div>
    <div class="stat-card">
      <div class="stat-number">
        <%
          // 计算未填写住址的员工数（当前页）
          long missingCount = empList.size() - hasAddressCount;
          out.print(missingCount);
        %>
      </div>
      <div class="stat-label">当前页待完善住址</div>
    </div>
  </div>

  <!-- 员工卡片网格 -->
  <div class="employee-grid">
    <c:forEach items="${empList}" var="emp">
      <%
        Emp empItem = (Emp) pageContext.getAttribute("emp");
        Map<Integer, Address> addrMap = (Map<Integer, Address>) request.getAttribute("empAddressMap");
        Address addrItem = addrMap != null ? addrMap.get(empItem.getId()) : null;
        pageContext.setAttribute("addrItem", addrItem);
      %>
      <div class="employee-card">
        <div class="card-header">
          <div>
            <div class="employee-name">${emp.name}</div>
            <div class="employee-dept">${emp.deptName != null ? emp.deptName : '未分配部门'}</div>
          </div>
          <div class="employee-id">#${emp.id}</div>
        </div>

        <div class="card-details">
          <div class="detail-item">
            <span class="detail-label">年龄</span>
            <span class="detail-value">${emp.age}</span>
          </div>
          <div class="detail-item">
            <span class="detail-label">薪资</span>
            <span class="detail-value">¥${emp.salary}</span>
          </div>
        </div>

        <div class="address-section">
          <div class="address-label"> 家庭住址</div>
          <div class="address-content">
            <c:choose>
              <c:when test="${not empty addrItem}">
                                <span class="address-full">
                                    ${addrItem.province != null ? addrItem.province : ''}
                                    ${addrItem.city != null ? addrItem.city : ''}
                                    ${addrItem.district != null ? addrItem.district : ''}
                                    ${addrItem.street != null ? addrItem.street : ''}
                                    ${addrItem.detail != null ? addrItem.detail : ''}
                                </span>
              </c:when>
              <c:otherwise>
                <span class="address-empty">未填写家庭住址</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/emp?method=edit&id=${emp.id}" class="btn btn-primary">编辑</a>
          <a href="${pageContext.request.contextPath}/address?method=list&empId=${emp.id}" class="btn btn-address">住址管理</a>
          <a href="javascript:void(0)" onclick="deleteEmp(${emp.id})" class="btn btn-danger">删除</a>
        </div>
      </div>
    </c:forEach>
  </div>

  <!-- 分页组件 -->
  <div class="pagination">
    <%
      int currentPage = (Integer) request.getAttribute("currentPage");
      int totalPagesVal = (Integer) request.getAttribute("totalPages");
      String contextPath = request.getContextPath();

      // 上一页
      if (currentPage > 1) {
    %>
    <a href="${pageContext.request.contextPath}/index.jsp?pageNo=<%=currentPage-1%>">上一页</a>
    <%
    } else {
    %>
    <span class="disabled">上一页</span>
    <%
      }

      // 页码显示逻辑：显示当前页前后各2页
      int startPage = Math.max(1, currentPage - 2);
      int endPage = Math.min(totalPagesVal, currentPage + 2);

      // 第一页
      if (startPage > 1) {
    %>
    <a href="${pageContext.request.contextPath}/index.jsp?pageNo=1">1</a>
    <%
      if (startPage > 2) {
    %>
    <span class="disabled">...</span>
    <%
        }
      }

      // 中间页码
      for (int i = startPage; i <= endPage; i++) {
        if (i == currentPage) {
    %>
    <span class="current"><%= i %></span>
    <%
    } else {
    %>
    <a href="${pageContext.request.contextPath}/index.jsp?pageNo=<%= i %>"><%= i %></a>
    <%
        }
      }

      // 最后一页
      if (endPage < totalPagesVal) {
        if (endPage < totalPagesVal - 1) {
    %>
    <span class="disabled">...</span>
    <%
      }
    %>
    <a href="${pageContext.request.contextPath}/index.jsp?pageNo=<%= totalPagesVal %>"><%= totalPagesVal %></a>
    <%
      }

      // 下一页
      if (currentPage < totalPagesVal) {
    %>
    <a href="${pageContext.request.contextPath}/index.jsp?pageNo=<%=currentPage+1%>">下一页</a>
    <%
    } else if (totalPagesVal > 0) {
    %>
    <span class="disabled">下一页</span>
    <%
      }
    %>
    <span class="page-info">第 ${currentPage} / ${totalPages} 页，共 ${totalCount} 条记录</span>
  </div>

  <div class="footer">
    <p>企业管理系统 </p>
    <p style="margin-top: 8px; font-size: 12px; color: #cbd5e1;">
      当前在线人数: ${applicationScope.onlineCount != null ? applicationScope.onlineCount : 0} 人
      &nbsp;&nbsp;|&nbsp;&nbsp;
      系统版本: ${applicationScope.appVersion}
      &nbsp;&nbsp;|&nbsp;&nbsp;
      启动时间: ${applicationScope.appStartTime}
    </p>
  </div>
</div>

<script>
  function deleteEmp(id) {
    if (confirm('确定要删除该员工吗？删除后无法恢复，该员工的家庭住址也会一并删除。')) {
      window.location.href = '${pageContext.request.contextPath}/emp?method=delete&id=' + id;
    }
  }
</script>
</body>
</html>