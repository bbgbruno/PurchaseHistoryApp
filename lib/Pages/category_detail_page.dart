import 'package:fl_chart/fl_chart.dart';
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
  CategoryMonthlyData? _monthly;
  bool _loading = true;
  Set<String> _productsInBoth = {};

  static const _monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
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
      final results = await Future.wait([
        _dashboardService.getCategoryProducts(widget.categoryId),
        _dashboardService.getCategoryMonthly(widget.categoryId),
      ]);
      if (mounted) {
        final data = results[0] as CategoryProductsData;
        final monthly = results[1] as CategoryMonthlyData;
        final currentIds =
            data.currentMonth.map((e) => e.productId).toSet();
        final lastIds =
            data.lastMonth.map((e) => e.productId).toSet();
        setState(() {
          _data = data;
          _monthly = monthly;
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

  Widget _buildChart() {
    if (_monthly == null || _monthly!.months.isEmpty) {
      return const SizedBox.shrink();
    }

    final months = _monthly!.months;
    final maxTotal = months
        .map((m) => m.total)
        .reduce((a, b) => a > b ? a : b);
    final maxY = maxTotal > 0 ? maxTotal * 1.15 : 1.0;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                'Evolução Mensal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem:
                          (group, groupIndex, rod, rodIndex) {
                        final m = months[groupIndex];
                        return BarTooltipItem(
                          '${_monthNames[m.month - 1]}/${m.year}\nR\$ ${m.total.toStringAsFixed(2)}',
                          const TextStyle(
                              color: Colors.white,
                              fontSize: 12),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= months.length) {
                            return const SizedBox.shrink();
                          }
                          final m = months[i];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 4),
                            child: Text(
                              _monthNames[m.month - 1],
                              style: const TextStyle(
                                  fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) {
                            return const Text('');
                          }
                          return Text(
                            'R\$ ${value.toInt()}',
                            style: const TextStyle(
                                fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: months.asMap().entries.map(
                    (e) {
                      final i = e.key;
                      final m = e.value;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: m.total,
                            color: Colors.orange,
                            width: 18,
                            borderRadius:
                                const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: _textColor(item.productId),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qtd: ${item.quantity.toStringAsFixed(3)} ${item.unit ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: _textColor(item.productId) ??
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${item.unitPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: R\$ ${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: inBoth
                      ? Colors.orange
                      : Colors.green,
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
                      _buildChart(),
                      const SizedBox(height: 16),
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
