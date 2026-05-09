import 'package:intl/intl.dart';

import '../../utils/imports.dart';

/// Screen displaying the history of all rental transactions.
///
/// Shows basic details like bike plate, customer name, and rental period.
/// Allows navigation to edit or add rentals.
class RentalListScreen extends ConsumerWidget {
  const RentalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rentalListViewModelProvider.notifier);
    final state = ref.watch(rentalListViewModelProvider);
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget body;

    // Handle different UI states (Loading, Failure, Success).
    switch (state.status) {
      case RentalListStatus.loading:
      case RentalListStatus.initial:
        body = const Center(child: CircularProgressIndicator());
        break;
      case RentalListStatus.failure:
        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage ?? appStrings.msgLoadFailed),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.fetchRentals(isRefresh: true),
                child: Text(appStrings.btnRetry),
              )
            ],
          ),
        );
        break;
      case RentalListStatus.success:
        if (state.items.isEmpty) {
          body = Center(
            child: Text(appStrings.msgNoRentalsAvailable),
          );
        } else {
          body = RefreshIndicator(
            onRefresh: () => viewModel.fetchRentals(isRefresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                final rental = item.rental;
                final customer = item.customer;

                return Card(
                  child: ListTile(
                    title: Text(
                        '${rental.bikeId} ${appStrings.by} ${customer?.name}'),
                    subtitle: Text(
                        '${DateFormat('dd.MM.yyyy').format(rental.startDate)} - ${DateFormat('dd.MM.yyyy').format(rental.endDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit existing rental.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RentalEditScreen(rental: rental),
                              ),
                            ).then((result) {
                              if (result == true || result == null) {
                                viewModel.refreshData();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        break;
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new rental screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RentalEditScreen(rental: null),
            ),
          ).then((result) {
            if (result == true || result == null) {
              viewModel.refreshData();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
