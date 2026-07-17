import '../models/order.dart';
import '../models/supplier.dart';
import '../models/supply_item.dart';
import '../models/order_item.dart';

class OrderStore {
  static final List<Order> orders = [
    Order(
      id: 'o1',
      chopBarName: "Auntie Efua's Chop Bar",
      supplier: Supplier(
        id: 's1',
        name: "Kwame's Fresh Produce",
        location: 'Kaneshie Market',
        items: [
          SupplyItem(
            id: 'i1',
            name: 'Tomatoes',
            pricePerUnit: 25.0,
            unit: 'kg',
          ),
          SupplyItem(id: 'i2', name: 'Rice', pricePerUnit: 350.0, unit: 'bag'),
        ],
      ),
      items: [
        OrderItem(
          item: SupplyItem(
            id: 'i1',
            name: 'Tomatoes',
            pricePerUnit: 25.0,
            unit: 'kg',
          ),
          quantity: 3,
        ),
        OrderItem(
          item: SupplyItem(
            id: 'i2',
            name: 'Rice',
            pricePerUnit: 350.0,
            unit: 'bag',
          ),
          quantity: 1,
        ),
      ],
      orderDate: DateTime.now(),
    ),
    Order(
      id: 'o2',
      chopBarName: "Auntie Efua's Chop Bar",
      supplier: Supplier(
        id: 's1',
        name: "Kwame's Fresh Produce",
        location: 'Kaneshie Market',
        items: [
          SupplyItem(
            id: 'i1',
            name: 'Tomatoes',
            pricePerUnit: 25.0,
            unit: 'kg',
          ),
        ],
      ),
      items: [
        OrderItem(
          item: SupplyItem(
            id: 'i1',
            name: 'Tomatoes',
            pricePerUnit: 25.0,
            unit: 'kg',
          ),
          quantity: 5,
        ),
      ],
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.delivered,
    ),
  ];

  static void addOrder(Order order) {
    orders.add(order);
  }
}
