// To parse this JSON data, do
//
//     final numberPlateData = numberPlateDataFromJson(jsonString);

import 'dart:convert';

NumberPlateData numberPlateDataFromJson(String str) => NumberPlateData.fromJson(json.decode(str));

String numberPlateDataToJson(NumberPlateData data) => json.encode(data.toJson());

class NumberPlateData {
  NumberPlateData({
    this.description,
    this.registrationYear,
    this.carMake,
    this.carModel,
    this.variant,
    this.engineSize,
    this.makeDescription,
    this.modelDescription,
    this.numberOfSeats,
    this.vechileIdentificationNumber,
    this.engineNumber,
    this.fuelType,
    this.registrationDate,
    this.owner,
    this.fitness,
    this.insurance,
    this.pucc,
    this.vehicleType,
    this.location,
    this.imageUrl,
  });

  String description;
  String registrationYear;
  CarMake carMake;
  CarMake carModel;
  String variant;
  CarMake engineSize;
  CarMake makeDescription;
  CarMake modelDescription;
  CarMake numberOfSeats;
  String vechileIdentificationNumber;
  String engineNumber;
  CarMake fuelType;
  String registrationDate;
  String owner;
  String fitness;
  String insurance;
  String pucc;
  String vehicleType;
  String location;
  String imageUrl;

  factory NumberPlateData.fromJson(Map<String, dynamic> json) => NumberPlateData(
    description: json["Description"],
    registrationYear: json["RegistrationYear"],
    carMake: CarMake.fromJson(json["CarMake"]),
    carModel: CarMake.fromJson(json["CarModel"]),
    variant: json["Variant"],
    engineSize: CarMake.fromJson(json["EngineSize"]),
    makeDescription: CarMake.fromJson(json["MakeDescription"]),
    modelDescription: CarMake.fromJson(json["ModelDescription"]),
    numberOfSeats: CarMake.fromJson(json["NumberOfSeats"]),
    vechileIdentificationNumber: json["VechileIdentificationNumber"],
    engineNumber: json["EngineNumber"],
    fuelType: CarMake.fromJson(json["FuelType"]),
    registrationDate: json["RegistrationDate"],
    owner: json["Owner"],
    fitness: json["Fitness"],
    insurance: json["Insurance"],
    pucc: json["PUCC"],
    vehicleType: json["VehicleType"],
    location: json["Location"],
    imageUrl: json["ImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "Description": description,
    "RegistrationYear": registrationYear,
    "CarMake": carMake.toJson(),
    "CarModel": carModel.toJson(),
    "Variant": variant,
    "EngineSize": engineSize.toJson(),
    "MakeDescription": makeDescription.toJson(),
    "ModelDescription": modelDescription.toJson(),
    "NumberOfSeats": numberOfSeats.toJson(),
    "VechileIdentificationNumber": vechileIdentificationNumber,
    "EngineNumber": engineNumber,
    "FuelType": fuelType.toJson(),
    "RegistrationDate": registrationDate,
    "Owner": owner,
    "Fitness": fitness,
    "Insurance": insurance,
    "PUCC": pucc,
    "VehicleType": vehicleType,
    "Location": location,
    "ImageUrl": imageUrl,
  };
}

class CarMake {
  CarMake({
    this.currentTextValue,
  });

  String currentTextValue;

  factory CarMake.fromJson(Map<String, dynamic> json) => CarMake(
    currentTextValue: json["CurrentTextValue"],
  );

  Map<String, dynamic> toJson() => {
    "CurrentTextValue": currentTextValue,
  };
}
