import 'package:dune/controllers/main_env_controller.dart';
import 'package:dune/models/environment_item.dart';

const String ENV_REGEX = r'\{\{[^\}\}]*\}\}';
const String BRACKET_REGEX = r'\{|\}';

String getVarRegex(var key) => "\\{\\{.*$key[^\\}\\}]*\\}\\}";

extension EnvironmentParsing on String {
  String parseEnv() {
    List<EnvironmentItem> items = MainEnvController.to.getValidItems();
    var finalStr = this;
    var variables = RegExp(ENV_REGEX)
        .allMatches(this)
        .map((m) => m[0]?.replaceAll(RegExp(BRACKET_REGEX), '').trim());
    for (var variable in variables) {
      dynamic item = items.singleWhere((i) => i.key == variable,
          orElse: () => EnvironmentItem());
      if (item.key != null) {
        finalStr =
            this.replaceAll(RegExp(getVarRegex(item.key)), item.currentValue);
      }
    }
    return finalStr;
  }
}
