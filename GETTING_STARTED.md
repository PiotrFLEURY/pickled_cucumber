# Dev starter kit

## Install Dart of Flutter sdk

This project requires Dart and/or Flutter sdk in order to run.

For Dart only purpose you can install Dart sdk only.

> Install Dart 🎯
>
> [https://dart.dev/get-dart](https://dart.dev/get-dart)

For Flutter purpose you can install Flutter sdk.

> Install Flutter 🦋
>
> [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

## Install dependencies

First run `pub get` to install dependencies.

```bash
flutter pub get
```

## Run tests

```bash
dart test
```

## Check coverage

Activate coverage package

```bash
pub global activate coverage
```

Collect coverage

```bash
dart run coverage:test_with_coverage
```

Install lcov

```bash
sudo apt install lcov
```

Generate report

```bash
genhtml -o coverage/html coverage/lcov.info
```
