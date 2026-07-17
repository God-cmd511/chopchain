import 'supply_item.dart';

class OrderItem {
  final SupplyItem item;
  final int quantity;

  OrderItem({required this.item, required this.quantity});

  double get subtotal => item.pricePerUnit * quantity;
}
