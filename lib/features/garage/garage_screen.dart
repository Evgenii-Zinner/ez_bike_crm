import '../../utils/imports.dart';

/// The primary dashboard screen of the application.
///
/// It displays the current fleet of bikes, their statuses, and provides
/// quick actions for renting, returning, or moving bikes to maintenance.
/// Includes comprehensive filtering by plate number, model, and status.
class GarageScreen extends ConsumerStatefulWidget {
  const GarageScreen({super.key});

  @override
  ConsumerState<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends ConsumerState<GarageScreen> {
  final TextEditingController _plateNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial fetch of bike data when the screen is first loaded.
    Future(() => ref.read(garageViewModelProvider.notifier).fetchBikes());
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  /// Navigates to the [RentalEditScreen] to start a new rental.
  void _navigateToRentOut(BuildContext context, WidgetRef ref, Bike bike) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RentalEditScreen(rental: null, bike: bike)),
    ).then((_) {
      // Refresh the list after returning from the edit screen.
      Future(() => ref.read(garageViewModelProvider.notifier).fetchBikes());
    });
  }

  /// Navigates to the [ReturnBikeScreen] to process a rental return.
  void _navigateToReturnBike(BuildContext context, WidgetRef ref, Bike bike) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReturnBikeScreen(bike: bike)),
    ).then((_) =>
        Future(() => ref.read(garageViewModelProvider.notifier).fetchBikes()));
  }

  /// Navigates to the [MaintenanceEditScreen] to log maintenance for a bike.
  Future<void> _navigateToMaintenance(
      BuildContext context, WidgetRef ref, Bike bike) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MaintenanceEditScreen(bike: bike)),
    ).then((_) =>
        Future(() => ref.read(garageViewModelProvider.notifier).fetchBikes()));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(garageViewModelProvider);
    final viewModel = ref.read(garageViewModelProvider.notifier);
    final appStrings = ref.watch(localizationProvider);

    // Synchronize the controller text with the state if it was cleared externally.
    if (_plateNumberController.text != state.plateNumberFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _plateNumberController.text = state.plateNumberFilter;
          _plateNumberController.selection = TextSelection.fromPosition(
            TextPosition(offset: _plateNumberController.text.length),
          );
        }
      });
    }

    Widget listDisplayWidget;

    // Handle different UI states based on the ViewModel status.
    switch (state.status) {
      case GarageStatus.loading || GarageStatus.refreshing:
        listDisplayWidget = const Center(child: CircularProgressIndicator());
        break;
      case GarageStatus.failure:
        listDisplayWidget = Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    state.errorMessage != null && state.errorMessage!.isNotEmpty
                        ? "${appStrings!.msgLoadFailed}: ${state.errorMessage}"
                        : appStrings!.msgLoadFailed,
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () => viewModel.fetchBikes(isInitialLoad: true),
                    child: Text(appStrings.btnRetry)),
              ],
            ),
          ),
        );
        break;
      case GarageStatus.success:
        if (state.allFetchedBikes.isEmpty) {
          listDisplayWidget = Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    appStrings!.msgNavigateToBikes,
                    textAlign: TextAlign.center,
                  )));
        } else if (state.filteredBikes.isEmpty) {
          listDisplayWidget = Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(appStrings!.msgFilteredAll),
            ),
          );
        } else {
          listDisplayWidget = ListView.builder(
            itemCount: state.filteredBikes.length,
            itemBuilder: (context, index) {
              final bike = state.filteredBikes[index];
              return BikeCard(
                bike: bike,
                endDate: state.rentedBikesDates[bike.registrationPlate],
                onRentOut: () => _navigateToRentOut(context, ref, bike),
                onReturnBike: () => _navigateToReturnBike(context, ref, bike),
                onRepairDone: () => _navigateToMaintenance(context, ref, bike),
              );
            },
          );
        }
        break;
      default:
        listDisplayWidget = const Column();
        break;
    }

    bool commonDropdownIsLoading = state.status == GarageStatus.loading ||
        state.status == GarageStatus.refreshing;

    return Column(
      children: [
        // Filter bar containing inputs and dropdowns.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: PlateNumberFilterInput(
                  controller: _plateNumberController,
                  currentFilterValue: state.plateNumberFilter,
                  onChanged: viewModel.onPlateNumberFilterChanged,
                  onClear: () {
                    viewModel.clearPlateNumberFilter();
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: ModelFilterDropdown(
                  selectedModel: state.selectedModel,
                  availableModels: state.availableModels,
                  onChanged: viewModel.onModelChanged,
                  onClear: viewModel.clearModelFilter,
                  isLoading: commonDropdownIsLoading,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: StatusFilterDropdown(
                  selectedStatus: state.selectedStatus,
                  availableStatuses: state.availableStatuses,
                  onChanged: viewModel.onStatusChanged,
                  onClear: viewModel.clearStatusFilter,
                  isLoading: commonDropdownIsLoading,
                ),
              ),
            ],
          ),
        ),
        // Secondary indicator for background refreshes.
        if (state.status == GarageStatus.refreshing &&
            state.status != GarageStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.0))),
          ),
        Expanded(child: listDisplayWidget),
      ],
    );
  }
}
