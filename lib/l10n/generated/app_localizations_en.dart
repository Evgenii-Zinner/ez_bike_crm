// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bike CRM';

  @override
  String get login => 'Login';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get update => 'Update';

  @override
  String get create => 'Create';

  @override
  String get btnRetry => 'Retry';

  @override
  String get msgRequired => 'This field is required';

  @override
  String get msgValidNumber => 'Please, input a valid number';

  @override
  String get msgOnlyPositive => 'Please, input a value greater than 0';

  @override
  String get msgDeleteSuccess => 'deleted successfully';

  @override
  String get msgDeleteFailed => 'Failed to delete';

  @override
  String get msgLoadFailed => 'Failed to load';

  @override
  String get msgLoading => 'Loading...';

  @override
  String get msgNoBikesAvailable => 'No bikes available';

  @override
  String get msgNoCustomersAvailable => 'No customers available';

  @override
  String get msgNoRentalsAvailable => 'No rentals available';

  @override
  String get msgPhoneLaunchFailed => 'Failed to launch phone call';

  @override
  String get screenAddBike => 'Add Bike';

  @override
  String get screenEditBike => 'Edit Bike';

  @override
  String get labelPlate => 'Plate';

  @override
  String get labelBike => 'Bike';

  @override
  String get labelModel => 'Model';

  @override
  String get labelOdometer => 'Odometer readings';

  @override
  String get labelPricePerDay => 'Price Per Day';

  @override
  String get labelPricePerMonth => 'Price Per Month';

  @override
  String get msgSaveBikeFailed => 'Failed to add a new bike';

  @override
  String get msgConfirmDeleteBike =>
      'Are you sure you want to delete this bike:';

  @override
  String get msgPlateExist => 'This registration plate already exists';

  @override
  String get msgNoRecords => 'There is no records yet';

  @override
  String get msgFilteredAll => 'There is no matches with this filters';

  @override
  String get msgAddSome =>
      'Please, add records using button + in bottom right corner';

  @override
  String get screenAddCustomer => 'Add Customer';

  @override
  String get screenEditCustomer => 'Edit Customer';

  @override
  String get msgConfirmDeleteCustomer =>
      'Are you sure you want to delete this customer:';

  @override
  String get msgSaveCustomerFailed => 'Failed to add a new customer';

  @override
  String get labelName => 'Customer name';

  @override
  String get labelPhoneNumber => 'Phone Number';

  @override
  String get msgValidPhoneNumber => 'Only numbers, hyphens and parentheses';

  @override
  String get labelAddress => 'Address';

  @override
  String get msgNavigateToBikes =>
      'Please, add some from Bikes management screen';

  @override
  String get msgSelectBike => 'Please select a Bike';

  @override
  String get msgSelectCustomer => 'Please select a customer';

  @override
  String get msgSaveMaintenanceFailed =>
      'Failed to add a new maintenance record';

  @override
  String get msgConfirmDeleteMaintenance =>
      'Are you sure you want to delete this maintenance record? This will break consistency of you financial data';

  @override
  String get screenAddMaintenance => 'Add Maintenance';

  @override
  String get screenEditMaintenance => 'Edit Maintenance';

  @override
  String get labelParts => 'Parts';

  @override
  String get labelPrice => 'Price';

  @override
  String get labelDate => 'Date';

  @override
  String get msgConfirmDeleteRental =>
      'Are you sure you want to delete this rental record? This will break consistency of you financial data';

  @override
  String get btnAddCustomer => 'Add Customer';

  @override
  String get labelDeposit => 'Deposit';

  @override
  String get screenAddRental => 'Add Rental';

  @override
  String get screenEditRental => 'Edit Rental';

  @override
  String get by => 'by';

  @override
  String get labelMaintenanceNeeded => 'Maintenance needed';

  @override
  String get msgRentFailed => 'Failed to create a new rental record';

  @override
  String get msgReturnFailed => 'Failed to finish a rental';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get labelOdometerReturn => 'Odometer on Return';

  @override
  String get labelFinalPrice => 'Final Price';

  @override
  String get labelBalance => 'Balance';

  @override
  String get labelBikeId => 'Bike ID';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelDays => 'Days';

  @override
  String get labelStartDate => 'Rental Start Date';

  @override
  String get labelEndDate => 'Rental End Date';

  @override
  String get labelActualReturnDate => 'Actual Return Date';

  @override
  String get labelPaid => 'Paid';

  @override
  String get labelPending => 'Pending';

  @override
  String get labelDocumentDepositProvided => 'Document Deposit Provided';

  @override
  String get labelMonth => 'Month';

  @override
  String get labelYear => 'Year';

  @override
  String get labelCustomer => 'Customer';

  @override
  String get labelSelectYear => 'Select Year';

  @override
  String get labelDepositsHeld => 'Deposits Currently Held';

  @override
  String get labelTotalDeposits => 'Total Active Deposits';

  @override
  String get labelDocumentsHeld => 'Physical Documents Held';

  @override
  String get labelFinancialSummary => 'Financial Summary';

  @override
  String get labelTotalEarnings => 'Total Earnings';

  @override
  String get labelTotalMaintenanceCosts => 'Total Maintenance Costs';

  @override
  String get labelCurrentBikeFleetStatus => 'Current Bike Fleet Status';

  @override
  String get labelBikesCurrentlyRented => 'Bikes Currently Rented';

  @override
  String get labelBikesCurrentlyInMaintenance =>
      'Bikes Currently in Maintenance';

  @override
  String get labelBikesCurrentlyAvailable => 'Bikes Currently Available';

  @override
  String get labelExcelReport => 'Download Full Report (Excel)';

  @override
  String get labelGeneratingReport => 'Generating Excel report...';

  @override
  String get labelDownloadingReport => 'Downloading Excel report...';

  @override
  String get labelFailedToCreateReport => 'Failed to generate report';

  @override
  String get labelAmountReturnedToCustomer => 'Amount Returned to Customer';

  @override
  String get labelOverduePayment => 'Overdue payment (including withheld)';

  @override
  String get screenGarage => 'Garage';

  @override
  String get screenReports => 'Reports';

  @override
  String get screenRentals => 'Rentals';

  @override
  String get screenMaintenances => 'Maintenances';

  @override
  String get screenCustomers => 'Customers';

  @override
  String get screenBikes => 'Bikes';

  @override
  String get screenReturnBike => 'Finish rental';

  @override
  String get msgDelayedReturn => 'Bike return is delayed by';

  @override
  String get msgDelayedDays => 'days';

  @override
  String get msgCustomerShouldPay => 'Customer owe you:';

  @override
  String get msgCustomerShouldGetBack => 'Customer should get back:';

  @override
  String get actionLogout => 'Logout';

  @override
  String get actionRentOut => 'Rent Out';

  @override
  String get actionOverdue => 'Return Bike';

  @override
  String get actionReturnBike => 'Return Bike';

  @override
  String get actionBooked => 'Rent Out';

  @override
  String get actionRepairDone => 'Repair Done';

  @override
  String get msgNoAvailable => 'N/A';

  @override
  String get bikeStatusGarage => 'Garage';

  @override
  String get bikeStatusRented => 'Rented';

  @override
  String get bikeStatusMaintenance => 'Maintenance';

  @override
  String get bikeStatusUnknown => 'Unknown';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusPending => 'Pending';
}
