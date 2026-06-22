import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/purchase_item.dart';
import '../services/category_service.dart';
import '../services/purchase_service.dart';

class PurchaseItemsPage extends StatefulWidget {
  final String purchaseId;
  final String storeName;

  const PurchaseItemsPage({
    super.key,
    required this.purchaseId,
    required this.storeName,
  });

  @override
  State<PurchaseItemsPage> createState() =>
      _PurchaseItemsPageState();
}

class _PurchaseItemsPageState
    extends State<PurchaseItemsPage> {
  final PurchaseService _purchaseService =
      PurchaseService();
  final CategoryService _categoryService =
      CategoryService();

  List<PurchaseItem> _items = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => _loading = true);

    try {
      final items = await _purchaseService
          .getItems(widget.purchaseId);
      final categories = await _categoryService
          .getAll();

      setState(() {
        _items = items;
        _categories = categories;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _editDiscount(
      PurchaseItem item, int index) async {
    final controller = TextEditingController(
        text: item.discount.toStringAsFixed(2));

    final discount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Desconto no item'),
        content: TextField(
          controller: controller,
          keyboardType:
              TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Valor do desconto (R\$)',
            border: OutlineInputBorder(),
            prefixText: 'R\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final v = double.tryParse(
                  controller.text.replaceAll(',', '.'));
              Navigator.pop(ctx, v != null && v > 0 ? v : 0);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (discount == null) return;

    try {
      await _purchaseService.updateDiscount(
          item.id, discount);
      final newUnitPrice = item.unitPrice - discount;
      final newTotal =
          (newUnitPrice < 0 ? 0 : newUnitPrice) * item.quantity;
      setState(() {
        _items[index] = PurchaseItem(
          id: item.id,
          purchaseId: item.purchaseId,
          productId: item.productId,
          originalDescription: item.originalDescription,
          productCode: item.productCode,
          ncmCode: item.ncmCode,
          ean: item.ean,
          quantity: item.quantity,
          unit: item.unit,
          unitPrice: newUnitPrice < 0 ? 0 : newUnitPrice,
          discount: discount,
          totalPrice: newTotal,
          categoryId: item.categoryId,
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _selectCategory(
      PurchaseItem item) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollController) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sem categoria'),
              leading: const Icon(Icons.block),
              onTap: () => Navigator.pop(ctx, null),
            ),
            Flexible(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: _categories.map((c) => ListTile(
                      title: Text(c.name),
                      leading: const Icon(Icons.label),
                      selected:
                          c.id == item.categoryId,
                      onTap: () =>
                          Navigator.pop(ctx, c.id),
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected == item.categoryId) return;

    try {
      await _purchaseService.updateProductCategory(
          item.id, selected);
      final index = _items.indexWhere(
          (i) => i.id == item.id);
      if (index != -1) {
        setState(() {
          _items[index] = PurchaseItem(
            id: item.id,
            purchaseId: item.purchaseId,
            productId: item.productId,
            originalDescription:
                item.originalDescription,
            productCode: item.productCode,
            ncmCode: item.ncmCode,
            ean: item.ean,
            quantity: item.quantity,
            unit: item.unit,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            categoryId: selected,
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum item encontrado.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: load,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, index) {
                      final item = _items[index];
                      final hasCategory =
                          item.categoryId != null;

                      final hasDiscount =
                          item.discount > 0;

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                        color: hasCategory
                            ? Colors.green.shade50
                            : null,
                        elevation: 2,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      _selectCategory(item),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        item.originalDescription,
                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 4),
                                      Text(
                                        'Qtd: ${item.quantity} ${item.unit ?? ''}',
                                        style: TextStyle(
                                          color: Colors
                                              .grey
                                              .shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (hasDiscount)
                                        Padding(
                                          padding: const EdgeInsets
                                              .only(
                                              top: 4),
                                          child: Text(
                                            'Desc: R\$ ${item.discount.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors
                                                  .red,
                                              fontWeight:
                                                  FontWeight
                                                      .w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    hasDiscount
                                        ? 'R\$ ${item.unitPrice.toStringAsFixed(2)}'
                                        : 'R\$ ${item.unitPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (hasDiscount)
                                    Text(
                                      'R\$ ${item.grossUnitPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors
                                            .grey
                                            .shade400,
                                        decoration:
                                            TextDecoration
                                                .lineThrough,
                                      ),
                                    ),
                                  const SizedBox(
                                      height: 2),
                                  Text(
                                    'Total: R\$ ${item.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors
                                          .grey
                                          .shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons
                                            .discount_outlined,
                                        size: 20),
                                    tooltip: 'Desconto',
                                    onPressed: () =>
                                        _editDiscount(
                                            item, index),
                                    padding:
                                        EdgeInsets.zero,
                                    constraints:
                                        const BoxConstraints(),
                                    color: hasDiscount
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  const SizedBox(
                                      height: 8),
                                  Icon(
                                    hasCategory
                                        ? Icons
                                            .check_circle
                                        : Icons
                                            .label_outline,
                                    size: 20,
                                    color: hasCategory
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
