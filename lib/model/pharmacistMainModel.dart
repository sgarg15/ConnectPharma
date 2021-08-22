import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainModel {
  List<PickerDateRange> dateRanges = [];
  Map<String, dynamic>? userData;
  DateTime? startDate;
  DateTime? endDate;

  PharmacistMainModel({
    this.dateRanges = const [],
    this.userData = null,
    this.startDate = null,
    this.endDate = null,
  });

  PharmacistMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
    Map<String, dynamic>? userData,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PharmacistMainModel(
      dateRanges: dateRanges ?? this.dateRanges,
      userData: userData ?? this.userData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
