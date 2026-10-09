package dao;

import utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 统计数据DAO
 */
public class StatsDao {

    /**
     * 获取各部门员工数量统计
     */
    public List<Map<String, Object>> getDeptEmployeeCount() {
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT d.deptcol as deptName, COUNT(e.id) as empCount " +
                    "FROM dept d " +
                    "LEFT JOIN emp e ON d.iddept = e.dept_id " +
                    "GROUP BY d.iddept, d.deptcol " +
                    "ORDER BY empCount DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("deptName") != null ? rs.getString("deptName") : "未命名");
                map.put("empCount", rs.getInt("empCount"));
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return result;
    }

    /**
     * 获取各部门平均薪资统计
     */
    public List<Map<String, Object>> getDeptAvgSalary() {
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT d.deptcol as deptName, " +
                    "ROUND(IFNULL(AVG(e.salary), 0), 2) as avgSalary, " +
                    "COUNT(e.id) as empCount, " +
                    "ROUND(IFNULL(SUM(e.salary), 0), 2) as totalSalary " +
                    "FROM dept d " +
                    "LEFT JOIN emp e ON d.iddept = e.dept_id " +
                    "GROUP BY d.iddept, d.deptcol " +
                    "ORDER BY avgSalary DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("deptName") != null ? rs.getString("deptName") : "未命名");
                map.put("avgSalary", rs.getDouble("avgSalary"));
                map.put("empCount", rs.getInt("empCount"));
                map.put("totalSalary", rs.getDouble("totalSalary"));
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return result;
    }

    /**
     * 获取年龄分布统计
     */
    public Map<String, Integer> getAgeDistribution() {
        Map<String, Integer> result = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT age FROM emp WHERE age IS NOT NULL";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                int age = rs.getInt("age");
                String range = getAgeRange(age);
                result.put(range, result.getOrDefault(range, 0) + 1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return result;
    }

    /**
     * 获取年龄区间
     */
    private String getAgeRange(int age) {
        if (age < 20) return "20岁以下";
        else if (age < 25) return "20-24岁";
        else if (age < 30) return "25-29岁";
        else if (age < 35) return "30-34岁";
        else if (age < 40) return "35-39岁";
        else return "40岁以上";
    }

    /**
     * 获取总员工数
     */
    public int getTotalEmployeeCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT COUNT(*) as total FROM emp";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }

    /**
     * 获取总部门数
     */
    public int getTotalDeptCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT COUNT(*) as total FROM dept";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }

    /**
     * 获取员工薪资TOP5
     */
    public List<Map<String, Object>> getTopSalaries() {
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT e.name, e.salary, d.deptcol as deptName " +
                    "FROM emp e " +
                    "LEFT JOIN dept d ON e.dept_id = d.iddept " +
                    "ORDER BY e.salary DESC " +
                    "LIMIT 5";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("name") != null ? rs.getString("name") : "未知");
                map.put("salary", rs.getDouble("salary"));
                map.put("deptName", rs.getString("deptName") != null ? rs.getString("deptName") : "未分配");
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return result;
    }

    /**
     * 获取所有统计数据（一次性获取）
     */
    public Map<String, Object> getAllStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("deptEmployeeCount", getDeptEmployeeCount());
        stats.put("deptAvgSalary", getDeptAvgSalary());
        stats.put("ageDistribution", getAgeDistribution());
        stats.put("totalEmployeeCount", getTotalEmployeeCount());
        stats.put("totalDeptCount", getTotalDeptCount());
        stats.put("topSalaries", getTopSalaries());
        return stats;
    }
}