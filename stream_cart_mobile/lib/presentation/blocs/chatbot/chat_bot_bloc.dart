import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chatbot/chat_bot_entity.dart';
import '../../../domain/usecases/chatbot/get_chatbot_history_usecase.dart';
import '../../../domain/usecases/chatbot/send_chatbot_message_usecase.dart';
import 'chat_bot_event.dart';
import 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
	final GetChatBotHistoryUseCase getHistoryUseCase;
	final SendChatBotMessageUseCase sendMessageUseCase;

	ChatBotHistoryEntity? _historyCache;

	ChatBotBloc({
		required this.getHistoryUseCase,
		required this.sendMessageUseCase,
	}) : super(ChatBotInitial()) {
		on<LoadChatBotHistory>(_onLoadHistory);
		on<RefreshChatBotHistory>(_onRefreshHistory);
		on<SendChatBotMessage>(_onSendMessage);
		on<ClearChatBot>(_onClear);
		on<ShowChatBotItem>(_onShowItem);
	}

	Future<void> _onLoadHistory(
		LoadChatBotHistory event,
		Emitter<ChatBotState> emit,
	) async {
		if (!event.isRefresh) emit(ChatBotLoading());

		final result = await getHistoryUseCase();
		result.fold(
			(failure) => emit(ChatBotError(failure.message)),
			(history) {
				_historyCache = history;
				emit(ChatBotHistoryLoaded(history: history, isRefresh: event.isRefresh));
			},
		);
	}

	Future<void> _onRefreshHistory(
		RefreshChatBotHistory event,
		Emitter<ChatBotState> emit,
	) async {
		add(const LoadChatBotHistory(isRefresh: true));
	}

	Future<void> _onSendMessage(
		SendChatBotMessage event,
		Emitter<ChatBotState> emit,
	) async {
		final now = DateTime.now();
		ChatBotHistoryItem tempItem = ChatBotHistoryItem(
			timestamp: now,
			userMessage: event.message,
			aiResponse: '',
		);

		// Ensure we have an in-memory history for the current session
		if (_historyCache == null) {
			_historyCache = ChatBotHistoryEntity(userId: '', history: []);
		}
		final newHistory = _historyCache!.copyWith(history: [..._historyCache!.history, tempItem]);
		_historyCache = newHistory;
		emit(ChatBotHistoryLoaded(history: newHistory));

		final params = SendChatBotMessageParams(message: event.message);
		final result = await sendMessageUseCase(params);

		result.fold(
			(failure) {
				emit(ChatBotError(failure.message));
			},
			(response) {
				if (_historyCache == null) return;
				final items = List<ChatBotHistoryItem>.from(_historyCache!.history);
				if (items.isNotEmpty) {
					final last = items.last;
					items[items.length - 1] = last.copyWith(aiResponse: response.response);
				}
				final updated = _historyCache!.copyWith(history: items);
				_historyCache = updated;
				emit(ChatBotHistoryLoaded(history: updated, lastResponse: response));
			},
		);
	}

	Future<void> _onClear(
		ClearChatBot event,
		Emitter<ChatBotState> emit,
	) async {
		_historyCache = null;
		emit(ChatBotCleared());
	}

	Future<void> _onShowItem(
		ShowChatBotItem event,
		Emitter<ChatBotState> emit,
	) async {
		// Replace the current session with the selected history item as a 1-message conversation
		final entity = ChatBotHistoryEntity(
			userId: _historyCache?.userId ?? '',
			history: [
				ChatBotHistoryItem(
					timestamp: event.item.timestamp,
					userMessage: event.item.userMessage,
					aiResponse: event.item.aiResponse,
				),
			],
		);
		_historyCache = entity;
		emit(ChatBotHistoryLoaded(history: entity));
	}
}

