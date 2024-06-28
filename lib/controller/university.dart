import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/university_model.dart';

const _universityTable = 'university';
const _columnUniversityId = 'id';
const _columnProvinceIdRelative = 'provinceId';

Future<int> createUniversity(UniversityModel university) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_universityTable, university.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createUniversity(): $err");
  }

  return id;
}

Future<List<Map<String, dynamic>>> getUniversites() async {
  late Future<List<Map<String, dynamic>>> universities;
  try {
    final db = await SQLHelper.getDb();
    universities = db.query(_universityTable);
  } catch (err) {
    debugPrint("getUniversites(): $err");
  }

  return universities;
}

Future<List<Map<String, dynamic>>> getUniversitiesByProvinceId(
    int idProvince) async {
  late Future<List<Map<String, dynamic>>> universities;
  try {
    final db = await SQLHelper.getDb();
    universities = db.query(_universityTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("getUniversitiesByProvinceId(): $err");
  }

  return universities;
}

Future<List<Map<String, dynamic>>> getUniversity(int id) async {
  late Future<List<Map<String, dynamic>>> university;

  try {
    final db = await SQLHelper.getDb();

    university = db.query(_universityTable,
        where: "$_columnUniversityId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getUniversity(): $err");
  }

  return university;
}

Future<int> updateUniversity(UniversityModel university) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(_universityTable, university.toMap(),
        where: "$_columnUniversityId = ?", whereArgs: [university.id]);
  } catch (err) {
    debugPrint("updateUniversity(): $err");
  }

  return result;
}

Future<void> deleteUniversity(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_universityTable,
        where: "$_columnUniversityId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an university: $err");
  }
}

Future<void> deleteUniversityByProvinceId(int idProvince) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_universityTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an license plate: $err");
  }
}
