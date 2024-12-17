import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingWrapper<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;
  final Widget loadingIndicator;

  const LoadingWrapper({
    required this.builder,
    this.loadingIndicator = const Center(child: Padding(
      padding: EdgeInsets.all(8),
      child: CircularProgressIndicator(),
    )),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context);
    final isLoading = (provider as dynamic).isLoading;

    return isLoading ? loadingIndicator : builder(context, provider);
  }
}
