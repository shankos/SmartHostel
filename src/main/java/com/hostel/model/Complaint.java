package com.hostel.model;

public class Complaint {

    private String description;
    private String userEmail;
    private String status;
    private String timestamp;

    public Complaint(String description, String userEmail) {
        this.description = description;
        this.userEmail   = userEmail;
        this.status      = "Pending";
        // Record submission time for display
        this.timestamp   = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a")
                               .format(new java.util.Date());
    }

    public String getDescription() { return description; }
    public String getUserEmail()   { return userEmail;   }
    public String getStatus()      { return status;      }
    public String getTimestamp()   { return timestamp;   }

    public void setStatus(String status) {
        if ("Pending".equals(status) || "Resolved".equals(status)) {
            this.status = status;
        }
    }

    public boolean isPending()  { return "Pending".equals(status);  }
    public boolean isResolved() { return "Resolved".equals(status); }
}