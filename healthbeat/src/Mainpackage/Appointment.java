package Mainpackage;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;


public class Appointment {

	private LocalDate date; //start time of an appointment
	private String time;
	Doctor doctor;
	Patient patient;
	
	
	public Appointment() {
		// TODO Auto-generated constructor stub
	}
	
	
	public Appointment(LocalDate date, String time, Doctor doctor, Patient patient) { //constructor to create appointments
		this.date = date;
		this.time = time;
		this.patient = patient;
		this.doctor = doctor;
	}
	
	
	//getters and setters for some attributes
	public LocalDate getDate() {
		return date;
	}
	
	
	public void setDate(LocalDate date) {
		this.date = date;
	}
	
	
	public String getTime() {
		return time;
	}
	
	
	public void setTime(String time) {
		this.time = time;
	}
	
	
	//find if patient is available
	public static String findPatAppointment() {
		String appointment = "SELECT app_id FROM mydb.appointments WHERE patient_id=? AND time=? AND date=? AND canceled=?"; //secure for SQL injection
		return appointment;
	}
	
	
	//find if doctor is available
	public static String findDocAppointment() {
		String appointment = "SELECT app_id FROM mydb.appointments WHERE doctor_id=? AND time=? AND date=? AND canceled=?"; //secure for SQL injection
		return appointment;
	}
	
	
	public static LocalDate findDate(String day) {
		LocalDate date = LocalDate.now();
		LocalDate input = LocalDate.now();
		
		if (day.equals("Monday")) {
			date = input.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
		}
		else if (day.equals("Tuesday")) {
			date = input.with(TemporalAdjusters.next(DayOfWeek.TUESDAY));
		}
		else if (day.equals("Wednesday")) {
			date = input.with(TemporalAdjusters.next(DayOfWeek.WEDNESDAY));
		}
		else if (day.equals("Thursday")) {
			date = input.with(TemporalAdjusters.next(DayOfWeek.THURSDAY));
		}
		else if (day.equals("Friday")) {
			date = input.with(TemporalAdjusters.next(DayOfWeek.FRIDAY));
		}
		
		return date;
	}
	
	
	public static LocalDate findNextDate(int weeks, LocalDate date) {
		LocalDate nextDate = date.plusWeeks(weeks);
		return nextDate;
	}
	
}