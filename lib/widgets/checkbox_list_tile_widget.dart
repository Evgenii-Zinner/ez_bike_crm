import '../utils/imports.dart';

/// A stylized [CheckboxListTile] that maintains its own internal check state.
///
/// Useful for forms where immediate visual feedback is needed while still
/// notifying the parent via [onChanged].
class CheckboxListTileWidget extends StatefulWidget {
  /// The label text for the checkbox.
  final String title;

  /// The initial checked status.
  final bool value;

  /// Callback triggered whenever the status is toggled.
  final ValueChanged<bool> onChanged;

  const CheckboxListTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CheckboxListTileWidget> createState() => _CheckboxListTileWidgetState();
}

class _CheckboxListTileWidgetState extends State<CheckboxListTileWidget> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: _isChecked,
      onChanged: (bool? newValue) {
        setState(() {
          _isChecked = newValue ?? false;
          widget.onChanged(_isChecked); // Notify the parent listener.
        });
      },
    );
  }
}
