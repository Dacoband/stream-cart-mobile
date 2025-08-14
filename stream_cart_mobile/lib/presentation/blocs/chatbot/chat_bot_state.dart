import 'package:equatable/equatable.dart';
import '../../../domain/entities/chatbot/chat_bot_entity.dart';

abstract class ChatBotState extends Equatable {
	const ChatBotState();

	@override
	List<Object?> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotHistoryLoaded extends ChatBotState {
	final ChatBotHistoryEntity history;
	final ChatBotMessageResponseEntity? lastResponse;
	final bool isRefresh;

	const ChatBotHistoryLoaded({
		required this.history,
		this.lastResponse,
		this.isRefresh = false,
	});

	ChatBotHistoryLoaded copyWith({
		ChatBotHistoryEntity? history,
		ChatBotMessageResponseEntity? lastResponse,
		bool? isRefresh,
	}) {
		return ChatBotHistoryLoaded(
			history: history ?? this.history,
			lastResponse: lastResponse ?? this.lastResponse,
			isRefresh: isRefresh ?? this.isRefresh,
		);
	}

	@override
	List<Object?> get props => [history, lastResponse, isRefresh];
}

class ChatBotSending extends ChatBotState {
	final String tempUserMessage;

	const ChatBotSending(this.tempUserMessage);

	@override
	List<Object?> get props => [tempUserMessage];
}

class ChatBotMessageReceived extends ChatBotState {
	final ChatBotMessageResponseEntity response;

	const ChatBotMessageReceived(this.response);

	@override
	List<Object?> get props => [response];
}

class ChatBotError extends ChatBotState {
	final String message;

	const ChatBotError(this.message);

	@override
	List<Object?> get props => [message];
}

class ChatBotCleared extends ChatBotState {}

