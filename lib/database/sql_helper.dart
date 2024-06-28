import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static const _databaseName = "MyNoteDatabase.db";
  static const _databaseVersion = 1;
  static const _usersTable = 'users';
  static const _provincesTable = 'provinces';
  static const _cityTable = 'city';
  static const _licenseTable = 'licensePlate';
  static const _universityTable = 'university';
  static const _scenicSpotTable = 'scenicSpot';
  static const _specialtyTable = 'specialty';

  // Users table
  static const _columnUserId = 'id';
  static const _columnUserEmail = 'email';
  static const _columnUserName = 'userName';
  static const _columnUserPassword = 'password';

  // Provinces table
  static const _columnProvinceId = 'id';
  static const _columnProvinceName = 'provinceName';
  static const _columnProvinceUserId = 'userId';

  // City table
  static const _columnCityId = 'id';
  static const _columnCity = 'city';

  // LicensePlate table
  static const _columnLicensePlateId = 'id';
  static const _columnLicensePlate = 'licensePlate';

  // University table
  static const _columnUniversityId = 'id';
  static const _columnUniversity = 'university';

  // Scenic spot table
  static const _columnScenicSpotId = 'id';
  static const _columnScenicSpot = 'scenicSpot';

  // Specialty spot table
  static const _columnSpecialtyId = 'id';
  static const _columnSpecialty = 'specialty';

  //Create other
  static const _columnProvinceIdRelative = 'provinceId';
  static const _columnCreatedAt = 'createdAt';

  static Future<void> createItemTable(Database database) async {
    try {
      //Create province table
      await database.execute('''
CREATE TABLE $_provincesTable (
$_columnProvinceId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnProvinceName TEXT NOT NULL UNIQUE,
$_columnProvinceUserId INTEGER,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)''');
      // Create city table
      await database.execute('''
CREATE TABLE $_cityTable (
$_columnCityId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnCity TEXT NOT NULL,
$_columnProvinceIdRelative INTEGER NOT NULL,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ($_columnProvinceIdRelative) REFERENCES $_provincesTable($_columnProvinceId) ON DELETE CASCADE
)''');

      // Create LicensePlate table
      await database.execute('''
CREATE TABLE $_licenseTable (
$_columnLicensePlateId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnLicensePlate INTEGER NOT NULL,
$_columnProvinceIdRelative INTEGER NOT NULL,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ($_columnProvinceIdRelative) REFERENCES $_provincesTable($_columnProvinceId) ON DELETE CASCADE
)''');

      // Create University table
      await database.execute('''
CREATE TABLE $_universityTable (
$_columnUniversityId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnUniversity TEXT NOT NULL,
$_columnProvinceIdRelative INTEGER NOT NULL,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ($_columnProvinceIdRelative) REFERENCES $_provincesTable($_columnProvinceId) ON DELETE CASCADE
)''');

      // Create Spot table
      await database.execute('''
CREATE TABLE $_scenicSpotTable (
$_columnScenicSpotId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnScenicSpot TEXT NOT NULL,
$_columnProvinceIdRelative INTEGER NOT NULL,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ($_columnProvinceIdRelative) REFERENCES $_provincesTable($_columnProvinceId) ON DELETE CASCADE
)''');

      // Create Specialty table
      await database.execute('''
CREATE TABLE $_specialtyTable (
$_columnSpecialtyId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
$_columnSpecialty TEXT NOT NULL,
$_columnProvinceIdRelative INTEGER NOT NULL,
$_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ($_columnProvinceIdRelative) REFERENCES $_provincesTable($_columnProvinceId) ON DELETE CASCADE
)''');
    } catch (err) {
      debugPrint("createDatabaseTable(): $err");
    }
  }

  static Future<void> createUserTable(Database database) async {
    try {
      await database.execute('''
      CREATE TABLE $_usersTable (
      $_columnUserId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $_columnUserEmail TEXT NOT NULL,
      $_columnUserName TEXT NOT NULL,
      $_columnUserPassword TEXT NOT NULL,
      $_columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )''');
    } catch (err) {
      debugPrint("createUserTable(): $err");
    }
  }

  static Future<void> createAUserIdColumn(Database database) async {
    try {
      await database.execute('''
      ALTER TABLE $_provincesTable ADD COLUMN $_columnProvinceUserId INTEGER''');
    } catch (err) {
      debugPrint("createAUserIdColumn(): $err");
    }
  }

  static Future<Database> getDb() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (Database database, int version) async {
        await createUserTable(database);
        await createItemTable(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {},
    );
  }
}
