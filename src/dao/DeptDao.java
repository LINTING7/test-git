package dao;

import bean.Dept;
import utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DeptDao {

    public List<Dept> findAll() {
        List<Dept> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT iddept as id, deptcol as name, manager, phone FROM Dept";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Dept dept = new Dept();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                dept.setManager(rs.getString("manager"));
                dept.setPhone(rs.getString("phone"));
                list.add(dept);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    public void add(Dept dept) {
        Connection conn = DBUtil.getConn();
        String sql = "INSERT INTO Dept(deptcol, manager, phone) VALUES(?, ?, ?)";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dept.getName());
            pstmt.setString(2, dept.getManager());
            pstmt.setString(3, dept.getPhone());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    public void delete(int id) {
        Connection conn = DBUtil.getConn();
        String sql = "DELETE FROM Dept WHERE iddept=?";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    public void update(Dept dept) {
        Connection conn = DBUtil.getConn();
        String sql = "UPDATE Dept SET deptcol=?, manager=?, phone=? WHERE iddept=?";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dept.getName());
            pstmt.setString(2, dept.getManager());
            pstmt.setString(3, dept.getPhone());
            pstmt.setInt(4, dept.getId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    public Dept findById(int id) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT iddept as id, deptcol as name, manager, phone FROM Dept WHERE iddept=?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Dept dept = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dept = new Dept();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                dept.setManager(rs.getString("manager"));
                dept.setPhone(rs.getString("phone"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return dept;
    }

    // 检查部门名称是否已存在
    public boolean isNameExists(String name) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT COUNT(*) FROM Dept WHERE deptcol=?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }

    // 检查部门名称是否已存在（排除自身）
    public boolean isNameExistsExcludeSelf(String name, int id) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT COUNT(*) FROM Dept WHERE deptcol=? AND iddept<>?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setInt(2, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }

    // 检查主管人是否已被其他部门使用
    public boolean isManagerExists(String manager) {
        if (manager == null || manager.trim().isEmpty()) return false;
        Connection conn = DBUtil.getConn();
        String sql = "SELECT COUNT(*) FROM Dept WHERE manager=?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, manager.trim());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }

    // 检查主管人是否已被其他部门使用（排除自身）
    public boolean isManagerExistsExcludeSelf(String manager, int id) {
        if (manager == null || manager.trim().isEmpty()) return false;
        Connection conn = DBUtil.getConn();
        String sql = "SELECT COUNT(*) FROM Dept WHERE manager=? AND iddept<>?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, manager.trim());
            pstmt.setInt(2, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }

    // 检查部门下是否有员工
    public boolean hasEmployees(int deptId) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT COUNT(*) FROM emp WHERE dept_id=?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, deptId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }
}