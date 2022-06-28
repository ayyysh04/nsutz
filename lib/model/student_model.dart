import 'package:flutter/material.dart';

class Student {
  Widget? studentImage;
  String? studentID;
  String? studentName;
  String? studentDOB;
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
      {this.studentID,
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
}
