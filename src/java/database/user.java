/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package database;

/**
 *
 * @author nathaphan
 */
public class user {
    String URL = "jdbc:mysql://localhost:3306";
    String DBName = "/BookStore?useUnicode=true&characterEncoding=UTF-8";
    String User = "root";
    String Pass = "1234";

    public String getURL() {
        return URL;
    }

    public String getDBName() {
        return DBName;
    }

    public String getUser() {
        return User;
    }

    public String getPass() {
        return Pass;
    }

}
