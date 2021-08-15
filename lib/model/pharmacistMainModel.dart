import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainModel {
  List<PickerDateRange> dateRanges = [];
  Map<String, dynamic>? userData;
  PharmacistMainModel({
    this.dateRanges = const [],
    this.userData = null,
  });

  PharmacistMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
    Map<String, dynamic>? userData,
  }) {
    return PharmacistMainModel(
      dateRanges: dateRanges ?? this.dateRanges,
      userData: userData ?? this.userData,
    );
  }
}
