import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/supplier.dart';
import '../models/supply_item.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../data/order_store.dart';

class PlaceOrderScreen extends StatefulWidget {
  final AppUser user;

  const PlaceOrderScreen({super.key, required this.user});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  // Demo suppliers — later this could come from a supplier store
  final List<Supplier> _suppliers = [
    Supplier(
      id: 's1',
      name: "Kwame's Fresh Produce",
      location: 'Kaneshie Market',
      items: [
        SupplyItem(id: 'i1', name: 'Tomatoes', pricePerUnit: 25.0, unit: 'kg'),
        SupplyItem(id: 'i2', name: 'Rice', pricePerUnit: 350.0, unit: 'bag'),
        SupplyItem(
          id: 'i3',
          name: 'Cooking Oil',
          pricePerUnit: 80.0,
          unit: 'bottle',
        ),
      ],
    ),
    Supplier(
      id: 's2',
      name: "Ama Provisions",
      location: 'Makola Market',
      items: [
        SupplyItem(id: 'i4', name: 'Onions', pricePerUnit: 15.0, unit: 'kg'),
        SupplyItem(id: 'i5', name: 'Pepper', pricePerUnit: 20.0, unit: 'kg'),
        SupplyItem(
          id: 'i6',
          name: 'Cooking Gas',
          pricePerUnit: 200.0,
          unit: 'cylinder',
        ),
      ],
    ),
  ];

  Supplier? _selectedSupplier;
  final Map<String, int> _quantities = {};

  double get _totalCost {
    if (_selectedSupplier == null) return 0;
    double total = 0;
    for (final item in _selectedSupplier!.items) {
      final qty = _quantities[item.id] ?? 0;
      total += item.pricePerUnit * qty;
    }
    return total;
  }

  void _placeOrder() {
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a supplier')));
      return;
    }

    final selectedItems = _selectedSupplier!.items
        .where((item) => (_quantities[item.id] ?? 0) > 0)
        .map((item) => OrderItem(item: item, quantity: _quantities[item.id]!))
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    final newOrder = Order(
      id: 'o${OrderStore.orders.length + 1}',
      chopBarName: widget.user.name,
      supplier: _selectedSupplier!,
      items: selectedItems,
      orderDate: DateTime.now(),
    );

    OrderStore.addOrder(newOrder);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Place an Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select a Supplier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._suppliers.map(
              (supplier) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _selectedSupplier?.id == supplier.id
                        ? Colors.deepOrange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                  title: Text(
                    supplier.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(supplier.location),
                  onTap: () {
                    setState(() {
                      _selectedSupplier = supplier;
                      _quantities.clear();
                    });
                  },
                ),
              ),
            ),
            if (_selectedSupplier != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Select Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._selectedSupplier!.items.map((item) {
                final qty = _quantities[item.id] ?? 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'GHS ${item.pricePerUnit} per ${item.unit}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: qty > 0
                                  ? () {
                                      setState(() {
                                        _quantities[item.id] = qty - 1;
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              '$qty',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  _quantities[item.id] = qty + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Card(
                color: Colors.deepOrange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cost',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'GHS $_totalCost',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
