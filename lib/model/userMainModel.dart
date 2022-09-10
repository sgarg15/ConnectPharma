import 'dart:io';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserMainModel {
  List<PickerDateRange> dateRanges = [];
  Map<String, dynamic>? userData;
  DateTime? startDate;
  DateTime? endDate;
  File? resumePDF;
  bool? permanentJob;
  bool? nightShift;

  UserMainModel({
    this.dateRanges = const [],
    this.userData,
    this.startDate,
    this.endDate,
    this.resumePDF,
    this.permanentJob = false,
    this.nightShift = false,
  });

  UserMainModel copyWithPharmacistMain({
    List<PickerDateRange>? dateRanges,
    Map<String, dynamic>? userData,
    DateTime? startDate,
    DateTime? endDate,
    File? resumePDF,
    bool? permanentJob,
    bool? nightShift,
  }) {
    return UserMainModel(
      dateRanges: dateRanges ?? this.dateRanges,
      userData: userData ?? this.userData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      resumePDF: resumePDF ?? this.resumePDF,
      permanentJob: permanentJob ?? this.permanentJob,
      nightShift: nightShift ?? this.nightShift,
    );
  }
}
