import '../../../utils/imports.dart';

/// A text input field for filtering the garage list by registration plate number.
class PlateNumberFilterInput extends ConsumerWidget {
  /// The [TextEditingController] for the input field.
  final TextEditingController controller;

  /// The current value of the filter as stored in the state.
  final String currentFilterValue;

  /// Callback triggered whenever the input text changes.
  final ValueChanged<String> onChanged;

  /// Callback triggered when the clear button is pressed.
  final VoidCallback onClear;

  const PlateNumberFilterInput(
      {super.key,
      required this.controller,
      required this.currentFilterValue,
      required this.onChanged,
      required this.onClear});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);

    return TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: appStrings!.labelPlate,
            suffixIcon: currentFilterValue.isNotEmpty
                ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
                : null),
        onChanged: onChanged);
  }
}
