package servlet;

import dao.StatsDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/stats")
public class StatsServlet extends HttpServlet {

    private StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String method = request.getParameter("method");

        if ("data".equals(method)) {
            // 返回JSON数据
            getStatsData(request, response);
        } else {
            // 显示统计页面
            request.getRequestDispatcher("/stats.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * 获取统计数据JSON（手动构建，不依赖第三方库）
     */
    private void getStatsData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Map<String, Object> stats = statsDao.getAllStats();

            // 手动构建JSON
            StringBuilder json = new StringBuilder();
            json.append("{");

            // 1. totalEmployeeCount
            json.append("\"totalEmployeeCount\":").append(stats.get("totalEmployeeCount")).append(",");

            // 2. totalDeptCount
            json.append("\"totalDeptCount\":").append(stats.get("totalDeptCount")).append(",");

            // 3. deptEmployeeCount
            json.append("\"deptEmployeeCount\":");
            json.append(listToJson((List<Map<String, Object>>) stats.get("deptEmployeeCount")));
            json.append(",");

            // 4. deptAvgSalary
            json.append("\"deptAvgSalary\":");
            json.append(listToJson((List<Map<String, Object>>) stats.get("deptAvgSalary")));
            json.append(",");

            // 5. ageDistribution
            json.append("\"ageDistribution\":");
            json.append(mapToJson((Map<String, Integer>) stats.get("ageDistribution")));
            json.append(",");

            // 6. topSalaries
            json.append("\"topSalaries\":");
            json.append(listToJson((List<Map<String, Object>>) stats.get("topSalaries")));

            json.append("}");

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    /**
     * List<Map> 转 JSON 数组
     */
    private String listToJson(List<Map<String, Object>> list) {
        if (list == null || list.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(mapToJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Map 转 JSON 对象
     */
    private String mapToJson(Map<String, ?> map) {
        if (map == null || map.isEmpty()) {
            return "{}";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        int count = 0;
        for (Map.Entry<String, ?> entry : map.entrySet()) {
            if (count > 0) sb.append(",");
            String key = entry.getKey();
            Object value = entry.getValue();
            sb.append("\"").append(escapeJson(key)).append("\":");
            if (value == null) {
                sb.append("null");
            } else if (value instanceof String) {
                sb.append("\"").append(escapeJson((String) value)).append("\"");
            } else if (value instanceof Number) {
                sb.append(value);
            } else if (value instanceof Boolean) {
                sb.append(value);
            } else if (value instanceof Map) {
                sb.append(mapToJson((Map<String, ?>) value));
            } else if (value instanceof List) {
                sb.append(listToJson((List<Map<String, Object>>) value));
            } else {
                sb.append("\"").append(escapeJson(value.toString())).append("\"");
            }
            count++;
        }
        sb.append("}");
        return sb.toString();
    }

    /**
     * 转义JSON特殊字符
     */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}