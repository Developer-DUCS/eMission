import 'package:flutter/cupertino.dart';

final String tableCars = 'cars';

class CarFields {
  static final List<String> values = [
    /// Add all fields
    carID, owner, make, model, carName
  ];

  static final String carID = '_carID';
  static final String owner = 'owner';
  static final String make = 'make';
  static final String model = 'model';
  static final String carName = 'carName';
}

class Car {
  int? carID;
  int owner; // foreign key = userID
  String make;
  String model;
  String year;
  String? carName;

  Car({
    required this.owner,
    required this.make,
    required this.model,
    required this.year,
    this.carID,
    this.carName,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carID: json['carID'],
        owner: json['owner'],
        make: json['make'],
        model: json['model'],
        year: json['year'],
        carName: json['carName'],
      );

  Map<String, dynamic> toJson() => {
        'carID': carID,
        'owner': owner,
        'make': make,
        'model': model,
        'year': year,
        'carName': carName,
      };
}
