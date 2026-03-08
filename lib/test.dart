import 'dart:io';
import 'dart:convert';

void main() async {
  var request = await HttpClient().getUrl(
    Uri.parse('https://pub.dev/packages/flutter_bloc/score'),
  );
  var response = await request.close();
  var body = await response.transform(utf8.decoder).join();
  await File('pub_dev_score.html').writeAsString(body);
  print('done');
}
