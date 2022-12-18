import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Student {
  Widget? studentImage;
  String? studentID;
  String? studentName;
  DateTime? studentDOB;
  String? studentGender;
  String? studentCategory;
  String? studentAdmission;
  String? studentBranchName;
  String? studentDegree;
  String? studentFullPart;
  String? studentSpecialization;
  String? studentSection;
  int? studentCurrentSemester;
  Student(
      {this.studentImage,
      this.studentID,
      this.studentName,
      this.studentDOB,
      this.studentGender,
      this.studentCategory,
      this.studentAdmission,
      this.studentBranchName,
      this.studentDegree,
      this.studentFullPart,
      this.studentSpecialization,
      this.studentSection,
      this.studentCurrentSemester});

  //TODO:FIND A WAY TO SAVE STUDENT DATA LOCALLY AND SYNC WITH NEW DATA

  static DateTime toDate(
      String date) //DATE STRING SHOULD BE IN dd-MM-yyyy FORMAT
  {
    DateFormat formater = DateFormat('dd-MM-yyyy');
    return formater.parse(date);
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentImage: map['studentImage'],
      studentID: map['studentID'],
      studentName: map['studentName'],
      studentDOB: map['studentDOB'] != null ? toDate(map['studentDOB']) : null,
      studentGender: map['studentGender'],
      studentCategory: map['studentCategory'],
      studentAdmission: map['studentAdmission'],
      studentBranchName: map['studentBranchName'],
      studentDegree: map['studentDegree'],
      studentFullPart: map['studentFullPart'],
      studentSpecialization: map['studentSpecialization'],
      studentSection: map['studentSection'],
      studentCurrentSemester: map['studentCurrentSemester'] != null
          ? int.parse(map['studentCurrentSemester'])
          : null,
    );
  }

  @override
  String toString() {
    return 'studentImage: $studentImage, studentID: $studentID, studentName: $studentName, studentDOB: $studentDOB, studentGender: $studentGender, studentCategory: $studentCategory, studentAdmission: $studentAdmission, studentBranchName: $studentBranchName, studentDegree: $studentDegree, studentFullPart: $studentFullPart, studentSpecialization: $studentSpecialization, studentSection: $studentSection, studentCurrentSemester: $studentCurrentSemester';
  }
}
