import '../../utils/imports.dart';

/// Screen for processing the return of a rented bike.
///
/// It displays summary details of the active rental and allows users to
/// record the actual return date, updated odometer reading, and whether
/// the bike needs maintenance.
class ReturnBikeScreen extends ConsumerWidget {
  /// The bike being returned.
  final Bike bike;

  const ReturnBikeScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(returnEditViewModelProvider(bike).notifier);
    final state = ref.watch(returnEditViewModelProvider(bike));
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget body;

    // UI builder based on current processing status.
    switch (state.status) {
      case ReturnBikeStatus.loading:
      case ReturnBikeStatus.initial:
        body = const Center(child: CircularProgressIndicator());
        break;
      case ReturnBikeStatus.failure:
        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage ?? appStrings.msgLoadFailed),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.loadInitialData,
                child: Text(appStrings.btnRetry),
              ),
            ],
          ),
        );
        break;
      case ReturnBikeStatus.success:
        body = SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Read-only display of bike model.
                TextFormField(
                  controller: state.bikeModelController,
                  decoration: InputDecoration(
                    enabled: false,
                    labelText: appStrings.labelModel,
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                // Read-only display of planned rental period.
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: state.rentalStartDateController,
                        decoration: InputDecoration(
                          enabled: false,
                          labelText: appStrings.labelStartDate,
                        ),
                        readOnly: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('-'),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: state.rentalEndDateController,
                        decoration: InputDecoration(
                          enabled: false,
                          labelText: appStrings.labelEndDate,
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Read-only display of the held deposit.
                TextFormField(
                  controller: state.depositController,
                  decoration: InputDecoration(
                    enabled: false,
                    labelText: appStrings.labelDeposit,
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                // Input for current odometer reading.
                TextFormField(
                  controller: state.odometerController,
                  decoration: InputDecoration(
                    labelText: appStrings.labelOdometer,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      viewModel.validateNumberField(value, isRequired: false),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                // Input for actual return date.
                TextFormField(
                  controller: state.returnDateController,
                  decoration: InputDecoration(
                    labelText: appStrings.labelActualReturnDate,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => viewModel.selectReturnDate(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => viewModel.selectReturnDate(context),
                ),
                const SizedBox(height: 16),
                // Warning displayed if the return is overdue.
                if (state.isOverdue)
                  Text(
                    '${appStrings.msgDelayedReturn} ${state.daysOverdue} ${appStrings.msgDelayedDays}',
                    style: const TextStyle(color: Colors.red),
                  ),
                if (state.isOverdue) const SizedBox(height: 16),
                // Calculation of how much deposit to return to customer.
                Text(
                  "${appStrings.msgCustomerShouldGetBack} ${state.amountToReturn?.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (state.isOverdue) const SizedBox(height: 16),
                // Input for additional payment in case of overdue returns.
                if (state.isOverdue)
                  TextFormField(
                    controller: state.overduePaymentController,
                    decoration: InputDecoration(
                        labelText: appStrings.labelOverduePayment),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        viewModel.validatePriceField(value, isRequired: true),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                const SizedBox(height: 16),
                // Checkbox to mark if the bike requires maintenance work.
                Row(
                  children: [
                    Checkbox(
                      value: state.maintenanceNeeded,
                      onChanged: (bool? value) {
                        viewModel.setMaintenanceNeeded(value ?? false);
                      },
                    ),
                    Text(appStrings.labelMaintenanceNeeded),
                  ],
                ),
                const SizedBox(height: 24),
                // Save and Cancel buttons.
                DSCButtons(
                  isEditing: false,
                  onDeletePressed: () {},
                  onCancelPressed: () {
                    Navigator.pop(context);
                  },
                  onSavePressed: () async {
                    final success = await viewModel.saveReturn(context);
                    if (success && context.mounted) {
                      Navigator.pop(context);
                    } else if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(appStrings.msgReturnFailed),
                            duration: const Duration(seconds: 3)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );

        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.screenReturnBike),
      ),
      body: body,
    );
  }
}
