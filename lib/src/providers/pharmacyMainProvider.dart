import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect/model/pharmacyMainModel.dart';
import '../../all_used.dart';

class PharmacyMainProvider extends StateNotifier<PharmacyMainModel> {
  PharmacyMainProvider() : super(PharmacyMainModel());

  List<Software?>? get softwareList => state.softwareList;
  List<Skill?>? get skillList => state.skillList;
  bool? get techOnSite => state.techOnSite;
  bool? get assistantOnSite => state.assistantOnSite;

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
}
