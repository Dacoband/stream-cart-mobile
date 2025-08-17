import 'package:equatable/equatable.dart';

class ChatBotHistoryItem extends Equatable {
	final DateTime timestamp;
	final String userMessage;
	final String aiResponse;

	const ChatBotHistoryItem({
		required this.timestamp,
		required this.userMessage,
		required this.aiResponse,
	});

	ChatBotHistoryItem copyWith({
		DateTime? timestamp,
		String? userMessage,
		String? aiResponse,
	}) => ChatBotHistoryItem(
				timestamp: timestamp ?? this.timestamp,
				userMessage: userMessage ?? this.userMessage,
				aiResponse: aiResponse ?? this.aiResponse,
			);

	@override
	List<Object?> get props => [timestamp, userMessage, aiResponse];
}

class ChatBotHistoryEntity extends Equatable {
	final String userId;
	final List<ChatBotHistoryItem> history;

	const ChatBotHistoryEntity({
		required this.userId,
		required this.history,
	});

	ChatBotHistoryEntity copyWith({
		String? userId,
		List<ChatBotHistoryItem>? history,
	}) => ChatBotHistoryEntity(
				userId: userId ?? this.userId,
				history: history ?? this.history,
			);

	@override
	List<Object?> get props => [userId, history];
}

class ChatBotMessageResponseEntity extends Equatable {
	final String response;
	final String status;
	final Map<String, dynamic>? metadata;

	const ChatBotMessageResponseEntity({
		required this.response,
		required this.status,
		this.metadata,
	});

	ChatBotMessageResponseEntity copyWith({
		String? response,
		String? status,
		Map<String, dynamic>? metadata,
	}) => ChatBotMessageResponseEntity(
				response: response ?? this.response,
				status: status ?? this.status,
				metadata: metadata ?? this.metadata,
			);

	@override
	List<Object?> get props => [response, status, metadata];
}

