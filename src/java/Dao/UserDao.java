/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import beans.UserBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author nathaphan
 */
public class UserDao {
    public boolean changePassword(Connection connection, String username, String newPassword) throws SQLException {
        String sql = "UPDATE user SET password = ? WHERE username = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, username);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
     public boolean updateUser(Connection connection, UserBean user) throws SQLException {
        String sql = "UPDATE user SET email = ?, phone = ? WHERE username = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getUsername());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
     
    public UserBean getUserDetails(Connection connection, String username) throws SQLException {
    String sql = "SELECT email, phone FROM user WHERE username = ?";
    UserBean user = new UserBean();
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setUsername(username);
        }
    }
    return user;
}
}
