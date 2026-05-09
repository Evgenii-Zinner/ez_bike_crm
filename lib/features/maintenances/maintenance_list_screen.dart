import 'package:intl/intl.dart';

import '../../utils/imports.dart';

/// Screen that displays a history of all bike maintenance logs.
///
/// It allows users to view previous maintenance events, edit them, or add
/// new ones via a floating action button.
class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(maintenanceListViewModelProvider.notifier);
    final screenState = ref.watch(maintenanceListViewModelProvider);
    final appStrings = ref.watch(localizationProvider);

    // Listens for error states to show global SnackBars.
    ref.listen<MaintenanceListState>(maintenanceListViewModelProvider,
        (previous, next) {
      if (next.status == MaintenanceListStatus.failure &&
          next.errorMessage != null &&
          previous?.status != MaintenanceListStatus.failure) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      body: _buildBody(context, screenState, viewModel, appStrings!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add maintenance screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const MaintenanceEditScreen(maintenance: null),
            ),
          ).then((_) {
            viewModel.refreshMaintenances();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the main body of the screen based on the current [MaintenanceListStatus].
  Widget _buildBody(BuildContext context, MaintenanceListState screenState,
      MaintenanceListViewModel viewModel, AppLocalizations appStrings) {
    switch (screenState.status) {
      case MaintenanceListStatus.initial:
      case MaintenanceListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MaintenanceListStatus.refreshing:
        return _buildListView(
            context, screenState.maintenances, viewModel, appStrings,
            isRefreshing: true);
      case MaintenanceListStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(screenState.errorMessage ?? appStrings.msgLoadFailed),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => viewModel.fetchMaintenances(),
                child: Text(appStrings.btnRetry),
              )
            ],
          ),
        );
      case MaintenanceListStatus.success:
        if (screenState.maintenances.isEmpty) {
          return Center(
            child: Text(appStrings.msgNoRecords),
          );
        }
        return _buildListView(
            context, screenState.maintenances, viewModel, appStrings);
    }
  }

  /// Builds the actual scrollable list of maintenance records.
  Widget _buildListView(BuildContext context, List<Maintenance> maintenances,
      MaintenanceListViewModel viewModel, AppLocalizations appStrings,
      {bool isRefreshing = false}) {
    return RefreshIndicator(
      onRefresh: viewModel.refreshMaintenances,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: maintenances.length,
        itemBuilder: (context, index) {
          final maintenance = maintenances[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(
                '${maintenance.bikeId} - ${DateFormat('dd.MM.yyyy').format(maintenance.date)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${appStrings.labelPrice} ${maintenance.price.toStringAsFixed(0)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit existing maintenance record.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MaintenanceEditScreen(maintenance: maintenance),
                    ),
                  ).then((_) {
                    viewModel.refreshMaintenances();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
