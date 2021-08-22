import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacistMainModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainProvider extends StateNotifier<PharmacistMainModel> {
  PharmacistMainProvider() : super(PharmacistMainModel());

  List<PickerDateRange> get dateRanges => state.dateRanges;
  Map<String, dynamic>? get userDataMap => state.userData;
  DateTime? get startDate => state.startDate;
  DateTime? get endDate => state.endDate;

  void clearDates() {
    state.startDate = null;
    state.endDate = null;
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
}
