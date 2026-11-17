import '../constants/app_assets.dart';

class BlueprintModel {
  final int id;
  final String title;
  final String author;
  final String price;
  final String stackLabel;
  final String description;
  final bool isVerified;
  final DateTime? createdAt;

  const BlueprintModel({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.stackLabel,
    this.description = '',
    this.isVerified = true,
    this.createdAt,
  });

  factory BlueprintModel.fromJson(Map<String, dynamic> json) {
    return BlueprintModel(
      id: json['id_blueprint'] is int
          ? json['id_blueprint']
          : int.tryParse(json['id_blueprint']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      stackLabel: json['stack_label']?.toString() ?? 'Flutter',
      description: json['description']?.toString() ?? '',
      isVerified: json['is_verified'] == true ||
          json['is_verified'] == 1 ||
          json['is_verified'] == '1',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id_blueprint': id,
      'title': title,
      'author': author,
      'price': price,
      'stack_label': stackLabel,
      'description': description,
      'is_verified': isVerified ? 1 : 0,
    };
  }

  BlueprintModel copyWith({
    int? id,
    String? title,
    String? author,
    String? price,
    String? stackLabel,
    String? description,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return BlueprintModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      price: price ?? this.price,
      stackLabel: stackLabel ?? this.stackLabel,
      description: description ?? this.description,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Mengembalikan asset SVG yang sesuai dengan stack teknologi
  String get stackSvg {
    final lower = stackLabel.toLowerCase();
    if (lower.contains('laravel')) return AppAssets.laravel;
    if (lower.contains('next')) return AppAssets.nextjs;
    if (lower.contains('react')) return AppAssets.react;
    if (lower.contains('python')) return AppAssets.python;
    return AppAssets.coding;
  }
}
