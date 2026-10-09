<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.EmpDao, dao.AddressDao, entity.Emp, entity.Address, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // ===== 重要：从request获取分页数据，不要重新查询！ =====
    List<Emp> empList = (List<Emp>) request.getAttribute("list");

    // 如果 empList 为 null（比如直接访问JSP页面），则重定向到Servlet
    if (empList == null) {
        response.sendRedirect(request.getContextPath() + "/emp?method=list");
        return;
    }

    AddressDao addressDao = new AddressDao();

    // 构建 empId -> 默认地址的映射
    Map<Integer, Address> empAddressMap = new HashMap<>();
    for (Emp emp : empList) {
        List<Address> addresses = addressDao.findByEmpId(emp.getId());
        if (!addresses.isEmpty()) {
            empAddressMap.put(emp.getId(), addresses.get(0));
        }
    }

    request.setAttribute("empList", empList);
    request.setAttribute("empAddressMap", empAddressMap);
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

        /* 顶部导航 */
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

        /* 导航菜单 */
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
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

        /* 员工表格 */
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
            padding: 18px 24px;
            background: #f8fafc;
            font-weight: 600;
            font-size: 14px;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 18px 24px;
            font-size: 15px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #fafcff;
        }

        .dept-badge {
            display: inline-block;
            padding: 5px 12px;
            background: #f1f5f9;
            border-radius: 30px;
            font-size: 13px;
            color: #475569;
        }

        .address-preview {
            max-width: 300px;
            font-size: 14px;
            color: #64748b;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .address-empty {
            color: #cbd5e1;
            font-style: italic;
            font-size: 13px;
        }

        .default-badge {
            font-size: 11px;
            background: #e6f7e6;
            color: #2e7d32;
            padding: 3px 8px;
            border-radius: 16px;
            margin-left: 10px;
        }

        .action-links {
            display: flex;
            gap: 20px;
        }

        .action-links a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 14px;
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

        /* ===== 分页组件样式 ===== */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 24px 20px;
            background: #fafcff;
            border-top: 1px solid #e2e8f0;
            flex-wrap: wrap;
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
            min-width: auto;
            margin-left: 8px;
        }

        .pagination .page-size-select {
            margin-left: 16px;
            padding: 6px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 13px;
            background: #fff;
            color: #475569;
            cursor: pointer;
        }

        .pagination .page-size-select:focus {
            outline: none;
            border-color: #3b82f6;
        }

        /* 页脚 */
        .footer {
            margin-top: 56px;
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
            .pagination a, .pagination span {
                min-width: 34px;
                height: 34px;
                font-size: 12px;
            }
            .pagination .page-info {
                font-size: 11px;
            }
        }

        @media (max-width: 640px) {
            .pagination {
                gap: 4px;
            }
            .pagination .page-info {
                width: 100%;
                text-align: center;
                margin-top: 8px;
            }
            .pagination .page-size-select {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<!-- 顶部导航 -->
<div class="navbar">
    <div class="logo">企业管理系统<span></span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp" class="active"> 员工管理</a>
        <a href="${pageContext.request.contextPath}/address/manager.jsp"> 家庭住址管理</a>
        <a href="${pageContext.request.contextPath}/dept?method=list"> 部门管理</a>
        <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
        <a href="${pageContext.request.contextPath}/stats.jsp"> 数据统计</a>
        <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
    </div>
    <div style="display: flex; align-items: center; gap: 16px;">
        <span class="user-info"> ${sessionScope.user.username}</span>
        <a href="${pageContext.request.contextPath}/logout" style="color: #94a3b8; text-decoration: none; font-size: 14px;"> 退出</a>
    </div>
</div>

<!-- 主内容 -->
<div class="container">
    <div class="page-header">
        <div>
            <h1>员工管理</h1>
            <p>管理企业员工信息 · 支持增删改查及家庭住址关联</p>
        </div>
        <a href="${pageContext.request.contextPath}/emp?method=add" class="btn-add">+ 新建员工</a>
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
                    long hasAddress = 0;
                    if (empList != null) {
                        for (Emp e : empList) {
                            if (empAddressMap.containsKey(e.getId())) {
                                hasAddress++;
                            }
                        }
                    }
                    out.print(hasAddress);
                %>
            </div>
            <div class="stat-label">当前页已填写住址</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">
                <%
                    long missingAddress = 0;
                    if (empList != null) {
                        missingAddress = empList.size() - hasAddress;
                    }
                    out.print(missingAddress);
                %>
            </div>
            <div class="stat-label">当前页待完善住址</div>
        </div>
    </div>

    <!-- 员工表格 -->
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>姓名</th>
                <th>年龄</th>
                <th>薪资</th>
                <th>部门</th>
                <th>默认家庭住址</th>
                <th style="width: 170px;">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${empList}" var="emp">
                <%
                    Emp empItem = (Emp) pageContext.getAttribute("emp");
                    Map<Integer, Address> addrMap = (Map<Integer, Address>) request.getAttribute("empAddressMap");
                    Address addrItem = addrMap != null ? addrMap.get(empItem.getId()) : null;
                    pageContext.setAttribute("addrItem", addrItem);
                %>
                <tr>
                    <td>${emp.id}</td>
                    <td><strong>${emp.name}</strong></td>
                    <td>${emp.age}</td>
                    <td>¥ ${emp.salary}</td>
                    <td>
                        <span class="dept-badge">${emp.deptName != null ? emp.deptName : '未分配'}</span>
                    </td>
                    <td>
                        <div class="address-preview">
                            <c:choose>
                                <c:when test="${not empty addrItem}">
                  <span>
                    ${addrItem.province != null ? addrItem.province : ''}
                    ${addrItem.city != null ? addrItem.city : ''}
                    ${addrItem.district != null ? addrItem.district : ''}
                    ${addrItem.detail != null ? addrItem.detail : ''}
                  </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="address-empty">未填写</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                    <td class="action-links">
                        <a href="${pageContext.request.contextPath}/emp?method=edit&id=${emp.id}">编辑</a>
                        <a href="${pageContext.request.contextPath}/address?method=list&empId=${emp.id}">住址管理</a>
                        <a href="javascript:void(0)" onclick="deleteEmp(${emp.id})" class="delete">删除</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty empList}">
                <tr class="empty-row">
                    <td colspan="7">
                        <div style="padding: 20px;">
                            <p>暂无员工数据</p>
                            <p style="margin-top: 12px; font-size: 14px;">
                                <a href="${pageContext.request.contextPath}/emp?method=add" style="color: #3b82f6;">点击新建员工</a>
                            </p>
                        </div>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

        <!-- ===== 分页组件 ===== -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <%
                    int currentPage = (Integer) request.getAttribute("currentPage");
                    int totalPages = (Integer) request.getAttribute("totalPages");
                    int pageSize = (Integer) request.getAttribute("pageSize");

                    // 上一页
                    if (currentPage > 1) {
                %>
                <a href="${pageContext.request.contextPath}/emp?method=list&pageNo=<%=currentPage-1%>&pageSize=<%=pageSize%>">上一页</a>
                <%
                } else {
                %>
                <span class="disabled">上一页</span>
                <%
                    }

                    // 页码显示逻辑：显示当前页前后各2页
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);

                    // 第一页
                    if (startPage > 1) {
                %>
                <a href="${pageContext.request.contextPath}/emp?method=list&pageNo=1&pageSize=<%=pageSize%>">1</a>
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
                <a href="${pageContext.request.contextPath}/emp?method=list&pageNo=<%= i %>&pageSize=<%=pageSize%>"><%= i %></a>
                <%
                        }
                    }

                    // 最后一页
                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) {
                %>
                <span class="disabled">...</span>
                <%
                    }
                %>
                <a href="${pageContext.request.contextPath}/emp?method=list&pageNo=<%= totalPages %>&pageSize=<%=pageSize%>"><%= totalPages %></a>
                <%
                    }

                    // 下一页
                    if (currentPage < totalPages) {
                %>
                <a href="${pageContext.request.contextPath}/emp?method=list&pageNo=<%=currentPage+1%>&pageSize=<%=pageSize%>">下一页</a>
                <%
                } else {
                %>
                <span class="disabled">下一页</span>
                <%
                    }
                %>
                <span class="page-info">
                    第 ${currentPage} / ${totalPages} 页，共 ${totalCount} 条记录，每页 ${pageSize} 条
                </span>

                <!-- 每页显示条数选择 -->
                <select class="page-size-select" onchange="changePageSize(this.value)">
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5条/页</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10条/页</option>
                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20条/页</option>
                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50条/页</option>
                </select>
            </div>
        </c:if>
    </div>

    <div class="footer">
        <p>企业管理系统</p>
        <p style="margin-top: 8px; font-size: 12px; color: #cbd5e1;">
            当前在线人数: ${applicationScope.onlineCount != null ? applicationScope.onlineCount : 0} 人
            &nbsp;&nbsp;|&nbsp;&nbsp;
            系统版本: ${applicationScope.appVersion}
        </p>
    </div>
</div>

<script>
    function deleteEmp(id) {
        if (confirm('确定要删除该员工吗？删除后无法恢复，该员工的家庭住址也会一并删除。')) {
            window.location.href = '${pageContext.request.contextPath}/emp?method=delete&id=' + id;
        }
    }

    function changePageSize(size) {
        window.location.href = '${pageContext.request.contextPath}/emp?method=list&pageSize=' + size + '&pageNo=1';
    }
</script>
</body>
</html>