import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacistMainModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PharmacistMainProvider extends StateNotifier<PharmacistMainModel> {
  PharmacistMainProvider() : super(PharmacistMainModel());

  List<PickerDateRange> get dateRanges => state.dateRanges;

  void changeDateRanges(List<PickerDateRange> dateRanges) {
    state = state.copyWithPharmacistMain(dateRanges: dateRanges);
  }
}
