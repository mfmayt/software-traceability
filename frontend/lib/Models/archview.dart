class ArchView {
    final String id;
    final String name;
    final String projectID;
    final String kind;
    final List<String> userKinds;

    ArchView({this.id, this.name, this.projectID, this.kind, this.userKinds});

    factory ArchView.fromJson(Map<String, dynamic> json) {
      return ArchView(
        id: json['id'] as String,
        name: json['name'] as String,
        projectID: json['projectID'] as String,
        kind: json['kind'] as String,
        userKinds: json["userKinds"] != null ? List.from(json["userKinds"]) : null,
      );
    }
    Map<String, dynamic> toJson(){
      return {
        'name': name,
        'projectID': projectID,
        'kind': kind,
        'userKinds': userKinds,
        'id': id,
      };
    }
  }
