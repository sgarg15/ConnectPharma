import '../all_used.dart';

class PharmacyMainModel {
  DateTime? startDate;
  DateTime? endDate;
  bool? fullTime;
  List<Software?>? softwareList = [];
  List<Skill?>? skillList = [];
  bool? techOnSite;
  bool? assistantOnSite;
  bool? limaStatus;
  String? hourlyRate;
  String? jobComments;
  Map<String, dynamic>? userData;
  String? position;

  PharmacyMainModel({
    this.startDate,
    this.endDate,
    this.fullTime = false,
    this.softwareList,
    this.skillList,
    this.techOnSite = false,
    this.assistantOnSite = false,
    this.limaStatus = false,
    this.hourlyRate = "",
    this.jobComments = "",
    this.userData,
    this.position,
  });

  PharmacyMainModel copyWithPharmacyMain({
    DateTime? startDate,
    DateTime? endDate,
    bool? fullTime,
    List<Software?>? softwareList,
    List<Skill?>? skillList,
    bool? techOnSite,
    bool? assistantOnSite,
    bool? limaStatus,
    String? hourlyRate,
    String? jobComments,
    Map<String, dynamic>? userData,
    String? position,
  }) {
    return PharmacyMainModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      fullTime: fullTime ?? this.fullTime,
      softwareList: softwareList ?? this.softwareList,
      skillList: skillList ?? this.skillList,
      techOnSite: techOnSite ?? this.techOnSite,
      assistantOnSite: assistantOnSite ?? this.assistantOnSite,
      limaStatus: limaStatus ?? this.limaStatus,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      jobComments: jobComments ?? this.jobComments,
      userData: userData ?? this.userData,
      position: position ?? this.position,
    );
  }
}
