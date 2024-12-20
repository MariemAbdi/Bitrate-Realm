import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingWrapper<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;

  const LoadingWrapper({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context);
    final isLoading = (provider as dynamic).isLoading;

    return isLoading
        ? Center(
            child: Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            width: 40,
            child: const CircularProgressIndicator(strokeWidth: 1.5),
          ))
        : builder(context, provider);
  }
}
