// To parse this JSON data, do
//
//     final serviceRequestResponse = serviceRequestResponseFromJson(jsonString);

import 'dart:convert';

ServiceRequestResponse serviceRequestResponseFromJson(String str) => ServiceRequestResponse.fromJson(json.decode(str));

String serviceRequestResponseToJson(ServiceRequestResponse data) => json.encode(data.toJson());

class ServiceRequestResponse {
  bool? success;
  List<Datum>? data;
  String? message;

  ServiceRequestResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ServiceRequestResponse.fromJson(Map<String, dynamic> json) => ServiceRequestResponse(
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? mbName;
  String? trxType;
  String? mobileNumber;
  String? reference;
  int? amount;
  String? status;
  dynamic response;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.mbName,
    this.trxType,
    this.mobileNumber,
    this.reference,
    this.amount,
    this.status,
    this.response,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mbName: json["mb_name"],
    trxType: json["trx_type"],
    mobileNumber: json["mobile_number"],
    reference: json["reference"],
    amount: json["amount"],
    status: json["status"],
    response: json["response"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mb_name": mbName,
    "trx_type": trxType,
    "mobile_number": mobileNumber,
    "reference": reference,
    "amount": amount,
    "status": status,
    "response": response,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
