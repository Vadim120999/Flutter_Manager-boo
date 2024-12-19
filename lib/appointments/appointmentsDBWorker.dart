   import 'package:sqflite/sqflite.dart';
   import 'package:path_provider/path_provider.dart';

   class AppointmentsDBWorker {
     static final AppointmentsDBWorker db = AppointmentsDBWorker._();

     AppointmentsDBWorker._();

     Future<Database> get _database async {
       final directory = await getApplicationDocumentsDirectory();
       final path = '${directory.path}/appointments.db';

       return openDatabase(
         path,
         version: 1,
         onCreate: (db, version) {
           db.execute('''
             CREATE TABLE appointments (
               id INTEGER PRIMARY KEY,
               title TEXT,
               date TEXT
             )
           ''');
         },
       );
     }

     Future<int> create(Map<String, dynamic> data) async {
       final db = await _database;
       return await db.insert('appointments', data);
     }

   }
