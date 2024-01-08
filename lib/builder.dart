import 'package:build/build.dart';
import 'package:pickled_cucumber/src/test_code_builder.dart';
import 'package:source_gen/source_gen.dart';

Builder stepDefinitionBuilder(BuilderOptions options) => LibraryBuilder(
      TestCodeBuilder(),
      generatedExtension: '.pickled.dart',
    );
