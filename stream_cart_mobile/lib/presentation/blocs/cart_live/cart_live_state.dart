import 'package:equatable/equatable.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

abstract class CartLiveState extends Equatable {
	const CartLiveState();
	@override
	List<Object?> get props => [];
}

class CartLiveInitial extends CartLiveState {}

class CartLiveLoading extends CartLiveState {}

class CartLiveLoaded extends CartLiveState {
	final PreviewOrderLiveModel cart;
	final Set<String> selectedCartItemIds;
	const CartLiveLoaded({required this.cart, this.selectedCartItemIds = const {}});
	CartLiveLoaded copyWith({PreviewOrderLiveModel? cart, Set<String>? selectedCartItemIds}) => CartLiveLoaded(
				cart: cart ?? this.cart,
				selectedCartItemIds: selectedCartItemIds ?? this.selectedCartItemIds,
			);
	@override
	List<Object?> get props => [cart, selectedCartItemIds];
}

class CartLiveUpdated extends CartLiveState {
	final String action;
	final PreviewOrderLiveModel cart;
	final Map<String, dynamic> raw;
	final Set<String> selectedCartItemIds;
	const CartLiveUpdated({required this.action, required this.cart, required this.raw, this.selectedCartItemIds = const {}});
	CartLiveUpdated copyWith({String? action, PreviewOrderLiveModel? cart, Map<String, dynamic>? raw, Set<String>? selectedCartItemIds}) => CartLiveUpdated(
				action: action ?? this.action,
				cart: cart ?? this.cart,
				raw: raw ?? this.raw,
				selectedCartItemIds: selectedCartItemIds ?? this.selectedCartItemIds,
			);
	@override
	List<Object?> get props => [action, cart, raw, selectedCartItemIds];
}

class CartLiveCleared extends CartLiveState {
	final Map<String, dynamic> payload;
	const CartLiveCleared(this.payload);
	@override
	List<Object?> get props => [payload];
}

class CartLiveError extends CartLiveState {
	final String message;
	const CartLiveError(this.message);
	@override
	List<Object?> get props => [message];
}

class CartLiveActionInProgress extends CartLiveState {
	final PreviewOrderLiveModel? previous;
	final Set<String> selectedCartItemIds;
	const CartLiveActionInProgress({this.previous, this.selectedCartItemIds = const {}});
	@override
	List<Object?> get props => [previous, selectedCartItemIds];
}
