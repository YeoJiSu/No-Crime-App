class PopulationModel {
  final String position;
  final int population;

  PopulationModel.fromJson(Map<String, dynamic> json)
      : position = json['위치'],
        population = json['인구수'];
}
