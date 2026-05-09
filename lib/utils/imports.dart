export 'package:collection/collection.dart';
export 'package:equatable/equatable.dart';
export 'package:ez_circle_avatar/ez_circle_avatar.dart';
export 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:shared_preferences/shared_preferences.dart';

// Data Layer
export '../data/database_service.dart';
export '../data/db_services/bike_db_service.dart';
export '../data/db_services/customer_db_service.dart';
export '../data/db_services/maintenance_db_service.dart';
export '../data/db_services/rental_db_service.dart';

// Models
export '../data/models/bike.dart';
export '../data/models/customer.dart';
export '../data/models/language_options.dart';
export '../data/models/maintenance.dart';
export '../data/models/rental.dart';

// Feature: Authentication
export '../features/authentication/login_screen.dart';

// Feature: Bikes
export '../features/bikes/bike_edit_screen.dart';
export '../features/bikes/bike_edit_view_model.dart';
export '../features/bikes/bike_list_screen.dart';
export '../features/bikes/bike_list_view_model.dart';

// Feature: Customers
export '../features/customers/customer_edit_screen.dart';
export '../features/customers/customer_edit_view_model.dart';
export '../features/customers/customer_list_screen.dart';
export '../features/customers/customer_list_view_model.dart';

// Feature: Garage
export '../features/garage/garage_screen.dart';
export '../features/garage/garage_view_model.dart';
export '../features/garage/widgets/bike_card.dart';
export '../features/garage/widgets/model_filter_dropdown.dart';
export '../features/garage/widgets/plate_number_filter_input.dart';
export '../features/garage/widgets/status_filter_dropdown.dart';

// Feature: Maintenances
export '../features/maintenances/maintenance_edit_screen.dart';
export '../features/maintenances/maintenance_edit_view_model.dart';
export '../features/maintenances/maintenance_list_screen.dart';
export '../features/maintenances/maintenance_list_view_model.dart';

// Feature: Rentals
export '../features/rentals/rental_edit_screen.dart';
export '../features/rentals/rental_edit_view_model.dart';
export '../features/rentals/rental_list_screen.dart';
export '../features/rentals/rental_list_view_model.dart';
export '../features/rentals/return_edit_screen.dart';
export '../features/rentals/return_edit_view_model.dart';

// Feature: Reports
export '../features/reports/reports_screen.dart';
export '../features/reports/reports_view_model.dart';

// Localization & Providers
export '../l10n/app_localization_providers.dart';
export '../l10n/generated/app_localizations.dart';
export '../main.dart';
export '../providers/providers.dart';

// Services
export '../services/auth_service.dart';
export '../services/bike_service.dart';
export '../services/customer_service.dart';
export '../services/excel_export_service.dart';
export '../services/maintenance_service.dart';
export '../services/rental_service.dart';

// Shared Widgets
export '../widgets/bike_picker.dart';
export '../widgets/checkbox_list_tile_widget.dart';
export '../widgets/customer_picker.dart';
export '../widgets/dsc_buttons.dart';
export '../widgets/language_switcher.dart';
export '../widgets/rental_length.dart';

// Utilities
export 'app_theme.dart';
export 'validators.dart';
