package com.hostel.model;

public class Payment {

    private String studentEmail;
    private String studentName;
    private String month;
    private double amount;
    private String status;   // "Paid" | "Pending" | "Overdue"
    private String paidDate;

    public Payment(String studentEmail, String studentName, String month, double amount) {
        this.studentEmail = studentEmail;
        this.studentName  = studentName;
        this.month        = month;
        this.amount       = amount;
        this.status       = "Pending";
        this.paidDate     = null;
    }

    public String getStudentEmail() { return studentEmail; }
    public String getStudentName()  { return studentName;  }
    public String getMonth()        { return month;        }
    public double getAmount()       { return amount;       }
    public String getStatus()       { return status;       }
    public String getPaidDate()     { return paidDate;     }

    public void setStatus(String status) {
        if ("Paid".equals(status) || "Pending".equals(status) || "Overdue".equals(status))
            this.status = status;
    }
    public void setPaidDate(String d) { this.paidDate = d; }
    public void setAmount(double a)   { this.amount   = a; }

    public boolean isPaid()    { return "Paid".equals(status);    }
    public boolean isPending() { return "Pending".equals(status); }
    public boolean isOverdue() { return "Overdue".equals(status); }
}