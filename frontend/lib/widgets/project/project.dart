class Project {
  final String name;

  Project({this.name});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
    );
  }
  
}

