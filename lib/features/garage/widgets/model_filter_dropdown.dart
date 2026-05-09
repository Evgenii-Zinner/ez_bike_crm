import '../../../utils/imports.dart';

/// A dropdown widget for filtering the garage list by bike model.
class ModelFilterDropdown extends ConsumerWidget {
  /// The currently selected bike model.
  final String? selectedModel;

  /// List of all unique bike models available for selection.
  final List<String> availableModels;

  /// Callback triggered when a new model is selected.
  final ValueChanged<String?> onChanged;

  /// Callback triggered when the filter is cleared.
  final VoidCallback onClear;

  /// Whether the data is currently being loaded.
  final bool isLoading;

  const ModelFilterDropdown(
      {super.key,
      this.selectedModel,
      required this.availableModels,
      required this.onChanged,
      required this.onClear,
      this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);

    return AbsorbPointer(
      absorbing: isLoading && availableModels.isEmpty,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        icon: (isLoading && availableModels.isEmpty) || selectedModel != null
            ? const SizedBox.shrink()
            : const Icon(Icons.arrow_drop_down),
        value: selectedModel,
        items: availableModels
            .map((m) => DropdownMenuItem(
                value: m, child: Text(m, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (isLoading && availableModels.isEmpty) ? null : onChanged,
        decoration: InputDecoration(
            labelText: appStrings!.labelModel,
            hintText: isLoading ? appStrings.msgLoading : appStrings.labelModel,
            suffixIcon: selectedModel != null && !isLoading
                ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
                : null),
        disabledHint: isLoading ? Text(appStrings.msgLoading) : null,
      ),
    );
  }
}
