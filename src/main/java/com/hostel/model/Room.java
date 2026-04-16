package com.hostel.model;

public class Room {

    private String roomNumber;
    private int    capacity;

    public Room(String roomNumber, int capacity) {
        this.roomNumber = roomNumber;
        this.capacity   = capacity;
    }

    public String getRoomNumber() { return roomNumber; }
    public int    getCapacity()   { return capacity;   }

    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public void setCapacity(int capacity)        { this.capacity   = capacity;   }
}