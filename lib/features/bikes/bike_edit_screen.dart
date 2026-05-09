import '../../utils/imports.dart';

/// A screen that allows users to add a new bike or edit an existing one.
///
/// It captures details like registration plate, model, odometer, and pricing.
/// Uses [BikeEditViewModel] for state management and validation.
class BikeEditScreen extends ConsumerWidget {
  /// The bike being edited. If null, the screen operates in 'Add' mode.
  final Bike? bike;

  const BikeEditScreen({super.key, this.bike});

  /// Logic for deleting the bike currently being edited.
  ///
  /// Displays a confirmation dialog before proceeding with the deletion
  /// through the [viewModel].
  Future<void> _handleDelete(
    BuildContext context,
    BikeEditViewModel viewModel,
    AppLocalizations appStrings,
    WidgetRef ref,
  ) async {
    final currentState = ref.read(bikeEditViewModelProvider(bike));
    if (!currentState.isEditing) return;

    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(appStrings.delete),
            content: Text(
                '${appStrings.msgConfirmDeleteBike} (${currentState.initialBikeRegistrationPlate})?'),
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
      final success = await viewModel.deleteBike();
      if (success && context.mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${currentState.initialBikeRegistrationPlate} ${appStrings.msgDeleteSuccess}')),
        );
      } else if (!success && context.mounted) {
        final latestState = ref.read(bikeEditViewModelProvider(bike));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(latestState.errorMessage ??
                '${appStrings.msgDeleteFailed}: ${currentState.initialBikeRegistrationPlate}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bikeEditViewModelProvider(bike).notifier);
    final screenState = ref.watch(bikeEditViewModelProvider(bike));
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Listens for error state changes to show SnackBars.
    ref.listen<BikeEditState>(bikeEditViewModelProvider(bike),
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
            ? appStrings.screenEditBike
            : appStrings.screenAddBike),
      ),
      body: AbsorbPointer(
        absorbing: screenState.isLoading,
        child: Form(
          key: screenState.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: screenState.registrationPlateController,
                  decoration: InputDecoration(labelText: appStrings.labelPlate),
                  validator: viewModel.validateRegistrationPlate,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.modelController,
                  decoration: InputDecoration(labelText: appStrings.labelModel),
                  validator: (value) => viewModel.validateRequiredField(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.odometerController,
                  decoration:
                      InputDecoration(labelText: appStrings.labelOdometer),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  validator: (value) =>
                      viewModel.validateNumberField(value, isRequired: false),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.pricePerDayController,
                  decoration:
                      InputDecoration(labelText: appStrings.labelPricePerDay),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  validator: (value) =>
                      viewModel.validateNumberField(value, isRequired: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.pricePerMonthController,
                  decoration:
                      InputDecoration(labelText: appStrings.labelPricePerMonth),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  validator: (value) =>
                      viewModel.validateNumberField(value, isRequired: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                DSCButtons(
                  isEditing: screenState.isEditing,
                  onDeletePressed: () =>
                      _handleDelete(context, viewModel, appStrings, ref),
                  onCancelPressed: () => Navigator.pop(context),
                  onSavePressed: () async {
                    final success = await viewModel.saveBike();
                    if (success && context.mounted) {
                      Navigator.pop(context,
                          ref.read(bikeEditViewModelProvider(bike)).savedBike);
                    } else if (!success && context.mounted) {
                      final latestState =
                          ref.read(bikeEditViewModelProvider(bike));
                      if (latestState.errorMessage == null) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(appStrings.msgSaveBikeFailed),
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
