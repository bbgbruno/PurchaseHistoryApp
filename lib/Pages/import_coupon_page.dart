import 'package:flutter/material.dart';

import '../services/coupon_import_service.dart';
import 'qr_scanner_page.dart';

class ImportCouponPage extends StatefulWidget {
  const ImportCouponPage({super.key});

  @override
  State<ImportCouponPage> createState() =>
      _ImportCouponPageState();
}

class _ImportCouponPageState
    extends State<ImportCouponPage> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _service = CouponImportService();
  bool _loading = false;

  Future<void> _scanQrCode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
          builder: (_) => const QrScannerPage()),
    );

    if (result != null) {
      _keyController.text = result;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _service.submit(
        _keyController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Chave salva com sucesso!')),
      );

      _keyController.clear();

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Cupom'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Digite a chave de acesso do cupom fiscal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: 'Chave de acesso',
                    hintText: '0000 0000 0000 ...',
                    prefixIcon: const Icon(
                        Icons.vpn_key_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(
                          Icons.qr_code_scanner),
                      tooltip: 'Escanear QR Code',
                      onPressed: _scanQrCode,
                    ),
                    border:
                        OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (v) => v == null ||
                          v.trim().isEmpty
                      ? 'Informe a chave de acesso'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.save_outlined),
                    label: const Text(
                      'Salvar Chave',
                      style:
                          TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
