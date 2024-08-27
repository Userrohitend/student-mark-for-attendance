// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceSystem {
    struct Student {
        uint256 totalClasses;
        uint256 attendedClasses;
        uint256 marks;
    }
    
    address public teacher;
    mapping(address => Student) public students;
    mapping(address => bool) public registeredStudents;
    
    // Events to log attendance and marks assignment
    event AttendanceMarked(address student, bool attended);
    event MarksAssigned(address student, uint256 marks);
    
    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can perform this action");
        _;
    }
    
    constructor() {
        teacher = msg.sender; // Assign the contract creator as the teacher
    }
    
    function registerStudent(address student) public onlyTeacher {
        require(!registeredStudents[student], "Student already registered");
        students[student] = Student(0, 0, 0);
        registeredStudents[student] = true;
    }
    
    function markAttendance(address student, bool attended) public onlyTeacher {
        require(registeredStudents[student], "Student is not registered");
        
        Student storage s = students[student];
        
        if (attended) {
            s.attendedClasses += 1;
        }
        
        s.totalClasses += 1;
        
        emit AttendanceMarked(student, attended);
    }
    
    function calculateMarks(address student) public onlyTeacher {
        require(registeredStudents[student], "Student is not registered");
        
        Student storage s = students[student];
        
        // Calculate marks based on attendance percentage
        if (s.totalClasses > 0) {
            uint256 attendancePercentage = (s.attendedClasses * 100) / s.totalClasses;
            if (attendancePercentage >= 90) {
                s.marks = 10;
            } else if (attendancePercentage >= 75) {
                s.marks = 7;
            } else if (attendancePercentage >= 50) {
                s.marks = 5;
            } else {
                s.marks = 2;
            }
        }
        
        emit MarksAssigned(student, s.marks);
    }
    
    function getStudentInfo(address student) public view returns (uint256 totalClasses, uint256 attendedClasses, uint256 marks) {
        Student memory s = students[student];
        return (s.totalClasses, s.attendedClasses, s.marks);
    }
}
