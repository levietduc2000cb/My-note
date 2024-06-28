import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/sql_helper.dart';
import '../model/license_plate_model.dart';

const _licenseTable = 'licensePlate';
const _columnLicensePlateId = 'id';
const _columnProvinceIdRelative = 'provinceId';

Future<int> createLicense(LicensePlateModel licensePlate) async {
  int id = 0;
  try {
    final db = await SQLHelper.getDb();
    id = await db.insert(_licenseTable, licensePlate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (err) {
    debugPrint("createLicenseTable(): $err");
  }

  return id;
}

Future<List<Map<String, dynamic>>> getLicensePlates() async {
  late Future<List<Map<String, dynamic>>> licensePlates;
  try {
    final db = await SQLHelper.getDb();
    licensePlates = db.query(_licenseTable);
  } catch (err) {
    debugPrint("getLicensePlates(): $err");
  }

  return licensePlates;
}

Future<List<Map<String, dynamic>>> getLicensePlatesByProvinceId(
    int idProvince) async {
  late Future<List<Map<String, dynamic>>> licensePlates;
  try {
    final db = await SQLHelper.getDb();
    licensePlates = db.query(_licenseTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("getLicensePlatesByProvinceId(): $err");
  }

  return licensePlates;
}

Future<List<Map<String, dynamic>>> getLicensePlate(int id) async {
  late Future<List<Map<String, dynamic>>> licensePlate;

  try {
    final db = await SQLHelper.getDb();

    licensePlate = db.query(_licenseTable,
        where: "$_columnLicensePlateId = ?", whereArgs: [id], limit: 1);
  } catch (err) {
    debugPrint("getCity(): $err");
  }

  return licensePlate;
}

Future<int> updateLicensePlate(LicensePlateModel licensePlate) async {
  int result = 0;
  try {
    final db = await SQLHelper.getDb();
    result = await db.update(_licenseTable, licensePlate.toMap(),
        where: "$_columnLicensePlateId = ?", whereArgs: [licensePlate.id]);
  } catch (err) {
    debugPrint("updateCity(): $err");
  }

  return result;
}

Future<void> deleteLicensePlate(int id) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_licenseTable,
        where: "$_columnLicensePlateId = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an license plate: $err");
  }
}

Future<void> deleteLicensePlateByProvinceId(int idProvince) async {
  try {
    final db = await SQLHelper.getDb();
    await db.delete(_licenseTable,
        where: "$_columnProvinceIdRelative = ?", whereArgs: [idProvince]);
  } catch (err) {
    debugPrint("Something went wrong when deleting an license plate: $err");
  }
}
