import '../../utils/imports.dart';

/// State object for the bike editing/addition screen.
class BikeEditState {
  /// Global key for the form used for validation.
  final GlobalKey<FormState> formKey;

  /// Controller for the registration plate input field.
  final TextEditingController registrationPlateController;

  /// Controller for the bike model input field.
  final TextEditingController modelController;

  /// Controller for the odometer reading input field.
  final TextEditingController odometerController;

  /// Controller for the daily price input field.
  final TextEditingController pricePerDayController;

  /// Controller for the monthly price input field.
  final TextEditingController pricePerMonthController;

  /// Cache of existing plates to check for duplicates.
  final Map<String, bool> existingPlates;

  /// Whether a save or load operation is in progress.
  final bool isLoading;

  /// Whether the screen is in editing mode (vs add mode).
  final bool isEditing;

  /// The registration plate of the bike when the screen was opened.
  final String? initialBikeRegistrationPlate;

  /// Error message to be displayed in the UI.
  final String? errorMessage;

  /// The bike object after a successful save operation.
  final Bike? savedBike;

  BikeEditState({
    required this.formKey,
    required this.registrationPlateController,
    required this.modelController,
    required this.odometerController,
    required this.pricePerDayController,
    required this.pricePerMonthController,
    this.existingPlates = const {},
    this.isLoading = false,
    required this.isEditing,
    this.initialBikeRegistrationPlate,
    this.errorMessage,
    this.savedBike,
  });

  /// Creates a copy of the state with specific fields updated.
  BikeEditState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? registrationPlateController,
    TextEditingController? modelController,
    TextEditingController? odometerController,
    TextEditingController? pricePerDayController,
    TextEditingController? pricePerMonthController,
    Map<String, bool>? existingPlates,
    bool? isLoading,
    bool? isEditing,
    String? initialBikeRegistrationPlate,
    String? errorMessage,
    bool clearErrorMessage = false,
    Bike? savedBike,
    bool clearSavedBike = false,
  }) {
    return BikeEditState(
      formKey: formKey ?? this.formKey,
      registrationPlateController:
          registrationPlateController ?? this.registrationPlateController,
      modelController: modelController ?? this.modelController,
      odometerController: odometerController ?? this.odometerController,
      pricePerDayController:
          pricePerDayController ?? this.pricePerDayController,
      pricePerMonthController:
          pricePerMonthController ?? this.pricePerMonthController,
      existingPlates: existingPlates ?? this.existingPlates,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      initialBikeRegistrationPlate:
          initialBikeRegistrationPlate ?? this.initialBikeRegistrationPlate,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      savedBike: clearSavedBike ? null : (savedBike ?? this.savedBike),
    );
  }
}

/// ViewModel for the [BikeEditScreen], managing form state and bike persistence.
class BikeEditViewModel extends StateNotifier<BikeEditState> {
  final Ref _ref;
  final Bike? _initialBike;
  late final AppValidators _validators;

  BikeService get _bikeService => _ref.read(bikeServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  BikeEditViewModel(this._ref, this._initialBike)
      : super(BikeEditState(
          formKey: GlobalKey<FormState>(),
          registrationPlateController: TextEditingController(
              text: _initialBike?.registrationPlate ?? ''),
          modelController:
              TextEditingController(text: _initialBike?.model ?? ''),
          odometerController: TextEditingController(
              text: _initialBike?.odometer.toString() ?? ''),
          pricePerDayController: TextEditingController(
              text: _initialBike?.pricePerDay.toString() ?? ''),
          pricePerMonthController: TextEditingController(
              text: _initialBike?.pricePerMonth.toString() ?? ''),
          isEditing: _initialBike != null,
          initialBikeRegistrationPlate: _initialBike?.registrationPlate,
        )) {
    _validators = AppValidators(_appStrings);
    _loadInitialData();
  }

  /// Loads the list of existing plates to prevent duplicate registration.
  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    try {
      final plates = await _bikeService.getExistingPlates();
      state = state.copyWith(existingPlates: plates, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: "${_appStrings.msgLoadFailed}: $e");
    }
  }

  /// Validation logic for the registration plate.
  String? validateRegistrationPlate(String? value) {
    return _validators.registrationPlate(
      value,
      existingPlates: state.existingPlates,
      isEditing: state.isEditing,
      initialPlate: state.initialBikeRegistrationPlate,
    );
  }

  /// Standard required field validation.
  String? validateRequiredField(String? value) {
    return _validators.requiredField(value);
  }

  /// Numeric field validation with optional requirement check.
  String? validateNumberField(String? value, {bool isRequired = true}) {
    return _validators.numberField(value, isRequired: isRequired);
  }

  /// Collects form data and saves the bike to the database.
  ///
  /// Returns true if the save was successful.
  Future<bool> saveBike() async {
    state = state.copyWith(clearErrorMessage: true, clearSavedBike: true);
    if (!state.formKey.currentState!.validate()) {
      return false;
    }

    state = state.copyWith(isLoading: true);
    try {
      final bikeToSave = Bike(
        registrationPlate: state.registrationPlateController.text,
        model: state.modelController.text,
        odometer: double.parse(state.odometerController.text),
        pricePerDay: double.parse(state.pricePerDayController.text),
        pricePerMonth: double.parse(state.pricePerMonthController.text),
        bikeStatus: _initialBike?.bikeStatus ?? BikeStatusConstants.garage,
        lastRentalId: _initialBike?.lastRentalId ?? '',
      );

      Bike? savedBikeResult;
      if (state.isEditing) {
        await _bikeService.updateBike(bikeToSave);
        savedBikeResult = bikeToSave;
      } else {
        await _bikeService.addBike(bikeToSave);
        savedBikeResult = bikeToSave;
      }
      state = state.copyWith(isLoading: false, savedBike: savedBikeResult);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: "${_appStrings.msgSaveBikeFailed}: $e");
      return false;
    }
  }

  /// Deletes the bike currently being edited.
  Future<bool> deleteBike() async {
    if (!state.isEditing || state.initialBikeRegistrationPlate == null) {
      state = state.copyWith(errorMessage: _appStrings.msgDeleteFailed);
      return false;
    }
    state = state.copyWith(
        isLoading: true, clearErrorMessage: true, clearSavedBike: true);
    try {
      await _bikeService.removeBike(state.initialBikeRegistrationPlate!);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: "${_appStrings.msgDeleteFailed}: $e");
      return false;
    }
  }

  @override
  void dispose() {
    state.registrationPlateController.dispose();
    state.modelController.dispose();
    state.odometerController.dispose();
    state.pricePerDayController.dispose();
    state.pricePerMonthController.dispose();
    super.dispose();
  }
}
