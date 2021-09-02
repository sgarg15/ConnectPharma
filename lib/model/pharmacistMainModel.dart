import 'dart:io';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainModel {
  List<PickerDateRange> dateRanges = [];
  Map<String, dynamic>? userData;
  DateTime? startDate;
  DateTime? endDate;
  File? resumePDF;

  PharmacistMainModel({
    this.dateRanges = const [],
    this.userData = null,
    this.startDate = null,
    this.endDate = null,
    this.resumePDF,
  });

  PharmacistMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
    Map<String, dynamic>? userData,
    DateTime? startDate,
    DateTime? endDate,
    File? resumePDF,
  }) {
    return PharmacistMainModel(
      dateRanges: dateRanges ?? this.dateRanges,
      userData: userData ?? this.userData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      resumePDF: resumePDF ?? this.resumePDF,
    );
  }
}
