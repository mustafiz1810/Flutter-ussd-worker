// To parse this JSON data, do
//
//     final serviceSingleRequestResponse = serviceSingleRequestResponseFromJson(jsonString);

import 'dart:convert';

ServiceSingleRequestResponse serviceSingleRequestResponseFromJson(String str) => ServiceSingleRequestResponse.fromJson(json.decode(str));

String serviceSingleRequestResponseToJson(ServiceSingleRequestResponse data) => json.encode(data.toJson());

class ServiceSingleRequestResponse {
  bool? success;
  Data? data;
  String? message;

  ServiceSingleRequestResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ServiceSingleRequestResponse.fromJson(Map<String, dynamic> json) => ServiceSingleRequestResponse(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
