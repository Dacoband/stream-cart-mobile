import 'package:equatable/equatable.dart';
import '../../../domain/entities/chatbot/chat_bot_entity.dart';

abstract class ChatBotEvent extends Equatable {
	const ChatBotEvent();

	@override
	List<Object?> get props => [];
}

class LoadChatBotHistory extends ChatBotEvent {
	final bool isRefresh;

	const LoadChatBotHistory({this.isRefresh = false});

	@override
	List<Object?> get props => [isRefresh];
}

class RefreshChatBotHistory extends ChatBotEvent {
	const RefreshChatBotHistory();
}

class SendChatBotMessage extends ChatBotEvent {
	final String message;

	const SendChatBotMessage({required this.message});

	@override
	List<Object?> get props => [message];
}

class ClearChatBot extends ChatBotEvent {
	const ClearChatBot();
}

class ShowChatBotItem extends ChatBotEvent {
	final ChatBotHistoryItem item;

	const ShowChatBotItem(this.item);

	@override
	List<Object?> get props => [item];
}

