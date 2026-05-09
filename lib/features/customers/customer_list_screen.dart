import '../../utils/imports.dart';

/// Screen that displays a list of all [Customer] records.
///
/// It allows users to view, edit, and call customers directly. It also
/// provides a button to add a new customer.
class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(customerListViewModelProvider.notifier);
    final screenState = ref.watch(customerListViewModelProvider);
    final appStrings = ref.watch(localizationProvider);

    if (appStrings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Listens for error state changes to show error messages via SnackBar.
    ref.listen<CustomerListState>(customerListViewModelProvider,
        (previous, next) {
      if (next.errorMessage != null &&
          (previous?.errorMessage != next.errorMessage ||
              (previous?.status != CustomerListStatus.failure &&
                  next.status == CustomerListStatus.failure))) {
        if (next.status != CustomerListStatus.failure) {
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
      }
    });

    Widget body;

    switch (screenState.status) {
      case CustomerListStatus.initial:
      case CustomerListStatus.loading:
        body = const Center(child: CircularProgressIndicator());
        break;
      case CustomerListStatus.failure:
        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(screenState.errorMessage ?? appStrings.msgLoadFailed),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.fetchCustomers(isRefresh: true),
                child: Text(appStrings.btnRetry),
              )
            ],
          ),
        );
        break;
      case CustomerListStatus.success:
        if (screenState.customers.isEmpty) {
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
            onRefresh: () => viewModel.fetchCustomers(isRefresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: screenState.customers.length,
              itemBuilder: (context, index) {
                final customer = screenState.customers[index];
                return Card(
                  child: ListTile(
                    title: Text(customer.name),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.phone, size: 16.0),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            customer.phoneNumber,
                            style: const TextStyle(fontSize: 14.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            // Initiates a phone call to the customer.
                            viewModel.launchPhoneCall(customer.phoneNumber);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigates to the edit screen for the selected customer.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerEditScreen(customer: customer),
                              ),
                            ).then((result) {
                              if (result is Customer || result == null) {
                                viewModel.refreshCustomerList();
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
          // Navigates to the screen to add a new customer.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerEditScreen(customer: null),
            ),
          ).then((result) {
            if (result is Customer) {
              viewModel.refreshCustomerList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
