package Mainpackage;

public class Patient extends User {
	
	final String amka;
	private String mobile;
	
	
	public Patient(String  name, String  surname, String  amka) {
		super(name, surname);
		this.amka = amka;
		this.role = User.PATIENT_ROLE;
	}
	
	
	public Patient(String name, String surname, String username, String password, String amka, String mobile) {
		super(name, surname, username, password);
		this.amka = amka;
		this.mobile = mobile;
		this.role = User.PATIENT_ROLE;  //role = 0 every time an object of type Patient is created 
	}
	
	
	//getters for attributes that are not inherited from class Users
	public String getAMKA() {
		return amka;
	}
	
	
	public String getMobile() {
		return mobile;
	}
	
	
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
} 