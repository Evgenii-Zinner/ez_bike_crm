# User Flow

This document outlines the user flow for the Bike CRM application, screen by screen. It will be used as a reference for creating integration tests.

## 1. Login Process

*   **Initial State**: The user is not authenticated.
*   **Screen Displayed**: `LoginScreen`

### `LoginScreen`

*   **What is shown**:
    *   An app bar with the title "Login".
    *   A single, centrally located "Login" button.
*   **User action**: The user taps the "Login" button.
*   **System action**: The application initiates the Google Sign-In flow, which presents a native Google account selection UI.
*   **Expected result**:
    *   The user selects a valid Google account and successfully authenticates.
    *   The application navigates the user to the `MainScreen`, which defaults to showing the `GarageScreen`.

## 2. Main Application View (`MainScreen`)

This is the main container for the application after login. It provides the primary navigation and displays the content of the selected screen.

*   **What is shown**:
    *   An app bar with a title that changes based on the selected screen.
    *   A navigation drawer for switching between different feature screens.
    *   The content of the currently selected screen (defaults to `GarageScreen`).

### Navigation Drawer

*   **User action**: The user taps the hamburger icon in the app bar.
*   **What is shown**: A slide-out drawer containing a list of navigable screens:
    *   Garage
    *   Reports
    *   Rentals
    *   Maintenances
    *   Customers
    *   Bikes
*   **User action**: The user taps on an item in the drawer.
*   **Expected result**: The application navigates to the corresponding screen, and the main content area is updated.

## 3. Garage Screen (`GarageScreen`)

This screen provides an overview of the bike fleet, with filtering capabilities.

*   **What is shown**:
    *   The app bar with the title "Garage".
    *   A filter row with three input fields:
        *   Plate Number (text input)
        *   Model (dropdown)
        *   Status (dropdown)
    *   A list of `BikeCard` widgets, each representing a bike.

*   **User actions**:
    1.  **Filter by Plate Number**:
        *   The user types a partial or full plate number into the text field.
        *   **Expected result**: The list of bikes is filtered to show only those with matching plate numbers.
    2.  **Filter by Model**:
        *   The user selects a model from the dropdown.
        *   **Expected result**: The list of bikes is filtered to show only those of the selected model.
    3.  **Filter by Status**:
        *   The user selects a status from the dropdown (e.g., "Available", "Rented").
        *   **Expected result**: The list of bikes is filtered to show only those with the selected status.
    4.  **Navigate to Rent Out**:
        *   The user taps the "Rent Out" button on a `BikeCard` for an available bike.
        *   **Expected result**: The application navigates to the `RentalEditScreen`.
    5.  **Navigate to Return Bike**:
        *   The user taps the "Return Bike" button on a `BikeCard` for a rented bike.
        *   **Expected result**: The application navigates to the `ReturnBikeScreen`.
    6.  **Navigate to Maintenance**:
        *   The user taps the "Repair Done" button on a `BikeCard` for a bike in for maintenance.
        *   **Expected result**: The application navigates to the `MaintenanceEditScreen`.

## 4. Reports Screen (`ReportsScreen`)

This screen provides financial and operational reports for a selected period.

*   **What is shown**:
    *   The app bar with the title "Reports".
    *   A segmented button to select the report period type ("Month" or "Year").
    *   A date picker for selecting the specific month or year.
    *   Three report cards:
        *   **Deposits Held**: Shows the total amount of deposits and the number of documents held.
        *   **Financial Summary**: Shows total earnings, maintenance costs, and the resulting balance.
        *   **Current Bike Fleet Status**: Shows the number of bikes currently rented, in maintenance, and available.
    *   An "Excel Report" button (on web).

*   **User actions**:
    1.  **Change Period Type**:
        *   The user taps either "Month" or "Year" in the segmented button.
        *   **Expected result**: The date picker and report data update to reflect the new period type.
    2.  **Change Period**:
        *   The user taps the left or right arrows to move to the previous or next period.
        *   **Expected result**: The report data updates to reflect the new period.
    3.  **Select Specific Period**:
        *   The user taps the date display to open a date or year picker.
        *   **Expected result**: The user selects a new date/year, and the report data updates accordingly.
    4.  **Download Excel Report** (web only):
        *   The user taps the "Excel Report" button.
        *   **Expected result**: The system generates and downloads an Excel file containing the report data.

## 5. Rentals Screen (`RentalListScreen`)

This screen displays a list of all current and past rentals.

*   **What is shown**:
    *   The app bar with the title "Rentals".
    *   A list of cards, each representing a rental and showing the bike ID, customer name, and rental dates.
    *   An "Add" floating action button.

*   **User actions**:
    1.  **Navigate to Edit Rental**:
        *   The user taps the "Edit" icon on a rental card.
        *   **Expected result**: The application navigates to the `RentalEditScreen` for the selected rental.
    2.  **Navigate to Add Rental**:
        *   The user taps the "Add" floating action button.
        *   **Expected result**: The application navigates to the `RentalEditScreen` to create a new rental.

## 6. Rental Edit Screen (`RentalEditScreen`)

This screen allows for creating a new rental or editing an existing one.

*   **What is shown**:
    *   An app bar with the title "Add Rental" or "Edit Rental".
    *   A form with the following fields:
        *   Bike picker (dropdown)
        *   Customer picker (dropdown)
        *   Rental period (start and end dates)
        *   Final price (text input)
        *   Deposit amount (text input)
        *   Document deposit provided (checkbox)
    *   "Save", "Cancel", and "Delete" buttons.

*   **User actions**:
    1.  **Select a Bike**:
        *   The user selects a bike from the dropdown.
    2.  **Select a Customer**:
        *   The user selects a customer from the dropdown.
    3.  **Add a New Customer**:
        *   The user taps the "Add Customer" button within the customer picker.
        *   **Expected result**: The application navigates to the `CustomerEditScreen`.
    4.  **Set Rental Period**:
        *   The user selects a start and end date for the rental.
    5.  **Enter Financial Details**:
        *   The user enters the final price and deposit amount.
    6.  **Mark Document Deposit**:
        *   The user checks or unchecks the "Document deposit provided" checkbox.
    7.  **Save Rental**:
        *   The user taps the "Save" button.
        *   **Expected result**: The rental is saved, and the user is navigated back to the previous screen.
    8.  **Cancel**:
        *   The user taps the "Cancel" button.
        *   **Expected result**: The user is navigated back to the previous screen without saving any changes.
    9.  **Delete Rental**:
        *   The user taps the "Delete" button.
        *   **Expected result**: A confirmation dialog is shown. If the user confirms, the rental is deleted, and the user is navigated back to the previous screen.

## 7. Return Bike Screen (`ReturnBikeScreen`)

This screen is used to process the return of a rented bike.

*   **What is shown**:
    *   An app bar with the title "Return Bike".
    *   A form with the following fields:
        *   Bike model (read-only)
        *   Rental period (read-only)
        *   Deposit amount (read-only)
        *   Odometer reading (text input)
        *   Actual return date (date picker)
        *   Overdue payment (text input, if applicable)
        *   Maintenance needed (checkbox)
    *   A message indicating if the return is overdue and the amount to be returned to the customer.
    *   "Save" and "Cancel" buttons.

*   **User actions**:
    1.  **Enter Odometer Reading**:
        *   The user enters the current odometer reading of the bike.
    2.  **Select Return Date**:
        *   The user selects the date of the bike's return.
    3.  **Enter Overdue Payment** (if applicable):
        *   If the bike is returned late, the user enters the amount paid for the overdue period.
    4.  **Mark for Maintenance**:
        *   The user checks the "Maintenance needed" checkbox if the bike requires servicing.
    5.  **Save Return**:
        *   The user taps the "Save" button.
        *   **Expected result**: The return is processed, the bike's status is updated, and the user is navigated back to the previous screen.
    6.  **Cancel**:
        *   The user taps the "Cancel" button.
        *   **Expected result**: The user is navigated back to the previous screen without saving any changes.

## 8. Maintenances Screen (`MaintenanceListScreen`)

This screen displays a list of all maintenance records.

*   **What is shown**:
    *   The app bar with the title "Maintenances".
    *   A list of cards, each representing a maintenance record and showing the bike ID, date, and price.
    *   An "Add" floating action button.

*   **User actions**:
    1.  **Navigate to Edit Maintenance**:
        *   The user taps the "Edit" icon on a maintenance card.
        *   **Expected result**: The application navigates to the `MaintenanceEditScreen` for the selected record.
    2.  **Navigate to Add Maintenance**:
        *   The user taps the "Add" floating action button.
        *   **Expected result**: The application navigates to the `MaintenanceEditScreen` to create a new record.

## 9. Maintenance Edit Screen (`MaintenanceEditScreen`)

This screen allows for creating a new maintenance record or editing an existing one.

*   **What is shown**:
    *   An app bar with the title "Add Maintenance" or "Edit Maintenance".
    *   A form with the following fields:
        *   Bike picker (dropdown)
        *   Date (date picker)
        *   Parts (text input)
        *   Price (text input)
    *   "Save", "Cancel", and "Delete" buttons.

*   **User actions**:
    1.  **Select a Bike**:
        *   The user selects a bike from the dropdown.
    2.  **Select a Date**:
        *   The user selects a date for the maintenance record.
    3.  **Enter Parts and Price**:
        *   The user enters a description of the parts used and the total price of the maintenance.
    4.  **Save Maintenance**:
        *   The user taps the "Save" button.
        *   **Expected result**: The maintenance record is saved, and the user is navigated back to the previous screen.
    5.  **Cancel**:
        *   The user taps the "Cancel" button.
        *   **Expected result**: The user is navigated back to the previous screen without saving any changes.
    6.  **Delete Maintenance**:
        *   The user taps the "Delete" button.
        *   **Expected result**: A confirmation dialog is shown. If the user confirms, the maintenance record is deleted, and the user is navigated back to the previous screen.

## 10. Customers Screen (`CustomerListScreen`)

This screen displays a list of all customers.

*   **What is shown**:
    *   The app bar with the title "Customers".
    *   A list of cards, each representing a customer and showing their name and phone number.
    *   An "Add" floating action button.

*   **User actions**:
    1.  **Call Customer**:
        *   The user taps the "Call" icon on a customer card.
        *   **Expected result**: The phone app is launched with the customer's phone number.
    2.  **Navigate to Edit Customer**:
        *   The user taps the "Edit" icon on a customer card.
        *   **Expected result**: The application navigates to the `CustomerEditScreen` for the selected customer.
    3.  **Navigate to Add Customer**:
        *   The user taps the "Add" floating action button.
        *   **Expected result**: The application navigates to the `CustomerEditScreen` to create a new customer.

## 11. Customer Edit Screen (`CustomerEditScreen`)

This screen allows for creating a new customer or editing an existing one.

*   **What is shown**:
    *   An app bar with the title "Add Customer" or "Edit Customer".
    *   A form with the following fields:
        *   Name (text input)
        *   Phone Number (text input)
        *   Address (text input)
    *   "Save", "Cancel", and "Delete" buttons.

*   **User actions**:
    1.  **Enter Customer Details**:
        *   The user enters the customer's name, phone number, and address.
    2.  **Save Customer**:
        *   The user taps the "Save" button.
        *   **Expected result**: The customer is saved, and the user is navigated back to the previous screen.
    3.  **Cancel**:
        *   The user taps the "Cancel" button.
        *   **Expected result**: The user is navigated back to the previous screen without saving any changes.
    4.  **Delete Customer**:
        *   The user taps the "Delete" button.
        *   **Expected result**: A confirmation dialog is shown. If the user confirms, the customer is deleted, and the user is navigated back to the previous screen.

## 12. Bikes Screen (`BikeListScreen`)

This screen displays a list of all bikes in the fleet.

*   **What is shown**:
    *   The app bar with the title "Bikes".
    *   A list of cards, each representing a bike and showing its registration plate, model, and status.
    *   An "Add" floating action button.

*   **User actions**:
    1.  **Navigate to Edit Bike**:
        *   The user taps the "Edit" icon on a bike card.
        *   **Expected result**: The application navigates to the `BikeEditScreen` for the selected bike.
    2.  **Navigate to Add Bike**:
        *   The user taps the "Add" floating action button.
        *   **Expected result**: The application navigates to the `BikeEditScreen` to create a new bike.

## 13. Bike Edit Screen (`BikeEditScreen`)

This screen allows for creating a new bike or editing an existing one.

*   **What is shown**:
    *   An app bar with the title "Add Bike" or "Edit Bike".
    *   A form with the following fields:
        *   Registration Plate (text input)
        *   Model (text input)
        *   Odometer (text input)
        *   Price per Day (text input)
        *   Price per Month (text input)
    *   "Save", "Cancel", and "Delete" buttons.

*   **User actions**:
    1.  **Enter Bike Details**:
        *   The user enters the bike's registration plate, model, odometer reading, and rental prices.
    2.  **Save Bike**:
        *   The user taps the "Save" button.
        *   **Expected result**: The bike is saved, and the user is navigated back to the previous screen.
    3.  **Cancel**:
        *   The user taps the "Cancel" button.
        *   **Expected result**: The user is navigated back to the previous screen without saving any changes.
    4.  **Delete Bike**:
        *   The user taps the "Delete" button.
        *   **Expected result**: A confirmation dialog is shown. If the user confirms, the bike is deleted, and the user is navigated back to the previous screen.
