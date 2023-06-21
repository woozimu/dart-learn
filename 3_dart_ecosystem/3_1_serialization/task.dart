import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:toml/toml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'request.dart';



void main() {
  final json = '''
    {
  "type": "success",
  "stream": {
    "user_id": "8d234120-0bda-49b2-b7e0-fbd3912f6cbf",
    "is_private": false,
    "settings": 45345,
    "shard_url": "https://n3.example.com/sapi",
    "public_tariff": {
      "id": 1,
      "price": 100,
      "duration": "1h",
      "description": "test public tariff"
    },
    "private_tariff": {
      "client_price": 250,
      "duration": "1m",
      "description": "test private tariff"
    }
  },
  "gifts": [{
    "id": 1,
    "price": 2,
    "description": "Gift 1"
  }, {
    "id": 2,
    "price": 3,
    "description": "Gift 2"
  }],
  "debug": {
    "duration": "234ms",
    "at": "2019-06-28T08:35:46+00:00"
  }
}
  ''';

  final jsonMap = jsonDecode(json);
  //print(jsonMap);
  final request = Request.fromJson(jsonMap);
var yamlWriter = YAMLWriter();
  final yaml = yamlWriter.write(jsonMap).toString();
  final toml = TomlDocument.fromMap(jsonMap).toString();

  print('YAML:');
  print(yaml);

  print('TOML:');
  print(toml);
}
