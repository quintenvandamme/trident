// 1. import dart:convert
import 'dart:convert';

void main() {
  // this represents some response data we get from the network
  final jsonData =
      '{ "name": "Pizza da Mario", "cuisine": "Italian", "reviews": [{"score": 4.5,"review": "The pizza was amazing!"},{"score": 5.0,"review": "Very friendly staff, excellent service!"}]}';
  // 2. decode the json
  final parsedJson = jsonDecode(jsonData);
  // 3. print the type and value
  print(parsedJson);
}
