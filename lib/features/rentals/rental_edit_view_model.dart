import '../../utils/imports.dart';

/// State for the [RentalEditScreen].
///
/// Holds form controllers, selection state, and the status of data loading.
class RentalEditState {
  /// The [GlobalKey] for the [Form] widget.
  final GlobalKey<FormState> formKey;

  /// Controller for the monetary deposit input field.
  final TextEditingController depositAmountController;

  /// Controller for the final price input field.
  final TextEditingController finalPriceController;

  /// Whether a physical document (like an ID) was provided as a deposit.
  final bool documentDepositProvided;

  /// The start date of the rental period.
  final DateTime? startDate;

  /// The scheduled end date of the rental period.
  final DateTime? endDate;

  /// The actual return date (if returned).
  final DateTime? returnDate;

  /// The bike selected for this rental.
  final Bike? selectedBike;

  /// The customer associated with this rental.
  final Customer? selectedCustomer;

  /// List of all available bikes for selection.
  final List<Bike> allBikes;

  /// List of all available customers for selection.
  final List<Customer> allCustomers;

  /// Whether the state is currently fetching initial data.
  final bool isLoading;

  /// Whether the screen is in editing mode (vs add mode).
  final bool isEditing;

  /// The original rental ID if editing an existing record.
  final String? initialRentalId;

  RentalEditState({
    required this.formKey,
    required this.depositAmountController,
    required this.finalPriceController,
    this.documentDepositProvided = false,
    this.startDate,
    this.endDate,
    this.returnDate,
    this.selectedBike,
    this.selectedCustomer,
    this.allBikes = const [],
    this.allCustomers = const [],
    this.isLoading = true,
    required this.isEditing,
    this.initialRentalId,
  });

  /// Creates a copy of the state with specific fields updated.
  RentalEditState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? depositAmountController,
    TextEditingController? finalPriceController,
    bool? documentDepositProvided,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? returnDate,
    Bike? selectedBike,
    Customer? selectedCustomer,
    List<Bike>? allBikes,
    List<Customer>? allCustomers,
    bool? isLoading,
    bool? isEditing,
    String? initialRentalId,
    bool clearSelectedBike = false,
    bool clearSelectedCustomer = false,
  }) {
    return RentalEditState(
      formKey: formKey ?? this.formKey,
      depositAmountController:
          depositAmountController ?? this.depositAmountController,
      finalPriceController: finalPriceController ?? this.finalPriceController,
      documentDepositProvided:
          documentDepositProvided ?? this.documentDepositProvided,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      returnDate: returnDate ?? this.returnDate,
      selectedBike:
          clearSelectedBike ? null : selectedBike ?? this.selectedBike,
      selectedCustomer: clearSelectedCustomer
          ? null
          : selectedCustomer ?? this.selectedCustomer,
      allBikes: allBikes ?? this.allBikes,
      allCustomers: allCustomers ?? this.allCustomers,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      initialRentalId: initialRentalId ?? this.initialRentalId,
    );
  }
}

/// ViewModel for the [RentalEditScreen], managing form logic and persistence.
class RentalEditViewModel extends StateNotifier<RentalEditState> {
  final Ref _ref;
  final Rental? _initialRental;
  final Bike? _initialBike;
  late final AppValidators _validators;

  RentalEditViewModel(this._ref, this._initialRental, this._initialBike)
      : super(RentalEditState(
          formKey: GlobalKey<FormState>(),
          depositAmountController: TextEditingController(),
          finalPriceController: TextEditingController(),
          isEditing: _initialRental != null,
          initialRentalId: _initialRental?.rentalId,
        )) {
    _validators = AppValidators(_appStrings);
    _loadRentalDetails();
  }

  BikeService get _bikeService => _ref.read(bikeServiceProvider);
  CustomerService get _customerService => _ref.read(customerServiceProvider);
  RentalService get _rentalService => _ref.read(rentalServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  /// Recalculates the estimated final price based on rental duration and bike rates.
  void updateFinalPrice() {
    if (state.selectedBike == null ||
        state.startDate == null ||
        state.endDate == null) {
      state.finalPriceController.text = "0";
      return;
    }

    final daysCount = state.endDate!.difference(state.startDate!).inDays;
    double price = 0;

    if (daysCount > 0) {
      if (state.selectedBike!.pricePerMonth > 0 && daysCount >= 30) {
        final fullMonths = daysCount ~/ 30;
        final remainingDays = daysCount % 30;
        price = (fullMonths * state.selectedBike!.pricePerMonth) +
            (remainingDays * state.selectedBike!.pricePerDay);
      } else {
        price = daysCount * state.selectedBike!.pricePerDay;
      }
    }
    state.finalPriceController.text = price.toStringAsFixed(0);
  }

  /// Initial setup of the form data by fetching bikes and customers.
  Future<void> _loadRentalDetails() async {
    state = state.copyWith(isLoading: true);
    try {
      final bikesMap = await _bikeService.getBikes();
      final customersMap = await _customerService.getCustomers();
      final allBikesList = bikesMap.values.toList();
      final allCustomersList = customersMap.values.toList();

      Bike? preSelectedBike;
      Customer? preSelectedCustomer;
      DateTime initialStartDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime initialEndDate = initialStartDate.add(const Duration(days: 1));
      bool initialDocDepositProvided = false;
      DateTime? initialReturnDate;
      String initialDepositAmount = "0";
      String initialFinalPrice = '0';

      if (_initialRental != null) {
        final rental = _initialRental;
        initialDepositAmount = rental.depositAmount.toString();
        initialFinalPrice = rental.finalPrice.toStringAsFixed(0);
        state.depositAmountController.text = rental.depositAmount.toString();
        state.finalPriceController.text = rental.finalPrice.toString();
        preSelectedBike = allBikesList
            .firstWhereOrNull((b) => b.registrationPlate == rental.bikeId);
        preSelectedCustomer = allCustomersList
            .firstWhereOrNull((c) => c.customerId == rental.customerId);
        initialStartDate = rental.startDate;
        initialEndDate = rental.endDate;
        initialDocDepositProvided = rental.documentDepositProvided;
        state = state.copyWith(
          documentDepositProvided: rental.documentDepositProvided,
          returnDate: rental.returnDate,
        );
      } else {
        if (_initialBike != null) {
          preSelectedBike = allBikesList.firstWhereOrNull(
              (b) => b.registrationPlate == _initialBike.registrationPlate);
        }
      }

      state.depositAmountController.text = initialDepositAmount;
      if (_initialRental != null) {
        state.finalPriceController.text = initialFinalPrice;
      }

      state = state.copyWith(
        allBikes: allBikesList,
        allCustomers: allCustomersList,
        selectedBike: preSelectedBike,
        selectedCustomer: preSelectedCustomer,
        startDate: initialStartDate,
        endDate: initialEndDate,
        documentDepositProvided: initialDocDepositProvided,
        returnDate: initialReturnDate,
        isLoading: false,
      );

      if (_initialRental == null) {
        updateFinalPrice();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Validation for currency input fields.
  String? validatePriceField(String? value, {bool isRequired = true}) {
    return _validators.validateMoneyField(value, isRequired: isRequired);
  }

  /// Selects a bike and recalculates the price.
  void selectBike(Bike? bike) {
    state = state.copyWith(selectedBike: bike);
    updateFinalPrice();
  }

  /// Selects a customer for the rental.
  void selectCustomer(Customer? customer) {
    state = state.copyWith(selectedCustomer: customer);
  }

  /// Updates the rental period and recalculates the price.
  void setRentalPeriod(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
    updateFinalPrice();
  }

  /// Updates the document deposit status.
  void setDocumentDepositProvided(bool value) {
    state = state.copyWith(documentDepositProvided: value);
  }

  /// Saves the rental transaction and updates bike status to 'Rented'.
  Future<bool> saveRental() async {
    if (!state.formKey.currentState!.validate()) {
      return false;
    }
    if (state.selectedBike == null ||
        state.selectedCustomer == null ||
        state.startDate == null ||
        state.endDate == null) {
      return false;
    }

    state = state.copyWith(isLoading: true);
    try {
      final rental = Rental(
        rentalId: state.initialRentalId ?? '',
        bikeId: state.selectedBike!.registrationPlate,
        customerId: state.selectedCustomer!.customerId,
        startDate: state.startDate!,
        endDate: state.endDate!,
        finalPrice: double.tryParse(state.finalPriceController.text) ?? 0,
        depositAmount: state.depositAmountController.text.isEmpty
            ? 0
            : double.tryParse(state.depositAmountController.text) ?? 0,
        paymentStatus: RentalStatusConstants.paid,
        documentDepositProvided: state.documentDepositProvided,
        returnDate: state.returnDate,
      );

      if (state.isEditing) {
        await _rentalService.updateRental(rental);
      } else {
        String createdRentalId = await _rentalService.addRental(rental);
        await _bikeService.updateBike(state.selectedBike!.copyWith(
            lastRentalId: createdRentalId,
            bikeStatus: BikeStatusConstants.rented));
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Deletes the current rental and moves the bike back to 'Garage' status.
  Future<bool> deleteRental() async {
    state = state.copyWith(isLoading: true);
    try {
      await _rentalService.removeRental(state.initialRentalId!);
      await _bikeService.updateBike(state.selectedBike!
          .copyWith(lastRentalId: '', bikeStatus: BikeStatusConstants.garage));
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Updates the customer list when a new customer is created in-screen.
  void newCustomerAdded(Customer newCustomer) {
    final updatedCustomers = List<Customer>.from(state.allCustomers)
      ..add(newCustomer);
    state = state.copyWith(
        allCustomers: updatedCustomers, selectedCustomer: newCustomer);
  }

  @override
  void dispose() {
    state.depositAmountController.dispose();
    state.finalPriceController.dispose();
    super.dispose();
  }
}
