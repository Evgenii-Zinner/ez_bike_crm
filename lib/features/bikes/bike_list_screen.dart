import '../../utils/imports.dart';

/// A screen that displays the full list of bikes in the fleet.
///
/// Allows users to view statuses, initiate edits, and add new bikes via
/// a floating action button.
class BikeListScreen extends ConsumerWidget {
  const BikeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bikeListViewModelProvider.notifier);
    final screenState = ref.watch(bikeListViewModelProvider);
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Listens for list fetching failures to show error SnackBars.
    ref.listen<BikeListState>(bikeListViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.status == BikeListStatus.failure &&
          (previous?.errorMessage != next.errorMessage ||
              previous?.status != BikeListStatus.failure)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(next.errorMessage!),
                  duration: const Duration(seconds: 3)),
            );
          }
        });
      }
    });

    Widget body;

    switch (screenState.status) {
      case BikeListStatus.initial:
      case BikeListStatus.loading:
        body = const Center(child: CircularProgressIndicator());
        break;
      case BikeListStatus.failure:
        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(screenState.errorMessage ?? appStrings.msgLoadFailed),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.fetchBikes(isRefresh: true),
                child: Text(appStrings.btnRetry),
              )
            ],
          ),
        );
        break;
      case BikeListStatus.success:
        if (screenState.bikes.isEmpty) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appStrings.msgNoRecords),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appStrings.msgAddSome),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        } else {
          body = RefreshIndicator(
            onRefresh: () => viewModel.fetchBikes(isRefresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: screenState.bikes.length,
              itemBuilder: (context, index) {
                final bike = screenState.bikes[index];
                return Card(
                  child: ListTile(
                    title: Text(bike.registrationPlate),
                    subtitle: Text(
                        '${bike.model}, ${getLocalizedBikeStatus(bike.bikeStatus, appStrings)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BikeEditScreen(bike: bike),
                              ),
                            ).then((_) {
                              viewModel.refreshBikeList();
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BikeEditScreen(bike: null),
            ),
          ).then((result) {
            if (result is Bike) {
              viewModel.refreshBikeList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
