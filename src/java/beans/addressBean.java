/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package beans;

public class addressBean {
    private int addressID;
    private String name;
    private String address;
    private String customerID;

    // Constructor
    public addressBean() {
    }

    // Getters and Setters
    public int getAddressID() {
        return addressID;
    }

    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    // Optional: override toString for easy debugging
    @Override
    public String toString() {
        return "Address{" +
                "addressID=" + addressID +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", customerID='" + customerID + '\'' +
                '}';
    }
}

