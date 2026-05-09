import '../../utils/imports.dart';

/// State for the [CustomerEditScreen].
///
/// Holds the controllers for the form fields and the current status of the
/// edit operation.
class CustomerEditState {
  /// The [GlobalKey] for the [Form] widget.
  final GlobalKey<FormState> formKey;

  /// The [TextEditingController] for the customer's name.
  final TextEditingController nameController;

  /// The [TextEditingController] for the customer's phone number.
  final TextEditingController phoneNumberController;

  /// The [TextEditingController] for the customer's address.
  final TextEditingController addressController;

  /// Whether the view model is currently performing a network request.
  final bool isLoading;

  /// Whether the screen is in editing mode (as opposed to creating a new customer).
  final bool isEditing;

  /// The original [Customer] object before any modifications.
  final Customer? initialCustomer;

  /// An error message to display if an operation fails.
  final String? errorMessage;

  /// The [Customer] object after it has been successfully saved.
  final Customer? savedCustomer;

  CustomerEditState({
    required this.formKey,
    required this.nameController,
    required this.phoneNumberController,
    required this.addressController,
    this.isLoading = false,
    required this.isEditing,
    this.initialCustomer,
    this.errorMessage,
    this.savedCustomer,
  });

  /// Creates a copy of the current state with the given fields replaced.
  CustomerEditState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? nameController,
    TextEditingController? phoneNumberController,
    TextEditingController? addressController,
    bool? isLoading,
    bool? isEditing,
    Customer? initialCustomer,
    String? errorMessage,
    bool clearErrorMessage = false,
    Customer? savedCustomer,
    bool clearSavedCustomer = false,
  }) {
    return CustomerEditState(
      formKey: formKey ?? this.formKey,
      nameController: nameController ?? this.nameController,
      phoneNumberController:
          phoneNumberController ?? this.phoneNumberController,
      addressController: addressController ?? this.addressController,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      initialCustomer: initialCustomer ?? this.initialCustomer,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      savedCustomer:
          clearSavedCustomer ? null : (savedCustomer ?? this.savedCustomer),
    );
  }
}

/// View model for the [CustomerEditScreen].
///
/// Manages the state of the customer edit form and handles the business logic
/// for saving and deleting customer records through the [CustomerService].
class CustomerEditViewModel extends StateNotifier<CustomerEditState> {
  final Ref _ref;
  late final AppValidators _validators;

  CustomerService get _customerService => _ref.read(customerServiceProvider);

  AppLocalizations get _appStrings => _ref.watch(localizationProvider)!;

  CustomerEditViewModel(this._ref, Customer? initialCustomer)
      : super(CustomerEditState(
          formKey: GlobalKey<FormState>(),
          nameController:
              TextEditingController(text: initialCustomer?.name ?? ''),
          phoneNumberController:
              TextEditingController(text: initialCustomer?.phoneNumber ?? ''),
          addressController:
              TextEditingController(text: initialCustomer?.address ?? ''),
          isEditing: initialCustomer != null,
          initialCustomer: initialCustomer,
        )) {
    _validators = AppValidators(_appStrings);
  }

  /// Validates that a field is not empty.
  String? validateRequiredField(String? value) {
    return _validators.requiredField(value);
  }

  /// Validates the format of a phone number.
  String? validatePhoneNumber(String? value) {
    return _validators.validatePhoneNumber(value);
  }

  /// Saves the customer details to the database.
  ///
  /// Updates the record if [isEditing] is true, otherwise adds a new customer.
  /// Returns `true` if the operation was successful.
  Future<bool> saveCustomer() async {
    state = state.copyWith(clearErrorMessage: true, clearSavedCustomer: true);
    if (!state.formKey.currentState!.validate()) {
      return false;
    }

    state = state.copyWith(isLoading: true);
    try {
      final customerToSave = Customer(
        customerId: state.initialCustomer?.customerId ?? '',
        name: state.nameController.text,
        phoneNumber: state.phoneNumberController.text,
        address: state.addressController.text,
      );

      Customer? savedCustomer;

      if (state.isEditing) {
        await _customerService.updateCustomer(customerToSave);
      } else {
        savedCustomer = await _customerService.addCustomer(customerToSave);
      }
      state = state.copyWith(isLoading: false, savedCustomer: savedCustomer);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage:
              "${_appStrings.msgSaveCustomerFailed}: ${e.toString()}");
      return false;
    }
  }

  /// Deletes the customer currently being edited.
  ///
  /// Returns `true` if the operation was successful.
  Future<bool> deleteCustomer() async {
    state = state.copyWith(
        isLoading: true, clearErrorMessage: true, clearSavedCustomer: true);
    try {
      await _customerService.removeCustomer(state.initialCustomer!.customerId);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage:
              "${_appStrings.msgSaveCustomerFailed}: ${e.toString()}");
      return false;
    }
  }

  @override
  void dispose() {
    state.nameController.dispose();
    state.phoneNumberController.dispose();
    state.addressController.dispose();
    super.dispose();
  }
}
