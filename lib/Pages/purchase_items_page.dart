import 'package:flutter/material.dart';

import '../models/purchase_item.dart';
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

  final PurchaseService _service =
      PurchaseService();

  List<PurchaseItem> _items = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    setState(() {
      _loading = true;
    });

    try {
      final result =
          await _service.getItems(widget.purchaseId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeName,
        ),
      ),

      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum item encontrado.',
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

                      return Card(
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .all(16),
                          child: Row(
                            children: [
                              Expanded(
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
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                children: [
                                  Text(
                                    'R\$ ${item.unitPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize: 16,
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
