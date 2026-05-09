import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../utils/imports.dart';

/// A screen that displays financial and fleet status reports.
///
/// It allows users to view data for specific months or years, showing
/// summaries of earnings, maintenance costs, and bike availability.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(reportsViewModelProvider.notifier);
    final state = ref.watch(reportsViewModelProvider);
    final appStrings = ref.watch(localizationProvider);

    /// Formats the selected date and period type into a user-friendly string.
    String displaySelectedPeriod(DateTime date, ReportPeriodType periodType) {
      if (periodType == ReportPeriodType.month) {
        if (appStrings?.localeName == 'vi') {
          return 'Tháng ${date.month}, ${date.year}';
        } else {
          return DateFormat.yMMMM().format(date);
        }
      } else {
        return DateFormat.y().format(date);
      }
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => viewModel.loadReportData(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Period type selector (Month vs Year).
            SegmentedButton<ReportPeriodType>(
              segments: <ButtonSegment<ReportPeriodType>>[
                ButtonSegment<ReportPeriodType>(
                    value: ReportPeriodType.month,
                    label: Text(appStrings!.labelMonth),
                    icon: const Icon(Icons.calendar_view_month)),
                ButtonSegment<ReportPeriodType>(
                    value: ReportPeriodType.year,
                    label: Text(appStrings.labelYear),
                    icon: Icon(Icons.calendar_today)),
              ],
              selected: <ReportPeriodType>{state.selectedPeriodType},
              onSelectionChanged: (Set<ReportPeriodType> newSelection) {
                viewModel.setPeriodType(newSelection.first);
              },
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
            const SizedBox(height: 16),
            // Navigation controls for switching periods.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed:
                      state.isLoading ? null : viewModel.goToPreviousPeriod,
                ),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          // Date picker for Month or Year selection.
                          if (state.selectedPeriodType ==
                              ReportPeriodType.month) {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: state.selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              initialDatePickerMode: DatePickerMode.year,
                            );
                            if (picked != null &&
                                picked != state.selectedDate) {
                              viewModel.setSelectedDate(picked);
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(appStrings.labelSelectYear),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: YearPicker(
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                      selectedDate: state.selectedDate,
                                      onChanged: (DateTime dateTime) {
                                        viewModel.setSelectedDate(
                                            DateTime(dateTime.year, 1, 1));
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                  child: Text(
                    displaySelectedPeriod(
                        state.selectedDate, state.selectedPeriodType),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: state.isLoading ? null : viewModel.goToNextPeriod,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ))
            else if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            // Report cards showing summarized data.
            if (!state.isLoading && state.errorMessage == null) ...[
              _buildReportCard(
                context: context,
                title: appStrings.labelDepositsHeld,
                iconWidget: Text(
                  NumberFormat.simpleCurrency(name: 'VND').currencySymbol,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconColor: Colors.orange,
                data: {
                  appStrings.labelTotalDeposits: NumberFormat.currency(
                    symbol: '₫',
                    decimalDigits: 0,
                  ).format(state.totalDepositsHeld),
                  appStrings.labelDocumentsHeld:
                      state.totalDepositDocumentsHeld.toString(),
                },
              ),
              const SizedBox(height: 16),
            ],
            if (!state.isLoading && state.errorMessage == null) ...[
              _buildReportCard(
                context: context,
                title: appStrings.labelFinancialSummary,
                iconWidget: Text(
                  NumberFormat.simpleCurrency(name: 'VND').currencySymbol,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconColor: Colors.green,
                data: {
                  appStrings.labelTotalEarnings:
                      NumberFormat.currency(symbol: '₫', decimalDigits: 0)
                          .format(state.totalEarnings),
                  appStrings.labelTotalMaintenanceCosts:
                      NumberFormat.currency(symbol: '₫', decimalDigits: 0)
                          .format(state.totalMaintenanceCosts),
                  appStrings.labelBalance:
                      NumberFormat.currency(symbol: '₫', decimalDigits: 0)
                          .format(state.balance),
                },
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                context: context,
                title: appStrings.labelCurrentBikeFleetStatus,
                iconWidget:
                    Icon(Icons.motorcycle, color: Colors.blue, size: 28),
                iconColor: Colors.blue,
                data: {
                  appStrings.labelBikesCurrentlyRented:
                      state.bikesInRentCount.toString(),
                  appStrings.labelBikesCurrentlyInMaintenance:
                      state.totalBikesInMaintenance.toString(),
                  appStrings.labelBikesCurrentlyAvailable:
                      state.bikesAvailableCount.toString(),
                },
              ),
              const SizedBox(height: 24),
              // Excel export button (visible only on Web).
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.download_for_offline),
                    label: Text(appStrings.labelExcelReport),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(appStrings.labelGeneratingReport),
                                  duration: Duration(seconds: 10)),
                            );
                            final List<int>? excelBytes =
                                await viewModel.prepareExcelReport();
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();

                            if (excelBytes != null && excelBytes.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        appStrings.labelDownloadingReport)),
                              );
                            } else if (state.errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        appStrings.labelFailedToCreateReport)),
                              );
                            }
                          },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a stylized card for report summaries.
  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    Widget? iconWidget,
    required Color iconColor,
    required Map<String, String> data,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (iconWidget != null) ...[
                  iconWidget,
                  const SizedBox(width: 10),
                ],
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...data.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(entry.key,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(entry.value,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
