import 'package:http/http.dart' as http;

void main() async {
  final res = await http.get(Uri.parse('https://pub.dev/packages'));
  final body = res.body;
  final regex = RegExp(r'<option\s+value="([^"]+)"[^>]*>([^<]+)</option>');
  final matches = regex.allMatches(body);
  for (var match in matches) {
    print('${match.group(1)}: ${match.group(2)?.trim()}');
  }
}
