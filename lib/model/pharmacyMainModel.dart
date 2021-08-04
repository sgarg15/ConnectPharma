import '../all_used.dart';

class PharmacyMainModel {
  List<Software?>? softwareList = [];
  List<Skill?>? skillList = [];
  bool? techOnSite;
  bool? assistantOnSite;
  PharmacyMainModel({
    this.softwareList,
    this.skillList,
    this.techOnSite = false,
    this.assistantOnSite = false,
  });

  PharmacyMainModel copyWithPharmacyMain({
    List<Software?>? softwareList,
    List<Skill?>? skillList,
    bool? techOnSite,
    bool? assistantOnSite,
  }) {
    return PharmacyMainModel(
      softwareList: softwareList ?? this.softwareList,
      skillList: skillList ?? this.skillList,
      techOnSite: techOnSite ?? this.techOnSite,
      assistantOnSite: assistantOnSite ?? this.assistantOnSite,
    );
  }
}
