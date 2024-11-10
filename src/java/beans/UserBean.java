// UserBean.java
package beans;

import java.sql.*;

public class UserBean {
    private String username;
    private String email;
    private String password;
    private String confirmPassword;
    private String firstName;
    private String lastName;
    private String role;
    private String phone;

    // Getters and Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
     public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    // Check if the user already exists
    public boolean userExists(Connection connection) throws SQLException {
        String query = "SELECT COUNT(*) FROM user WHERE username = ? OR email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // Register a new user
    public boolean registerUser(Connection connection, boolean isAdmin) throws SQLException {
        if (!password.equals(confirmPassword)) {
            return false; // Passwords do not match
        }

        String query;
        if (isAdmin) {
            query = "INSERT INTO user (username, email, password, role, firstName, lastName) VALUES (?, ?, ?, 'Employee', ?, ?)";
        } else {
            query = "INSERT INTO user (username, email, password, role) VALUES (?, ?, ?, 'User')";
        }

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            if (isAdmin) {
                stmt.setString(4, firstName);
                stmt.setString(5, lastName);
            }
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    public boolean deleteUser(Connection connection, String user) throws SQLException{
        String query = "Delete from user where username = ?";
        try(PreparedStatement stmt = connection.prepareStatement(query)){
           stmt.setString(1, user); 
           int rowsAffected = stmt.executeUpdate();
           return rowsAffected > 0;
        }
    }
    
}
