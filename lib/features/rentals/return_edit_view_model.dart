import 'package:intl/intl.dart';

import '../../utils/imports.dart';

/// Possible statuses for the [ReturnBikeScreen] processing.
enum ReturnBikeStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for the [ReturnBikeScreen].
///
/// Holds form controllers for return details, rental summary data, and
/// calculated overdue penalties.
class ReturnBikeState {
  /// Controller for the updated odometer reading.
  final TextEditingController odometerController;

  /// Read-only controller for the bike model.
  final TextEditingController bikeModelController;

  /// Read-only controller for the rental start date.
  final TextEditingController rentalStartDateController;

  /// Read-only controller for the scheduled rental end date.
  final TextEditingController rentalEndDateController;

  /// Read-only controller for the monetary deposit held.
  final TextEditingController depositController;

  /// Controller for the actual return date.
  final TextEditingController returnDateController;

  /// Read-only controller for the amount to be returned to the customer.
  final TextEditingController amountReturnedController;

  /// Controller for additional overdue payments.
  final TextEditingController overduePaymentController;

  /// The bike being returned.
  final Bike? initialBike;

  /// The specific rental record being closed.
  final Rental? lastRental;

  /// The currently selected return date.
  final DateTime selectedReturnDate;

  /// The current status of the return process.
  final ReturnBikeStatus status;

  /// Error message if processing failed.
  final String? errorMessage;

  /// Whether the bike is being returned after the scheduled end date.
  final bool isOverdue;

  /// Number of days by which the return is delayed.
  final int daysOverdue;

  /// Calculated additional amount the customer needs to pay.
  final double? amountToPay;

  /// Calculated amount of deposit to be refunded to the customer.
  final double? amountToReturn;

  /// Whether the user indicated that the bike requires maintenance work.
  final bool maintenanceNeeded;

  ReturnBikeState({
    required this.odometerController,
    required this.bikeModelController,
    required this.rentalStartDateController,
    required this.rentalEndDateController,
    required this.depositController,
    required this.returnDateController,
    required this.amountReturnedController,
    required this.overduePaymentController,
    this.initialBike,
    this.lastRental,
    required this.selectedReturnDate,
    this.status = ReturnBikeStatus.initial,
    this.errorMessage,
    this.isOverdue = false,
    this.daysOverdue = 0,
    this.amountToPay,
    this.amountToReturn,
    this.maintenanceNeeded = false,
  });

  /// Creates a copy of the state with specific fields updated.
  ReturnBikeState copyWith({
    TextEditingController? odometerController,
    TextEditingController? bikeModelController,
    TextEditingController? rentalStartDateController,
    TextEditingController? rentalEndDateController,
    TextEditingController? depositController,
    TextEditingController? returnDateController,
    TextEditingController? amountReturnedController,
    TextEditingController? overduePaymentController,
    Bike? initialBike,
    Rental? lastRental,
    DateTime? selectedReturnDate,
    ReturnBikeStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isOverdue,
    int? daysOverdue,
    double? amountToPay,
    double? amountToReturn,
    bool? maintenanceNeeded,
  }) {
    return ReturnBikeState(
      odometerController: odometerController ?? this.odometerController,
      bikeModelController: bikeModelController ?? this.bikeModelController,
      rentalStartDateController:
          rentalStartDateController ?? this.rentalStartDateController,
      rentalEndDateController:
          rentalEndDateController ?? this.rentalEndDateController,
      depositController: depositController ?? this.depositController,
      returnDateController: returnDateController ?? this.returnDateController,
      amountReturnedController:
          amountReturnedController ?? this.amountReturnedController,
      overduePaymentController:
          overduePaymentController ?? this.overduePaymentController,
      initialBike: initialBike ?? this.initialBike,
      lastRental: lastRental ?? this.lastRental,
      selectedReturnDate: selectedReturnDate ?? this.selectedReturnDate,
      status: status ?? this.status,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isOverdue: isOverdue ?? this.isOverdue,
      daysOverdue: daysOverdue ?? this.daysOverdue,
      amountToPay: amountToPay ?? this.amountToPay,
      amountToReturn: amountToReturn ?? this.amountToReturn,
      maintenanceNeeded: maintenanceNeeded ?? this.maintenanceNeeded,
    );
  }
}

/// ViewModel for the [ReturnBikeScreen].
///
/// Manages the logic for closing a rental, calculating overdue penalties,
/// and updating both the [Bike] and [Rental] records in the database.
class ReturnEditViewModel extends StateNotifier<ReturnBikeState> {
  final Ref _ref;
  final Bike _initialBike;
  late final AppValidators _validators;

  ReturnEditViewModel(this._ref, this._initialBike)
      : super(_initialState(_initialBike)) {
    _validators = AppValidators(_appStrings);
    loadInitialData();
  }

  /// Helper to create the initial state with controllers populated.
  static ReturnBikeState _initialState(Bike initialBike) {
    return ReturnBikeState(
      odometerController:
          TextEditingController(text: initialBike.odometer.toString()),
      bikeModelController: TextEditingController(text: initialBike.model),
      rentalStartDateController: TextEditingController(),
      rentalEndDateController: TextEditingController(),
      depositController: TextEditingController(),
      returnDateController: TextEditingController(
          text: DateFormat('dd.MM.yyyy').format(DateTime.now())),
      amountReturnedController: TextEditingController(),
      overduePaymentController: TextEditingController(),
      initialBike: initialBike,
      selectedReturnDate: DateTime.now(),
      status: ReturnBikeStatus.initial,
    );
  }

  RentalService get _rentalService => _ref.read(rentalServiceProvider);
  BikeService get _bikeService => _ref.read(bikeServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  /// Fetches the rental associated with the bike and sets up the form.
  Future<void> loadInitialData() async {
    state = state.copyWith(
        status: ReturnBikeStatus.loading, clearErrorMessage: true);
    try {
      if (_initialBike.lastRentalId.isEmpty) {
        state = state.copyWith(
          status: ReturnBikeStatus.failure,
          errorMessage: _appStrings.msgLoadFailed,
        );
        return;
      }

      final rental = await _rentalService.getRental(_initialBike.lastRentalId);

      if (rental != null) {
        state.rentalStartDateController.text =
            DateFormat('dd.MM.yyyy').format(rental.startDate);
        state.rentalEndDateController.text =
            DateFormat('dd.MM.yyyy').format(rental.endDate);
        state.depositController.text = rental.depositAmount.toStringAsFixed(0);

        _updateCalculatedValues(rental, state.selectedReturnDate);

        state = state.copyWith(
          lastRental: rental,
          status: ReturnBikeStatus.success,
        );
      } else {
        state = state.copyWith(
          status: ReturnBikeStatus.failure,
          errorMessage: _appStrings.msgLoadFailed,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ReturnBikeStatus.failure,
        errorMessage: '${_appStrings.msgLoadFailed}: $e',
      );
    }
  }

  /// Internal logic to calculate overdue days and monetary amounts.
  void _updateCalculatedValues(Rental rental, DateTime returnDate) {
    final isOverdue = returnDate.isAfter(rental.endDate);
    final deposit = rental.depositAmount;
    final daysOverdue =
        isOverdue ? returnDate.difference(rental.endDate).inDays : 0;

    // Simple penalty logic: daily price * number of overdue days.
    final amountToPay =
        isOverdue ? daysOverdue * _initialBike.pricePerDay : 0.0;
    double amountToReturn = !isOverdue ? deposit : (deposit - amountToPay);
    if (amountToReturn < 0) {
      amountToReturn = 0;
    }
    state = state.copyWith(
      isOverdue: isOverdue,
      daysOverdue: daysOverdue,
      amountToPay: amountToPay,
      amountToReturn: amountToReturn,
    );

    state.amountReturnedController.text = amountToReturn.toStringAsFixed(0);
    state.overduePaymentController.text = amountToPay.toStringAsFixed(0);
  }

  /// Opens the date picker and triggers value recalculation.
  Future<void> selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedReturnDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2075),
    );
    if (picked != null && picked != state.selectedReturnDate) {
      final newReturnDate = picked;
      state.returnDateController.text =
          DateFormat('dd.MM.yyyy').format(newReturnDate);

      state = state.copyWith(selectedReturnDate: newReturnDate);
      if (state.lastRental != null) {
        _updateCalculatedValues(state.lastRental!, newReturnDate);
      }
    }
  }

  /// Sets the maintenance required flag.
  void setMaintenanceNeeded(bool value) {
    state = state.copyWith(maintenanceNeeded: value);
  }

  /// Validation for numeric fields.
  String? validateNumberField(String? value, {bool isRequired = true}) {
    return _validators.numberField(value, isRequired: isRequired);
  }

  /// Validation for money fields.
  String? validatePriceField(String? value, {bool isRequired = true}) {
    return _validators.validateMoneyField(value, isRequired: isRequired);
  }

  /// Finalizes the return process by updating the bike and closing the rental.
  Future<bool> saveReturn(BuildContext context) async {
    state = state.copyWith(status: ReturnBikeStatus.loading);
    try {
      final newOdometer = double.tryParse(state.odometerController.text) ??
          _initialBike.odometer;

      // Update bike status based on user input (Maintenance vs Garage).
      final updatedBike = _initialBike.copyWith(
        odometer: newOdometer,
        bikeStatus: state.maintenanceNeeded
            ? BikeStatusConstants.maintenance
            : BikeStatusConstants.garage,
        lastRentalId: '',
      );
      await _bikeService.updateBike(updatedBike);

      // Update the rental record with return date and any penalty payments.
      double newFinalPrice = state.lastRental!.finalPrice +
          double.parse(state.overduePaymentController.text);
      final updatedRental = state.lastRental!.copyWith(
          returnDate: state.selectedReturnDate, finalPrice: newFinalPrice);
      await _rentalService.updateRental(updatedRental);

      state = state.copyWith(status: ReturnBikeStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ReturnBikeStatus.failure,
        errorMessage: '${_appStrings.msgReturnFailed}: $e',
      );
      return false;
    }
  }

  @override
  void dispose() {
    state.odometerController.dispose();
    state.bikeModelController.dispose();
    state.rentalStartDateController.dispose();
    state.rentalEndDateController.dispose();
    state.depositController.dispose();
    state.returnDateController.dispose();
    state.amountReturnedController.dispose();
    state.overduePaymentController.dispose();
    super.dispose();
  }
}
