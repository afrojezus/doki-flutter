import 'package:doki/screens/viewer_vm.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<ViewerViewModel>(ViewerViewModel());
}
