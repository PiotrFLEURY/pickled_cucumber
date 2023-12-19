import 'package:build/build.dart';
import 'package:cucumber_dart/src/test_code_builder.dart';
import 'package:source_gen/source_gen.dart';

Builder stepDefinitionBuilder(BuilderOptions options) => LibraryBuilder(
      TestCodeBuilder(),
      generatedExtension: '.g.dart',
    );
