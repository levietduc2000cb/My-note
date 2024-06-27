import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/specialty_model.dart';


const _specialtyTable = 'specialty';
const _columnSpecialtyId = 'id';
const _columnProvinceIdRelative = 'provinceId';

Future<int> createSpecialty(SpecialtyModel specialty) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_specialtyTable, specialty.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createSpecialty(): $err");
  }

  return id;
}


Future<List<Map<String, dynamic>>> getSpecialties() async {
  late Future<List<Map<String, dynamic>>> specialties;
  try {
    final db = await SQLHelper.getDb();
    specialties = db.query(_specialtyTable);
  } catch (err) {
    debugPrint("getSpecialties(): $err");
  }

  return specialties;
}

Future<List<Map<String, dynamic>>> getSpecialtiesByProvinceId(int idProvince) async {
  late Future<List<Map<String, dynamic>>> specialties;
  try {
    final db = await SQLHelper.getDb();
    specialties = db.query(_specialtyTable, where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("getSpecialtiesByProvinceId(): $err");
  }

  return specialties;
}


Future<List<Map<String, dynamic>>> getSpecialtie(int id) async {
  late Future<List<Map<String, dynamic>>> specialty;

  try {
    final db = await SQLHelper.getDb();

    specialty = db.query(_specialtyTable,
        where: "$_columnSpecialtyId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getSpecialtie(): $err");
  }

  return specialty;
}


Future<int> updateSpecialty(SpecialtyModel specialty) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(_specialtyTable, specialty.toMap(),
        where: "$_columnSpecialtyId = ?", whereArgs: [specialty.id]);
  } catch (err) {
    debugPrint("updateSpecialty(): $err");
  }

  return result;
}


Future<void> deleteSpecialty(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_specialtyTable, where: "$_columnSpecialtyId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an specialty: $err");
  }
}

Future<void> deleteSpecialtyByProvinceId(int idProvince) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_specialtyTable, where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an license plate: $err");
  }
}