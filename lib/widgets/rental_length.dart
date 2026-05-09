import 'package:intl/intl.dart';

import '../utils/imports.dart';

/// A complex widget for selecting a rental date range and duration.
///
/// Provides dual date pickers for start and end dates, along with an
/// incrementable/decrementable text input for the number of rental days.
/// Automatically synchronizes dates when the duration changes and vice-versa.
class RentalLength extends ConsumerStatefulWidget {
  /// Initial start date.
  final DateTime? startDate;

  /// Initial end date.
  final DateTime? endDate;

  /// Callback triggered whenever the period is modified.
  final Function(DateTime startDate, DateTime endDate) onRentalPeriodChanged;

  const RentalLength({
    super.key,
    this.startDate,
    this.endDate,
    required this.onRentalPeriodChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RentalLengthState();
}

class _RentalLengthState extends ConsumerState<RentalLength> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _days;
  late final TextEditingController _daysController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    DateTime initialStartDate;
    DateTime initialEndDate;

    // Populate initial dates from props or defaults.
    if (widget.startDate != null) {
      initialStartDate = DateTime(
        widget.startDate!.year,
        widget.startDate!.month,
        widget.startDate!.day,
      );

      if (widget.endDate != null) {
        initialEndDate = DateTime(
          widget.endDate!.year,
          widget.endDate!.month,
          widget.endDate!.day,
        );
        if (initialEndDate.isBefore(initialStartDate)) {
          initialEndDate = initialStartDate.add(const Duration(days: 1));
        }
      } else {
        initialEndDate = initialStartDate.add(const Duration(days: 1));
      }
    } else {
      initialStartDate = DateTime.now();
      initialEndDate = initialStartDate.add(const Duration(days: 1));
    }

    _startDate = initialStartDate;
    _endDate = initialEndDate;
    _days = _calculateDays();

    _daysController = TextEditingController(text: _days.toString());
    _startDateController = TextEditingController(
        text: DateFormat('dd.MM.yyyy').format(_startDate));
    _endDateController =
        TextEditingController(text: DateFormat('dd.MM.yyyy').format(_endDate));

    _daysController.addListener(_onDaysTextChanged);
  }

  @override
  void dispose() {
    _daysController.removeListener(_onDaysTextChanged);
    _daysController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Synchronizes the end date when the number of days is changed via text input.
  void _onDaysTextChanged() {
    final value = _daysController.text;
    final newDays = int.tryParse(value);
    if (newDays != null && newDays >= 0 && newDays != _days) {
      setState(() {
        _days = newDays;
        _endDate = _startDate.add(Duration(days: _days));
        _endDateController.text = DateFormat('dd.MM.yyyy').format(_endDate);
      });
      widget.onRentalPeriodChanged(_startDate, _endDate);
    }
  }

  /// Calculates the integer difference in days between start and end dates.
  int _calculateDays() {
    final startUtc =
        DateTime.utc(_startDate.year, _startDate.month, _startDate.day);
    final endUtc = DateTime.utc(_endDate.year, _endDate.month, _endDate.day);
    if (startUtc.isAfter(endUtc)) {
      return 0;
    }
    return endUtc.difference(startUtc).inDays;
  }

  /// Updates the start date and adjusts end date/duration accordingly.
  void _updateStartDate(DateTime newStartDate) {
    final dateOnlyStartDate =
        DateTime(newStartDate.year, newStartDate.month, newStartDate.day);
    if (dateOnlyStartDate == _startDate) return;

    setState(() {
      _startDate = dateOnlyStartDate;
      _endDate = _startDate.add(Duration(days: _days));
      _days = _calculateDays();
      _daysController.text = _days.toString();
      _daysController.selection = TextSelection.fromPosition(
        TextPosition(offset: _daysController.text.length),
      );
      _startDateController.text = DateFormat('dd.MM.yyyy').format(_startDate);
      _endDateController.text = DateFormat('dd.MM.yyyy').format(_endDate);
    });
    widget.onRentalPeriodChanged(_startDate, _endDate);
  }

  /// Updates the end date and adjusts duration accordingly.
  void _updateEndDate(DateTime newEndDate) {
    final dateOnlyEndDate =
        DateTime(newEndDate.year, newEndDate.month, newEndDate.day);
    if (dateOnlyEndDate == _endDate) return;

    setState(() {
      _endDate = dateOnlyEndDate;
      _days = _calculateDays();
      _daysController.text = _days.toString();
      _daysController.selection = TextSelection.fromPosition(
        TextPosition(offset: _daysController.text.length),
      );
      _endDateController.text = DateFormat('dd.MM.yyyy').format(_endDate);
    });
    widget.onRentalPeriodChanged(_startDate, _endDate);
  }

  /// Increases the rental duration by one day.
  void _incrementDays() {
    setState(() {
      _days++;
      _daysController.text = _days.toString();
      _endDate = _startDate.add(Duration(days: _days));
      _endDateController.text = DateFormat('dd.MM.yyyy').format(_endDate);
    });
    widget.onRentalPeriodChanged(_startDate, _endDate);
  }

  /// Decreases the rental duration by one day.
  void _decrementDays() {
    if (_days > 0) {
      setState(() {
        _days--;
        _daysController.text = _days.toString();
        _endDate = _startDate.add(Duration(days: _days));
        _endDateController.text = DateFormat('dd.MM.yyyy').format(_endDate);
      });
      widget.onRentalPeriodChanged(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = ref.watch(localizationProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Start Date Picker.
            Expanded(
              child: TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: DateFormat('dd.MM.yyyy').format(_startDate),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  isDense: true,
                  suffixIcon: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _startDate) {
                        _updateStartDate(picked);
                      }
                    },
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 8),
            const Text('-', style: TextStyle(fontSize: 20.0)),
            const SizedBox(width: 8),
            // End Date Picker.
            Expanded(
              child: TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: DateFormat('dd.MM.yyyy').format(_endDate),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  isDense: true,
                  suffixIcon: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _endDate) {
                        _updateEndDate(picked);
                      }
                    },
                    child: const Icon(Icons.calendar_month),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Duration (Days) controller with +/- buttons.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                    labelText: appStrings!.labelDays,
                    border: const OutlineInputBorder(),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementDays,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementDays,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
