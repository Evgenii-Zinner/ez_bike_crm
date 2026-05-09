import '../../utils/imports.dart';

/// Constants representing the possible statuses of a bike.
class BikeStatusConstants {
  static const String garage = 'Garage';
  static const String rented = 'Rented';
  static const String maintenance = 'Maintenance';
  static const String unknown = 'Unknown';
}

/// Returns a localized string for the given bike [statusConstant].
String getLocalizedBikeStatus(
    String statusConstant, AppLocalizations appStrings) {
  switch (statusConstant) {
    case BikeStatusConstants.garage:
      return appStrings.bikeStatusGarage;
    case BikeStatusConstants.rented:
      return appStrings.bikeStatusRented;
    case BikeStatusConstants.maintenance:
      return appStrings.bikeStatusMaintenance;
    case BikeStatusConstants.unknown:
    default:
      return appStrings.bikeStatusUnknown;
  }
}

/// Data model representing a bike in the fleet.
class Bike extends Equatable {
  /// Unique identifier (usually the license plate).
  final String registrationPlate;

  /// The model/manufacturer of the bike.
  final String model;

  /// Current odometer reading in kilometers.
  final double odometer;

  /// Standard rental price per day.
  final double pricePerDay;

  /// Standard rental price per month (long-term).
  final double pricePerMonth;

  /// Current availability status (see [BikeStatusConstants]).
  final String bikeStatus;

  /// ID of the most recent rental transaction.
  final String lastRentalId;

  const Bike({
    required this.registrationPlate,
    required this.model,
    required this.odometer,
    required this.pricePerDay,
    required this.pricePerMonth,
    required this.bikeStatus,
    required this.lastRentalId,
  });

  Map<String, dynamic> toJson() => {
        'registrationPlate': registrationPlate,
        'model': model,
        'odometer': odometer,
        'pricePerDay': pricePerDay,
        'pricePerMonth': pricePerMonth,
        'bikeStatus': bikeStatus,
        'lastRentalId': lastRentalId,
      };

  factory Bike.fromJson(Map<String, dynamic> json) => Bike(
        registrationPlate: json['registrationPlate'],
        model: json['model'],
        odometer: (json['odometer'] as num?)?.toDouble() ?? 0.0,
        pricePerDay: (json['pricePerDay'] as num).toDouble(),
        pricePerMonth: (json['pricePerMonth'] as num).toDouble(),
        bikeStatus: json['bikeStatus'],
        lastRentalId: json['lastRentalId'],
      );

  Bike copyWith({
    String? registrationPlate,
    String? model,
    double? odometer,
    double? pricePerDay,
    double? pricePerMonth,
    String? bikeStatus,
    String? lastRentalId,
  }) {
    return Bike(
      registrationPlate: registrationPlate ?? this.registrationPlate,
      model: model ?? this.model,
      odometer: odometer ?? this.odometer,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      bikeStatus: bikeStatus ?? this.bikeStatus,
      lastRentalId: lastRentalId ?? this.lastRentalId,
    );
  }

  @override
  List<Object?> get props => [
        registrationPlate,
        model,
        odometer,
        pricePerDay,
        pricePerMonth,
        bikeStatus,
        lastRentalId,
      ];
}
