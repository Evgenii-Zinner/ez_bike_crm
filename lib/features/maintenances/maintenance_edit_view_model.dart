import 'package:intl/intl.dart';

import '../../utils/imports.dart';

/// Possible statuses for the [MaintenanceEditScreen] operations.
enum MaintenanceEditStatus {
  idle,
  loadingInitial,
  saving,
  deleting,
}

/// State for the [MaintenanceEditScreen].
///
/// Holds form controllers, selection state, and the status of data loading.
class MaintenanceEditState {
  /// The [GlobalKey] for the [Form] widget.
  final GlobalKey<FormState> formKey;

  /// Controller for the price input field.
  final TextEditingController priceController;

  /// Controller for the description of parts/work.
  final TextEditingController partsController;

  /// Controller for the maintenance date input field.
  final TextEditingController dateController;

  /// The currently selected maintenance date.
  final DateTime selectedDate;

  /// The bike for which the maintenance is being logged.
  final Bike? selectedBike;

  /// List of all available bikes for the picker.
  final List<Bike> allBikes;

  /// Whether a network request or data loading is in progress.
  final bool isLoading;

  /// Whether the screen is in editing mode (vs add mode).
  final bool isEditing;

  /// The original maintenance ID if editing an existing record.
  final String? initialMaintenanceId;

  /// Error message to display in the UI.
  final String? errorMessage;

  MaintenanceEditState({
    required this.formKey,
    required this.priceController,
    required this.partsController,
    required this.dateController,
    required this.selectedDate,
    this.selectedBike,
    this.allBikes = const [],
    this.isLoading = true,
    required this.isEditing,
    this.initialMaintenanceId,
    this.errorMessage,
  });

  /// Creates a copy of the current state with the given fields replaced.
  MaintenanceEditState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? priceController,
    TextEditingController? partsController,
    TextEditingController? dateController,
    DateTime? selectedDate,
    Bike? selectedBike,
    bool clearSelectedBike = false,
    List<Bike>? allBikes,
    bool? isLoading,
    bool? isEditing,
    String? initialMaintenanceId,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MaintenanceEditState(
      formKey: formKey ?? this.formKey,
      priceController: priceController ?? this.priceController,
      partsController: partsController ?? this.partsController,
      dateController: dateController ?? this.dateController,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedBike:
          clearSelectedBike ? null : (selectedBike ?? this.selectedBike),
      allBikes: allBikes ?? this.allBikes,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      initialMaintenanceId: initialMaintenanceId ?? this.initialMaintenanceId,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// View model for the [MaintenanceEditScreen].
///
/// Manages form logic, handles bike selection, and performs CRUD operations
/// for [Maintenance] records through the [MaintenanceService].
class MaintenanceEditViewModel extends StateNotifier<MaintenanceEditState> {
  final Ref _ref;
  final Maintenance? _initialMaintenance;
  final Bike? _bike;
  late final AppValidators _validators;

  MaintenanceService get _maintenanceService =>
      _ref.read(maintenanceServiceProvider);
  BikeService get _bikeService => _ref.read(bikeServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  MaintenanceEditViewModel(this._ref, this._initialMaintenance, this._bike)
      : super(MaintenanceEditState(
          formKey: GlobalKey<FormState>(),
          priceController: TextEditingController(),
          partsController: TextEditingController(),
          dateController: TextEditingController(
            text: DateFormat('dd.MM.yyyy').format(
              _initialMaintenance?.date ?? DateTime.now(),
            ),
          ),
          selectedDate: _initialMaintenance?.date ?? DateTime.now(),
          selectedBike: _bike,
          isEditing: _initialMaintenance != null,
          initialMaintenanceId: _initialMaintenance?.maintenanceId,
        )) {
    _loadMaintenanceDetails();
    _validators = AppValidators(_appStrings);
  }

  /// Loads the bike list and populates form fields if in editing mode.
  Future<void> _loadMaintenanceDetails() async {
    state = state.copyWith(isLoading: true);
    try {
      final bikesMap = await _bikeService.getBikes();
      final allBikesList = bikesMap.values.toList();
      Bike? preSelectedBike = state.selectedBike;
      DateTime currentDate = state.selectedDate;

      if (_initialMaintenance != null) {
        final maintenance = _initialMaintenance;
        state.partsController.text = maintenance.parts;
        state.priceController.text = maintenance.price.toString();
        currentDate = maintenance.date;
      }
      if (allBikesList.isNotEmpty) {
        preSelectedBike = allBikesList.firstWhereOrNull(
            (b) => b.registrationPlate == _bike?.registrationPlate);
      }

      state.dateController.text = DateFormat('dd.MM.yyyy').format(currentDate);

      state = state.copyWith(
        allBikes: allBikesList,
        selectedBike: preSelectedBike,
        selectedDate: currentDate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: "${_appStrings.msgLoadFailed}: ${e.toString()}");
    }
  }

  /// Updates the currently selected bike for the maintenance log.
  void selectBike(Bike? bike) {
    state = state.copyWith(selectedBike: bike, clearErrorMessage: true);
  }

  /// Updates the maintenance date.
  void selectDate(DateTime date) {
    state.dateController.text = DateFormat('dd.MM.yyyy').format(date);
    state = state.copyWith(selectedDate: date, clearErrorMessage: true);
  }

  /// Validation for required text fields.
  String? validateRequiredField(String? value) {
    return _validators.requiredField(value);
  }

  /// Validation for currency/price fields.
  String? validatePriceField(String? value) {
    return _validators.validateMoneyField(value);
  }

  /// Saves the maintenance record to the database.
  ///
  /// If the bike was in 'Maintenance' status, it moves it back to 'Garage'
  /// upon completion of the log. Returns true if successful.
  Future<bool> saveMaintenance() async {
    state = state.copyWith(clearErrorMessage: true);
    if (!state.formKey.currentState!.validate()) {
      return false;
    }

    if (state.selectedBike == null) {
      state = state.copyWith(errorMessage: _appStrings.msgSelectBike);
      return false;
    }

    state = state.copyWith(isLoading: true);
    try {
      final maintenance = Maintenance(
        maintenanceId: state.initialMaintenanceId ?? '',
        bikeId: state.selectedBike!.registrationPlate,
        date: state.selectedDate,
        parts: state.partsController.text,
        price: double.parse(state.priceController.text),
      );

      if (state.isEditing) {
        await _maintenanceService.updateMaintenance(maintenance);
      } else {
        await _maintenanceService.addMaintenance(maintenance);
      }

      // Automatic status update: if a bike is marked done with repair, move to garage.
      if (state.selectedBike!.bikeStatus == BikeStatusConstants.maintenance) {
        await _bikeService.updateBike(state.selectedBike!
            .copyWith(bikeStatus: BikeStatusConstants.garage));
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage:
              "${_appStrings.msgSaveMaintenanceFailed}: ${e.toString()}");
      return false;
    }
  }

  /// Deletes the maintenance record currently being edited.
  Future<bool> deleteMaintenance() async {
    if (!state.isEditing || state.initialMaintenanceId == null) {
      return false;
    }
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      await _maintenanceService.removeMaintenance(state.initialMaintenanceId!);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage:
              "${_appStrings.msgDeleteFailed}: ${state.initialMaintenanceId}");
      return false;
    }
  }

  @override
  void dispose() {
    state.priceController.dispose();
    state.partsController.dispose();
    state.dateController.dispose();
    super.dispose();
  }
}
