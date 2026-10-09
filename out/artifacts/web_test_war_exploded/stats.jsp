<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.StatsDao, java.util.*, java.text.DecimalFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    StatsDao statsDao = new StatsDao();

    // 获取所有统计数据
    List<Map<String, Object>> deptEmployeeCount = statsDao.getDeptEmployeeCount();
    List<Map<String, Object>> deptAvgSalary = statsDao.getDeptAvgSalary();
    Map<String, Integer> ageDistribution = statsDao.getAgeDistribution();
    int totalEmployeeCount = statsDao.getTotalEmployeeCount();
    int totalDeptCount = statsDao.getTotalDeptCount();
    List<Map<String, Object>> topSalaries = statsDao.getTopSalaries();

    // 计算平均薪资和最高薪资
    double avgSalary = 0;
    double maxSalary = 0;
    if (deptAvgSalary != null && !deptAvgSalary.isEmpty()) {
        double total = 0;
        int count = 0;
        for (Map<String, Object> item : deptAvgSalary) {
            double avg = item.get("avgSalary") != null ? ((Number) item.get("avgSalary")).doubleValue() : 0;
            int empCount = item.get("empCount") != null ? ((Number) item.get("empCount")).intValue() : 0;
            if (avg > 0 && empCount > 0) {
                total += avg * empCount;
                count += empCount;
            }
            if (avg > maxSalary) {
                maxSalary = avg;
            }
        }
        avgSalary = count > 0 ? total / count : 0;
    }

    // 构建JSON数据供ECharts使用
    StringBuilder deptJson = new StringBuilder("[");
    for (int i = 0; i < deptEmployeeCount.size(); i++) {
        if (i > 0) deptJson.append(",");
        Map<String, Object> item = deptEmployeeCount.get(i);
        String name = item.get("deptName") != null ? item.get("deptName").toString() : "未命名";
        int count = item.get("empCount") != null ? ((Number) item.get("empCount")).intValue() : 0;
        deptJson.append("{\"name\":\"").append(name).append("\",\"value\":").append(count).append("}");
    }
    deptJson.append("]");

    StringBuilder salaryJson = new StringBuilder("[");
    for (int i = 0; i < deptAvgSalary.size(); i++) {
        if (i > 0) salaryJson.append(",");
        Map<String, Object> item = deptAvgSalary.get(i);
        String name = item.get("deptName") != null ? item.get("deptName").toString() : "未命名";
        double avg = item.get("avgSalary") != null ? ((Number) item.get("avgSalary")).doubleValue() : 0;
        salaryJson.append("{\"name\":\"").append(name).append("\",\"value\":").append(avg).append("}");
    }
    salaryJson.append("]");

    StringBuilder ageJson = new StringBuilder("{");
    int idx = 0;
    for (Map.Entry<String, Integer> entry : ageDistribution.entrySet()) {
        if (idx > 0) ageJson.append(",");
        ageJson.append("\"").append(entry.getKey()).append("\":").append(entry.getValue());
        idx++;
    }
    ageJson.append("}");

    StringBuilder topJson = new StringBuilder("[");
    for (int i = 0; i < topSalaries.size(); i++) {
        if (i > 0) topJson.append(",");
        Map<String, Object> item = topSalaries.get(i);
        String name = item.get("name") != null ? item.get("name").toString() : "未知";
        double salary = item.get("salary") != null ? ((Number) item.get("salary")).doubleValue() : 0;
        String dept = item.get("deptName") != null ? item.get("deptName").toString() : "未分配";
        topJson.append("{\"name\":\"").append(name).append("\",\"salary\":").append(salary).append(",\"dept\":\"").append(dept).append("\"}");
    }
    topJson.append("]");

    // 保存到request
    request.setAttribute("totalEmployeeCount", totalEmployeeCount);
    request.setAttribute("totalDeptCount", totalDeptCount);
    request.setAttribute("avgSalary", Math.round(avgSalary));
    request.setAttribute("maxSalary", Math.round(maxSalary));
    request.setAttribute("deptJson", deptJson.toString());
    request.setAttribute("salaryJson", salaryJson.toString());
    request.setAttribute("ageJson", ageJson.toString());
    request.setAttribute("topJson", topJson.toString());
    request.setAttribute("salaryList", deptAvgSalary);
%>
<html>
<head>
    <title>数据统计 - 企业管理系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
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
            transition: all 0.2s;
            padding: 8px 0;
            position: relative;
        }
        .nav-links a:hover { color: #3b82f6; }
        .nav-links a.active { color: #3b82f6; }
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px 48px;
        }
        .page-header {
            margin-bottom: 32px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px 28px;
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
        .stat-card .icon {
            font-size: 32px;
            float: right;
            opacity: 0.6;
        }
        .stat-card.blue .stat-number { color: #3b82f6; }
        .stat-card.green .stat-number { color: #22c55e; }
        .stat-card.orange .stat-number { color: #f59e0b; }
        .stat-card.purple .stat-number { color: #8b5cf6; }
        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        .chart-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 20px;
            transition: all 0.2s;
        }
        .chart-card:hover {
            border-color: #cbd5e1;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
        }
        .chart-title {
            font-size: 16px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }
        .chart-container {
            width: 100%;
            height: 350px;
        }
        .table-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 20px;
            margin-top: 24px;
        }
        .table-card .chart-title {
            margin-bottom: 16px;
        }
        .table-card table {
            width: 100%;
            border-collapse: collapse;
        }
        .table-card th {
            text-align: left;
            padding: 12px 16px;
            background: #f8fafc;
            font-weight: 600;
            font-size: 13px;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }
        .table-card td {
            padding: 12px 16px;
            font-size: 14px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }
        .table-card tr:last-child td { border-bottom: none; }
        .table-card tr:hover td { background-color: #fafcff; }
        .salary-high { color: #22c55e; font-weight: 600; }
        .salary-low { color: #ef4444; }
        .footer {
            margin-top: 48px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
            text-align: center;
            font-size: 13px;
            color: #94a3b8;
        }
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .chart-grid { grid-template-columns: 1fr; }
            .container { padding: 24px 20px; }
            .navbar { padding: 0 20px; }
            .nav-links { gap: 24px; }
            .nav-links a { font-size: 15px; }
        }
        @media (max-width: 640px) {
            .stats-grid { grid-template-columns: 1fr; }
            .stat-card .icon { float: none; display: block; margin-bottom: 8px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">企业管理系统<span> · 数据统计</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">员工管理</a>
        <a href="${pageContext.request.contextPath}/address/manager.jsp">家庭住址管理</a>
        <a href="${pageContext.request.contextPath}/dept?method=list">部门管理</a>
        <a href="${pageContext.request.contextPath}/user-manager?method=list"> 管理者管理</a>
        <a href="${pageContext.request.contextPath}/stats.jsp" class="active">数据统计</a>
        <a href="${pageContext.request.contextPath}/online.jsp"> 在线用户</a>
        <span class="user-info">${sessionScope.user.username}</span>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <h1> 数据统计看板</h1>
        <p>企业员工数据可视化分析</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-grid">
        <div class="stat-card blue">
            <div class="icon"></div>
            <div class="stat-number">${totalEmployeeCount}</div>
            <div class="stat-label">总员工数</div>
        </div>
        <div class="stat-card green">
            <div class="icon"></div>
            <div class="stat-number">${totalDeptCount}</div>
            <div class="stat-label">总部门数</div>
        </div>
        <div class="stat-card orange">
            <div class="icon">💰</div>
            <div class="stat-number">¥${avgSalary}</div>
            <div class="stat-label">平均薪资</div>
        </div>
        <div class="stat-card purple">
            <div class="icon"></div>
            <div class="stat-number">¥${maxSalary}</div>
            <div class="stat-label">最高薪资</div>
        </div>
    </div>

    <!-- 图表 -->
    <div class="chart-grid">
        <div class="chart-card">
            <div class="chart-title"> 各部门员工数量</div>
            <div class="chart-container" id="deptChart"></div>
        </div>
        <div class="chart-card">
            <div class="chart-title"> 各部门平均薪资</div>
            <div class="chart-container" id="salaryChart"></div>
        </div>
        <div class="chart-card">
            <div class="chart-title"> 年龄分布</div>
            <div class="chart-container" id="ageChart"></div>
        </div>
        <div class="chart-card">
            <div class="chart-title"> 薪资TOP5</div>
            <div class="chart-container" id="topChart"></div>
        </div>
    </div>

    <!-- 部门薪资详情表格 -->
    <div class="table-card">
        <div class="chart-title"> 部门薪资详情</div>
        <table>
            <thead>
            <tr>
                <th>部门名称</th>
                <th>员工数</th>
                <th>平均薪资</th>
                <th>总薪资</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty salaryList}">
                    <c:forEach items="${salaryList}" var="dept">
                        <tr>
                            <td><strong>${dept.deptName}</strong></td>
                            <td>${dept.empCount} 人</td>
                            <td class="${dept.avgSalary > 50000 ? 'salary-high' : 'salary-low'}">
                                ¥${dept.avgSalary}
                            </td>
                            <td>¥${dept.totalSalary}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="4" style="text-align:center;color:#94a3b8;">暂无数据</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div class="footer">
        <p>数据可视化 · 使用 ECharts 构建</p>
    </div>
</div>

<script>
    // 从JSP获取数据
    var deptData = ${deptJson};
    var salaryData = ${salaryJson};
    var ageData = ${ageJson};
    var topData = ${topJson};

    console.log('部门数据:', deptData);
    console.log('薪资数据:', salaryData);
    console.log('年龄数据:', ageData);
    console.log('TOP5数据:', topData);

    // 1. 部门员工数量柱状图
    var deptChart = echarts.init(document.getElementById('deptChart'));
    var deptNames = deptData.map(function(item) { return item.name; });
    var deptValues = deptData.map(function(item) { return item.value; });
    deptChart.setOption({
        tooltip: { trigger: 'axis', formatter: function(params) { return '<strong>' + params[0].name + '</strong><br/>员工数量: ' + params[0].value + ' 人'; } },
        grid: { left: '3%', right: '4%', bottom: '3%', top: '10%', containLabel: true },
        xAxis: { type: 'category', data: deptNames, axisLabel: { fontSize: 12, interval: 0, rotate: deptNames.length > 6 ? 30 : 0 } },
        yAxis: { type: 'value', name: '人数', splitLine: { lineStyle: { color: '#f1f5f9', type: 'dashed' } } },
        series: [{
            type: 'bar',
            data: deptValues,
            barWidth: '50%',
            itemStyle: { color: function(params) { var colors = ['#3b82f6','#60a5fa','#93c5fd','#bfdbfe','#dbeafe']; return colors[params.dataIndex % colors.length]; }, borderRadius: [6,6,0,0] },
            label: { show: true, position: 'top', fontSize: 12, fontWeight: 'bold', color: '#1e293b' }
        }]
    });

    // 2. 部门平均薪资折线图
    var salaryChart = echarts.init(document.getElementById('salaryChart'));
    var salaryNames = salaryData.map(function(item) { return item.name; });
    var salaryValues = salaryData.map(function(item) { return Math.round(item.value); });
    salaryChart.setOption({
        tooltip: { trigger: 'axis', formatter: function(params) { return '<strong>' + params[0].name + '</strong><br/>平均薪资: ¥' + params[0].value.toLocaleString(); } },
        grid: { left: '3%', right: '4%', bottom: '3%', top: '10%', containLabel: true },
        xAxis: { type: 'category', data: salaryNames, axisLabel: { fontSize: 12, interval: 0, rotate: salaryNames.length > 6 ? 30 : 0 } },
        yAxis: { type: 'value', name: '薪资 (¥)', splitLine: { lineStyle: { color: '#f1f5f9', type: 'dashed' } }, axisLabel: { formatter: function(v) { return '¥' + (v >= 10000 ? (v/10000).toFixed(1) + '万' : v); } } },
        series: [{
            type: 'line',
            data: salaryValues,
            smooth: true,
            symbol: 'circle',
            symbolSize: 10,
            lineStyle: { color: '#22c55e', width: 3 },
            areaStyle: { color: { type: 'linear', x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: 'rgba(34,197,94,0.3)' }, { offset: 1, color: 'rgba(34,197,94,0.02)' }] } },
            itemStyle: { color: '#22c55e' },
            label: { show: true, formatter: function(p) { return '¥' + p.value.toLocaleString(); }, fontSize: 11, color: '#1e293b' }
        }]
    });

    // 3. 年龄分布饼图
    var ageChart = echarts.init(document.getElementById('ageChart'));
    var ageKeys = Object.keys(ageData);
    var ageValues = Object.values(ageData);
    var ageColors = ['#8b5cf6','#a78bfa','#c4b5fd','#ddd6fe','#ede9fe'];
    ageChart.setOption({
        tooltip: { trigger: 'item', formatter: function(p) { return '<strong>' + p.name + '</strong><br/>人数: ' + p.value + ' 人 (' + p.percent + '%)'; } },
        legend: { orient: 'vertical', right: '5%', top: 'center', itemWidth: 12, itemHeight: 12, textStyle: { fontSize: 12, color: '#64748b' } },
        series: [{
            type: 'pie',
            radius: ['45%', '72%'],
            center: ['45%', '50%'],
            avoidLabelOverlap: true,
            itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 2 },
            label: { show: true, formatter: '{b}\n{d}%', fontSize: 11, color: '#64748b' },
            labelLine: { length: 15, length2: 15 },
            data: ageKeys.map(function(key, i) { return { name: key, value: ageValues[i], itemStyle: { color: ageColors[i % ageColors.length] } }; })
        }]
    });

    // 4. 薪资TOP5柱状图
    var topChart = echarts.init(document.getElementById('topChart'));
    var topNames = topData.map(function(item) { return item.name; });
    var topSalaries = topData.map(function(item) { return Math.round(item.salary); });
    var topDepts = topData.map(function(item) { return item.dept; });
    var topColors = ['#f59e0b','#fbbf24','#fcd34d','#fde68a','#fef3c7'];
    topChart.setOption({
        tooltip: { trigger: 'axis', formatter: function(params) { var idx = params[0].dataIndex; return '<strong>' + params[0].name + '</strong><br/>部门: ' + topDepts[idx] + '<br/>薪资: ¥' + params[0].value.toLocaleString(); } },
        grid: { left: '3%', right: '4%', bottom: '3%', top: '10%', containLabel: true },
        xAxis: { type: 'category', data: topNames, axisLabel: { fontSize: 12 } },
        yAxis: { type: 'value', name: '薪资 (¥)', splitLine: { lineStyle: { color: '#f1f5f9', type: 'dashed' } }, axisLabel: { formatter: function(v) { return '¥' + (v >= 10000 ? (v/10000).toFixed(1) + '万' : v); } } },
        series: [{
            type: 'bar',
            data: topSalaries.map(function(v, i) { return { value: v, itemStyle: { color: topColors[i % topColors.length], borderRadius: [6,6,0,0] } }; }),
            barWidth: '50%',
            label: { show: true, position: 'top', formatter: function(p) { return '¥' + p.value.toLocaleString(); }, fontSize: 11, fontWeight: 'bold', color: '#1e293b' }
        }]
    });

    // 窗口自适应
    window.addEventListener('resize', function() {
        deptChart.resize();
        salaryChart.resize();
        ageChart.resize();
        topChart.resize();
    });
</script>
</body>
</html>