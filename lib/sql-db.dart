/*
import 'package:mysql1/mysql1.dart';

Future<void> testMySQLConnect() async {
  MySqlConnection? connection;

  try {
    final settings = ConnectionSettings(
      host: '192.168.12.128',
      port: 3306,
      user: 'Newuser',
      password: 'Newpassword1',
      db: 'EmissionDatabase',
    );

    connection = await MySqlConnection.connect(settings);

    final results = await connection.query('SELECT 1 + 1 AS result');
    for (var row in results) {
      print('Test Result: ${row['result']}');
    }
  } on MySqlException catch (e) {
    print('MySQL Error: ${e.message}');
  } finally {
    // Close the connection only if it was successfully established.
    if (connection != null) {
      await connection.close();
    }
  }
}
*/
