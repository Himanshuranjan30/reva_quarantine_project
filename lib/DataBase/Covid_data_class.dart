import 'dart:ffi';

class Covid19Data {
  final String worldWideTotal;
  final String activeCaseInCounrty;
  final String recoveredCaseInCounrty;
  final String deathInCounrty;
  final String totalCasesInCounrty;
  final String stateName;
  final String activeCaseInState;
  final String recoveredCaseInState;
  final String deathInState;
  final String totalCasesInState;

  Covid19Data(
      {this.worldWideTotal,
      this.activeCaseInCounrty,
      this.recoveredCaseInCounrty,
      this.deathInCounrty,
      this.totalCasesInCounrty,
      this.stateName,
      this.activeCaseInState,
      this.recoveredCaseInState,
      this.deathInState,
      this.totalCasesInState});

  factory Covid19Data.fromJson(final json) {
    return Covid19Data(
      worldWideTotal: json["updated"].toStringAsFixed(0),
      activeCaseInCounrty: json["total"]["active"].toStringAsFixed(0),
      recoveredCaseInCounrty: json["total"]["recovered"].toStringAsFixed(0),
      deathInCounrty: json["total"]["deaths"].toStringAsFixed(0),
      totalCasesInCounrty: json["total"]["total"].toStringAsFixed(0),
      stateName: json["states"][15]["state"],
      activeCaseInState: json["states"][15]["active"].toStringAsFixed(0),
      recoveredCaseInState: json["states"][15]["recovered"].toStringAsFixed(0),
      deathInState: json["states"][15]["deaths"].toStringAsFixed(0),
      totalCasesInState: json["states"][15]["total"].toStringAsFixed(0),
    );
  }
}
