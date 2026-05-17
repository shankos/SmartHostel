package com.hostel.model;

public class Room {

    private String roomNumber;
    private int    capacity;
    private String assignedStudentEmail;
    private String assignedStudentName;

    public Room(String roomNumber, int capacity) {
        this.roomNumber           = roomNumber;
        this.capacity             = capacity;
        this.assignedStudentEmail = null;
        this.assignedStudentName  = null;
    }

    public String getRoomNumber()           { return roomNumber;           }
    public int    getCapacity()             { return capacity;             }
    public String getAssignedStudentEmail() { return assignedStudentEmail; }
    public String getAssignedStudentName()  { return assignedStudentName;  }

    public void setRoomNumber(String roomNumber)         { this.roomNumber           = roomNumber; }
    public void setCapacity(int capacity)                { this.capacity             = capacity;   }
    public void setAssignedStudentEmail(String email)    { this.assignedStudentEmail = email;      }
    public void setAssignedStudentName(String name)      { this.assignedStudentName  = name;       }

    public boolean isAssigned() {
        return assignedStudentEmail != null && !assignedStudentEmail.trim().isEmpty();
    }

    public void unassign() {
        this.assignedStudentEmail = null;
        this.assignedStudentName  = null;
    }
}