import '../../utils/imports.dart';

/// Screen for adding or editing a [Customer].
///
/// It provides a form to input customer details such as name, phone number,
/// and address. Uses [CustomerEditViewModel] to manage its state.
class CustomerEditScreen extends ConsumerWidget {
  /// The customer to edit. If null, the screen is in "Add Customer" mode.
  final Customer? customer;

  const CustomerEditScreen({super.key, this.customer});

  /// Handles the deletion of a customer.
  ///
  /// Displays a confirmation dialog before calling the [viewModel] to
  /// remove the customer record.
  Future<void> _handleDelete(
    BuildContext context,
    CustomerEditViewModel viewModel,
    AppLocalizations appStrings,
    WidgetRef ref,
  ) async {
    final currentState = ref.read(customerEditViewModelProvider(customer));
    if (!currentState.isEditing) return;

    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(appStrings.delete),
            content: Text(
                '${appStrings.msgConfirmDeleteCustomer} ${currentState.initialCustomer!.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(appStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(appStrings.delete),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete && context.mounted) {
      final success = await viewModel.deleteCustomer();
      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${currentState.initialCustomer!.name} ${appStrings.msgDeleteSuccess}')),
        );
      } else if (!success && context.mounted) {
        final latestState = ref.read(customerEditViewModelProvider(customer));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(latestState.errorMessage ??
                ' ${appStrings.msgDeleteFailed} ${currentState.initialCustomer!.name}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(customerEditViewModelProvider(customer).notifier);
    final screenState = ref.watch(customerEditViewModelProvider(customer));
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Listens for state changes to show error messages via SnackBar.
    ref.listen<CustomerEditState>(customerEditViewModelProvider(customer),
        (previous, next) {
      if (next.errorMessage != null &&
          (previous?.errorMessage != next.errorMessage ||
              previous?.isLoading == true && next.isLoading == false)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(next.errorMessage!),
                  duration: const Duration(seconds: 4)),
            );
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(screenState.isEditing
            ? appStrings.screenEditCustomer
            : appStrings.screenAddCustomer),
      ),
      body: AbsorbPointer(
        absorbing: screenState.isLoading,
        child: Form(
          key: screenState.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: screenState.nameController,
                  decoration: InputDecoration(
                    labelText: appStrings.labelName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => viewModel.validateRequiredField(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.phoneNumberController,
                  decoration: InputDecoration(
                    labelText: appStrings.labelPhoneNumber,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => viewModel.validatePhoneNumber(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.addressController,
                  decoration: InputDecoration(
                    labelText: appStrings.labelAddress,
                    border: const OutlineInputBorder(),
                  ),
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 24),
                if (screenState.isLoading)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  )),
                DSCButtons(
                  isEditing: screenState.isEditing,
                  onDeletePressed: () =>
                      _handleDelete(context, viewModel, appStrings, ref),
                  onCancelPressed: () => Navigator.pop(context),
                  onSavePressed: () async {
                    final success = await viewModel.saveCustomer();
                    if (success && context.mounted) {
                      Navigator.pop(
                          context,
                          ref
                              .read(customerEditViewModelProvider(customer))
                              .savedCustomer);
                    } else if (!success && context.mounted) {
                      final latestState =
                          ref.read(customerEditViewModelProvider(customer));
                      if (latestState.errorMessage == null) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(appStrings.msgSaveCustomerFailed),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                ),
                if (screenState.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
