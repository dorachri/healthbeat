package Mainpackage;

import java.util.ArrayList;

public class Availability {
	
	private int startTime, endTime;
	
	
	public Availability() {
		// TODO Auto-generated constructor stub
	}
	
	
	public Availability(int startTime, int endTime) {
		this.startTime = startTime;
		this.endTime = endTime;
	}
	
	
	//getters and setters for some attributes
	public int getStartTime() {
		return startTime;
	}
		
		
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
		
		
	public int getEndTime() {
		return endTime;
	}
		
		
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}
	
	
	public static ArrayList<String> splitTimeInterval(String av, int interval) {
		ArrayList<String> daily_av = new ArrayList<>();
		int begin_time = 0;
		int end_time = 0;
		
		String[] time = av.split("-");
		String begin = time[0];
		String end = time[1];
		
		String[] time2 = begin.split(":");
		int begin_hour = Integer.parseInt(time2[0]);
		int begin_min = Integer.parseInt(time2[1]);
		
		if (begin_min == 0) {
			begin_time = begin_hour*60;
		}
		else if (begin_min == 15) {
			begin_time = begin_hour*60 + 1/4*60;
		}
		else if (begin_min == 30) {
			begin_time = begin_hour*60 + 1/2*60;
		}
		else if (begin_min == 45) {
			begin_time = begin_hour*60 + 3/4*60;
		}
		
		String[] time3 = end.split(":");
		int end_hour = Integer.parseInt(time3[0]);
		int end_min = Integer.parseInt(time3[1]);
		
		if (end_min == 0) {
			end_time = end_hour*60;
		}
		else if (end_min == 15) {
			end_time = end_hour*60 + 1/4*60;
		}
		else if (end_min == 30) {
			end_time = end_hour*60 + 1/2*60;
		}
		else if (end_min == 45) {
			end_time = end_hour*60 + 3/4*60;
		}
		
		for (int i = begin_time; i <= end_time; i += interval) {
			daily_av.add(String.format("%02d:%02d", i/60, i%60));
		}
		
		return daily_av;
	}
	
	
	public static String findDocWeeklyAv() {
		String doc_weekly_av = "SELECT * FROM mydb.availability WHERE doctor_id=?"; //secure for SQL injection
		return doc_weekly_av;
	}

}