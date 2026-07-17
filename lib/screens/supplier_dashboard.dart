import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/order.dart';
import '../data/order_store.dart';
import 'order_detail_screen.dart';

class SupplierDashboard extends StatefulWidget {
  final AppUser user;

  const SupplierDashboard({super.key, required this.user});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.outForDelivery:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.paid:
        return Colors.teal;
    }
  }

  void _updateStatus(Order order, OrderStatus newStatus) {
    setState(() {
      order.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderStore.orders;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text(widget.user.name)),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.chopBarName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    order.status,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.status.name,
                                  style: TextStyle(
                                    color: _statusColor(order.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map(
                            (item) => Text(
                              '• ${item.quantity} ${item.item.unit} of ${item.item.name}',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: GHS ${order.totalCost}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap to view details →',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          _actionButtons(order),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _actionButtons(Order order) {
    if (order.status == OrderStatus.pending) {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, OrderStatus.confirmed),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text('Confirm Order'),
      );
    } else if (order.status == OrderStatus.confirmed) {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, OrderStatus.outForDelivery),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        child: const Text('Mark Out for Delivery'),
      );
    } else if (order.status == OrderStatus.outForDelivery) {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, OrderStatus.delivered),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text('Mark Delivered'),
      );
    } else if (order.status == OrderStatus.delivered) {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, OrderStatus.paid),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        child: const Text('Mark as Paid'),
      );
    } else {
      return const Text(
        '✓ Completed',
        style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
      );
    }
  }
}
