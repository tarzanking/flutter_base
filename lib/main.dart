import 'package:flutter/material.dart';

import 'my_app.dart';
import 'sub_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SubMain.initServices();
  runApp(MyApp());
}