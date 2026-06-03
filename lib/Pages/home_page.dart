import 'package:flutter/material.dart';

import 'product_search_page.dart';
import 'purchase_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase History',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            /*
            ==============================================
            CONSULTAR COMPRAS
            ==============================================
            */

            SizedBox(
              width: double.infinity,
              height: 120,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const PurchaseListPage(),
                      ),
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors
                                .blue
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons
                                .shopping_cart_checkout,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                            width: 20),
                        const Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Consultar Compras',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Compras importadas',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /*
            ==============================================
            CONSULTAR PRODUTOS
            ==============================================
            */

            SizedBox(
              width: double.infinity,
              height: 120,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProductSearchPage(),
                      ),
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors
                                .green
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons
                                .inventory_2_outlined,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                            width: 20),
                        const Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Consultar Produtos',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Histórico de preços',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
