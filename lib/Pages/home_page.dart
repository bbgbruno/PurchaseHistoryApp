import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import 'categories_page.dart';
import 'import_coupon_page.dart';
import 'login_page.dart';
import 'product_search_page.dart';
import 'purchase_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dashboardService = DashboardService();
  DashboardData? _dashboard;
  bool _loadingDashboard = true;

  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  String _currentMonthLabel() {
    final now = DateTime.now();
    return '${_monthNames[now.month - 1]}/${now.year}';
  }

  String _lastMonthLabel() {
    final last = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    return '${_monthNames[last.month - 1]}/${last.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data =
          await _dashboardService.get();
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
            else if (_dashboard != null) ...[
              const Text('Despesas Totais',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Card(
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentMonthLabel(),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors
                                      .grey.shade600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'R\$ ${_dashboard!.totalCurrentMonth.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: VerticalDivider(
                          thickness: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lastMonthLabel(),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors
                                      .grey.shade600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'R\$ ${_dashboard!.totalLastMonth.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_dashboard!.categories.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Por categoria',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600)),
                const SizedBox(height: 8),
                ..._dashboard!.categories.map(
                  (c) => Card(
                    margin: const EdgeInsets.only(
                        bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.categoryName,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _currentMonthLabel(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors
                                          .grey
                                          .shade600),
                                ),
                              ),
                              Text(
                                'R\$ ${c.totalCurrentMonth.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _lastMonthLabel(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors
                                          .grey
                                          .shade600),
                                ),
                              ),
                              Text(
                                'R\$ ${c.totalLastMonth.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue
                                      .shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
              height: 72,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ImportCouponPage(),
                      ),
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors
                                .orange
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            size: 28,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(
                            width: 14),
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
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Chave de acesso',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
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
              height: 72,
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CategoriesPage(),
                      ),
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors
                                .purple
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.label_outline,
                            size: 28,
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
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Gerenciar categorias',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
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
              height: 72,
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
                        const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors
                                .blue
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons
                                .shopping_cart_checkout,
                            size: 28,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                            width: 14),
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
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Compras importadas',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
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
              height: 72,
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
                        const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors
                                .green
                                .shade50,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons
                                .inventory_2_outlined,
                            size: 28,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                            width: 14),
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
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Histórico de preços',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
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
