import 'package:bemol/app/core/utils/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('String capitalizeFirstLetter', () {
    String originalText = 'exemplo de texto';
    String capitalizedText = originalText.capitalize();
    expect(capitalizedText[0], 'E');
  });
}
