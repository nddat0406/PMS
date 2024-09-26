/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.text.SimpleDateFormat;

/**
 *
 * @author HP
 */
public class User {

    private int id;
    private String email;
    private String fullname;
    private String mobile;
    private String password;
    private String note;
    private Group department;
    private int role;
    private int status;
    private String image;
    private boolean gender;
    private String address;
    private Date birthdate;
    private String otp;
    private Date otp_expiry;//Sử dụng kiểu dữ liệu Date cho thời gian hết hạn OTP

    public User() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Group getDepartment() {
        return department;
    }

    public void setDepartment(Group department) {
        this.department = department;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getBirthdate() {
        return birthdate;
    }

    public String getBirthdateString() {
        SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
        if (birthdate != null) {
            return formatter.format(birthdate);
        } else {
            return null;
        }
    }

    public void setBirthdate(Date birthdate) {
        this.birthdate = birthdate;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Date getOtp_expiry() {
        return otp_expiry;
    }

    public void setOtp_expiry(Date otp_expiry) {
        this.otp_expiry = otp_expiry;
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", email=" + email + ", fullname=" + fullname + ", mobile=" + mobile + ", password=" + password + ", note=" + note + ", department=" + department + ", role=" + role + ", status=" + status + ", image=" + image + ", gender=" + gender + ", address=" + address + ", birthdate=" + birthdate + ", otp=" + otp + ", otp_expiry=" + otp_expiry + '}';
    }

}
