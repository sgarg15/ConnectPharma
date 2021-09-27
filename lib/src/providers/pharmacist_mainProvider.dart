import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacistMainModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainProvider extends StateNotifier<PharmacistMainModel> {
  PharmacistMainProvider() : super(PharmacistMainModel());

  List<PickerDateRange> get dateRanges => state.dateRanges;
  Map<String, dynamic>? get userDataMap => state.userData;
  DateTime? get startDate => state.startDate;
  DateTime? get endDate => state.endDate;
  File? get resumePDFData => state.resumePDF;
  bool? get permanentJob => state.permanentJob;

  void clearDates() {
    state.startDate = null;
    state.endDate = null;
  }

  void resetValues() {
    state.dateRanges = [];
    state.endDate = null;
    state.startDate = null;
    state.permanentJob = false;
    state.resumePDF = null;
    state.userData = null;
  }

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
