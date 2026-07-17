import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/order.dart';
import '../data/order_store.dart';
import 'place_order_screen.dart';
import 'order_detail_screen.dart';

class ChopBarDashboard extends StatefulWidget {
  final AppUser user;

  const ChopBarDashboard({super.key, required this.user});

  @override
  State<ChopBarDashboard> createState() => _ChopBarDashboardState();
}

class _ChopBarDashboardState extends State<ChopBarDashboard> {
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

  @override
  Widget build(BuildContext context) {
    final myOrders = OrderStore.orders
        .where((o) => o.chopBarName == widget.user.name)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text(widget.user.name)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Place Order'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceOrderScreen(user: widget.user),
            ),
          );
          setState(() {});
        },
      ),
      body: myOrders.isEmpty
          ? const Center(
              child: Text('No orders yet — tap Place Order to start'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myOrders.length,
              itemBuilder: (context, index) {
                final order = myOrders[index];
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
                                order.supplier.name,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
