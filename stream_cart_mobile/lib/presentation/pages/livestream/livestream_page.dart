import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_event.dart';
import '../../blocs/livestream/livestream_state.dart';
import '../../widgets/livestream/video_section.dart';
import '../../widgets/livestream/info_bar.dart';
import '../../widgets/livestream/chat_section.dart';
import '../../widgets/livestream/error_retry.dart';
import '../../../core/config/livekit_config.dart';
import '../../widgets/livestream/livestream_products_bottom_sheet.dart';
import '../../widgets/livestream/chat_input.dart';

class LiveStreamPage extends StatefulWidget {
  final String liveStreamId;

  const LiveStreamPage({super.key, required this.liveStreamId});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  bool _chatInitRequested = false;
  @override
  void initState() {
    super.initState();
  }

  void _dispatchInitial(BuildContext context) {
    final bloc = context.read<LiveStreamBloc>();
    if (bloc.state is LiveStreamInitial) {
      bloc
        ..add(LoadLiveStreamEvent(widget.liveStreamId))
  ..add(JoinLiveStreamEvent(widget.liveStreamId))
  ..add(LoadProductsByLiveStreamEvent(widget.liveStreamId))
  ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LiveStreamBloc>(),
      child: Builder(
        builder: (innerCtx) {
          _dispatchInitial(innerCtx);
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'Livestream',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Sản phẩm',
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => _showProductsBottomSheet(innerCtx),
                ),
              ],
              backgroundColor: Color(0xFF202328),
              foregroundColor: Color(0xFFB0F847),
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            body: BlocConsumer<LiveStreamBloc, LiveStreamState>(
              listenWhen: (prev, curr) => curr is LiveStreamLoaded,
              listener: (ctx, state) {
                if (state is LiveStreamLoaded) {
                  if (!state.isConnectedRoom && !state.isConnectingRoom && state.liveStream.joinToken != null) {
                    ctx.read<LiveStreamBloc>().add(
                      ConnectLiveKitEvent(url: LiveKitConfig.serverUrl, token: state.liveStream.joinToken!),
                    );
                  }
                  if (!_chatInitRequested && !state.chatInitialized) {
                    _chatInitRequested = true;
                    ctx.read<LiveStreamBloc>()
                      ..add(JoinChatLiveStreamEvent(widget.liveStreamId))
                      ..add(LoadLiveStreamMessagesEvent(widget.liveStreamId));
                  }
                }
              },
              builder: (ctx, state) {
                if (state is LiveStreamLoading || state is LiveStreamInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LiveStreamError) {
      return ErrorRetry(
                    message: state.message,
                    onRetry: () => ctx.read<LiveStreamBloc>().add(LoadLiveStreamEvent(widget.liveStreamId)),
                  );
                }
                if (state is LiveStreamLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ctx.read<LiveStreamBloc>().add(RefreshLiveStreamEvent(widget.liveStreamId));
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: VideoSection(state: state)),
                        SliverToBoxAdapter(child: InfoBar(state: state)),
                        SliverFillRemaining(hasScrollBody: true, child: ChatSection(messages: state.joinedMessages)),
                      ],
                    ),
                  );
                }
                if (state is LiveStreamListLoading || state is LiveStreamListLoaded || state is LiveStreamListError) {
                  return const Center(child: Text('Danh sách không hỗ trợ ở trang này'));
                }
                return const SizedBox();
              },
            ),
            bottomNavigationBar: LiveStreamChatInput(liveStreamId: widget.liveStreamId),
          );
        },
      ),
    );
  }
}

extension on _LiveStreamPageState {
  void _showProductsBottomSheet(BuildContext context) {
    final rootContext = context;
    final bloc = context.read<LiveStreamBloc>();

    void reopen() {
      _showProductsBottomSheet(rootContext);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => LiveStreamProductsBottomSheet(
        bloc: bloc,
        liveStreamId: widget.liveStreamId,
        rootContext: rootContext,
        reopenBottomSheet: reopen,
      ),
    );
  }
}