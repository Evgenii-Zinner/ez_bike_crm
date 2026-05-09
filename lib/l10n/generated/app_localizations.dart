import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Bike CRM'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @msgRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get msgRequired;

  /// No description provided for @msgValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please, input a valid number'**
  String get msgValidNumber;

  /// No description provided for @msgOnlyPositive.
  ///
  /// In en, this message translates to:
  /// **'Please, input a value greater than 0'**
  String get msgOnlyPositive;

  /// No description provided for @msgDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'deleted successfully'**
  String get msgDeleteSuccess;

  /// No description provided for @msgDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get msgDeleteFailed;

  /// No description provided for @msgLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get msgLoadFailed;

  /// No description provided for @msgLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get msgLoading;

  /// No description provided for @msgNoBikesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No bikes available'**
  String get msgNoBikesAvailable;

  /// No description provided for @msgNoCustomersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No customers available'**
  String get msgNoCustomersAvailable;

  /// No description provided for @msgNoRentalsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rentals available'**
  String get msgNoRentalsAvailable;

  /// No description provided for @msgPhoneLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch phone call'**
  String get msgPhoneLaunchFailed;

  /// No description provided for @screenAddBike.
  ///
  /// In en, this message translates to:
  /// **'Add Bike'**
  String get screenAddBike;

  /// No description provided for @screenEditBike.
  ///
  /// In en, this message translates to:
  /// **'Edit Bike'**
  String get screenEditBike;

  /// No description provided for @labelPlate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get labelPlate;

  /// No description provided for @labelBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get labelBike;

  /// No description provided for @labelModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get labelModel;

  /// No description provided for @labelOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer readings'**
  String get labelOdometer;

  /// No description provided for @labelPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price Per Day'**
  String get labelPricePerDay;

  /// No description provided for @labelPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Price Per Month'**
  String get labelPricePerMonth;

  /// No description provided for @msgSaveBikeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add a new bike'**
  String get msgSaveBikeFailed;

  /// No description provided for @msgConfirmDeleteBike.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this bike:'**
  String get msgConfirmDeleteBike;

  /// No description provided for @msgPlateExist.
  ///
  /// In en, this message translates to:
  /// **'This registration plate already exists'**
  String get msgPlateExist;

  /// No description provided for @msgNoRecords.
  ///
  /// In en, this message translates to:
  /// **'There is no records yet'**
  String get msgNoRecords;

  /// No description provided for @msgFilteredAll.
  ///
  /// In en, this message translates to:
  /// **'There is no matches with this filters'**
  String get msgFilteredAll;

  /// No description provided for @msgAddSome.
  ///
  /// In en, this message translates to:
  /// **'Please, add records using button + in bottom right corner'**
  String get msgAddSome;

  /// No description provided for @screenAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get screenAddCustomer;

  /// No description provided for @screenEditCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get screenEditCustomer;

  /// No description provided for @msgConfirmDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this customer:'**
  String get msgConfirmDeleteCustomer;

  /// No description provided for @msgSaveCustomerFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add a new customer'**
  String get msgSaveCustomerFailed;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get labelName;

  /// No description provided for @labelPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get labelPhoneNumber;

  /// No description provided for @msgValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Only numbers, hyphens and parentheses'**
  String get msgValidPhoneNumber;

  /// No description provided for @labelAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get labelAddress;

  /// No description provided for @msgNavigateToBikes.
  ///
  /// In en, this message translates to:
  /// **'Please, add some from Bikes management screen'**
  String get msgNavigateToBikes;

  /// No description provided for @msgSelectBike.
  ///
  /// In en, this message translates to:
  /// **'Please select a Bike'**
  String get msgSelectBike;

  /// No description provided for @msgSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get msgSelectCustomer;

  /// No description provided for @msgSaveMaintenanceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add a new maintenance record'**
  String get msgSaveMaintenanceFailed;

  /// No description provided for @msgConfirmDeleteMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this maintenance record? This will break consistency of you financial data'**
  String get msgConfirmDeleteMaintenance;

  /// No description provided for @screenAddMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Add Maintenance'**
  String get screenAddMaintenance;

  /// No description provided for @screenEditMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Edit Maintenance'**
  String get screenEditMaintenance;

  /// No description provided for @labelParts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get labelParts;

  /// No description provided for @labelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get labelPrice;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @msgConfirmDeleteRental.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this rental record? This will break consistency of you financial data'**
  String get msgConfirmDeleteRental;

  /// No description provided for @btnAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get btnAddCustomer;

  /// No description provided for @labelDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get labelDeposit;

  /// No description provided for @screenAddRental.
  ///
  /// In en, this message translates to:
  /// **'Add Rental'**
  String get screenAddRental;

  /// No description provided for @screenEditRental.
  ///
  /// In en, this message translates to:
  /// **'Edit Rental'**
  String get screenEditRental;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @labelMaintenanceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Maintenance needed'**
  String get labelMaintenanceNeeded;

  /// No description provided for @msgRentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create a new rental record'**
  String get msgRentFailed;

  /// No description provided for @msgReturnFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to finish a rental'**
  String get msgReturnFailed;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @labelOdometerReturn.
  ///
  /// In en, this message translates to:
  /// **'Odometer on Return'**
  String get labelOdometerReturn;

  /// No description provided for @labelFinalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get labelFinalPrice;

  /// No description provided for @labelBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get labelBalance;

  /// No description provided for @labelBikeId.
  ///
  /// In en, this message translates to:
  /// **'Bike ID'**
  String get labelBikeId;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get labelDays;

  /// No description provided for @labelStartDate.
  ///
  /// In en, this message translates to:
  /// **'Rental Start Date'**
  String get labelStartDate;

  /// No description provided for @labelEndDate.
  ///
  /// In en, this message translates to:
  /// **'Rental End Date'**
  String get labelEndDate;

  /// No description provided for @labelActualReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Actual Return Date'**
  String get labelActualReturnDate;

  /// No description provided for @labelPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get labelPaid;

  /// No description provided for @labelPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get labelPending;

  /// No description provided for @labelDocumentDepositProvided.
  ///
  /// In en, this message translates to:
  /// **'Document Deposit Provided'**
  String get labelDocumentDepositProvided;

  /// No description provided for @labelMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get labelMonth;

  /// No description provided for @labelYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get labelYear;

  /// No description provided for @labelCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get labelCustomer;

  /// No description provided for @labelSelectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get labelSelectYear;

  /// No description provided for @labelDepositsHeld.
  ///
  /// In en, this message translates to:
  /// **'Deposits Currently Held'**
  String get labelDepositsHeld;

  /// No description provided for @labelTotalDeposits.
  ///
  /// In en, this message translates to:
  /// **'Total Active Deposits'**
  String get labelTotalDeposits;

  /// No description provided for @labelDocumentsHeld.
  ///
  /// In en, this message translates to:
  /// **'Physical Documents Held'**
  String get labelDocumentsHeld;

  /// No description provided for @labelFinancialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get labelFinancialSummary;

  /// No description provided for @labelTotalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get labelTotalEarnings;

  /// No description provided for @labelTotalMaintenanceCosts.
  ///
  /// In en, this message translates to:
  /// **'Total Maintenance Costs'**
  String get labelTotalMaintenanceCosts;

  /// No description provided for @labelCurrentBikeFleetStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Bike Fleet Status'**
  String get labelCurrentBikeFleetStatus;

  /// No description provided for @labelBikesCurrentlyRented.
  ///
  /// In en, this message translates to:
  /// **'Bikes Currently Rented'**
  String get labelBikesCurrentlyRented;

  /// No description provided for @labelBikesCurrentlyInMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Bikes Currently in Maintenance'**
  String get labelBikesCurrentlyInMaintenance;

  /// No description provided for @labelBikesCurrentlyAvailable.
  ///
  /// In en, this message translates to:
  /// **'Bikes Currently Available'**
  String get labelBikesCurrentlyAvailable;

  /// No description provided for @labelExcelReport.
  ///
  /// In en, this message translates to:
  /// **'Download Full Report (Excel)'**
  String get labelExcelReport;

  /// No description provided for @labelGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Generating Excel report...'**
  String get labelGeneratingReport;

  /// No description provided for @labelDownloadingReport.
  ///
  /// In en, this message translates to:
  /// **'Downloading Excel report...'**
  String get labelDownloadingReport;

  /// No description provided for @labelFailedToCreateReport.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate report'**
  String get labelFailedToCreateReport;

  /// No description provided for @labelAmountReturnedToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Amount Returned to Customer'**
  String get labelAmountReturnedToCustomer;

  /// No description provided for @labelOverduePayment.
  ///
  /// In en, this message translates to:
  /// **'Overdue payment (including withheld)'**
  String get labelOverduePayment;

  /// No description provided for @screenGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get screenGarage;

  /// No description provided for @screenReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get screenReports;

  /// No description provided for @screenRentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get screenRentals;

  /// No description provided for @screenMaintenances.
  ///
  /// In en, this message translates to:
  /// **'Maintenances'**
  String get screenMaintenances;

  /// No description provided for @screenCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get screenCustomers;

  /// No description provided for @screenBikes.
  ///
  /// In en, this message translates to:
  /// **'Bikes'**
  String get screenBikes;

  /// No description provided for @screenReturnBike.
  ///
  /// In en, this message translates to:
  /// **'Finish rental'**
  String get screenReturnBike;

  /// No description provided for @msgDelayedReturn.
  ///
  /// In en, this message translates to:
  /// **'Bike return is delayed by'**
  String get msgDelayedReturn;

  /// No description provided for @msgDelayedDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get msgDelayedDays;

  /// No description provided for @msgCustomerShouldPay.
  ///
  /// In en, this message translates to:
  /// **'Customer owe you:'**
  String get msgCustomerShouldPay;

  /// No description provided for @msgCustomerShouldGetBack.
  ///
  /// In en, this message translates to:
  /// **'Customer should get back:'**
  String get msgCustomerShouldGetBack;

  /// No description provided for @actionLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get actionLogout;

  /// No description provided for @actionRentOut.
  ///
  /// In en, this message translates to:
  /// **'Rent Out'**
  String get actionRentOut;

  /// No description provided for @actionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Return Bike'**
  String get actionOverdue;

  /// No description provided for @actionReturnBike.
  ///
  /// In en, this message translates to:
  /// **'Return Bike'**
  String get actionReturnBike;

  /// No description provided for @actionBooked.
  ///
  /// In en, this message translates to:
  /// **'Rent Out'**
  String get actionBooked;

  /// No description provided for @actionRepairDone.
  ///
  /// In en, this message translates to:
  /// **'Repair Done'**
  String get actionRepairDone;

  /// No description provided for @msgNoAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get msgNoAvailable;

  /// No description provided for @bikeStatusGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get bikeStatusGarage;

  /// No description provided for @bikeStatusRented.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get bikeStatusRented;

  /// No description provided for @bikeStatusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get bikeStatusMaintenance;

  /// No description provided for @bikeStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get bikeStatusUnknown;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
