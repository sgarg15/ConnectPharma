import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/model/pharmacistMainModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainProvider extends StateNotifier<PharmacistMainModel> {
  PharmacistMainProvider() : super(PharmacistMainModel());

  List<PickerDateRange> get dateRanges => state.dateRanges;
  Map<String, dynamic>? get userDataMap => state.userData;
  DateTime? get startDate => state.startDate;
  DateTime? get endDate => state.endDate;
  File? get resumePDFData => state.resumePDF;
  bool? get permanentJob => state.permanentJob;
  bool? get nightShift => state.nightShift;

  ///Clears Dates information.
  void clearDates() {
    state.startDate = null;
    state.endDate = null;
  }

  ///Resets the following information:
  /// - [dateRanges]
  /// - [endDate]
  /// - [startDate]
  /// - [permanentJob]
  /// - [resumePDF]
  /// - [userData]
  /// - [nightShift]
  void resetValues() {
    state.dateRanges = [];
    state.endDate = null;
    state.startDate = null;
    state.permanentJob = false;
    state.resumePDF = null;
    state.userData = null;
    state.nightShift = false;
  }

  //Setters
  void changeDateRanges(List<PickerDateRange> dateRanges) {
    state = state.copyWithPharmacistMain(dateRanges: dateRanges);
  }

  void changeUserDataMap(Map<String, dynamic>? data) {
    state = state.copyWithPharmacistMain(userData: data);
  }

  void changeStartDate(DateTime? value) {
    state = state.copyWithPharmacistMain(startDate: value);
  }

  void changeEndDate(DateTime? value) {
    state = state.copyWithPharmacistMain(endDate: value);
  }

  void changeResumePDF(File? asset) {
    state = state.copyWithPharmacistMain(resumePDF: asset);
  }

  void changePermanentJob(bool? value) {
    state = state.copyWithPharmacistMain(permanentJob: value);
  }

  void changeNightShift(bool? value) {
    state = state.copyWithPharmacistMain(nightShift: value);
  }

  ///Clears the resumePDF Data and sets:
  /// - [dateRanges] to its value
  /// - [startDate] to its value
  /// - [userData] to its value
  void clearResumePDF() {
    state = PharmacistMainModel(
      dateRanges: state.dateRanges,
      userData: state.userData,
      startDate: state.startDate,
      resumePDF: null,
    );
    changeResumePDF(null);
  }
}
