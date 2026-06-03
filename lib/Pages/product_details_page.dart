import 'package:flutter/material.dart';

import '../models/product_details.dart';
import '../services/product_service.dart';

class ProductDetailsPage
    extends StatefulWidget {

  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {

  final ProductService _service =
      ProductService();

  ProductDetails? _details;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {

    final result =
        await _service.getDetails(
            widget.productId);

    setState(() {

      _details = result;

      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final product = _details!;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          product.productName,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /*
            ==============================================
            STATS
            ==============================================
            */

            Card(

              child: Padding(

                padding:
                    const EdgeInsets.all(16),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Menor preço: R\$ ${product.lowestPrice.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Maior preço: R\$ ${product.highestPrice.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Média: R\$ ${product.averagePrice.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Histórico',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            /*
            ==============================================
            HISTORY
            ==============================================
            */

            Expanded(

              child: ListView.builder(

                itemCount:
                    product.history.length,

                itemBuilder: (_, index) {

                  final item =
                      product.history[index];

                  return Card(

                    child: ListTile(

                      title:
                          Text(item.storeName),

                      subtitle:
                          Text(item.purchaseDate ?? ''),

                      trailing: Text(

                        'R\$ ${item.unitPrice.toStringAsFixed(2)}',

                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}