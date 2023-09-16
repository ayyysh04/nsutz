import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  Uint8List? studentImage;
  @HiveField(1)
  String? studentID;
  @HiveField(2)
  String? studentName;
  @HiveField(3)
  DateTime? studentDOB;
  @HiveField(4)
  String? studentGender;
  @HiveField(5)
  String? studentCategory;
  @HiveField(6)
  String? studentAdmission;
  @HiveField(7)
  String? studentBranchName;
  @HiveField(8)
  String? studentDegree;
  @HiveField(9)
  String? studentFullPart;
  @HiveField(10)
  String? studentSpecialization;
  @HiveField(11)
  String? studentSection;
  @HiveField(12)
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

  // factory Student.fromMap(Map<String, dynamic> map) {
  //   return Student(
  //     studentImage: map['studentImage'],
  //     studentID: map['studentID'],
  //     studentName: map['studentName'],
  //     studentDOB: map['studentDOB'] != null ? toDate(map['studentDOB']) : null,
  //     studentGender: map['studentGender'],
  //     studentCategory: map['studentCategory'],
  //     studentAdmission: map['studentAdmission'],
  //     studentBranchName: map['studentBranchName'],
  //     studentDegree: map['studentDegree'],
  //     studentFullPart: map['studentFullPart'],
  //     studentSpecialization: map['studentSpecialization'],
  //     studentSection: map['studentSection'],
  //     studentCurrentSemester: map['studentCurrentSemester'] != null
  //         ? int.parse(map['studentCurrentSemester'])
  //         : null,
  //   );
  // }

  factory Student.fromStudent(
      {Uint8List? studentImage,
      String? studentID,
      String? studentName,
      String? studentDOB,
      String? studentGender,
      String? studentCategory,
      String? studentAdmission,
      String? studentBranchName,
      String? studentDegree,
      String? studentFullPart,
      String? studentSpecialization,
      String? studentSection,
      String? studentCurrentSemester}) {
    return Student(
      studentImage: studentImage,
      studentID: studentID,
      studentName: studentName,
      studentDOB: studentDOB != null ? toDate(studentDOB) : null,
      studentGender: studentGender,
      studentCategory: studentCategory,
      studentAdmission: studentAdmission,
      studentBranchName: studentBranchName,
      studentDegree: studentDegree,
      studentFullPart: studentFullPart,
      studentSpecialization: studentSpecialization,
      studentSection: studentSection,
      studentCurrentSemester: studentCurrentSemester != null
          ? int.parse(studentCurrentSemester)
          : null,
    );
  }
  @override
  String toString() {
    return 'studentImage: $studentImage, studentID: $studentID, studentName: $studentName, studentDOB: $studentDOB, studentGender: $studentGender, studentCategory: $studentCategory, studentAdmission: $studentAdmission, studentBranchName: $studentBranchName, studentDegree: $studentDegree, studentFullPart: $studentFullPart, studentSpecialization: $studentSpecialization, studentSection: $studentSection, studentCurrentSemester: $studentCurrentSemester';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.studentImage == studentImage &&
        other.studentID == studentID &&
        other.studentName == studentName &&
        other.studentDOB == studentDOB &&
        other.studentGender == studentGender &&
        other.studentCategory == studentCategory &&
        other.studentAdmission == studentAdmission &&
        other.studentBranchName == studentBranchName &&
        other.studentDegree == studentDegree &&
        other.studentFullPart == studentFullPart &&
        other.studentSpecialization == studentSpecialization &&
        other.studentSection == studentSection &&
        other.studentCurrentSemester == studentCurrentSemester;
  }

  @override
  int get hashCode {
    return studentImage.hashCode ^
        studentID.hashCode ^
        studentName.hashCode ^
        studentDOB.hashCode ^
        studentGender.hashCode ^
        studentCategory.hashCode ^
        studentAdmission.hashCode ^
        studentBranchName.hashCode ^
        studentDegree.hashCode ^
        studentFullPart.hashCode ^
        studentSpecialization.hashCode ^
        studentSection.hashCode ^
        studentCurrentSemester.hashCode;
  }
}
