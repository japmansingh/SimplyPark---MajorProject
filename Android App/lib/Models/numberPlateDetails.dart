import 'package:flutter/material.dart';

class NumberPlateDetails {
  String ownerName;
  String registerationNumber;
  String model;
  String vehicleClass;
  String fuelType;
  String regDate;
  String chassisNumber;
  String engineNumber;
  String fitnessUpto;
  String insuranceExpiry;
  String registeringAuthority;

  NumberPlateDetails({this.ownerName, this.registerationNumber, this.model, this.vehicleClass, this.fuelType, this.regDate, this.chassisNumber, this.engineNumber, this.fitnessUpto, this.insuranceExpiry, this.registeringAuthority});

  NumberPlateDetails.fromJson(Map<String, dynamic> json) {
  ownerName = json['Owner Name'];
  registerationNumber = json['Registeration Number'];
  model = json['Model'];
  vehicleClass = json['Class'];
  fuelType = json['Fuel Type'];
  regDate = json['Reg Date'];
  chassisNumber = json['Chassis Number'];
  engineNumber = json['Engine Number'];
  fitnessUpto = json['Fitness Upto'];
  insuranceExpiry = json['Insurance expiry'];
  registeringAuthority = json['Registering Authority'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['Owner Name'] = this.ownerName;
  data['Registeration Number'] = this.registerationNumber;
  data['Model'] = this.model;
  data['Class'] = this.vehicleClass;
  data['Fuel Type'] = this.fuelType;
  data['Reg Date'] = this.regDate;
  data['Chassis Number'] = this.chassisNumber;
  data['Engine Number'] = this.engineNumber;
  data['Fitness Upto'] = this.fitnessUpto;
  data['Insurance expiry'] = this.insuranceExpiry;
  data['Registering Authority'] = this.registeringAuthority;
  return data;
  }
}