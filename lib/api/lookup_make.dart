import 'package:flutter/services.dart';
import 'dart:convert';

class MakeLookupService {
  List<Map<String, dynamic>> makeData = [];

  MakeLookupService() {
    loadMakeData();
  }

  Future<void> loadMakeData() async {
    final String jsonContent =
        await rootBundle.loadString('assets/VehicleMakes.json');
    makeData = List<Map<String, dynamic>>.from(json.decode(jsonContent));
  }

  Future<String> lookupMakeId(String carMake) async {
    try {
      await loadMakeData();
      print(makeData);

      for (var makeEntry in makeData) {
        final attributes = makeEntry["data"]["attributes"];
        print(attributes);
        if (attributes["name"].toLowerCase() == carMake.toLowerCase()) {
          return(makeEntry["data"]["id"]);
        }
      }
    return '';
    }
     // Return an empty string if no match is found
    catch (e) {
    print('Error in lookupMakeId: $e');
    return ''; // Return an empty string in case of an error
    }
  }
}
