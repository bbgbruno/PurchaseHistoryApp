import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetailPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailPage> createState() =>
      _CategoryDetailPageState();
}

class _CategoryDetailPageState
    extends State<CategoryDetailPage> {
  final _dashboardService = DashboardService();
  CategoryProductsData? _data;
  bool _loading = true;
  Set<String> _productsInBoth = {};

  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  String _monthLabel(int offset) {
    final date = DateTime(
        DateTime.now().year, DateTime.now().month + offset, 1);
    return '${_monthNames[date.month - 1]}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _dashboardService
          .getCategoryProducts(widget.categoryId);
      if (mounted) {
        final currentIds =
            data.currentMonth.map((e) => e.productId).toSet();
        final lastIds =
            data.lastMonth.map((e) => e.productId).toSet();
        setState(() {
          _data = data;
          _productsInBoth = currentIds.intersection(lastIds);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Color? _bgColor(String productId) {
    if (_productsInBoth.contains(productId)) {
      return Colors.orange.shade50;
    }
    return null;
  }

  Color? _textColor(String productId) {
    if (_productsInBoth.contains(productId)) {
      return Colors.orange.shade900;
    }
    return null;
  }

  Widget _buildProductList(
      List<CategoryProductItem> items, String monthLabel) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Nenhum produto em $monthLabel',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: items.map((item) {
        final inBoth = _productsInBoth.contains(item.productId);
        return Card(
          color: _bgColor(item.productId),
          margin: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textColor(item.productId),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.quantity.toStringAsFixed(0)} ${item.quantity == 1 ? 'un' : 'uns'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor(item.productId) ??
                            Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'R\$ ${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor(item.productId),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(child: Text('Erro ao carregar dados'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          _monthLabel(0),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      _buildProductList(
                          _data!.currentMonth, _monthLabel(0)),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          _monthLabel(-1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      _buildProductList(
                          _data!.lastMonth, _monthLabel(-1)),
                    ],
                  ),
                ),
    );
  }
}
