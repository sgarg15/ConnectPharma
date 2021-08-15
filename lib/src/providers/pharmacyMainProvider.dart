import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacyMainModel.dart';
import '../../all_used.dart';

class PharmacyMainProvider extends StateNotifier<PharmacyMainModel> {
  PharmacyMainProvider() : super(PharmacyMainModel());
  bool isValidCreateShift() {
    if (state.startDate == null ||
        state.endDate == null ||
        state.softwareList == null ||
        state.hourlyRate == "" ||
        state.jobComments == "") {
      print("true account info");
      return true;
    } else {
      print("false account info");
      return false;
    }
  }

  bool isValidSearchPharmacist() {
    if (state.startDate == null ||
        state.endDate == null ||
        state.skillList!.isEmpty) {
      print("true search pharmacist");
      return true;
    } else {
      print(state.startDate);
      print(state.endDate);
      print(state.skillList);
      print("false search pharmacist");
      return false;
    }
  }

  void clearDateValues() {
    state.startDate = null;
    state.endDate = null;
  }

  void clearValues() {
    state.hourlyRate = "";
    state.jobComments = "";
    state.startDate = null;
    state.endDate = null;
  }

  DateTime? get startDate => state.startDate;
  DateTime? get endDate => state.endDate;
  List<Software?>? get softwareList => state.softwareList;
  List<Skill?>? get skillList => state.skillList;
  bool? get techOnSite => state.techOnSite;
  bool? get assistantOnSite => state.assistantOnSite;
  bool? get limaStatus => state.limaStatus;
  String? get hourlyRate => state.hourlyRate;
  String? get jobComments => state.jobComments;
  Map<String, dynamic>? get userData => state.userData;

  void changeStartDate(DateTime? value) {
    state = state.copyWithPharmacyMain(startDate: value);
  }

  void changeEndDate(DateTime? value) {
    state = state.copyWithPharmacyMain(endDate: value);
  }

  void changeSoftwareList(List<Software?> value) {
    state = state.copyWithPharmacyMain(softwareList: value);
  }

  void changeSkillList(List<Skill?> value) {
    state = state.copyWithPharmacyMain(skillList: value);
  }

  void changeTechOnSite(bool? value) {
    state = state.copyWithPharmacyMain(techOnSite: value);
  }

  void changeAssistantOnSite(bool? value) {
    state = state.copyWithPharmacyMain(assistantOnSite: value);
  }

  void changeLIMAStatus(bool? value) {
    state = state.copyWithPharmacyMain(limaStatus: value);
  }

  void changeHourlyRate(String value) {
    state = state.copyWithPharmacyMain(hourlyRate: value);
  }

  void changeComments(String value) {
    state = state.copyWithPharmacyMain(jobComments: value);
  }

  void changeUserDataMap(Map<String, dynamic>? data) {
    state = state.copyWithPharmacyMain(userData: data);
  }
}
