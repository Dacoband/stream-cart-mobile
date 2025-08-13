import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_router.dart';
import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_event.dart';
import '../../blocs/livestream/livestream_state.dart';

class LiveStreamProductsBottomSheet extends StatelessWidget {
  final LiveStreamBloc bloc;
  final String liveStreamId;
  final BuildContext rootContext;
  final VoidCallback reopenBottomSheet;

  const LiveStreamProductsBottomSheet({
    super.key,
    required this.bloc,
    required this.liveStreamId,
    required this.rootContext,
    required this.reopenBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final st = bloc.state;
    if (st is LiveStreamLoaded) {
      if (!st.isLoadingProducts && st.products.isEmpty) {
        bloc.add(LoadProductsByLiveStreamEvent(liveStreamId));
      }
    } else {
      bloc.add(LoadProductsByLiveStreamEvent(liveStreamId));
    }

    return BlocProvider.value(
      value: bloc,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sản phẩm trong livestream',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<LiveStreamBloc, LiveStreamState>(
                    builder: (c, state) {
                      if (state is LiveStreamLoaded) {
                        if (state.isLoadingProducts && state.products.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state.products.isEmpty) {
                          return const Center(child: Text('Chưa có sản phẩm'));
                        }
                        return ListView.separated(
                          controller: controller,
                          itemBuilder: (_, i) {
                            final p = state.products[i];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: p.productImageUrl.isNotEmpty
                                      ? Image.network(
                                          p.productImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                                        )
                                      : Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                                ),
                              ),
                              title: Text(p.productName, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text(p.variantName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: Text('${p.price.toStringAsFixed(0)} đ', style: const TextStyle(fontWeight: FontWeight.w600)),
                              onTap: () async {
                                Navigator.of(context).pop();
                                await Navigator.pushNamed(
                                  rootContext,
                                  AppRouter.productDetails,
                                  arguments: {
                                    'productId': p.productId,
                                    'imageUrl': p.productImageUrl.isNotEmpty ? p.productImageUrl : null,
                                    'name': p.productName,
                                    'price': p.price,
                                  },
                                );
                                if (!rootContext.mounted) return;
                                reopenBottomSheet();
                              },
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemCount: state.products.length,
                        );
                      }
                      if (state is LiveStreamLoading || state is LiveStreamInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is LiveStreamError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
