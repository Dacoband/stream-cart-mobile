// Hiển thị trạng thái kết nối của LiveKit.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';

class LiveKitStatusWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
                if (state is LiveKitConnected) {
                  return Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Đang kết nối: ${state.chatRoomId}'),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => context.read<ChatBloc>().add(DisconnectLiveKit()),
                            color: Colors.red,
                          ),
                        ],
                      ),
                  );
                }
                if (state is ChatReconnecting) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(width: 8),
                        Text(state.message),
                      ],
                    ),
                  );
                }
                if (state is ChatReconnectFailed) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Kết nối lại thất bại: ${state.message}', style: TextStyle(color: Colors.red)),
                  );
                }
                if (state is ChatStatusChanged) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(state.status),
                  );
                }
                if (state is LiveKitDisconnected) return Text('Ngắt kết nối');
                if (state is ChatError) return Text('Lỗi: ${(state).message}', style: TextStyle(color: Colors.red));
                return SizedBox.shrink();
            },
        );
    }
}