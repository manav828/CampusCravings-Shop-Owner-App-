class OrderItem {
  String? itemName;
  String? itemId;
  double? itemPrice;

  int? itemQuantity;

  OrderItem({
    this.itemQuantity,
    this.itemName,
    this.itemPrice,
    this.itemId,
  });
}

class PendingOrder {
  final String orderId;
  final String userId;
  final String shopId;
  final String orderStatus;
  final String orderDate;
  final String orderTime;
  final double totalAmount;
  final String userName;
  final String userToken;
  final List<OrderItem> orderItems; // Add this property

  PendingOrder({
    required this.orderId,
    required this.userId,
    required this.shopId,
    required this.orderStatus,
    required this.orderDate,
    required this.orderTime,
    required this.totalAmount,
    required this.userName,
    required this.userToken,
    required this.orderItems, // Initialize it here
  });
}
