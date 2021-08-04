import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainModel {
  List<PickerDateRange> dateRanges = [];
  PharmacistMainModel({
    this.dateRanges = const [],
  });

  PharmacistMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
  }) {
    return PharmacistMainModel(dateRanges: dateRanges ?? this.dateRanges);
  }
}
