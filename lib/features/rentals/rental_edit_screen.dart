import '../../utils/imports.dart';

/// Screen for creating or editing a bike rental transaction.
///
/// It allows users to select a bike and a customer, define the rental period,
/// and set the final price and deposit details.
class RentalEditScreen extends ConsumerWidget {
  final Rental? rental;
  final Bike? bike;

  const RentalEditScreen({super.key, this.rental, this.bike});

  /// Navigates to the [CustomerEditScreen] to create a new customer on the fly.
  void _navigateToAddCustomer(
      BuildContext context, RentalEditViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerEditScreen(customer: null),
      ),
    ).then((newCustomer) {
      if (newCustomer is Customer) {
        viewModel.newCustomerAdded(newCustomer);
      }
    });
  }

  /// Handles the deletion of the current rental record.
  ///
  /// Displays a confirmation dialog before calling the [viewModel] to delete.
  Future<void> _deleteRental(BuildContext context,
      RentalEditViewModel viewModel, AppLocalizations appStrings) async {
    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(appStrings.delete),
            content: Text(appStrings.msgConfirmDeleteRental),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(appStrings.cancel)),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(appStrings.delete),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete && context.mounted) {
      final success = await viewModel.deleteRental();
      if (success && context.mounted) {
        Navigator.pop(context);
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${appStrings.msgDeleteFailed}.}'),
              duration: const Duration(seconds: 3)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
        rentalEditViewModelProvider((rental: rental, bike: bike)).notifier);
    final state =
        ref.watch(rentalEditViewModelProvider((rental: rental, bike: bike)));
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.isLoading && state.allBikes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(appStrings.msgLoading)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing
            ? appStrings.screenEditRental
            : appStrings.screenAddRental),
      ),
      body: Form(
        key: state.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Bike picker for selecting which bike is being rented.
              if (state.allBikes.isNotEmpty)
                BikePicker(
                  bikes: state.allBikes,
                  selectedBike: state.selectedBike,
                  onBikeSelected: viewModel.selectBike,
                )
              else if (state.isLoading)
                Center(child: Text(appStrings.msgLoading))
              else
                Center(child: Text(appStrings.msgNoBikesAvailable)),
              const SizedBox(height: 16),
              // Customer picker for selecting or adding a customer.
              if (state.allCustomers.isNotEmpty)
                CustomerPicker(
                  customers: state.allCustomers,
                  selectedCustomer: state.selectedCustomer,
                  onCustomerSelected: viewModel.selectCustomer,
                  onAddCustomerPressed: () =>
                      _navigateToAddCustomer(context, viewModel),
                )
              else if (state.isLoading)
                Center(child: Text(appStrings.msgLoading))
              else
                Column(
                  children: [
                    Center(child: Text(appStrings.msgNoCustomersAvailable)),
                  ],
                ),
              const SizedBox(height: 16),
              // Rental period and duration selection.
              if (state.startDate != null && state.endDate != null)
                RentalLength(
                  startDate: state.startDate!,
                  endDate: state.endDate!,
                  onRentalPeriodChanged: viewModel.setRentalPeriod,
                ),
              const SizedBox(height: 16),
              // Input for final rental price.
              TextFormField(
                controller: state.finalPriceController,
                decoration: InputDecoration(
                  labelText: appStrings.labelFinalPrice,
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    viewModel.validatePriceField(value, isRequired: true),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              // Input for monetary deposit amount.
              TextFormField(
                controller: state.depositAmountController,
                decoration: InputDecoration(labelText: appStrings.labelDeposit),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    viewModel.validatePriceField(value, isRequired: false),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              // Toggle for indicating if a physical document was provided.
              CheckboxListTileWidget(
                title: appStrings.labelDocumentDepositProvided,
                value: state.documentDepositProvided,
                onChanged: viewModel.setDocumentDepositProvided,
              ),
              const SizedBox(height: 20),
              // Action buttons: Save, Cancel, and Delete (if editing).
              DSCButtons(
                isEditing: state.isEditing,
                onDeletePressed: () =>
                    _deleteRental(context, viewModel, appStrings),
                onCancelPressed: () => Navigator.pop(context),
                onSavePressed: () async {
                  final success = await viewModel.saveRental();
                  if (success && context.mounted) {
                    Navigator.pop(context);
                  } else if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(appStrings.msgRentFailed),
                          duration: const Duration(seconds: 3)),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
