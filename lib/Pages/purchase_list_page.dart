import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../services/purchase_service.dart';
import 'purchase_items_page.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  @override
  State<PurchaseListPage> createState() =>
      _PurchaseListPageState();
}

class _PurchaseListPageState
    extends State<PurchaseListPage> {

  final PurchaseService _service =
      PurchaseService();

  List<Purchase> _items = [];

  bool _loading = true;

  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;

    load();
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
    load();
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
    load();
  }

  Future<void> load() async {
    setState(() {
      _loading = true;
    });

    try {
      final result =
          await _service.getAll(month: _selectedMonth, year: _selectedYear);

      setState(() {
        _items = result;
      });

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _confirmDelete(Purchase item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir compra'),
        content: Text(
          'Deseja realmente excluir a compra em ${item.storeName} no valor de R\$ ${item.totalValue.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deletePurchase(item.id);
    }
  }

  Future<void> _deletePurchase(
      String purchaseId) async {
    try {
      await _service.delete(purchaseId);

      setState(() {
        _items.removeWhere(
            (i) => i.id == purchaseId);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Compra excluída com sucesso.'),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  String _monthLabel(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril',
      'Maio', 'Junho', 'Julho', 'Agosto',
      'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compras Importadas',
        ),
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_monthLabel(_selectedMonth)} $_selectedYear',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _items.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma compra encontrada.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: load,
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (_, index) {
                            final item =
                                _items[index];

                      final fullyCat =
                          item.isFullyCategorized;

                      return Card(
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        color: fullyCat
                            ? Colors.green.shade50
                            : null,
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PurchaseItemsPage(
                                  purchaseId:
                                      item.id,
                                  storeName:
                                      item.storeName,
                                ),
                              ),
                            );
                            load();
                          },
                          borderRadius:
                              BorderRadius.circular(12),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(
                              left: 16,
                              right: 4,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        item.storeName,
                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 4),
                                      Text(
                                        item.purchaseDate ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors
                                              .grey
                                              .shade600,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 2),
                                      Text(
                                        '${item.categorizedItems}/${item.totalItems} categorizados',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: fullyCat
                                              ? Colors
                                                  .green
                                              : Colors
                                                  .orange,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'R\$ ${item.totalValue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons
                                        .delete_outline,
                                    color:
                                        Colors.red,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(
                                          item),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
