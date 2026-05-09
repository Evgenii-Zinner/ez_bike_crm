import '../utils/imports.dart';

/// A standardized row of action buttons (Delete, Cancel, Save) used in edit screens.
///
/// Handles localization of button labels and conditional display of
/// the Delete button based on [isEditing] status.
class DSCButtons extends ConsumerWidget {
  /// Callback for the Delete action.
  final VoidCallback onDeletePressed;

  /// Callback for the Cancel action.
  final VoidCallback onCancelPressed;

  /// Callback for the Save/Update action.
  final VoidCallback onSavePressed;

  /// If true, the Delete button is visible.
  final bool isEditing;

  const DSCButtons({
    super.key,
    required this.onDeletePressed,
    required this.onCancelPressed,
    required this.onSavePressed,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing)
          ElevatedButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: onDeletePressed,
            child: Text(appStrings!.delete),
          ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onCancelPressed,
          child: Text(appStrings!.cancel),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onSavePressed,
          child: Text(isEditing ? appStrings.update : appStrings.create),
        ),
      ],
    );
  }
}
