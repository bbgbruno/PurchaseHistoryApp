import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import 'categories_page.dart';
import 'import_coupon_page.dart';
import 'login_page.dart';
import 'product_search_page.dart';
import 'purchase_list_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dashboardService = DashboardService();
  DashboardData? _dashboard;
  bool _loadingDashboard = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data =
          await _dashboardService.get(widget.userId);
      if (mounted) {
        setState(() {
          _dashboard = data;
          _loadingDashboard = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingDashboard = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /*
            ==============================================
            DASHBOARD
            ==============================================
            */
            if (_loadingDashboard)
              const LinearProgressIndicator()
            else ...[
              if (_dashboard != null) ...[
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up,
                            size: 40,
                            color: Colors.blue
                                .shade700),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Total no último mês',
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Colors.grey),
                            ),
                            const SizedBox(
                                height: 4),
                            Text(
                              'R\$ ${_dashboard!.totalLastMonth.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_dashboard!
                    .categories.isNotEmpty) ...[
                  const Text(
                    'Por categoria',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._dashboard!.categories.map(
                    (c) => Card(
                      margin:
                          const EdgeInsets.only(
                              bottom: 6),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.label,
                              color: Colors
                                  .purple
                                  .shade300,
                            ),
                            const SizedBox(
                                width: 12),
                            Expanded(
                              child: Text(
                                c
                                    .categoryName,
                                style:
                                    const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              'R\$ ${c.totalSpent.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],

            const SizedBox(height: 16),

            /*
            ==============================================
            IMPORTAR CUPOM
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
                            ImportCouponPage(
                                userId:
                                    widget.userId),
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
                                .orange
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            size: 40,
                            color: Colors.orange,
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
                              'Importar Cupom',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Chave de acesso',
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
            CATEGORIAS
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
                            CategoriesPage(
                                userId:
                                    widget.userId),
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
                                .purple
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.label_outline,
                            size: 40,
                            color: Colors.purple,
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
                              'Categorias',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gerenciar categorias',
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
                            PurchaseListPage(
                                userId:
                                    widget.userId),
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
