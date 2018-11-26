package Mainpackage;

public class User {
	
	public static final int PATIENT_ROLE = 0;
	public static final int DOCTOR_ROLE = 1;
	public static final int ADMIN_ROLE = 2;
	final String name, surname;
	private String username, password;
	static int usersCounter;
	public int role;
	
	
	public User(String name, String surname) {
		usersCounter++;
		this.name = name;
		this.surname = surname;
	}
	
	
	public User(String name, String surname, String username, String password) {
		usersCounter++;
		this.name = name;
		this.surname = surname;
		this.username = username;
		this.password = password;
	}
	
	
	//getters and setters 
	public String getName() {
		return name;
	}
	
	
	public String getSurname() {
		return surname;
	}
	
	
	public String getUsername() {
		return username;
	}
	
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	
	public int getRole() {
		return role;
	}
	
	
	public void setRole(int role) {
		this.role = role;
	}
	
	
	public String getPassword() {
		return password;
	}
	
	
	public void setPassword(String password) {
		this.password = password;	
	}
	
	
	public int getCounter() {
		return usersCounter;
	}
	
	
	//find user_id given a username
	public static String findUserId() {
		String userId = "SELECT user_id FROM mydb.users WHERE username=?"; //secure for SQL injection
		return userId;
	}
	
	
	//find full name and gender given a user_id
	public static String findUserNameSurnameGender() {
		String data = "SELECT name, surname, gender FROM mydb.users WHERE user_id=?"; //secure for SQL injection
		return data;
	}
	
}