import 'package:flutter_test/flutter_test.dart';
import 'package:code_necromancer/models/blueprint_model.dart';
import 'package:code_necromancer/config/api_config.dart';

void main() {
  group('BlueprintModel Tests', () {
    test('BlueprintModel serialization and deserialization', () {
      final json = {
        'id_blueprint': 10,
        'title': 'Unit Test Blueprint',
        'author': 'Tester Dev',
        'price': 'Rp 500.000',
        'stack_label': 'Flutter',
        'description': 'A test blueprint description',
        'is_verified': 1,
        'created_at': '2026-11-17 10:00:00',
      };

      final blueprint = BlueprintModel.fromJson(json);

      expect(blueprint.id, 10);
      expect(blueprint.title, 'Unit Test Blueprint');
      expect(blueprint.author, 'Tester Dev');
      expect(blueprint.price, 'Rp 500.000');
      expect(blueprint.stackLabel, 'Flutter');
      expect(blueprint.isVerified, true);

      final serialized = blueprint.toJson();
      expect(serialized['id_blueprint'], 10);
      expect(serialized['title'], 'Unit Test Blueprint');
      expect(serialized['is_verified'], 1);
    });

    test('ApiConfig returns proper endpoints', () {
      ApiConfig.resetHost();
      expect(ApiConfig.port, 80);

      final readUri = ApiConfig.readEndpoint;
      expect(readUri.path, '/api_blueprint/read.php');

      final createUri = ApiConfig.createEndpoint;
      expect(createUri.path, '/api_blueprint/create.php');

      final updateUri = ApiConfig.updateEndpoint;
      expect(updateUri.path, '/api_blueprint/update.php');

      final deleteUri = ApiConfig.deleteEndpoint;
      expect(deleteUri.path, '/api_blueprint/delete.php');
    });
  });
}
