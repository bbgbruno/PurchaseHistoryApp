import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../services/purchase_service.dart';

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
      final result = await _service.getAll();

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
        title: const Text(
          'Compras Importadas',
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

                      return Card(
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets
                                  .all(16),
                          title: Text(
                            item.storeName,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle:
                              const SizedBox(
                                  height: 6),
                          trailing: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .end,
                            children: [
                              Text(
                                'R\$ ${item.totalValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                  height: 2),
                              Text(
                                item.purchaseDate ??
                                    '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .grey
                                      .shade600,
                                ),
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
