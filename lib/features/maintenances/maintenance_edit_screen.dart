import '../../utils/imports.dart';

/// A screen for creating or editing maintenance records for bikes.
///
/// It allows users to select a bike, set the maintenance date, describe parts/work done,
/// and record the price. It handles both "Add" and "Edit" modes.
class MaintenanceEditScreen extends ConsumerWidget {
  /// The maintenance record being edited. If null, the screen is in "Add" mode.
  final Maintenance? maintenance;

  /// A pre-selected bike if navigating from a specific bike's action.
  final Bike? bike;

  const MaintenanceEditScreen({super.key, this.maintenance, this.bike});

  /// Handles the deletion of the current maintenance record.
  ///
  /// Displays a confirmation dialog before calling the [viewModel] to delete.
  Future<void> _handleDelete(
    BuildContext context,
    MaintenanceEditViewModel viewModel,
    AppLocalizations appStrings,
    WidgetRef ref,
  ) async {
    final currentState = ref.read(maintenanceEditViewModelProvider(
        (maintenance: maintenance, bike: bike)));
    if (!currentState.isEditing) return;

    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(appStrings.delete),
            content: Text('${appStrings.msgConfirmDeleteMaintenance}?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(appStrings.cancel)),
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
      final success = await viewModel.deleteMaintenance();
      if (success && context.mounted) {
        Navigator.pop(context);
      } else if (!success && context.mounted) {
        final latestState = ref.read(maintenanceEditViewModelProvider(
            (maintenance: maintenance, bike: bike)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(latestState.errorMessage ?? appStrings.msgDeleteFailed),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
        maintenanceEditViewModelProvider((maintenance: maintenance, bike: bike))
            .notifier);
    final screenState = ref.watch(maintenanceEditViewModelProvider(
        (maintenance: maintenance, bike: bike)));
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (screenState.isLoading &&
        screenState.allBikes.isEmpty &&
        screenState.initialMaintenanceId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(appStrings.msgLoading)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (screenState.errorMessage != null && !screenState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted &&
            ref
                    .read(maintenanceEditViewModelProvider(
                        (maintenance: maintenance, bike: bike)))
                    .errorMessage !=
                null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(screenState.errorMessage!),
              duration: const Duration(seconds: 4)));
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(screenState.isEditing
            ? appStrings.screenAddMaintenance
            : appStrings.screenAddMaintenance),
      ),
      body: AbsorbPointer(
        absorbing: screenState.isLoading,
        child: Form(
          key: screenState.formKey,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (screenState.allBikes.isNotEmpty)
                  BikePicker(
                    bikes: screenState.allBikes,
                    selectedBike: screenState.selectedBike,
                    onBikeSelected: viewModel.selectBike,
                  )
                else if (screenState.isLoading)
                  Center(child: Text(appStrings.msgLoading))
                else
                  Center(child: Text(appStrings.msgNoBikesAvailable)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: appStrings.labelDate,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    isDense: true,
                    suffixIcon: InkWell(
                      onTap: screenState.isLoading
                          ? null
                          : () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: screenState.selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null &&
                                  picked != screenState.selectedDate) {
                                viewModel.selectDate(picked);
                              }
                            },
                      child: const Icon(Icons.calendar_today),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  validator: (value) => viewModel.validateRequiredField(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.partsController,
                  decoration: InputDecoration(labelText: appStrings.labelParts),
                  maxLines: 3,
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: screenState.priceController,
                  decoration: InputDecoration(labelText: appStrings.labelPrice),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => viewModel.validatePriceField(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !screenState.isLoading,
                ),
                const SizedBox(height: 24),
                if (screenState.isLoading)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )),
                DSCButtons(
                  isEditing: screenState.isEditing,
                  onDeletePressed: () =>
                      _handleDelete(context, viewModel, appStrings, ref),
                  onCancelPressed: () => Navigator.pop(context),
                  onSavePressed: () async {
                    final success = await viewModel.saveMaintenance();
                    if (success && context.mounted) {
                      Navigator.pop(context);
                    } else if (!success && context.mounted) {
                      final latestState = ref.read(
                          maintenanceEditViewModelProvider(
                              (maintenance: maintenance, bike: bike)));
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(latestState.errorMessage ??
                              appStrings.msgSaveMaintenanceFailed),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                ),
                if (screenState.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
