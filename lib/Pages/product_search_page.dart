import 'package:flutter/material.dart';

import '../models/product_search_result.dart';
import '../services/product_service.dart';
import 'product_details_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() =>
      _ProductSearchPageState();
}

class _ProductSearchPageState
    extends State<ProductSearchPage> {

  final ProductService _service =
      ProductService();

  final TextEditingController _controller =
      TextEditingController();

  List<ProductSearchResult> _items = [];

  bool _loading = false;

  /*
  ==========================================================
  SEARCH
  ==========================================================
  */

  Future<void> _search(String term) async {

    if (term.isEmpty) {

      setState(() {
        _items = [];
      });

      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final result =
          await _service.search(term);

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

  /*
  ==========================================================
  UI
  ==========================================================
  */

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Histórico de Produtos',
        ),
      ),

      body: Column(

        children: [

          /*
          ====================================================
          SEARCH
          ====================================================
          */

          Padding(

            padding:
                const EdgeInsets.all(12),

            child: TextField(

              controller: _controller,

              onChanged: _search,

              decoration: InputDecoration(

                hintText:
                    'Digite um produto...',

                prefixIcon:
                    const Icon(Icons.search),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          /*
          ====================================================
          LOADING
          ====================================================
          */

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child:
                  CircularProgressIndicator(),
            ),

          /*
          ====================================================
          LIST
          ====================================================
          */

          Expanded(

            child: ListView.builder(

              itemCount: _items.length,

              itemBuilder: (_, index) {

                final item = _items[index];

                return Card(

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  elevation: 2,

                  child: ListTile(

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsPage(
                            productId:
                                item.productId,
                          ),
                        ),
                      );
                    },

                    contentPadding:
                        const EdgeInsets.all(12),

                    /*
                    ==========================================
                    TITLE
                    ==========================================
                    */

                    title: Text(

                      item.productName,

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    /*
                    ==========================================
                    SUBTITLE
                    ==========================================
                    */

                    subtitle: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const SizedBox(height: 8),

                        Text(

                          item.storeName,

                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(

                          item.purchaseDate ?? '',

                          style: TextStyle(
                            color:
                                Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(

                          'Total: R\$ ${item.totalPrice.toStringAsFixed(2)}',

                          style: TextStyle(
                            color:
                                Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),

                    /*
                    ==========================================
                    PRICE
                    ==========================================
                    */

                    trailing: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      crossAxisAlignment:
                          CrossAxisAlignment.end,

                      children: [

                        const Text(

                          'Unitário',

                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        Text(

                          'R\$ ${item.unitPrice.toStringAsFixed(2)}',

                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}