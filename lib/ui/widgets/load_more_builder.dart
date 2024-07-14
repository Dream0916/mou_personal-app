import 'package:flutter/material.dart';
import 'package:mou_app/ui/base/loadmore_viewmodel.dart';
import 'package:mou_app/ui/widgets/app_loading.dart';

class LoadMoreBuilder<DataType> extends StatelessWidget {
  final LoadMoreViewModel<DataType> viewModel;
  final Stream<List<DataType>> stream;
  final Widget Function(
    BuildContext context,
    List<DataType> data,
    bool isLoadMore,
  ) builder;

  const LoadMoreBuilder({
    super.key,
    required this.viewModel,
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: viewModel.loadingSubject,
      builder: (_, loadingSnapshot) {
        bool loading = loadingSnapshot.data ?? false;
        return loading
            ? const AppLoadingIndicator()
            : NotificationListener(
                onNotification: viewModel.onNotification,
                child: StreamBuilder<bool>(
                  stream: viewModel.loadMoreSubject,
                  builder: (_, loadMoreSnapshot) {
                    bool loadMore = loadMoreSnapshot.data ?? false;
                    return StreamBuilder<List<DataType>>(
                      stream: stream,
                      builder: (_, dataSnapshot) {
                        if (dataSnapshot.connectionState == ConnectionState.waiting)
                          return const AppLoadingIndicator();
                        List<DataType> data = dataSnapshot.data ?? [];
                        return builder(context, data, loadMore);
                      },
                    );
                  },
                ),
              );
      },
    );
  }
}
