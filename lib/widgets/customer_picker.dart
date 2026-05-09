import '../utils/imports.dart';

/// A dropdown picker for selecting a [Customer] from a provided list.
///
/// Features:
/// - Alphabetical sorting of customers.
/// - Inline button to trigger the creation of a new customer record.
/// - Auto-matching of the [selectedCustomer] within the list.
class CustomerPicker extends ConsumerWidget {
  /// The list of customers to pick from.
  final List<Customer> customers;

  /// The currently selected customer.
  final Customer? selectedCustomer;

  /// Callback triggered when a new customer is selected from the dropdown.
  final Function(Customer?) onCustomerSelected;

  /// Callback triggered when the 'Add' button in the suffix icon is pressed.
  final VoidCallback? onAddCustomerPressed;

  const CustomerPicker({
    super.key,
    required this.customers,
    this.selectedCustomer,
    required this.onCustomerSelected,
    this.onAddCustomerPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStrings = ref.watch(localizationProvider);

    var mutableCustomers = customers.toList();

    // Sort customers alphabetically by name.
    mutableCustomers.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    // Match initial selection with a reference in the sorted list.
    final Customer? matchingCustomer = selectedCustomer != null
        ? mutableCustomers.firstWhereOrNull(
            (customer) => customer.customerId == selectedCustomer!.customerId,
          )
        : null;

    return DropdownButtonFormField<Customer>(
      value: matchingCustomer,
      hint: Text(appStrings!.labelCustomer),
      isExpanded: true,
      decoration: InputDecoration(
        labelText: appStrings.labelCustomer,
        suffixIcon: onAddCustomerPressed != null
            ? IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAddCustomerPressed,
              )
            : null,
      ),
      items: [
        ...mutableCustomers
            .map<DropdownMenuItem<Customer>>((Customer customer) {
          return DropdownMenuItem<Customer>(
            value: customer,
            child: Text(customer.name),
          );
        }),
      ],
      onChanged: onCustomerSelected,
      validator: (value) => value == null ? appStrings.msgSelectCustomer : null,
    );
  }
}
