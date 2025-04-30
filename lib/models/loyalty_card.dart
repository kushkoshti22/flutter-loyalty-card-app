import 'package:flutter/foundation.dart';

class LoyaltyCard {
  final int? id;
  final String name;
  final String cardNumber;
  final String barcode;
  final String? barcodeType;
  final DateTime expiryDate;
  final String? notes;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  LoyaltyCard({
    this.id,
    required this.name,
    required this.cardNumber,
    required this.barcode,
    this.barcodeType,
    required this.expiryDate,
    this.notes,
    this.imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cardNumber': cardNumber,
      'barcode': barcode,
      'barcodeType': barcodeType,
      'expiryDate': expiryDate.toIso8601String(),
      'notes': notes,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    return LoyaltyCard(
      id: map['id'],
      name: map['name'],
      cardNumber: map['cardNumber'],
      barcode: map['barcode'],
      barcodeType: map['barcodeType'],
      expiryDate: DateTime.parse(map['expiryDate']),
      notes: map['notes'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }

  LoyaltyCard copyWith({
    int? id,
    String? name,
    String? cardNumber,
    String? barcode,
    String? barcodeType,
    DateTime? expiryDate,
    String? notes,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return LoyaltyCard(
      id: id ?? this.id,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      barcode: barcode ?? this.barcode,
      barcodeType: barcodeType ?? this.barcodeType,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
