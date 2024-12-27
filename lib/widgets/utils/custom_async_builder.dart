import 'package:async_builder/async_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../translations/locale_keys.g.dart';

class CustomAsyncBuilder<T> extends StatelessWidget {
  const CustomAsyncBuilder(
      {Key? key,
      this.future,
      this.stream,
      required this.builder,
      this.errorMessage})
      : super(key: key);

  final Future<T>? future;
  final Stream<T>? stream;
  final Widget Function(BuildContext, T?) builder;
  final String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<T>(
      future: future,
      stream: stream,
      waiting: (context) {
        return const Center(
            child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(strokeWidth: 1.5)
            )
        );
      },
      builder: builder,
      error: (context, error, stackTrace){
        debugPrint(error.toString());
        return Center(
          child: Text(errorMessage ?? LocaleKeys.somethingWentWrong.tr(),
              style: context.textTheme.headlineSmall),
        );
      }
    );
  }
}
