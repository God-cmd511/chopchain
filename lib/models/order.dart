import 'order_item.dart';
import 'supplier.dart';

enum OrderStatus { pending, confirmed, outForDelivery, delivered, paid }

class Order {
  final String id;
  final String chopBarName;
  final Supplier supplier;
  final List<OrderItem> items;
  final DateTime orderDate;
  OrderStatus status;

  Order({
    required this.id,
    required this.chopBarName,
    required this.supplier,
    required this.items,
    required this.orderDate,
    this.status = OrderStatus.pending,
  });

  double get totalCost {
    double total = 0;
    for (final item in items) {
      total += item.subtotal;
    }
    return total;
  }
}
