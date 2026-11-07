import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Erro com a mensagem que a API devolveu (ex.: "Estoque insuficiente...")
class ApiErro implements Exception {
  final String mensagem;
  ApiErro(this.mensagem);
  @override
  String toString() => mensagem;
}

class Api {
  // Endereço do túnel do Visual Studio (Dev Tunnels) que aponta para a API
  static const base = 'https://9w49x2vl-7011.brs.devtunnels.ms';

  // ---------- Sessão do usuário logado ----------
  static String? token;
  static int? usuarioId;
  static String? nome;
  static String? email;
  static bool isAdmin = false;

  static bool get logado => token != null;

  // pula a página de aviso do Dev Tunnels
  static const _tunel = {'X-Tunnel-Skip-AntiPhishing-Page': 'true'};

  // Cabeçalhos enviados em toda requisição (com o token JWT quando logado)
  static Map<String, String> get _h => {
        'Content-Type': 'application/json',
        ..._tunel,
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<void> carregarSessao() async {
    final p = await SharedPreferences.getInstance();
    token = p.getString('token');
    usuarioId = p.getInt('usuarioId');
    nome = p.getString('nome');
    email = p.getString('email');
    isAdmin = p.getBool('isAdmin') ?? false;
  }

  static Future<void> _salvarSessao() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('token', token!);
    await p.setInt('usuarioId', usuarioId!);
    await p.setString('nome', nome ?? '');
    await p.setString('email', email ?? '');
    await p.setBool('isAdmin', isAdmin);
  }

  static Future<void> logout() async {
    token = null;
    usuarioId = null;
    nome = null;
    email = null;
    isAdmin = false;
    final p = await SharedPreferences.getInstance();
    await p.remove('token');
    await p.remove('usuarioId');
    await p.remove('nome');
    await p.remove('email');
    await p.remove('isAdmin');
  }

  // ---------- Funções base: fazem a requisição e tratam erros ----------
  static Future<dynamic> _enviar(String metodo, String rota,
      [Object? corpo]) async {
    final url = Uri.parse('$base$rota');
    final body = corpo == null ? null : jsonEncode(corpo);
    http.Response r;

    try {
      final req = switch (metodo) {
        'GET' => http.get(url, headers: _h),
        'POST' => http.post(url, headers: _h, body: body),
        'PUT' => http.put(url, headers: _h, body: body),
        'DELETE' => http.delete(url, headers: _h),
        _ => throw ApiErro('Método inválido'),
      };
      r = await req.timeout(const Duration(seconds: 20));
    } on ApiErro {
      rethrow;
    } catch (_) {
      throw ApiErro(
          'Sem conexão com o servidor. Verifique se a API e o túnel estão rodando.');
    }

    // Token vencido ou inválido: encerra a sessão
    if (r.statusCode == 401 && rota != '/api/Usuarios/login') {
      await logout();
      throw ApiErro('Sua sessão expirou. Entre novamente.');
    }
    if (r.statusCode == 403) {
      throw ApiErro('Você não tem permissão para isso.');
    }

    dynamic dados;
    if (r.body.isNotEmpty) {
      try {
        dados = jsonDecode(r.body);
      } catch (_) {
        dados = r.body;
      }
    }

    if (r.statusCode < 200 || r.statusCode >= 300) {
      if (dados is Map && dados['mensagem'] != null)
        throw ApiErro(dados['mensagem']);
      throw ApiErro('Erro ${r.statusCode} ao falar com o servidor.');
    }
    return dados;
  }

  // =================== USUÁRIOS ===================
  static Future<void> login(String email, String senha) async {
    final d = await _enviar(
        'POST', '/api/Usuarios/login', {'email': email, 'senha': senha});
    token = d['token'];
    usuarioId = d['id'];
    nome = d['nome'] ?? d['email'];
    Api.email = d['email'];
    isAdmin = d['isAdmin'] == true;
    await _salvarSessao();
  }

  static Future<String> criarConta(
      String nome, String email, String senha, String confirmar) async {
    final d = await _enviar('POST', '/api/Usuarios/criar-conta', {
      'nome': nome,
      'email': email,
      'senha': senha,
      'confirmarSenha': confirmar
    });
    return d['mensagem'] ?? 'Conta criada.';
  }

  static Future<String> criarAdmin(
      String email, String senha, String confirmar) async {
    final d = await _enviar('POST', '/api/Usuarios/criar-admin',
        {'email': email, 'senha': senha, 'confirmarSenha': confirmar});
    return d['mensagem'] ?? 'Administrador criado.';
  }

  // =================== PRODUTOS ===================
  // SINCRONIZAÇÃO: quando consegue falar com a API, guarda o catálogo no
  // aparelho. Se estiver sem internet, mostra a última cópia salva.
  static bool catalogoOffline = false;

  static Future<List<dynamic>> produtos() async {
    final p = await SharedPreferences.getInstance();
    try {
      final lista = await _enviar('GET', '/api/Produtos') as List<dynamic>;
      catalogoOffline = false;
      // imagens em base64 são grandes: não vão para a cópia local
      final copia = lista.map((e) {
        final m = Map<String, dynamic>.from(e);
        if ((m['imagemUrl'] ?? '').toString().startsWith('data:'))
          m['imagemUrl'] = null;
        return m;
      }).toList();
      await p.setString('cacheProdutos', jsonEncode(copia));
      await p.setString('cacheProdutosData', DateTime.now().toIso8601String());
      return lista;
    } on ApiErro {
      final salvo = p.getString('cacheProdutos');
      if (salvo == null) rethrow;
      catalogoOffline = true;
      return jsonDecode(salvo);
    }
  }

  // Número que muda sempre que algum produto muda (usado no tempo real)
  static Future<int> versaoCatalogo() async {
    final d = await _enviar('GET', '/api/Produtos/versao');
    return d['versao'];
  }

  static Future<void> criarProduto(Map<String, dynamic> produto) =>
      _enviar('POST', '/api/Produtos', produto);

  static Future<void> editarProduto(int id, Map<String, dynamic> produto) =>
      _enviar('PUT', '/api/Produtos/$id', {...produto, 'id': id});

  static Future<void> excluirProduto(int id) =>
      _enviar('DELETE', '/api/Produtos/$id');

  // =================== COMPRAS ===================
  // itens: [{produtoNome, quantidade}]  -> no banco: procedure sp_FinalizarCompra
  static Future<int> finalizarCompra(List<Map<String, dynamic>> itens) async {
    final d = await _enviar('POST', '/api/Compras/finalizar', {
      'itens': itens.map((i) => {'origem': 'Carrinho', ...i}).toList(),
    });
    return d['compraId'];
  }

  static Future<List<dynamic>> minhasCompras() async =>
      await _enviar('GET', '/api/Compras/usuario/$usuarioId') as List<dynamic>;

  // procedure sp_CancelarCompra
  static Future<void> cancelarCompra(int compraId) =>
      _enviar('PUT', '/api/Compras/cancelar/$compraId');

  // =================== CARRINHO SALVO NO BANCO ===================
  // Cada item: {produtoId, quantidade, origem}
  static Future<List<dynamic>> obterCarrinho() async =>
      await _enviar('GET', '/api/Carrinho') as List<dynamic>;

  // procedure sp_SalvarCarrinho - devolve o carrinho como ficou salvo
  static Future<List<dynamic>> salvarCarrinho(
          List<Map<String, dynamic>> itens) async =>
      await _enviar('PUT', '/api/Carrinho', {'itens': itens}) as List<dynamic>;

  // =================== VENDAS (itens de cada compra) ===================
  // Cliente recebe só as dele; admin recebe todas
  static Future<List<dynamic>> vendas() async =>
      await _enviar('GET', '/api/Vendas') as List<dynamic>;

  // procedure sp_AvancarStatusVenda (admin)
  static Future<String> avancarStatus(int vendaId) async {
    final d = await _enviar('PUT', '/api/Vendas/avancar-status/$vendaId');
    return d['status'];
  }

  // procedure sp_DevolverVenda
  static Future<void> devolver(int vendaId, String motivo, String? texto) =>
      _enviar('PUT', '/api/Vendas/devolver/$vendaId',
          {'motivo': motivo, 'motivoTexto': texto});

  // =================== DASHBOARD (admin) ===================
  static Future<Map<String, dynamic>> resumo() async =>
      Map<String, dynamic>.from(await _enviar('GET', '/api/Dashboard/resumo'));

  static Future<List<dynamic>> maisVendidos() async =>
      await _enviar('GET', '/api/Dashboard/mais-vendidos?top=5')
          as List<dynamic>;

  static Future<List<dynamic>> renda(String por) async =>
      await _enviar('GET', '/api/Dashboard/renda?por=$por') as List<dynamic>;

  static Future<List<dynamic>> estoqueBaixo() async =>
      await _enviar('GET', '/api/Dashboard/estoque-baixo') as List<dynamic>;
}
