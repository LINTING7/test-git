<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.EmpDao, dao.AddressDao, entity.Emp, entity.Address, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
  EmpDao empDao = new EmpDao();
  AddressDao addressDao = new AddressDao();

  // 获取分页参数
  int pageNo = 1;
  int pageSize = 5; // 每页显示5个员工

  String pageNoStr = request.getParameter("pageNo");
  if (pageNoStr != null && !pageNoStr.trim().isEmpty()) {
    try {
      pageNo = Integer.parseInt(pageNoStr);
      if (pageNo < 1) pageNo = 1;
    } catch (NumberFormatException e) {
      pageNo = 1;
    }
  }

  // 获取总记录数和总页数
  int totalCount = empDao.getTotalCount();
  int totalPages = (int) Math.ceil((double) totalCount / pageSize);

  // 分页查询员工
  List<Emp> empList = empDao.findByPage(pageNo, pageSize);

  // 为每个员工获取地址（每人只有一个）
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
  <title>家庭住址管理</title>
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

    .page-header p {
      font-size: 15px;
      color: #64748b;
      margin-top: 8px;
    }

    /* 统计卡片 */
    .stats-grid {
      display: flex;
      gap: 24px;
      margin-bottom: 32px;
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

    /* 员工列表表格样式 */
    .emp-table {
      background: #fff;
      border-radius: 16px;
      border: 1px solid #e2e8f0;
      overflow: hidden;
      width: 100%;
    }

    .emp-table table {
      width: 100%;
      border-collapse: collapse;
    }

    .emp-table th {
      text-align: left;
      padding: 16px 20px;
      background: #f8fafc;
      font-weight: 600;
      font-size: 14px;
      color: #475569;
      border-bottom: 1px solid #e2e8f0;
    }

    .emp-table td {
      padding: 16px 20px;
      font-size: 14px;
      color: #334155;
      border-bottom: 1px solid #f1f5f9;
      vertical-align: top;
    }

    .emp-table tr:last-child td {
      border-bottom: none;
    }

    .emp-table tr:hover td {
      background-color: #fafcff;
    }

    .dept-badge {
      display: inline-block;
      padding: 4px 12px;
      background: #f1f5f9;
      border-radius: 20px;
      font-size: 12px;
    }

    .address-list {
      margin: 0;
      padding: 0;
      list-style: none;
    }

    .address-item {
      padding: 8px 0;
      border-bottom: 1px dashed #e2e8f0;
      font-size: 13px;
    }

    .address-item:last-child {
      border-bottom: none;
    }

    .default-address {
      background: #f0fdf4;
      padding: 8px 12px;
      border-radius: 8px;
      margin-bottom: 8px;
    }

    .default-badge {
      display: inline-block;
      background: #22c55e;
      color: white;
      font-size: 10px;
      padding: 2px 6px;
      border-radius: 10px;
      margin-left: 8px;
    }

    .address-actions {
      margin-top: 6px;
    }

    .address-actions a {
      color: #94a3b8;
      text-decoration: none;
      font-size: 12px;
      margin-right: 12px;
    }

    .address-actions a:hover {
      color: #3b82f6;
    }

    .add-address-link {
      display: inline-block;
      margin-top: 8px;
      color: #3b82f6;
      text-decoration: none;
      font-size: 12px;
    }

    .add-address-link:hover {
      text-decoration: underline;
    }

    .empty-address {
      color: #cbd5e1;
      font-style: italic;
      font-size: 13px;
    }

    .action-links a {
      color: #94a3b8;
      text-decoration: none;
      font-size: 13px;
      margin-right: 12px;
    }

    .action-links a:hover {
      color: #3b82f6;
    }

    /* 分页组件样式 */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-top: 32px;
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

    .footer {
      margin-top: 48px;
      padding-top: 24px;
      border-top: 1px solid #e2e8f0;
      text-align: center;
      font-size: 13px;
      color: #94a3b8;
    }

    @media (max-width: 900px) {
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
      .stats-grid {
        flex-direction: column;
        gap: 16px;
      }
      .emp-table {
        overflow-x: auto;
        display: block;
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
  <div class="logo">企业管理系统<span> · 极简版</span></div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp"> 员工管理</a>
    <a href="${pageContext.request.contextPath}/address/manager.jsp" class="active"> 家庭住址管理</a>
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

<div class="container">
  <div class="page-header">
    <h1> 家庭住址管理</h1>
    <p>查看所有员工的家庭住址信息</p>
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
          long hasAddressCount = 0;
          for (Emp emp : empList) {
            Address addr = empAddressMap.get(emp.getId());
            if (addr != null) {
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
        <% out.print(empList.size() - hasAddressCount); %>
      </div>
      <div class="stat-label">当前页待完善住址</div>
    </div>
  </div>

  <div class="emp-table">
    <table>
      <thead>
      <tr>
        <th>员工</th>
        <th>部门</th>
        <th>家庭住址</th>
        <th style="width: 100px;">操作</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${empList}" var="emp">
        <%
          Emp empItem = (Emp) pageContext.getAttribute("emp");
          Map<Integer, Address> addressMap = (Map<Integer, Address>) request.getAttribute("empAddressMap");
          Address addr = addressMap != null ? addressMap.get(empItem.getId()) : null;
          pageContext.setAttribute("addr", addr);
        %>
        <tr>
          <td style="font-weight: 500;">${emp.name}</td>
          <td><span class="dept-badge">${emp.deptName != null ? emp.deptName : '未分配'}</span></td>
          <td>
            <c:choose>
              <c:when test="${not empty addr}">
                  ${addr.province != null ? addr.province : ''}
                  ${addr.city != null ? addr.city : ''}
                  ${addr.district != null ? addr.district : ''}
                  ${addr.detail != null ? addr.detail : ''}
                <div class="address-actions">
                  <a href="${pageContext.request.contextPath}/address?method=editPage&id=${addr.id}&empId=${emp.id}">编辑</a>
                </div>
              </c:when>
              <c:otherwise>
                <span class="empty-address">暂无家庭住址信息</span>
              </c:otherwise>
            </c:choose>
          </td>
          <td class="action-links">
            <a href="${pageContext.request.contextPath}/address?method=list&empId=${emp.id}">管理住址</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty empList}">
        <tr class="empty-row">
          <td colspan="4" style="text-align: center; padding: 60px; color: #94a3b8;">
            暂无员工数据
            <br>
            <a href="${pageContext.request.contextPath}/emp?method=add" style="color: #3b82f6; margin-top: 10px; display: inline-block;">点击添加员工</a>
          </td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- 分页组件 -->
  <div class="pagination">
    <%
      int currentPage = (Integer) request.getAttribute("currentPage");
      int totalPagesVal = (Integer) request.getAttribute("totalPages");

      // 上一页
      if (currentPage > 1) {
    %>
    <a href="${pageContext.request.contextPath}/address/manager.jsp?pageNo=<%=currentPage-1%>">上一页</a>
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
    <a href="${pageContext.request.contextPath}/address/manager.jsp?pageNo=1">1</a>
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
    <a href="${pageContext.request.contextPath}/address/manager.jsp?pageNo=<%= i %>"><%= i %></a>
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
    <a href="${pageContext.request.contextPath}/address/manager.jsp?pageNo=<%= totalPagesVal %>"><%= totalPagesVal %></a>
    <%
      }

      // 下一页
      if (currentPage < totalPagesVal) {
    %>
    <a href="${pageContext.request.contextPath}/address/manager.jsp?pageNo=<%=currentPage+1%>">下一页</a>
    <%
    } else if (totalPagesVal > 0) {
    %>
    <span class="disabled">下一页</span>
    <%
      }
    %>
    <span class="page-info">第 ${currentPage} / ${totalPages} 页，共 ${totalCount} 条记录，每页 ${pageSize} 条</span>
  </div>

  <div class="footer">
    <p>家庭住址管理 </p>
  </div>
</div>
</body>
</html>