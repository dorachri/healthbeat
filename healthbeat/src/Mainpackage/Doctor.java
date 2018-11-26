package Mainpackage;

import java.util.ArrayList;


public class Doctor extends User {
	
	private static ArrayList<Doctor> doctors = new ArrayList<>();
	final String amka, specialty;
	private String telephone, mobile, region, location, address, zip_code;
	private double cost;
	
	
	public Doctor(String name, String surname, String amka, String specialty) {
		super(name, surname);
		this.amka = amka;
		this.specialty = specialty;
		this.role = User.DOCTOR_ROLE; //role = 1 every time an object of type Doctor is created
		doctors.add(this); //every time an object of type Doctor is created, it is added to the arraylist doctors		
	}
	
	
	public Doctor(String name, String surname, String username, String password, String amka, String specialty, double cost, String telephone, String mobile, String region, String location, String address, String zip_code) {
		super(name, surname, username, password);
		this.amka = amka;
		this.specialty = specialty;
		this.cost = cost;
		this.telephone = telephone;
		this.mobile = mobile;
		this.region = region;
		this.location = location;
		this.address = address;
		this.zip_code = zip_code;
		this.role = User.DOCTOR_ROLE;
		doctors.add(this); //every time an object of type Doctor is created, it is added to the arraylist doctors
	}
	
	
	//getters and setters for the attributes that are not inherited from class Users
	public String getAMKA() {
		return amka;
	}
	
	
	public String getSpecialty() {
		return specialty;
	}
	
	
	public double getCost() {
		return cost;
	}
	
	
	public void setCost(double cost) {
		this.cost = cost;
	}
	
	
	public String getTelephone() {
		return telephone;
	}
	
	
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	
	
	public String getMobile() {
		return mobile;
	}
	
	
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	
	public String getRegion() {
		return region;
	}
	
	
	public void setRegion(String region) {
		this.region = region;
	}
	
	
	public String getLocation() {
		return location;
	}
	
	
	public void setLocation(String location) {
		this.location = location;
	}
	
	
	public String getAddress() {
		return address;
	}
	
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	
	public String getZipCode() {
		return zip_code;
	}
	
	
	public void setZipCode(String zip_code) {
		this.zip_code = zip_code;
	}
	
	
	//find office and specialty given a doctor_id
	public static String findOfficeAndSpecialty() {
		String data = "SELECT region, location, address, specialty FROM mydb.doctors WHERE doctor_id=?"; //secure for SQL injection
		return data;
	}
	
	//find all doctors given a specialty
	public static String findDoctorsBySpecialty() {
		String doctorIds = "SELECT doctor_id FROM mydb.doctors WHERE specialty=?"; //secure for SQL injection
		return doctorIds;
	}
	
	//find specialty given a doctor_id
	public static String findSpecialty() {
		String specialty = "SELECT specialty FROM mydb.doctors WHERE doctor_id=?"; //secure for SQL injection
		return specialty;
	}
	
	//find doctor_id given an amka
	public static String findID() {
		String id = "SELECT doctor_id FROM mydb.doctors WHERE amka=?"; //secure for SQL injection
		return id;
	}
	
}