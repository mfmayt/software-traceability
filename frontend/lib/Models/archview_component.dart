class ArchViewComponent {
    final String id;
    final String userKind;
    final String projectID;
    final String viewID;
    final String kind;
    final String description;
    final List<String> links;
    final List<String> functions;
    final List<String> variables;
    final int level;

    ArchViewComponent({this.id, this.description, this.kind, this.projectID, this.userKind, this.functions, this.variables, this.links, this.viewID, this.level});

    factory ArchViewComponent.fromJson(Map<String, dynamic> json) {
      return ArchViewComponent(
        id: json['id'] as String,
        description: json['description'] as String,
        projectID: json['projectID'] as String,
        viewID: json['viewID'] as String,
        userKind: json['userKind'] as String,
        functions: json["functions"] != null ? List.from(json["functions"]) : null,
        links: json["links"] != null ? List.from(json["links"]) : null,
        variables: json["variables"] != null ? List.from(json["variables"]) : null,
        kind: json["kind"] as String,
        level: json["level"] as int,
      );
    }
    Map<String, dynamic> toJson(){
      return {
        'id': id,
        'description': description,
        'projectID': projectID,
        'viewID': viewID,
        'userKind': userKind,
        'kind': kind,
        'links': links,
        'functions': functions,
        'variables': variables,
        'level': level,
      };
    }
}