import '../../../utils/imports.dart';

/// A dropdown widget for filtering the garage list by bike status.
class StatusFilterDropdown extends ConsumerWidget {
  /// The currently selected bike status.
  final String? selectedStatus;

  /// List of all unique bike statuses available for selection.
  final List<String> availableStatuses;

  /// Callback triggered when a new status is selected.
  final ValueChanged<String?> onChanged;

  /// Callback triggered when the filter is cleared.
  final VoidCallback onClear;

  /// Whether the data is currently being loaded.
  final bool isLoading;

  const StatusFilterDropdown(
      {super.key,
      this.selectedStatus,
      required this.availableStatuses,
      required this.onChanged,
      required this.onClear,
      this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);
    return AbsorbPointer(
      absorbing: isLoading && availableStatuses.isEmpty,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        icon: (isLoading && availableStatuses.isEmpty) || selectedStatus != null
            ? const SizedBox.shrink()
            : const Icon(Icons.arrow_drop_down),
        value: selectedStatus,
        items: availableStatuses
            .map((s) => DropdownMenuItem(
                value: s,
                child: Text(getLocalizedBikeStatus(s, appStrings!),
                    overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (isLoading && availableStatuses.isEmpty) ? null : onChanged,
        decoration: InputDecoration(
            labelText: appStrings!.labelStatus,
            hintText:
                isLoading ? appStrings.msgLoading : appStrings.labelStatus,
            suffixIcon: selectedStatus != null && !isLoading
                ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
                : null),
        disabledHint: isLoading ? Text(appStrings.msgLoading) : null,
      ),
    );
  }
}
