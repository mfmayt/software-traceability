String interpolate(String string, {Map<String, dynamic> params = const {}}) {
  var keys = params.keys;
  String result = string;
  for (var key in keys) {
    result = result.replaceAll('{{$key}}', params[key]);
  }

  return result;
}