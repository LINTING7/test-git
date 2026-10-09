package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/emptest?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "123457";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 自动初始化默认账号
            initDefaultUser();
        } catch (Exception e) {
            System.out.println("数据库驱动加载失败");
            e.printStackTrace();
        }
    }

    // 自动创建 users 表并插入默认账号
    private static void initDefaultUser() {
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = getConn();
            if (conn == null) return;
            stmt = conn.createStatement();

            // 创建 users 表（如果不存在）
            String createTableSQL = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT," +
                    "username VARCHAR(50) NOT NULL UNIQUE," +
                    "password VARCHAR(50) NOT NULL)";
            stmt.executeUpdate(createTableSQL);

            // 检查是否已有用户
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
            rs.next();
            int count = rs.getInt(1);
            rs.close();

            // 如果没有用户，插入默认账号 admin/123456
            if (count == 0) {
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO users(username, password) VALUES (?, ?)");
                pstmt.setString(1, "admin");
                pstmt.setString(2, "12345");
                pstmt.executeUpdate();
                pstmt.close();
                System.out.println("已创建默认账号: admin / 123456");
            }
        } catch (Exception e) {
            System.out.println("初始化默认账号失败");
            e.printStackTrace();
        } finally {
            close(conn, stmt, null);
        }
    }

    public static Connection getConn() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.out.println("数据库连接失败");
            e.printStackTrace();
            return null;
        }
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}