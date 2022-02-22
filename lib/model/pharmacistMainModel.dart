import 'dart:io';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainModel {
  List<PickerDateRange> dateRanges = [];
  Map<String, dynamic>? userData;
  DateTime? startDate;
  DateTime? endDate;
  File? resumePDF;
  bool? permanentJob;

  PharmacistMainModel({
    this.dateRanges = const [],
    this.userData,
    this.startDate,
    this.endDate,
    this.resumePDF,
    this.permanentJob = false,
  });

  PharmacistMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
    Map<String, dynamic>? userData,
    DateTime? startDate,
    DateTime? endDate,
    File? resumePDF,
    bool? permanentJob,
  }) {
    return PharmacistMainModel(
      dateRanges: dateRanges ?? this.dateRanges,
      userData: userData ?? this.userData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      resumePDF: resumePDF ?? this.resumePDF,
      permanentJob: permanentJob ?? this.permanentJob,
    );
  }
}
