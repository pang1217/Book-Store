/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package database;
import java.sql.*;
/**
 *
 * @author nathaphan
 */
public class connect {
    Connection c;
    public connect(){
        database.user m = new database.user();
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection con = DriverManager.getConnection(m.getURL()+m.getDBName(), m.getUser(), m.getPass());
            this.c = con;
        } catch (Exception e) {System.out.println(e);}
    }
    
    public Connection getC (){
        return c;
    }
}
