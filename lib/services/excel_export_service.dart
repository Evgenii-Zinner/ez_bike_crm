import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import '../utils/imports.dart';

/// Generates a multi-sheet Excel workbook containing a comprehensive business report.
///
/// Sheets included:
/// - **Rentals:** List of all transactions in the period.
/// - **Maintenances:** History of repairs and costs.
/// - **Bikes:** Inventory list with status and mileage.
/// - **Customers:** Client directory.
///
/// Returns the byte list of the generated file or null on failure.
Future<List<int>?> generateFullReportExcel({
  required AppLocalizations appStrings,
  required List<Rental> rentalsForPeriod,
  required List<Maintenance> maintenancesForPeriod,
  required List<Bike> allBikes,
  required List<Customer> allCustomers,
  required DateTime periodStart,
  required DateTime periodEnd,
}) async {
  var excel = Excel.createExcel();

  final rentalsSheetName = appStrings.screenRentals;
  final maintenancesSheetName = appStrings.screenMaintenances;
  final bikesSheetName = appStrings.screenBikes;
  final customersSheetName = appStrings.screenCustomers;

  if (excel.sheets.keys.isNotEmpty) {
    final defaultSheetName = excel.sheets.keys.first;
    excel.setDefaultSheet(defaultSheetName);
    excel.rename(defaultSheetName, rentalsSheetName);
  }

  final rentalSheet = excel[rentalsSheetName];
  final bikeList = {for (var bike in allBikes) bike.registrationPlate: bike};
  final customerList = {
    for (var customer in allCustomers) customer.customerId: customer
  };

  rentalSheet.appendRow([
    TextCellValue(appStrings.labelModel),
    TextCellValue(appStrings.labelPlate),
    TextCellValue(appStrings.labelName),
    TextCellValue(appStrings.labelStartDate),
    TextCellValue(appStrings.labelEndDate),
    TextCellValue(appStrings.labelActualReturnDate),
    TextCellValue(appStrings.labelFinalPrice),
    TextCellValue(appStrings.labelDeposit),
    TextCellValue(appStrings.labelStatus),
  ]);
  for (var rental in rentalsForPeriod) {
    final bike = bikeList[rental.bikeId];
    final customer = customerList[rental.customerId];
    rentalSheet.appendRow([
      TextCellValue(bike?.model ?? appStrings.msgNoAvailable),
      TextCellValue(rental.bikeId),
      TextCellValue(customer?.name ?? appStrings.msgNoAvailable),
      TextCellValue(rental.startDate.toIso8601String().substring(0, 10)),
      TextCellValue(rental.endDate.toIso8601String().substring(0, 10)),
      TextCellValue(
          rental.returnDate?.toIso8601String().substring(0, 10) ?? ''),
      DoubleCellValue(rental.finalPrice),
      DoubleCellValue(rental.depositAmount),
      TextCellValue(rental.paymentStatus),
    ]);
  }

  final maintenanceSheet = excel[maintenancesSheetName];
  maintenanceSheet.appendRow([
    TextCellValue(appStrings.labelPlate),
    TextCellValue(appStrings.labelDate),
    TextCellValue(appStrings.labelParts),
    TextCellValue(appStrings.labelPrice),
  ]);
  for (var maintenance in maintenancesForPeriod) {
    maintenanceSheet.appendRow([
      TextCellValue(maintenance.bikeId),
      TextCellValue(maintenance.date.toIso8601String().substring(0, 10)),
      TextCellValue(maintenance.parts),
      DoubleCellValue(maintenance.price),
    ]);
  }

  final bikeSheet = excel[bikesSheetName];
  bikeSheet.appendRow([
    TextCellValue(appStrings.labelPlate),
    TextCellValue(appStrings.labelModel),
    TextCellValue(appStrings.labelOdometer),
    TextCellValue(appStrings.labelPricePerDay),
    TextCellValue(appStrings.labelPricePerMonth),
    TextCellValue(appStrings.labelStatus),
  ]);
  for (var bike in allBikes) {
    bikeSheet.appendRow([
      TextCellValue(bike.registrationPlate),
      TextCellValue(bike.model),
      DoubleCellValue(bike.odometer),
      DoubleCellValue(bike.pricePerDay),
      DoubleCellValue(bike.pricePerMonth),
      TextCellValue(bike.bikeStatus),
    ]);
  }

  final customerSheet = excel[customersSheetName];
  customerSheet.appendRow([
    TextCellValue(appStrings.labelName),
    TextCellValue(appStrings.labelPhoneNumber),
    TextCellValue(appStrings.labelAddress),
  ]);
  for (var customer in allCustomers) {
    customerSheet.appendRow([
      TextCellValue(customer.name),
      TextCellValue(customer.phoneNumber),
      TextCellValue(customer.address),
    ]);
  }

  for (var sheetName in excel.sheets.keys) {
    var sheet = excel.sheets[sheetName]!;
    for (int i = 0; i < (sheet.maxColumns); i++) {
      sheet.setColumnAutoFit(i);
    }
  }

  final formattedStartDate = DateFormat('dd-MM-yyy').format(periodStart);
  final formattedEndDate = DateFormat('dd-MM-yyy').format(periodEnd);

  return excel.save(
    fileName:
        "${appStrings.screenReports}_${formattedStartDate}_-_$formattedEndDate.xlsx",
  );
}
