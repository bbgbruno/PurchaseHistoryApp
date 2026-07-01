# PurchaseHistoryApp

Aplicativo Flutter para gerenciamento de histórico de compras. Permite importar cupons fiscais (NFC-e), categorizar produtos, visualizar dashboards de gastos e acompanhar histórico de preços.

## Funcionalidades

- **Autenticação** — Login, cadastro e recuperação de senha com persistência de sessão (SharedPreferences)
- **Dashboard** — Resumo de gastos do mês atual vs anterior, com valores totais e categorizados, exibindo saldo por categoria
- **Importação de Cupom** — Importação via chave de acesso de 44 dígitos (NFC-e) com suporte a leitura de QR Code
- **Lista de Compras** — Visualização de todas as compras importadas com valor total, data, loja e status de categorização. Swipe-to-delete com confirmação
- **Itens da Compra** — Listagem de itens de uma compra com edição de desconto e atribuição de categoria via bottom sheet
- **Categorias** — CRUD completo de categorias para organização dos produtos
- **Detalhe da Categoria** — Gráfico de barras mensais (fl_chart) e comparação de produtos entre mês atual e anterior, destacando itens presentes em ambos
- **Pesquisa de Produtos** — Busca em tempo real (search-as-you-type) por nome do produto
- **Detalhes do Produto** — Histórico de preços com menor/maior/média e lista completa de compras do produto

## Tecnologias

- Flutter
- State management via `setState()` (sem bibliotecas de estado)
- `mobile_scanner` para leitura de QR Code
- `fl_chart` para gráficos
- `SharedPreferences` para persistência de sessão
- `http` package para chamadas à API

## Estrutura do Projeto

```
lib/
├── main.dart                          # Entry point com verificação de sessão
├── Models/
│   ├── purchase.dart                  # Modelo de compra
│   ├── purchase_item.dart             # Modelo de item de compra
│   ├── product_search_result.dart     # Resultado de busca de produto
│   ├── product_details.dart           # Detalhes e histórico do produto
│   └── category.dart                  # Modelo de categoria
├── Pages/
│   ├── login_page.dart                # Tela de login
│   ├── register_page.dart             # Tela de cadastro
│   ├── forgot_password_page.dart      # Tela de recuperação de senha
│   ├── home_page.dart                 # Dashboard principal
│   ├── purchase_list_page.dart        # Lista de compras
│   ├── purchase_items_page.dart       # Itens de uma compra
│   ├── product_search_page.dart       # Pesquisa de produtos
│   ├── product_details_page.dart      # Histórico do produto
│   ├── categories_page.dart           # CRUD de categorias
│   ├── category_detail_page.dart      # Dashboard por categoria
│   ├── import_coupon_page.dart        # Importação de cupom
│   └── qr_scanner_page.dart           # Leitor de QR Code
└── Services/
    ├── api_service.dart               # Wrapper HTTP (base URL, userId)
    ├── auth_service.dart              # Login, cadastro, recuperação
    ├── session_service.dart           # Persistência de sessão
    ├── purchase_service.dart          # CRUD de compras
    ├── product_service.dart           # Busca e histórico de produtos
    ├── dashboard_service.dart         # Dados do dashboard
    ├── category_service.dart          # CRUD de categorias
    └── coupon_import_service.dart     # Importação de cupom
```

## API

O app consome a [PurchaseHistoryApi](https://github.com/anomalyco/PurchaseHistoryApi) com os seguintes endpoints:

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/auth/login` | Autenticação |
| POST | `/api/auth/forgot-password` | Recuperação de senha |
| POST | `/api/users` | Cadastro de usuário |
| GET | `/api/purchases` | Lista compras |
| GET | `/api/purchases/{id}/items` | Itens de uma compra |
| PATCH | `/api/purchase-items/{id}/product-category` | Define categoria do item |
| PATCH | `/api/purchase-items/{id}/discount` | Define desconto do item |
| DELETE | `/api/purchases/{id}` | Exclui compra |
| GET | `/api/products/search` | Busca produtos |
| GET | `/api/products/history/{id}` | Histórico de preços |
| GET | `/api/dashboard` | Resumo do dashboard |
| GET | `/api/dashboard/category/{id}/products` | Produtos por categoria |
| GET | `/api/dashboard/category/{id}/monthly` | Mensal por categoria |
| GET | `/api/categories` | Lista categorias |
| POST | `/api/categories` | Cria categoria |
| PUT | `/api/categories/{id}` | Atualiza categoria |
| DELETE | `/api/categories/{id}` | Exclui categoria |
| POST | `/api/cupons/imports` | Importa cupom por chave |

## Configuração

1. Configure a URL da API em `lib/Services/api_service.dart` (padrão: `https://purchasehistoryapi.onrender.com/api`)
2. Execute `flutter pub get`
3. Execute `flutter run`
