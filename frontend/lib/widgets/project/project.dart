class Project {
  final String id;
  final String name;
  final String owner;
  final String userStory;
  final String functionalView;
  final String developmentView;
  
  Project({this.id, this.name,this.owner, this.userStory, this.functionalView, this.developmentView});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      userStory: json['userStory'],
      functionalView: json['functionalView'],
      developmentView: json['developmentView'],
    );
  }
  
}

