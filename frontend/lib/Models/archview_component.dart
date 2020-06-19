class ArchViewComponent {
    final String id;
    final String userKind;
    final String projectID;
    final String viewID;
    final String description;
    final List<String> links;
    final List<String> functions;
    final List<String> variables;

    ArchViewComponent({this.id, this.description, this.projectID, this.userKind, this.functions, this.variables, this.links, this.viewID});

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
      );
    }
}