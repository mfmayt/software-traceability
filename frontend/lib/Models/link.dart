class Link {
    final String id;
    final String from;
    final String to;
    final String kind;
    final String projectID;
    final bool inView;

    Link({this.id, this.from, this.projectID, this.to, this.kind, this.inView});

    factory Link.fromJson(Map<String, dynamic> json) {
      return Link(
        id: json['id'] as String,
        from: json['from'] as String,
        projectID: json['projectID'] as String,
        to: json['to'] as String,
        kind: json["kind"] as String,
        inView: json["inView"] as bool,
      );
    }
    Map<String, dynamic> toJson(){
      return {
        'from': from,
        'projectID': projectID,
        'kind': kind,
        'to': to,
        'id': id,
        'inView': inView,
      };
    }
  }
