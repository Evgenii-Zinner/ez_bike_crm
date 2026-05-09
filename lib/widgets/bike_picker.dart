import '../utils/imports.dart';

/// A dropdown picker for selecting a [Bike] from a provided list.
///
/// Automatically sorts bikes by registration plate and manages
/// the matching of the [selectedBike] within the list.
class BikePicker extends ConsumerWidget {
  /// The list of bikes to pick from.
  final List<Bike> bikes;

  /// The currently selected bike.
  final Bike? selectedBike;

  /// Callback triggered when a new bike is selected.
  final Function(Bike?) onBikeSelected;

  const BikePicker({
    super.key,
    required this.bikes,
    required this.selectedBike,
    required this.onBikeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);

    // Sort bikes alphabetically by plate number for a consistent dropdown experience.
    bikes.sort((a, b) => a.registrationPlate.compareTo(b.registrationPlate));

    // Ensure the initial value correctly matches an object reference in the current list.
    final Bike? matchingBike = selectedBike != null
        ? bikes.firstWhereOrNull(
            (bike) => bike.registrationPlate == selectedBike!.registrationPlate,
          )
        : null;

    return DropdownButtonFormField<Bike>(
      value: matchingBike,
      decoration: InputDecoration(
        labelText: appStrings!.labelBike,
      ),
      hint: Text(appStrings.labelBike),
      items: bikes.map((Bike bike) {
        return DropdownMenuItem<Bike>(
          value: bike,
          child: Text('${bike.registrationPlate} - ${bike.model}'),
        );
      }).toList(),
      onChanged: onBikeSelected,
      validator: (value) => value == null ? appStrings.msgSelectBike : null,
    );
  }
}
