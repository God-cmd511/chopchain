import 'supply_item.dart';

class Supplier {
  final String id;
  final String name;
  final String location;
  final List<SupplyItem> items;

  Supplier({
    required this.id,
    required this.name,
    required this.location,
    required this.items,
  });
}
