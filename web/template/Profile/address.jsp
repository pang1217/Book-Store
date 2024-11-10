<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Addresses</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
    <script src="./jquery/jquery-3.7.1.min"></script>
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="d-flex align-items-center justify-content-between">
            <h4 class="mb-0">ที่อยู่ของฉัน</h4>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addressModal" onclick="clearForm()">เพิ่มที่อยู่</button>
        </div>
        <hr>

        <table class="table" id="addressTable">
            <thead>
                <tr>
                    <th>ที่อยู่</th>
                    <th>การจัดการ</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String user = (String) session.getAttribute("user");
                    request.setCharacterEncoding("UTF-8");
                    if (user != null) {
                        String action = request.getParameter("action");
                        String addressId = request.getParameter("addressId");
                        String name = request.getParameter("name");
                        String address = request.getParameter("address");
                        String message = "";
                        Connection conn = null;

                        try {
                            conn = (new database.connect()).getC();

                            if ("POST".equalsIgnoreCase(request.getMethod())) {
                                if ("delete".equals(action)) {
                                    String deleteSql = "DELETE FROM address WHERE addressID = ? AND customerID = ?";
                                    try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                                        ps.setString(1, addressId);
                                        ps.setString(2, user);
                                        ps.executeUpdate();
                                        message = "Address deleted successfully.";
                                    }
                                } else if ("save".equals(action)) {
                                    if (addressId == null || addressId.isEmpty()) {
                                        // Insert new address
                                        String insertSql = "INSERT INTO address (name, address, customerID) VALUES (?, ?, ?)";
                                        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                                            ps.setString(1, name);
                                            ps.setString(2, address);
                                            ps.setString(3, user);
                                            ps.executeUpdate();
                                            message = "Address added successfully.";
                                        }
                                    } else {
                                        // Update existing address
                                        String updateSql = "UPDATE address SET name = ?, address = ? WHERE addressID = ? AND customerID = ?";
                                        try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                                            ps.setString(1, name);
                                            ps.setString(2, address);
                                            ps.setString(3, addressId);
                                            ps.setString(4, user);
                                            ps.executeUpdate();
                                            message = "Address updated successfully.";
                                        }
                                    }
                                }
                            }

                            // Fetch and display addresses
                            String selectSql = "SELECT * FROM address WHERE customerID = ?";
                            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                                ps.setString(1, user);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String id = rs.getString("addressID");
                                    String dbName = rs.getString("name");
                                    String dbAddress = rs.getString("address");
                %>
                                    <tr>
                                        <td>
                                            <p><strong><%= dbName %></strong><br><%= dbAddress %></p>
                                        </td>
                                        <td>
                                            <button class="btn btn-secondary" onclick="editAddress('<%= id %>', '<%= dbName %>', '<%= dbAddress %>')">แก้ไข</button>
                                            <form method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this address?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="addressId" value="<%= id %>">
                                                <button type="submit" class="btn btn-danger">ลบ</button>
                                            </form>
                                        </td>
                                    </tr>
                <%
                                }
                            }
                        } catch (SQLException e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                        }
                    } else {
                        out.println("<tr><td colspan='2'>Please log in to view addresses.</td></tr>");
                    }
                %>
            </tbody>
        </table>

        <!-- Modal for Address Input -->
        <div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addressModalLabel">เพิ่มที่อยู่ใหม่</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addressForm" method="post">
                            <input type="hidden" name="addressId" id="addressId">
                            <input type="hidden" name="action" value="save">
                            <div class="mb-3">
                                <label for="name" class="form-label">ชื่อ</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label for="address" class="form-label">ที่อยู่</label>
                                <input type="text" class="form-control" id="address" name="address" required>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ยกเลิก</button>
                                <button type="submit" class="btn btn-primary">บันทึก</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function editAddress(id, name, address) {
            document.getElementById("addressId").value = id;
            document.getElementById("name").value = name;
            document.getElementById("address").value = address;
            document.getElementById("addressModalLabel").innerText = "แก้ไขที่อยู่";
            new bootstrap.Modal(document.getElementById('addressModal')).show();
        }

        function clearForm() {
            document.getElementById("addressId").value = "";
            document.getElementById("name").value = "";
            document.getElementById("address").value = "";
            document.getElementById("addressModalLabel").innerText = "เพิ่มที่อยู่ใหม่";
        }
    </script>
</body>
</html>
