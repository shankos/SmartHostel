package com.hostel.model;

public class RoomRequest {

    private String studentEmail;
    private String studentName;
    private String preferredRoom;
    private String reason;
    private String status;      // "Pending" | "Approved" | "Denied"
    private String submittedAt;
    private String adminNote;

    public RoomRequest(String studentEmail, String studentName, String preferredRoom, String reason) {
        this.studentEmail  = studentEmail;
        this.studentName   = studentName;
        this.preferredRoom = preferredRoom;
        this.reason        = reason;
        this.status        = "Pending";
        this.adminNote     = null;
        this.submittedAt   = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a")
                                 .format(new java.util.Date());
    }

    public String getStudentEmail()  { return studentEmail;  }
    public String getStudentName()   { return studentName;   }
    public String getPreferredRoom() { return preferredRoom; }
    public String getReason()        { return reason;        }
    public String getStatus()        { return status;        }
    public String getSubmittedAt()   { return submittedAt;   }
    public String getAdminNote()     { return adminNote;     }

    public void setStatus(String status)     { this.status    = status;    }
    public void setAdminNote(String note)    { this.adminNote = note;      }

    public boolean isPending()  { return "Pending".equals(status);  }
    public boolean isApproved() { return "Approved".equals(status); }
    public boolean isDenied()   { return "Denied".equals(status);   }
}