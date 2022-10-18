import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //fungsi membuat database
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE catatan(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      judul TEXT,
      jenis TEXT,
      penulis TEXT,
      penerbit TEXT,
      redaksi TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('catatan.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //add database
  static Future<int> addCatatan(String judul, String jenis, String penulis,
      String penerbit, String redaksi) async {
    final db = await SQLHelper.db();
    final data = {
      'judul': judul,
      'jenis': jenis,
      'penulis': penulis,
      'penerbit': penerbit,
      'redaksi': redaksi
    };
    return await db.insert('catatan', data);
  }

  //ambil data
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query('catatan');
  }

  //fungsi update data
  static Future<int> updateCatatan(int id, String judul, String jenis,
      String penulis, String penerbit, String redaksi) async {
    final db = await SQLHelper.db();

    final data = {
      'judul': judul,
      'jenis': jenis,
      'penulis': penulis,
      'penerbit': penerbit,
      'redaksi': redaksi
    };
    return await db.update('catatan', data, where: "id = $id");
  }

  //fungsi delete
  static Future<void> deleteCatatan(int id) async {
    final db = await SQLHelper.db();
    await db.delete('catatan', where: "id = $id");
  }
}
