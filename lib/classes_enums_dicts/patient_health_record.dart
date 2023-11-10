class BasicInfo {
  final String name;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final String bmi;
  final String ethnic;
  final String icNo;

  BasicInfo({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.ethnic,
    required this.icNo,
  });

  BasicInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        age = json['age'].toString(),
        gender = json['gender'].toString(),
        height = json['height'].toString(),
        weight = json['weight'].toString(),
        bmi = json['bmi'].toString(),
        ethnic = json['ethnic'].toString(),
        icNo = json['icNo'].toString();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'ethnic': ethnic,
      'icNo': icNo,
    };
  }
}
