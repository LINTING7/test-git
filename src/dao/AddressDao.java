package dao;

import entity.Address;
import utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDao {

    // 根据员工ID查询所有地址
    public List<Address> findByEmpId(int empId) {
        List<Address> list = new ArrayList<>();
        Connection conn = DBUtil.getConn();
        String sql = "SELECT * FROM emp_address WHERE emp_id = ? ORDER BY id DESC";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, empId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapToAddress(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    // 根据ID查询地址
    public Address findById(int id) {
        Connection conn = DBUtil.getConn();
        String sql = "SELECT * FROM emp_address WHERE id = ?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapToAddress(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    // 添加地址（每人只能有一个地址，若已有则先删除旧地址再插入）
    public void add(Address address) {
        Connection conn = null;
        try {
            conn = DBUtil.getConn();
            conn.setAutoCommit(false);

            // 删除该员工已有的地址
            PreparedStatement delPstmt = conn.prepareStatement("DELETE FROM emp_address WHERE emp_id = ?");
            delPstmt.setInt(1, address.getEmpId());
            delPstmt.executeUpdate();
            delPstmt.close();

            // 插入新地址
            String sql = "INSERT INTO emp_address(emp_id, province, city, district, street, detail, postal_code) VALUES(?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, address.getEmpId());
            pstmt.setString(2, address.getProvince());
            pstmt.setString(3, address.getCity());
            pstmt.setString(4, address.getDistrict());
            pstmt.setString(5, address.getStreet());
            pstmt.setString(6, address.getDetail());
            pstmt.setString(7, address.getPostalCode());
            pstmt.executeUpdate();
            pstmt.close();

            conn.commit();
            System.out.println("add address: empId=" + address.getEmpId());
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            System.out.println("add address 失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception e) { e.printStackTrace(); }
            DBUtil.close(conn, null, null);
        }
    }

    // 更新地址
    public void update(Address address) {
        Connection conn = DBUtil.getConn();
        String sql = "UPDATE emp_address SET province=?, city=?, district=?, street=?, detail=?, postal_code=?, update_time=NOW() WHERE id=?";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, address.getProvince());
            pstmt.setString(2, address.getCity());
            pstmt.setString(3, address.getDistrict());
            pstmt.setString(4, address.getStreet());
            pstmt.setString(5, address.getDetail());
            pstmt.setString(6, address.getPostalCode());
            pstmt.setInt(7, address.getId());
            pstmt.executeUpdate();
            System.out.println("update address: id=" + address.getId());
        } catch (Exception e) {
            System.out.println("update address 失败: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // 删除地址
    public void delete(int id) {
        Connection conn = DBUtil.getConn();
        String sql = "DELETE FROM emp_address WHERE id = ?";
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

    // 映射ResultSet到Address对象
    private Address mapToAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setId(rs.getInt("id"));
        address.setEmpId(rs.getInt("emp_id"));
        address.setProvince(rs.getString("province"));
        address.setCity(rs.getString("city"));
        address.setDistrict(rs.getString("district"));
        address.setStreet(rs.getString("street"));
        address.setDetail(rs.getString("detail"));
        address.setPostalCode(rs.getString("postal_code"));
        address.setCreateTime(rs.getTimestamp("create_time"));
        address.setUpdateTime(rs.getTimestamp("update_time"));
        return address;
    }
}