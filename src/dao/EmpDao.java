package dao;

import entity.Emp;
import utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EmpDao {

    // 查询所有员工（关联部门表获取部门名称）
    public List<Emp> findAll() {
        List<Emp> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT e.id, e.name, e.salary, e.age, e.dept_id, d.deptcol as dept_name " +
                "FROM emp e " +
                "LEFT JOIN dept d ON e.dept_id = d.iddept";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Emp emp = new Emp();
                emp.setId(rs.getInt("id"));
                emp.setName(rs.getString("name"));
                emp.setSalary(rs.getDouble("salary"));
                emp.setAge(rs.getInt("age"));
                emp.setDeptId(rs.getInt("dept_id"));
                emp.setDeptName(rs.getString("dept_name"));
                list.add(emp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 获取总记录数
     */
    public int getTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT COUNT(*) FROM emp";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }

    /**
     * 分页查询员工（关联部门表获取部门名称）
     */
    public List<Emp> findByPage(int pageNo, int pageSize) {
        List<Emp> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            int offset = (pageNo - 1) * pageSize;
            String sql = "SELECT e.id, e.name, e.salary, e.age, e.dept_id, d.deptcol as dept_name " +
                    "FROM emp e " +
                    "LEFT JOIN dept d ON e.dept_id = d.iddept " +
                    "LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Emp emp = new Emp();
                emp.setId(rs.getInt("id"));
                emp.setName(rs.getString("name"));
                emp.setSalary(rs.getDouble("salary"));
                emp.setAge(rs.getInt("age"));
                emp.setDeptId(rs.getInt("dept_id"));
                emp.setDeptName(rs.getString("dept_name"));
                list.add(emp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    // 检查同一部门下是否存在同名员工（用于新增）
    public boolean isNameExistsInDept(String name, int deptId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT COUNT(*) FROM emp WHERE name = ? AND dept_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setInt(2, deptId);
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

    // 检查同一部门下是否存在同名员工（用于更新，排除当前员工自己）
    public boolean isNameExistsInDeptExcludeSelf(String name, int deptId, int excludeId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT COUNT(*) FROM emp WHERE name = ? AND dept_id = ? AND id != ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setInt(2, deptId);
            pstmt.setInt(3, excludeId);
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

    // 添加员工
    public void addEmp(Emp emp) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "INSERT INTO emp(name, salary, age, dept_id) VALUES(?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, emp.getName());
            pstmt.setDouble(2, emp.getSalary());
            pstmt.setInt(3, emp.getAge());
            pstmt.setInt(4, emp.getDeptId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // 删除员工
    public void deleteEmp(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "DELETE FROM emp WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // 根据ID查询员工（关联部门表）
    public Emp loadEmp(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Emp emp = null;
        try {
            conn = DBUtil.getConn();
            String sql = "SELECT e.id, e.name, e.salary, e.age, e.dept_id, d.deptcol as dept_name " +
                    "FROM emp e " +
                    "LEFT JOIN dept d ON e.dept_id = d.iddept " +
                    "WHERE e.id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                emp = new Emp();
                emp.setId(rs.getInt("id"));
                emp.setName(rs.getString("name"));
                emp.setSalary(rs.getDouble("salary"));
                emp.setAge(rs.getInt("age"));
                emp.setDeptId(rs.getInt("dept_id"));
                emp.setDeptName(rs.getString("dept_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return emp;
    }

    // 修改员工信息
    public void updateEmp(Emp emp) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConn();
            String sql = "UPDATE emp SET name=?, salary=?, age=?, dept_id=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, emp.getName());
            pstmt.setDouble(2, emp.getSalary());
            pstmt.setInt(3, emp.getAge());
            pstmt.setInt(4, emp.getDeptId());
            pstmt.setInt(5, emp.getId());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }
}