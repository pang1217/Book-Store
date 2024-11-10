/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author nathaphan
 */
@WebServlet(urlPatterns = {"/slipImage"})
public class slipImage extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderID = request.getParameter("orderID");

        try {
            Connection conn = (new database.connect()).getC();
            String sql = "SELECT paymentSlip FROM payments WHERE orderID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, orderID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Blob imageBlob = rs.getBlob("paymentSlip");
                byte[] imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                
                response.setContentType("paymentSlip/jpeg"); // Change this to image/png if your images are in PNG format
                OutputStream os = response.getOutputStream();
                os.write(imageBytes);
                os.flush();
                os.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
