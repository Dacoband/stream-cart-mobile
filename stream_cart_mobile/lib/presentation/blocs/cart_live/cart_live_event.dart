import 'package:equatable/equatable.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

abstract class CartLiveEvent extends Equatable {
	const CartLiveEvent();
	@override
	List<Object?> get props => [];
}

class LoadCartLiveEvent extends CartLiveEvent {
	final String livestreamId;
	const LoadCartLiveEvent(this.livestreamId);
	@override
	List<Object?> get props => [livestreamId];
}

class AddToCartLiveEvent extends CartLiveEvent {
	final String livestreamId;
	final String livestreamProductId;
	final int quantity;
	const AddToCartLiveEvent({
		required this.livestreamId,
		required this.livestreamProductId,
		required this.quantity,
	});
	@override
	List<Object?> get props => [livestreamId, livestreamProductId, quantity];
}

class UpdateCartLiveItemQuantityEvent extends CartLiveEvent {
	final String cartItemId;
	final int quantity;
	const UpdateCartLiveItemQuantityEvent({
		required this.cartItemId,
		required this.quantity,
	});
	@override
	List<Object?> get props => [cartItemId, quantity];
}

// Selection related events
class ToggleSelectCartLiveItemEvent extends CartLiveEvent {
	final String cartItemId;
	const ToggleSelectCartLiveItemEvent(this.cartItemId);
	@override
	List<Object?> get props => [cartItemId];
}

class SelectAllCartLiveItemsEvent extends CartLiveEvent {
	const SelectAllCartLiveItemsEvent();
}

class UnselectAllCartLiveItemsEvent extends CartLiveEvent {
	const UnselectAllCartLiveItemsEvent();
}

class RemoveCartLiveItemEvent extends CartLiveEvent {
	final String cartItemId;
	const RemoveCartLiveItemEvent(this.cartItemId);
	@override
	List<Object?> get props => [cartItemId];
}

class ClearCartLiveEvent extends CartLiveEvent {
	final String livestreamId;
	const ClearCartLiveEvent(this.livestreamId);
	@override
	List<Object?> get props => [livestreamId];
}

class CartLiveRealtimeLoadedInternalEvent extends CartLiveEvent {
	final PreviewOrderLiveModel cart;
	const CartLiveRealtimeLoadedInternalEvent(this.cart);
	@override
	List<Object?> get props => [cart];
}

class CartLiveRealtimeUpdatedInternalEvent extends CartLiveEvent {
	final String action;
	final PreviewOrderLiveModel cart;
	final Map<String, dynamic> raw;
	const CartLiveRealtimeUpdatedInternalEvent(this.action, this.cart, this.raw);
	@override
	List<Object?> get props => [action, cart, raw];
}

class CartLiveRealtimeClearedInternalEvent extends CartLiveEvent {
	final Map<String, dynamic> payload;
	const CartLiveRealtimeClearedInternalEvent(this.payload);
	@override
	List<Object?> get props => [payload];
}

class CartLiveRealtimeErrorInternalEvent extends CartLiveEvent {
	final String message;
	const CartLiveRealtimeErrorInternalEvent(this.message);
	@override
	List<Object?> get props => [message];
}
