// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'CRM Xe máy';

  @override
  String get login => 'Đăng nhập';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get update => 'Cập nhật';

  @override
  String get create => 'Tạo';

  @override
  String get btnRetry => 'Thử lại';

  @override
  String get msgRequired => 'Trường này là bắt buộc';

  @override
  String get msgValidNumber => 'Vui lòng nhập một số hợp lệ';

  @override
  String get msgOnlyPositive => 'Vui lòng nhập giá trị lớn hơn 0';

  @override
  String get msgDeleteSuccess => 'đã xóa thành công';

  @override
  String get msgDeleteFailed => 'Xóa thất bại';

  @override
  String get msgLoadFailed => 'Tải thất bại';

  @override
  String get msgLoading => 'Đang tải...';

  @override
  String get msgNoBikesAvailable => 'Không có xe máy nào';

  @override
  String get msgNoCustomersAvailable => 'Không có khách hàng nào';

  @override
  String get msgNoRentalsAvailable => 'Không có lượt thuê nào';

  @override
  String get msgPhoneLaunchFailed => 'Không thể thực hiện cuộc gọi';

  @override
  String get screenAddBike => 'Thêm xe máy';

  @override
  String get screenEditBike => 'Sửa xe máy';

  @override
  String get labelPlate => 'Biển số xe';

  @override
  String get labelBike => 'Xe máy';

  @override
  String get labelModel => 'Kiểu xe';

  @override
  String get labelOdometer => 'Số công tơ mét';

  @override
  String get labelPricePerDay => 'Giá mỗi ngày';

  @override
  String get labelPricePerMonth => 'Giá mỗi tháng';

  @override
  String get msgSaveBikeFailed => 'Không thể thêm xe máy mới';

  @override
  String get msgConfirmDeleteBike =>
      'Bạn có chắc chắn muốn xóa chiếc xe máy này không:';

  @override
  String get msgPlateExist => 'Biển số này đã tồn tại';

  @override
  String get msgNoRecords => 'Chưa có bản ghi nào';

  @override
  String get msgFilteredAll => 'Không có kết quả nào khớp với bộ lọc này';

  @override
  String get msgAddSome =>
      'Vui lòng thêm bản ghi bằng nút + ở góc dưới bên phải';

  @override
  String get screenAddCustomer => 'Thêm khách hàng';

  @override
  String get screenEditCustomer => 'Sửa thông tin khách hàng';

  @override
  String get msgConfirmDeleteCustomer =>
      'Bạn có chắc chắn muốn xóa khách hàng này không:';

  @override
  String get msgSaveCustomerFailed => 'Không thể thêm khách hàng mới';

  @override
  String get labelName => 'Tên khách hàng';

  @override
  String get labelPhoneNumber => 'Số điện thoại';

  @override
  String get msgValidPhoneNumber =>
      'Chỉ gồm số, dấu gạch ngang và dấu ngoặc đơn';

  @override
  String get labelAddress => 'Địa chỉ';

  @override
  String get msgNavigateToBikes =>
      'Vui lòng thêm xe từ màn hình quản lý Xe máy';

  @override
  String get msgSelectBike => 'Vui lòng chọn một chiếc xe máy';

  @override
  String get msgSelectCustomer => 'Vui lòng chọn một khách hàng';

  @override
  String get msgSaveMaintenanceFailed => 'Không thể thêm bản ghi bảo trì mới';

  @override
  String get msgConfirmDeleteMaintenance =>
      'Bạn có chắc muốn xóa bản ghi bảo trì này không? Điều này sẽ phá vỡ tính nhất quán của dữ liệu tài chính.';

  @override
  String get screenAddMaintenance => 'Thêm bảo trì';

  @override
  String get screenEditMaintenance => 'Sửa bảo trì';

  @override
  String get labelParts => 'Phụ tùng';

  @override
  String get labelPrice => 'Giá tiền';

  @override
  String get labelDate => 'Ngày';

  @override
  String get msgConfirmDeleteRental =>
      'Bạn có chắc muốn xóa bản ghi cho thuê này không? Điều này sẽ phá vỡ tính nhất quán của dữ liệu tài chính.';

  @override
  String get btnAddCustomer => 'Thêm khách hàng';

  @override
  String get labelDeposit => 'Tiền cọc';

  @override
  String get screenAddRental => 'Thêm lượt thuê';

  @override
  String get screenEditRental => 'Sửa lượt thuê';

  @override
  String get by => 'bởi';

  @override
  String get labelMaintenanceNeeded => 'Cần bảo trì';

  @override
  String get msgRentFailed => 'Không thể tạo bản ghi cho thuê mới';

  @override
  String get msgReturnFailed => 'Không thể hoàn tất lượt thuê';

  @override
  String get themeDark => 'Chế độ tối';

  @override
  String get themeLight => 'Chế độ sáng';

  @override
  String get labelOdometerReturn => 'Số công tơ mét khi trả';

  @override
  String get labelFinalPrice => 'Giá cuối cùng';

  @override
  String get labelBalance => 'Số dư';

  @override
  String get labelBikeId => 'Mã xe máy';

  @override
  String get labelStatus => 'Trạng thái';

  @override
  String get labelDays => 'Số ngày';

  @override
  String get labelStartDate => 'Ngày bắt đầu thuê';

  @override
  String get labelEndDate => 'Ngày kết thúc thuê';

  @override
  String get labelActualReturnDate => 'Ngày trả thực tế';

  @override
  String get labelPaid => 'Đã thanh toán';

  @override
  String get labelPending => 'Đang chờ';

  @override
  String get labelDocumentDepositProvided => 'Đã cung cấp giấy tờ đặt cọc';

  @override
  String get labelMonth => 'Tháng';

  @override
  String get labelYear => 'Năm';

  @override
  String get labelCustomer => 'Khách hàng';

  @override
  String get labelSelectYear => 'Chọn năm';

  @override
  String get labelDepositsHeld => 'Các khoản cọc đang giữ';

  @override
  String get labelTotalDeposits => 'Tổng tiền cọc hiện có';

  @override
  String get labelDocumentsHeld => 'Giấy tờ gốc đang giữ';

  @override
  String get labelFinancialSummary => 'Tóm tắt tài chính';

  @override
  String get labelTotalEarnings => 'Tổng doanh thu';

  @override
  String get labelTotalMaintenanceCosts => 'Tổng chi phí bảo trì';

  @override
  String get labelCurrentBikeFleetStatus => 'Tình trạng đội xe';

  @override
  String get labelBikesCurrentlyRented => 'Số xe máy đang cho thuê';

  @override
  String get labelBikesCurrentlyInMaintenance => 'Số xe máy đang bảo trì';

  @override
  String get labelBikesCurrentlyAvailable => 'Số xe máy có sẵn';

  @override
  String get labelExcelReport => 'Tải báo cáo đầy đủ (Excel)';

  @override
  String get labelGeneratingReport => 'Đang tạo báo cáo Excel...';

  @override
  String get labelDownloadingReport => 'Đang tải báo cáo Excel...';

  @override
  String get labelFailedToCreateReport => 'Tạo báo cáo thất bại';

  @override
  String get labelAmountReturnedToCustomer => 'Số tiền trả lại khách';

  @override
  String get labelOverduePayment =>
      'Thanh toán quá hạn (bao gồm cả khoản bị giữ lại)';

  @override
  String get screenGarage => 'Nhà xe';

  @override
  String get screenReports => 'Báo cáo';

  @override
  String get screenRentals => 'Lượt thuê';

  @override
  String get screenMaintenances => 'Bảo trì';

  @override
  String get screenCustomers => 'Khách hàng';

  @override
  String get screenBikes => 'Xe máy';

  @override
  String get screenReturnBike => 'Hoàn tất lượt thuê';

  @override
  String get msgDelayedReturn => 'Việc trả xe máy bị chậm';

  @override
  String get msgDelayedDays => 'ngày';

  @override
  String get msgCustomerShouldPay => 'Khách hàng nợ bạn:';

  @override
  String get msgCustomerShouldGetBack => 'Khách hàng sẽ nhận lại:';

  @override
  String get actionLogout => 'Đăng xuất';

  @override
  String get actionRentOut => 'Cho thuê';

  @override
  String get actionOverdue => 'Trả xe máy';

  @override
  String get actionReturnBike => 'Trả xe máy';

  @override
  String get actionBooked => 'Cho thuê';

  @override
  String get actionRepairDone => 'Sửa xong';

  @override
  String get msgNoAvailable => 'Không có';

  @override
  String get bikeStatusGarage => 'Trong Kho';

  @override
  String get bikeStatusRented => 'Đã Thuê';

  @override
  String get bikeStatusMaintenance => 'Bảo Trì';

  @override
  String get bikeStatusUnknown => 'Không Rõ';

  @override
  String get paymentStatusPaid => 'Đã Thanh Toán';

  @override
  String get paymentStatusPending => 'Chờ Thanh Toán';
}
