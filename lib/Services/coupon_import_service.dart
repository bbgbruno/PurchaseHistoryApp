import 'api_service.dart';

class CouponImportService {
  Future<void> submit(String accessKey) async {
    final response = await ApiService.post(
        '/cupons/imports', {
      'accessKey': accessKey
    });

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao importar cupom');
    }
  }
}
