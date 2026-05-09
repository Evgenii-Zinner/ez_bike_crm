import 'package:intl/intl.dart';

import '../../../utils/imports.dart';

/// A card widget that displays information about a single bike.
///
/// Shows the registration plate, model, current status, and relevant
/// action buttons (e.g., 'Rent Out', 'Return', 'Repair Done') based
/// on the bike's status.
class BikeCard extends ConsumerWidget {
  /// The bike data to display.
  final Bike bike;

  /// The expected return date if the bike is currently rented.
  final DateTime? endDate;

  /// Callback triggered when the 'Rent Out' action is pressed.
  final VoidCallback onRentOut;

  /// Callback triggered when the 'Return' action is pressed.
  final VoidCallback onReturnBike;

  /// Callback triggered when the 'Repair Done' action is pressed.
  final VoidCallback onRepairDone;

  const BikeCard({
    super.key,
    required this.bike,
    required this.endDate,
    required this.onRentOut,
    required this.onReturnBike,
    required this.onRepairDone,
  });

  /// Determines the card's visual styling and action labels based on bike status.
  Map<String, dynamic> _getCardData(Bike bike, DateTime? endDate,
      ColorScheme colorScheme, AppLocalizations appStrings) {
    final isOverdue = endDate != null && DateTime.now().isAfter(endDate);

    switch (bike.bikeStatus) {
      case BikeStatusConstants.garage:
        return {
          'cardColor': colorScheme.primaryContainer,
          'actionButtonText': appStrings.actionRentOut,
          'actionButtonCallback': onRentOut,
          'subtitleText':
              '${bike.model} | ${getLocalizedBikeStatus(bike.bikeStatus, appStrings)}',
        };
      case BikeStatusConstants.rented:
        return {
          'cardColor': isOverdue
              ? colorScheme.errorContainer
              : colorScheme.secondaryContainer,
          'textColor': isOverdue
              ? colorScheme.onErrorContainer
              : colorScheme.onSecondaryContainer,
          'actionButtonText': isOverdue
              ? appStrings.actionOverdue
              : appStrings.actionReturnBike,
          'actionButtonCallback': onReturnBike,
          'subtitleText':
              '${bike.model} | ${getLocalizedBikeStatus(bike.bikeStatus, appStrings)} | ${endDate != null ? DateFormat('dd.MM.yyyy').format(endDate) : appStrings.msgNoAvailable}',
        };
      case BikeStatusConstants.maintenance:
        return {
          'cardColor': colorScheme.surfaceContainer,
          'textColor': colorScheme.onSurface,
          'actionButtonText': appStrings.actionRepairDone,
          'actionButtonCallback': onRepairDone,
          'subtitleText':
              '${bike.model} | ${getLocalizedBikeStatus(bike.bikeStatus, appStrings)}',
        };
      default:
        return {
          'cardColor': colorScheme.surfaceContainerHighest,
          'textColor': colorScheme.onSurface,
          'actionButtonText': appStrings.actionRentOut,
          'actionButtonCallback': onRentOut,
          'subtitleText':
              '${bike.model} | ${getLocalizedBikeStatus(bike.bikeStatus, appStrings)}',
        };
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final cardData = _getCardData(bike, endDate, colorScheme, appStrings!);

    return Card(
      color: cardData['cardColor'],
      child: DefaultTextStyle(
        style: TextStyle(color: cardData['textColor']),
        child: ListTile(
          leading: EzCircleAvatar(
            name: bike.model,
            foregroundColor: Colors.black,
          ),
          title: Text(bike.registrationPlate,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(cardData['subtitleText']),
          trailing: ElevatedButton(
            onPressed: cardData['actionButtonCallback'],
            child: Text(cardData['actionButtonText']),
          ),
        ),
      ),
    );
  }
}
