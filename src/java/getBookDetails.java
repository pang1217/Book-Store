import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/getBookDetails")
public class getBookDetails extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("id");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (bookId == null || bookId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Missing book ID\"}");
            out.flush();
            return;
        }
        try (Connection conn = (new database.connect()).getC();
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Books WHERE bookid = ?")) {
            
            stmt.setString(1, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String title = rs.getString("name");
                String author = rs.getString("author");
                double price = rs.getDouble("price");
                double priceDown = rs.getDouble("priceDown");
                int qtyInStock = rs.getInt("qtyInstock");

                // Properly formatted JSON response
                PrintWriter out = response.getWriter();
                out.print("{");
                out.print("\"title\":\"" + escapeJson(title) + "\",");
                out.print("\"author\":\"" + escapeJson(author) + "\",");
                out.print("\"price\":" + price + ",");
                out.print("\"priceDown\":" + priceDown + ",");
                out.print("\"qtyInStock\":" + qtyInStock);
                out.print("}");
                out.flush();
            } else {
                // Book not found, return 404
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Book not found\"}");
                out.flush();
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace(); // Log the exception for debugging
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Database error occurred\"}");
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace(); // Log the exception for debugging
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"An unexpected error occurred\"}");
            out.flush();
        }
    }

    // Helper method to escape JSON special characters
    private String escapeJson(String value) {
        if (value == null) return null;
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
