import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpharma/model/pharmacyMainModel.dart';
import '../../all_used.dart';

class PharmacyMainProvider extends StateNotifier<PharmacyMainModel> {
  PharmacyMainProvider() : super(PharmacyMainModel());

  ///Checks if the create shift page is valid
  bool isValidCreateShift() {
    if (state.startDate == null ||
        state.endDate == null ||
        state.startTime == null ||
        state.endTime == null ||
        state.skillList == null ||
        state.hourlyRate == "" ||
        state.jobComments == "") {
      print("Create shift is not valid");
      return false;
    } else {
      print("Create shift is valid");
      return true;
    }
  }

  ///Checks if the search pharmacist page is valid
  bool isValidSearchPharmacist(bool showAllPharmacist) {
    if (showAllPharmacist && state.position != null) {
      print("Show all pharmacist enabled");
      return true;
    } else if (state.startDate != null &&
        state.endDate != null &&
        state.position != null &&
        state.startTime != null &&
        state.endTime != null) {
      print("Search pharmacist page valid");
      return true;
    } else {
      print("Search pharmacist page not valid");
      return false;
    }
  }

  ///Clears the following values:
  /// - [startDate]
  /// - [endDate]
  /// - [startTime]
  /// - [endTime]
  /// - [skillList]
  /// - [languageList]
  /// - [softwareList]
  /// - [position]
  /// - [hourlyRate]
  /// - [jobComments]
  /// - [fullTime]
  void clearDateValues() {
    state.startDate = null;
    state.endDate = null;
    state.startTime = null;
    state.endTime = null;
    state.skillList = null;
    state.languageList = null;
    state.softwareList = null;
    state.position = null;
    state.hourlyRate = "";
    state.jobComments = "";
    state.fullTime = false;
  }

  ///Clears many values
  void resetValues() {
    state.startDate = null;
    state.endDate = null;
    state.startTime = null;
    state.endTime = null;
    state.hourlyRate = "";
    state.jobComments = "";
    state.softwareList = null;
    state.skillList = null;
    state.techOnSite = false;
    state.assistantOnSite = false;
    state.limaStatus = false;
    state.userData = null;
  }


  //Getters
  DateTime? get startDate => state.startDate;
  DateTime? get endDate => state.endDate;
  TimeOfDay? get startTime => state.startTime;
  TimeOfDay? get endTime => state.endTime;
  List<Software?>? get softwareList => state.softwareList;
  List<Skill?>? get skillList => state.skillList;
  List<Language?>? get languageList => state.languageList;
  bool? get techOnSite => state.techOnSite;
  bool? get assistantOnSite => state.assistantOnSite;
  bool? get limaStatus => state.limaStatus;
  String? get hourlyRate => state.hourlyRate;
  String? get jobComments => state.jobComments;
  Map<String, dynamic>? get userData => state.userData;
  bool? get fullTime => state.fullTime;
  String? get position => state.position;


  //Setters
  void changeStartDate(DateTime? value) {
    state = state.copyWithPharmacyMain(startDate: value);
  }

  void changeStartTime(TimeOfDay? value) {
    state = state.copyWithPharmacyMain(startTime: value);
  }

  void changeEndDate(DateTime? value) {
    state = state.copyWithPharmacyMain(endDate: value);
  }

  void changeEndTime(TimeOfDay? value) {
    state = state.copyWithPharmacyMain(endTime: value);
  }

  void changeSoftwareList(List<Software?> value) {
    state = state.copyWithPharmacyMain(softwareList: value);
  }

  void changeSkillList(List<Skill?> value) {
    state = state.copyWithPharmacyMain(skillList: value);
  }

  void changeLanguageList(List<Language?> value) {
    state = state.copyWithPharmacyMain(languageList: value);
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

  void changePosition(String? position) {
    state = state.copyWithPharmacyMain(position: position);
  }

  void changeFullTimeStatus(bool? fullTimeStatus) {
    state = state.copyWithPharmacyMain(fullTime: fullTimeStatus);
  }
}
