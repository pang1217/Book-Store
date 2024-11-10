/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import beans.addressBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class addressDao {

    private Connection conn;
    // Constructor that takes a Connection
    public addressDao(Connection conn) {
        this.conn = conn;
    }

    // Method to insert a new address
    public boolean insertAddress(addressBean address) throws SQLException {
        String sql = "INSERT INTO address (name, address, customerID) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address.getName());
            ps.setString(2, address.getAddress());
            ps.setString(3, address.getCustomerID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Returns true if the insert was successful
        }
    }

    // Method to update an existing address
    public boolean updateAddress(addressBean address) throws SQLException {
        String sql = "UPDATE address SET name = ?, address = ? WHERE addressID = ? AND customerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address.getName());
            ps.setString(2, address.getAddress());
            ps.setInt(3, address.getAddressID());
            ps.setString(4, address.getCustomerID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Returns true if the update was successful
        }
    }

    // Method to delete an address by ID
    public boolean deleteAddress(int addressID, String customerID) throws SQLException {
        String sql = "DELETE FROM address WHERE addressID = ? AND customerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressID);
            ps.setString(2, customerID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Returns true if the delete was successful
        }
    }

    // Method to retrieve all addresses for a specific customerID
    public List<addressBean> getAddressesByCustomerID(String customerID) throws SQLException {
        List<addressBean> addresses = new ArrayList<>();
        String sql = "SELECT * FROM address WHERE customerID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    addressBean address = new addressBean();
                    address.setAddressID(rs.getInt("addressID"));
                    address.setName(rs.getString("name"));
                    address.setAddress(rs.getString("address"));
                    address.setCustomerID(rs.getString("customerID"));
                    addresses.add(address);
                }
            }
        }
        return addresses;
    }
}