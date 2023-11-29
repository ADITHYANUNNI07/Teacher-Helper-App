import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/model/foldermodel.dart';
import 'package:eduvista/model/questionsmodel.dart';
import 'package:eduvista/model/studentattendance.dart';
import 'package:eduvista/model/studentattendancemodel.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/examquestions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> initalizeHiveandAdapter() async {
  // Register an adapter for UserDetails with the correct type ID (33)
  Hive.registerAdapter<UserDetails>(UserDetailsAdapter());
  Hive.registerAdapter<ClassModel>(ClassModelAdapter());
  Hive.registerAdapter<StudentModel>(StudentModelAdapter());
  Hive.registerAdapter<AllStudentAttendanceModel>(
      AllStudentAttendanceModelAdapter());
  Hive.registerAdapter<StudentAttendenceModel>(StudentAttendenceModelAdapter());
  Hive.registerAdapter<Questionsmodel>(QuestionsmodelAdapter());
  Hive.registerAdapter<FolderModel>(FolderModelAdapter());
  Hive.registerAdapter<SubFolderModel>(SubFolderModelAdapter());
  // Open the Hive box
  await Hive.openBox<UserDetails>('userDB');
  await Hive.openBox<ClassModel>('classDB');
  await Hive.openBox<StudentModel>('studentDB');
  await Hive.openBox<AllStudentAttendanceModel>('studentattendanceDB');
  await Hive.openBox<Questionsmodel>('questionsDB');
  await Hive.openBox<FolderModel>('FolderDB');
}

Future<void> addUserDetails(UserDetails user) async {
  final box = await Hive.openBox<UserDetails>('userDB');

  try {
    final index = await box.add(user);

    if (index >= 0) {
      print('UserDetails added at index: $index');
    } else {
      print('Failed to add UserDetails to the box');
    }
  } catch (e) {
    print('Error while adding UserDetails: $e');
  }
}

void checkCredentialsAndNavigate(
    String email, String password, BuildContext context) async {
  final userBox = await Hive.openBox<UserDetails>('userDB');
  final List<UserDetails> users = userBox.values.toList();

  for (UserDetails user in users) {
    if (user.email == email && user.password == password) {
      // Navigate to the home page
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashBoardScrn(),
        ),
      );
      return;
    }
  }
}

Future<UserDetails?> getUserDetailsByEmail(String email) async {
  final userBox = await Hive.openBox<UserDetails>('userDB');
  final List<UserDetails> users = userBox.values.toList();

  for (UserDetails user in users) {
    if (user.email == email) {
      return user;
    }
  }

  return null;
}

Future<bool> addClasstoHive(ClassModel cls) async {
  final box = await Hive.openBox<ClassModel>('classDB');

  try {
    final index = await box.add(cls);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> deleteClassFromHive(int index) async {
  final box = await Hive.openBox<ClassModel>('classDB');
  try {
    await box.deleteAt(index);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<ClassModel>> getClassByEmail(String email) async {
  final classBox = await Hive.openBox<ClassModel>('classDB');
  final List<ClassModel> clses = classBox.values.toList();
  List<ClassModel> usercls = [];
  for (ClassModel cls in clses) {
    if (cls.email == email) {
      usercls.add(cls);
    }
  }
  return usercls;
}

Future<bool> addStudentToHive(StudentModel studentDetails) async {
  final box = await Hive.openBox<StudentModel>('studentDB');
  try {
    final index = await box.add(studentDetails);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<List<StudentModel>> getStudentFromHive(String classname) async {
  final studentBox = await Hive.openBox<StudentModel>('studentDB');
  final List<StudentModel> allstudentlist = studentBox.values.toList();
  List<StudentModel> clsstudents = [];
  for (StudentModel student in allstudentlist) {
    if (student.classname == classname) {
      clsstudents.add(student);
    }
  }
  return clsstudents;
}

Future<bool> addStudentAttendanceToHive(
    AllStudentAttendanceModel studentDetails) async {
  final box =
      await Hive.openBox<AllStudentAttendanceModel>('studentattendanceDB');
  try {
    final index = await box.add(studentDetails);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<List<AllStudentAttendanceModel>> getStudentAttendanceFromHive(
    String classname) async {
  final studentBox =
      await Hive.openBox<AllStudentAttendanceModel>('studentattendanceDB');
  final List<AllStudentAttendanceModel> allstudentAttendancelist =
      studentBox.values.toList();
  List<AllStudentAttendanceModel> clsstudentsAttendance = [];
  for (AllStudentAttendanceModel student in allstudentAttendancelist) {
    if (student.classname == classname) {
      clsstudentsAttendance.add(student);
    }
  }
  return clsstudentsAttendance;
}

Future<void> updateStudentAttendanceInHive(
    AllStudentAttendanceModel attendanceModel, int key) async {
  var box =
      await Hive.openBox<AllStudentAttendanceModel>('studentattendanceDB');
  await box.put(key, attendanceModel);
}

Future<bool> addExamQuestionsToHive(Questionsmodel questionsmodel) async {
  final box = await Hive.openBox<Questionsmodel>('questionsDB');
  try {
    final index = await box.add(questionsmodel);
    if (index >= 0) {
      getQuestionsFN(questionsmodel.email);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<List<Questionsmodel>> getExamQuestionsFromHive(String email) async {
  final questionBox = await Hive.openBox<Questionsmodel>('questionsDB');
  final List<Questionsmodel> allquestionlist = questionBox.values.toList();
  List<Questionsmodel> eachteacherQlist = [];
  for (Questionsmodel question in allquestionlist) {
    if (question.email == email) {
      eachteacherQlist.add(question);
    }
  }
  return eachteacherQlist;
}

Future<bool> deleteQuestiondFromHive(int index) async {
  final box = await Hive.openBox<Questionsmodel>('questionsDB');
  try {
    await box.deleteAt(index);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> updateQuestionsInHive(
    Questionsmodel updatedquestionmodel, int key) async {
  var box = await Hive.openBox<Questionsmodel>('questionsDB');
  await box.put(key, updatedquestionmodel);
}

Future<bool> addFoldertoHive(FolderModel folderModel) async {
  final box = await Hive.openBox<FolderModel>('FolderDB');

  try {
    final index = await box.add(folderModel);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<List<FolderModel>> getFolderFromHive(String email) async {
  final box = await Hive.openBox<FolderModel>('FolderDB');
  final List<FolderModel> allfolderlist = box.values.toList();
  List<FolderModel> eachfolderlist = [];
  for (FolderModel folder in allfolderlist) {
    print(folder.email);
    if (folder.email == email) {
      eachfolderlist.add(folder);
    }
  }
  return eachfolderlist;
}

Future<void> updateFolderInHive(FolderModel updateFoldermodel, int key) async {
  var box = await Hive.openBox<FolderModel>('FolderDB');
  await box.put(key, updateFoldermodel);
}

Future<bool> deleteFolderFromHive(int key) async {
  final box = await Hive.openBox<FolderModel>('FolderDB');
  try {
    await box.delete(key);
    return true;
  } catch (e) {
    return false;
  }
}
