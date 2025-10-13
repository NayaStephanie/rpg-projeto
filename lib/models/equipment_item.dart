// lib/models/equipment_item.dart

/// Representa um item/equipamento no inventário do personagem
class EquipmentItem {
  final String name;
  final String description;
  final String category; // "Ferramenta", "Item Religioso", "Instrumento", etc.
  final int quantity;

  EquipmentItem({
    required this.name,
    required this.description,
    required this.category,
    this.quantity = 1,
  });

  /// Converte o item para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
    };
  }

  /// Cria um item a partir de JSON
  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  /// Cria uma cópia do item com modificações
  EquipmentItem copyWith({
    String? name,
    String? description,
    String? category,
    int? quantity,
  }) {
    return EquipmentItem(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return quantity > 1 ? '$name (x$quantity)' : name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EquipmentItem &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        category.hashCode ^
        quantity.hashCode;
  }
}