import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'api.dart';
import 'admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.carregarSessao(); // se já logou antes, entra direto
  runApp(const TechBuildApp());
}

// ---------------- PALETA DE CORES (a mesma do site) ----------------
// Harmonia COMPLEMENTAR do círculo cromático: azul (220°) x âmbar (40°).
// Proporção 60-30-10: 60% neutros claros, 30% azul, 10% âmbar (só compra).
// Azul = confiança (importante para quem vai pagar); âmbar = ação/compra.
// Todos os textos passam no contraste mínimo 4,5:1 (WCAG 2.1).
const corFundo = Color(0xFFF4F6FA); // fundo (cinza bem claro, azulado)
const corCartao = Color(0xFFFFFFFF); // cards
const corSuperficie2 = Color(0xFFEEF2F7); // áreas de destaque suave
const corBorda = Color(0xFFDDE3EC);
const corTexto = Color(0xFF1A2233); // texto principal
const corTextoSuave = Color(0xFF5B6576); // texto secundário
const corTopo = Color(0xFF0F2A5F); // azul-marinho (barra de cima, preço)
const corPrimaria = Color(0xFF1D4ED8); // azul dos botões comuns
const corPrimariaClara = Color(0xFFDBEAFE);
const corDestaque = Color(0xFFF59E0B); // âmbar: botões de compra
const corSucesso = Color(0xFF15803D);
const corAlerta = Color(0xFFB45309);
const corErro = Color(0xFFB91C1C);

class TechBuildApp extends StatelessWidget {
  const TechBuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechBuild',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: corFundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrimaria,
          brightness: Brightness.light,
          primary: corPrimaria,
          onPrimary: Colors.white,
          secondary: corDestaque,
          onSecondary: corTopo,
          surface: corCartao,
          onSurface: corTexto,
          error: corErro,
        ),
        cardTheme: const CardThemeData(
          color: corCartao,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            side: BorderSide(color: corBorda),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: corTopo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        // Botões cheios (Comprar, Finalizar...) em âmbar com texto azul-marinho
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: corDestaque,
            foregroundColor: corTopo,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(foregroundColor: corPrimaria),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: corCartao,
          selectedColor: corPrimariaClara,
          side: BorderSide(color: corBorda),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: corCartao,
          indicatorColor: corPrimariaClara,
        ),
        snackBarTheme: const SnackBarThemeData(backgroundColor: corTopo),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: corCartao,
        ),
      ),
      home: Api.logado ? const InicioPage() : const LoginPage(),
    );
  }
}

// =====================================================================
// FUNÇÕES DE APOIO usadas por várias telas
// =====================================================================

String formatarPreco(dynamic valor) {
  final v = (valor is num) ? valor.toDouble() : double.tryParse('$valor') ?? 0;
  final partes = v.toStringAsFixed(2).split('.');
  final inteiro =
      partes[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  return 'R\$ $inteiro,${partes[1]}';
}

String nomeTipo(String? tipo) => switch (tipo) {
      'CPU' => 'Processador',
      'GPU' => 'Placa de vídeo',
      'RAM' || 'Memoria RAM' => 'Memória RAM',
      'PlacaMae' => 'Placa-mãe',
      'SSDNVME' => 'SSD NVMe',
      'HD' => 'HD',
      'SSD' => 'SSD',
      'Fonte' => 'Fonte',
      'Gabinete' => 'Gabinete',
      _ => tipo ?? '',
    };

Color corStatus(String? status) => switch (status) {
      'Em Preparo' => corAlerta,
      'Em Transporte' => corPrimaria,
      'Entregue' => corSucesso,
      'Cancelada' => corErro,
      'Devolvida' => Color(0xFFC2410C),
      'Perda' => Color(0xFF7F1D1D),
      _ => corTextoSuave,
    };

// Status geral de uma compra, calculado a partir dos itens (mesma regra do site)
String statusGeral(List<String> statusItens, String statusCompra) {
  if (statusItens.isEmpty) return statusCompra;
  if (statusItens.toSet().length == 1) return statusItens.first;
  return 'Parcial';
}

// Imagem do produto: aceita URL, imagem em base64 (cadastrada pelo site) ou nenhuma
Widget imagemProduto(dynamic url, {double tamanho = 70}) {
  final semImagem = Image.network('${Api.base}/sem-imagem.jpg',
      width: tamanho,
      height: tamanho,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.memory, size: tamanho * 0.6, color: corPrimaria));
  final s = (url ?? '').toString();
  if (s.isEmpty || s.contains('via.placeholder.com')) return semImagem;
  if (s.startsWith('data:image')) {
    try {
      return Image.memory(base64Decode(s.split(',').last),
          width: tamanho, height: tamanho, fit: BoxFit.cover);
    } catch (_) {
      return semImagem;
    }
  }
  final completa = s.startsWith('http') ? s : '${Api.base}/$s';
  return Image.network(completa,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => semImagem);
}

// Mostra uma mensagem embaixo da tela e GARANTE que ela some depois de 3 segundos.
// (Em algumas situações o Flutter deixa a mensagem parada na tela; por isso
//  existe um Timer que fecha a mensagem se ela ainda estiver aberta.)
void aviso(BuildContext context, String texto) {
  final mensageiro = ScaffoldMessenger.of(context);
  mensageiro.hideCurrentSnackBar();
  final controle = mensageiro.showSnackBar(
      SnackBar(content: Text(texto), duration: const Duration(seconds: 3)));
  var fechada = false;
  controle.closed.then((_) => fechada = true);
  Timer(const Duration(seconds: 3), () {
    if (!fechada) mensageiro.hideCurrentSnackBar();
  });
}

Future<bool> confirmar(BuildContext context, String pergunta) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      content: Text(pergunta),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(c, false), child: const Text('Não')),
        FilledButton(
            onPressed: () => Navigator.pop(c, true), child: const Text('Sim')),
      ],
    ),
  );
  return r == true;
}

// Se a sessão expirou, volta para o login
void tratarErro(BuildContext context, Object e) {
  aviso(context, e.toString());
  if (!Api.logado) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }
}

// =====================================================================
// CARRINHO - salvo no BANCO (tabela CarrinhoItens)
// Toda mudança é enviada para a API (PUT /api/Carrinho). Ao abrir o app ou
// fazer login, o carrinho salvo é baixado (GET /api/Carrinho). A cada 3
// segundos o app confere se o carrinho mudou em outro aparelho (ex.: no site).
// Assim o carrinho não some ao fechar o app e é o mesmo no site e no celular.
// =====================================================================
class ItemCarrinho {
  final Map<String, dynamic> produto;
  int quantidade;
  final String
      origem; // 'Carrinho' (comprado avulso) ou 'MontePC' (PC montado no site)
  ItemCarrinho(this.produto, this.quantidade, {this.origem = 'Carrinho'});
  double get subtotal => (produto['preco'] as num).toDouble() * quantidade;
}

class Carrinho {
  // ValueNotifier avisa as telas quando o carrinho muda (para o contador da aba)
  static final itens = ValueNotifier<List<ItemCarrinho>>([]);

  static int get totalItens => itens.value.fold(0, (s, i) => s + i.quantidade);
  static double get total => itens.value.fold(0.0, (s, i) => s + i.subtotal);

  // Retorna false se não houver estoque suficiente
  static bool adicionar(Map<String, dynamic> p) {
    final lista = [...itens.value];
    final existente = lista
        .where((i) => i.produto['id'] == p['id'] && i.origem == 'Carrinho')
        .toList();
    final estoque = (p['quantidade'] ?? 0) as int;
    if (existente.isNotEmpty) {
      if (existente.first.quantidade >= estoque) return false;
      existente.first.quantidade++;
    } else {
      if (estoque <= 0) return false;
      lista.add(ItemCarrinho(p, 1));
    }
    itens.value = lista;
    _salvar();
    return true;
  }

  static void alterar(ItemCarrinho item, int delta) {
    final estoque = (item.produto['quantidade'] ?? 0) as int;
    final nova = item.quantidade + delta;
    if (nova > estoque) return;
    final lista = [...itens.value];
    if (nova <= 0) {
      lista.remove(item);
    } else {
      item.quantidade = nova;
    }
    itens.value = lista;
    _salvar();
  }

  static void limpar() {
    itens.value = [];
    _salvar(); // no logout não salva (já não tem login), então o carrinho fica guardado
  }

  // Chamado quando o catálogo muda em tempo real: atualiza preço/estoque dos
  // itens do carrinho e remove os que foram excluídos ou ficaram sem estoque.
  static void sincronizar(List<dynamic> produtos) {
    final lista = <ItemCarrinho>[];
    for (final item in itens.value) {
      final novo =
          produtos.where((p) => p['id'] == item.produto['id']).toList();
      if (novo.isEmpty) continue;
      final estoque = (novo.first['quantidade'] ?? 0) as int;
      if (estoque <= 0) continue;
      lista.add(ItemCarrinho(Map<String, dynamic>.from(novo.first),
          item.quantidade > estoque ? estoque : item.quantidade,
          origem: item.origem));
    }
    itens.value = lista;
  }

  // ---------- Sincronização com o banco ----------
  static String?
      _assinatura; // "foto" do último carrinho salvo/lido (para comparar)
  static Timer?
      _timerSalvar; // espera 0,4 s antes de salvar (junta toques rápidos)

  static List<Map<String, dynamic>> _paraServidor() => itens.value
      .map((i) => {
            'produtoId': i.produto['id'],
            'quantidade': i.quantidade,
            'origem': i.origem
          })
      .toList();

  static String _assinar(List<dynamic> lista) {
    final partes = lista
        .map((i) => '${i['origem']}-${i['produtoId']}-${i['quantidade']}')
        .toList()
      ..sort();
    return partes.join('|');
  }

  // Monta o carrinho da tela com o que veio do banco
  static void _aplicar(List<dynamic> salvo) {
    final produtos = Catalogo.i.produtos;
    final lista = <ItemCarrinho>[];
    for (final s in salvo) {
      final p = produtos.where((x) => x['id'] == s['produtoId']).toList();
      if (p.isEmpty) continue;
      lista.add(ItemCarrinho(
          Map<String, dynamic>.from(p.first), s['quantidade'],
          origem: s['origem'] ?? 'Carrinho'));
    }
    itens.value = lista;
    _assinatura = _assinar(salvo);
  }

  // Envia o carrinho para a API (procedure sp_SalvarCarrinho)
  static void _salvar() {
    if (!Api.logado) return;
    _timerSalvar?.cancel();
    _timerSalvar = Timer(const Duration(milliseconds: 400), () async {
      final enviado = _paraServidor();
      try {
        final salvo = await Api.salvarCarrinho(enviado);
        // o banco limita a quantidade ao estoque: se ajustou, mostra como ficou
        if (_assinar(salvo) != _assinar(enviado)) {
          _aplicar(salvo);
        } else {
          _assinatura = _assinar(salvo);
        }
      } catch (_) {
        // sem conexão: na próxima mudança tenta de novo
      }
      _timerSalvar = null;
    });
  }

  // Baixa o carrinho salvo (ao abrir o app e a cada 3 segundos)
  static Future<void> carregarSalvo() async {
    if (!Api.logado || Catalogo.i.produtos.isEmpty) return;
    try {
      final salvo = await Api.obterCarrinho();
      if (_timerSalvar != null)
        return; // há uma mudança deste aparelho esperando para ser salva
      if (_assinar(salvo) != _assinatura) _aplicar(salvo);
    } catch (_) {
      // sem conexão: tenta de novo depois
    }
  }

  // Ao sair da conta: limpa só a tela (o carrinho continua salvo no banco)
  static void esquecer() {
    _timerSalvar?.cancel();
    _timerSalvar = null;
    _assinatura = null;
    itens.value = [];
  }
}

// =====================================================================
// CATÁLOGO EM TEMPO REAL
// Guarda a lista de produtos para o app inteiro (Hardware e Estoque do admin).
// A cada 3 segundos chama GET /api/Produtos/versao. Esse número vem do banco
// (trigger de auditoria + procedure sp_VersaoCatalogo) e muda sempre que um
// produto muda. Só quando muda o app baixa os produtos de novo.
// =====================================================================
class Catalogo extends ChangeNotifier {
  static final i = Catalogo._();
  Catalogo._();

  List<dynamic> produtos = [];
  bool carregando = true;
  String? erro;

  int? _versao;
  Timer? _timer;

  Future<void> recarregar() async {
    if (produtos.isEmpty) {
      carregando = true;
      notifyListeners();
    }
    try {
      produtos = await Api.produtos();
      erro = null;
      Carrinho.sincronizar(produtos);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners(); // avisa as telas para se redesenharem
    }
  }

  void iniciarTempoReal() {
    _timer ??= Timer.periodic(const Duration(seconds: 3), (_) => _verificar());
  }

  void pararTempoReal() {
    _timer?.cancel();
    _timer = null;
    _versao = null;
  }

  Future<void> _verificar() async {
    Carrinho.carregarSalvo(); // o carrinho pode ter mudado em outro aparelho
    try {
      final v = await Api.versaoCatalogo();
      if (_versao == null) {
        _versao = v; // primeira leitura
        return;
      }
      if (v != _versao) {
        _versao = v;
        await recarregar();
      } else if (Api.catalogoOffline || erro != null) {
        await recarregar(); // a conexão voltou
      }
    } catch (_) {
      // sem conexão: tenta de novo daqui a 3 segundos
    }
  }
}

// =====================================================================
// TELA DE LOGIN / CRIAR CONTA
// =====================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();
  bool _criandoConta = false;
  bool _carregando = false;
  String? _erro;

  Future<void> _enviar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      if (_criandoConta) {
        final msg = await Api.criarConta(_nome.text.trim(), _email.text.trim(),
            _senha.text, _confirmar.text);
        if (!mounted) return;
        aviso(context, msg);
        setState(() => _criandoConta = false);
      } else {
        await Api.login(_email.text.trim(), _senha.text);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const InicioPage()));
      }
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      // o carregamento SEMPRE termina, mesmo com erro
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.memory, size: 64, color: corPrimaria),
                const SizedBox(height: 8),
                // logo com as duas cores da marca: "Tech" azul-marinho e "Build" âmbar
                const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Tech', style: TextStyle(color: corTopo)),
                    TextSpan(
                        text: 'Build', style: TextStyle(color: corDestaque)),
                  ]),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_criandoConta ? 'Criar conta' : 'Entrar',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                if (_criandoConta) ...[
                  TextField(
                      controller: _nome,
                      decoration: const InputDecoration(labelText: 'Nome')),
                  const SizedBox(height: 12),
                ],
                TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail')),
                const SizedBox(height: 12),
                TextField(
                    controller: _senha,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha')),
                if (_criandoConta) ...[
                  const SizedBox(height: 12),
                  TextField(
                      controller: _confirmar,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Confirmar senha')),
                ],
                if (_erro != null) ...[
                  const SizedBox(height: 12),
                  Text(_erro!, style: const TextStyle(color: corErro)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _carregando ? null : _enviar,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_criandoConta ? 'Criar conta' : 'Entrar'),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _criandoConta = !_criandoConta;
                    _erro = null;
                  }),
                  child: Text(_criandoConta
                      ? 'Já tenho conta'
                      : 'Não tenho conta - criar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// TELA INICIAL com as 4 abas (barra inferior)
// =====================================================================
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});
  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _aba = 0;
  // chave usada para recarregar a aba Pedidos depois de uma compra
  final _pedidosKey = GlobalKey<_PedidosPageState>();

  @override
  void initState() {
    super.initState();
    // depois de baixar os produtos, traz o carrinho salvo desta conta
    Catalogo.i.recarregar().then((_) => Carrinho.carregarSalvo());
    Catalogo.i.iniciarTempoReal(); // liga a atualização em tempo real
  }

  @override
  void dispose() {
    Catalogo.i.pararTempoReal();
    super.dispose();
  }

  void _irPara(int aba) => setState(() => _aba = aba);

  @override
  Widget build(BuildContext context) {
    final telas = [
      HardwarePage(irParaCarrinho: () => _irPara(1)),
      CarrinhoPage(aposCompra: () {
        _irPara(2);
        _pedidosKey.currentState?.carregar();
      }),
      PedidosPage(key: _pedidosKey),
      const ContaPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _aba, children: telas),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: Carrinho.itens,
        builder: (_, __, ___) => NavigationBar(
          selectedIndex: _aba,
          onDestinationSelected: _irPara,
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.memory), label: 'Hardware'),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: Carrinho.totalItens > 0,
                label: Text('${Carrinho.totalItens}'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Carrinho',
            ),
            const NavigationDestination(
                icon: Icon(Icons.local_shipping), label: 'Pedidos'),
            const NavigationDestination(
                icon: Icon(Icons.person), label: 'Conta'),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// ABA 1 - HARDWARE (catálogo)
// =====================================================================
class HardwarePage extends StatefulWidget {
  final VoidCallback irParaCarrinho;
  const HardwarePage({super.key, required this.irParaCarrinho});
  @override
  State<HardwarePage> createState() => _HardwarePageState();
}

class _HardwarePageState extends State<HardwarePage> {
  String _tipo = 'Todos';
  String _busca = '';
  RangeValues? _faixa; // filtro de preço escolhido (null = todos os preços)
  bool _mostrarFiltros = false;

  // Especificações técnicas do produto em uma linha
  String _especificacoes(dynamic p) {
    final partes = <String>[
      if ((p['socket'] ?? '').toString().isNotEmpty) 'Socket ${p['socket']}',
      if ((p['consumoEnergia'] ?? 0) > 0) 'Consumo ${p['consumoEnergia']} W',
      if (p['potencia'] != null && p['potencia'] > 0)
        'Potência ${p['potencia']} W',
    ];
    return partes.join('  •  ');
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: redesenha sozinho quando o Catalogo muda (tempo real)
    return ListenableBuilder(
      listenable: Catalogo.i,
      builder: (context, _) {
        final cat = Catalogo.i;
        final todos = cat.produtos;

        // limites do filtro de preço = menor e maior preço do catálogo
        final precos =
            todos.map((p) => (p['preco'] as num).toDouble()).toList();
        final minPreco = precos.isEmpty
            ? 0.0
            : precos.reduce((a, b) => a < b ? a : b).floorToDouble();
        var maxPreco = precos.isEmpty
            ? 1.0
            : precos.reduce((a, b) => a > b ? a : b).ceilToDouble();
        if (maxPreco <= minPreco) maxPreco = minPreco + 1;
        final faixa = RangeValues(
          (_faixa?.start ?? minPreco).clamp(minPreco, maxPreco).toDouble(),
          (_faixa?.end ?? maxPreco).clamp(minPreco, maxPreco).toDouble(),
        );

        final tipos = [
          'Todos',
          ...todos.map((p) => p['tipo'].toString()).toSet()
        ];
        final lista = todos.where((p) {
          final preco = (p['preco'] as num).toDouble();
          final okTipo = _tipo == 'Todos' || p['tipo'] == _tipo;
          final okBusca =
              p['nome'].toString().toLowerCase().contains(_busca.toLowerCase());
          final okPreco = preco >= faixa.start && preco <= faixa.end;
          return okTipo && okBusca && okPreco;
        }).toList();

        final filtroAtivo = _faixa != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hardware'),
            actions: [
              IconButton(
                tooltip: 'Filtrar por preço',
                icon: Badge(
                    isLabelVisible: filtroAtivo,
                    smallSize: 8,
                    child: const Icon(Icons.tune)),
                onPressed: () =>
                    setState(() => _mostrarFiltros = !_mostrarFiltros),
              ),
            ],
          ),
          body: Column(
            children: [
              if (Api.catalogoOffline)
                Container(
                  width: double.infinity,
                  color: corAlerta,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                      'Sem conexão: mostrando o catálogo salvo no aparelho.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar produto',
                      isDense: true),
                  onChanged: (v) => setState(() => _busca = v),
                ),
              ),
              // ---------- filtro por categoria ----------
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: tipos
                      .map((t) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(t == 'Todos' ? 'Todos' : nomeTipo(t)),
                              selected: _tipo == t,
                              onSelected: (_) => setState(() => _tipo = t),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // ---------- filtro por preço (aparece ao tocar no ícone) ----------
              if (_mostrarFiltros)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                            'Preço: ${formatarPreco(faixa.start)} até ${formatarPreco(faixa.end)}'),
                      ),
                      if (filtroAtivo)
                        TextButton(
                            onPressed: () => setState(() => _faixa = null),
                            child: const Text('Limpar')),
                    ]),
                    RangeSlider(
                      values: faixa,
                      min: minPreco,
                      max: maxPreco,
                      divisions: 100,
                      labels: RangeLabels(
                          formatarPreco(faixa.start), formatarPreco(faixa.end)),
                      onChanged: (v) => setState(() => _faixa = v),
                    ),
                  ]),
                ),
              Expanded(
                child: cat.carregando
                    ? const Center(child: CircularProgressIndicator())
                    : (cat.erro != null && todos.isEmpty)
                        ? TelaErro(
                            mensagem: cat.erro!, tentarDeNovo: cat.recarregar)
                        : RefreshIndicator(
                            onRefresh: cat.recarregar,
                            child: lista.isEmpty
                                ? ListView(children: const [
                                    Padding(
                                        padding: EdgeInsets.all(32),
                                        child: Center(
                                            child: Text(
                                                'Nenhum produto encontrado.')))
                                  ])
                                : ListView.builder(
                                    itemCount: lista.length,
                                    itemBuilder: (_, i) =>
                                        _cardProduto(lista[i]),
                                  ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cardProduto(dynamic p) {
    final estoque = (p['quantidade'] ?? 0) as int;
    final specs = _especificacoes(p);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagemProduto(p['imagemUrl'])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(nomeTipo(p['tipo']),
                      style: const TextStyle(color: corTextoSuave)),
                  if (specs.isNotEmpty)
                    Text(specs,
                        style: const TextStyle(
                            fontSize: 11, color: corTextoSuave)),
                  const SizedBox(height: 4),
                  Text(formatarPreco(p['preco']),
                      style: const TextStyle(
                          color: corTopo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  // quantidade em estoque (atualiza em tempo real)
                  Text(
                      estoque <= 0
                          ? 'Sem estoque'
                          : estoque <= 2
                              ? 'Últimas $estoque unidade${estoque > 1 ? 's' : ''} em estoque'
                              : '$estoque unidades em estoque',
                      style: TextStyle(
                          fontSize: 12,
                          color: estoque <= 0
                              ? corErro
                              : estoque <= 2
                                  ? corAlerta
                                  : corTextoSuave)),
                ],
              ),
            ),
            FilledButton(
              onPressed: estoque <= 0
                  ? null
                  : () {
                      final ok =
                          Carrinho.adicionar(Map<String, dynamic>.from(p));
                      // mensagem que some sozinha depois de 3 segundos
                      aviso(
                          context,
                          ok
                              ? '${p['nome']} adicionado ao carrinho'
                              : 'Quantidade máxima em estoque já está no carrinho');
                    },
              child: const Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// ABA 2 - CARRINHO
// =====================================================================
class CarrinhoPage extends StatefulWidget {
  final VoidCallback aposCompra;
  const CarrinhoPage({super.key, required this.aposCompra});
  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  bool _enviando = false;

  Future<void> _finalizar() async {
    if (!await confirmar(
        context, 'Finalizar compra de ${formatarPreco(Carrinho.total)}?'))
      return;
    setState(() => _enviando = true);
    try {
      final itens = Carrinho.itens.value
          .map((i) => {
                'produtoNome': i.produto['nome'],
                'quantidade': i.quantidade,
                'origem': i.origem
              })
          .toList();
      final compraId = await Api.finalizarCompra(itens);
      Carrinho.limpar();
      Catalogo.i.recarregar(); // estoque mudou
      if (!mounted) return;
      aviso(context, 'Compra #$compraId realizada! Acompanhe na aba Pedidos.');
      widget.aposCompra();
    } catch (e) {
      if (mounted) tratarErro(context, e);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: ValueListenableBuilder<List<ItemCarrinho>>(
        valueListenable: Carrinho.itens,
        builder: (_, itens, __) {
          if (itens.isEmpty) {
            return const Center(child: Text('Seu carrinho está vazio.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: itens
                      .map((i) => Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: imagemProduto(i.produto['imagemUrl'],
                                      tamanho: 48)),
                              title: Text(i.produto['nome']),
                              subtitle: Text(i.origem == 'MontePC'
                                  ? '${formatarPreco(i.subtotal)}  •  PC montado no site'
                                  : formatarPreco(i.subtotal)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      onPressed: () => Carrinho.alterar(i, -1)),
                                  Text('${i.quantidade}'),
                                  IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () => Carrinho.alterar(i, 1)),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: corCartao,
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Total: ${formatarPreco(Carrinho.total)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    FilledButton(
                      onPressed: _enviando ? null : _finalizar,
                      child: _enviando
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Finalizar compra'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================================
// ABA 3 - PEDIDOS (minhas compras)
// =====================================================================
class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});
  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<dynamic> _compras = [];
  List<dynamic> _vendas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      // compras (com itens) + vendas (status de cada item)
      final r = await Future.wait([Api.minhasCompras(), Api.vendas()]);
      _compras = r[0];
      // o admin recebe as vendas de todos; aqui só interessam as dele
      _vendas = r[1].where((v) => v['usuarioId'] == Api.usuarioId).toList();
    } catch (e) {
      _erro = e.toString();
      if (!Api.logado && mounted) tratarErro(context, e);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pedidos')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? TelaErro(mensagem: _erro!, tentarDeNovo: carregar)
              : RefreshIndicator(
                  onRefresh: carregar,
                  child: _compras.isEmpty
                      ? ListView(children: const [
                          Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                  child: Text('Você ainda não fez compras.')))
                        ])
                      : ListView(
                          children: _compras.map((c) {
                            final vendasCompra = _vendas
                                .where((v) => v['compraId'] == c['id'])
                                .toList();
                            final status = statusGeral(
                                vendasCompra
                                    .map((v) => v['status'].toString())
                                    .toList(),
                                c['status'].toString());
                            final total = (c['itens'] as List).fold<double>(
                                0,
                                (s, i) =>
                                    s +
                                    ((i['preco'] as num) *
                                            (i['quantidade'] as num))
                                        .toDouble());
                            final data =
                                DateTime.tryParse(c['dataCompra'].toString());
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text('Pedido #${c['id']}'),
                                subtitle: Text(
                                    '${data != null ? '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}  •  ' : ''}${formatarPreco(total)}'),
                                trailing: Chip(
                                  label: Text(status,
                                      style: const TextStyle(fontSize: 12)),
                                  side: BorderSide(color: corStatus(status)),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PedidoDetalhePage(
                                              compra: c,
                                              vendas: vendasCompra)));
                                  carregar(); // volta da tela: atualiza os status
                                },
                              ),
                            );
                          }).toList(),
                        ),
                ),
    );
  }
}

// =====================================================================
// ACOMPANHAR PEDIDO - linha do tempo + itens + cancelar / devolver
// =====================================================================
class PedidoDetalhePage extends StatefulWidget {
  final dynamic compra;
  final List<dynamic> vendas;
  const PedidoDetalhePage(
      {super.key, required this.compra, required this.vendas});
  @override
  State<PedidoDetalhePage> createState() => _PedidoDetalhePageState();
}

class _PedidoDetalhePageState extends State<PedidoDetalhePage> {
  late List<dynamic> _vendas = widget.vendas;
  bool _ocupado = false;

  static const etapas = ['Em Preparo', 'Em Transporte', 'Entregue'];

  Future<void> _recarregar() async {
    final todas = await Api.vendas();
    setState(() => _vendas =
        todas.where((v) => v['compraId'] == widget.compra['id']).toList());
  }

  Future<void> _executar(Future<void> Function() acao, String sucesso) async {
    setState(() => _ocupado = true);
    try {
      await acao();
      await _recarregar();
      if (mounted) aviso(context, sucesso);
    } catch (e) {
      if (mounted) tratarErro(context, e);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _devolver(dynamic venda) async {
    String motivo = 'Desistencia';
    final texto = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setD) => AlertDialog(
          title: const Text('Motivo da devolução'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // escolha do motivo (um botão por opção)
              Wrap(
                spacing: 8,
                children: const {
                  'Desistencia': 'Desisti da compra',
                  'Defeito': 'Produto com defeito',
                  'Outro': 'Outro',
                }
                    .entries
                    .map((e) => ChoiceChip(
                          label: Text(e.value),
                          selected: motivo == e.key,
                          onSelected: (_) => setD(() => motivo = e.key),
                        ))
                    .toList(),
              ),
              if (motivo == 'Outro')
                TextField(
                    controller: texto,
                    decoration: const InputDecoration(labelText: 'Explique')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Voltar')),
            FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Devolver')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await _executar(() => Api.devolver(venda['id'], motivo, texto.text),
        'Devolução registrada.');
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.compra;
    final status = statusGeral(
        _vendas.map((v) => v['status'].toString()).toList(),
        c['status'].toString());
    final podeCancelar =
        _vendas.isNotEmpty && _vendas.every((v) => v['status'] == 'Em Preparo');
    final passo = etapas.indexOf(status);

    return Scaffold(
      appBar: AppBar(title: Text('Pedido #${c['id']}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- linha do tempo do pedido ----------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Situação: $status',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: corStatus(status))),
                  const SizedBox(height: 16),
                  if (passo >= 0)
                    Row(
                      children: List.generate(etapas.length, (i) {
                        final feito = i <= passo;
                        return Expanded(
                          child: Column(children: [
                            Icon(
                                [
                                  Icons.inventory_2,
                                  Icons.local_shipping,
                                  Icons.check_circle
                                ][i],
                                color: feito ? corPrimaria : corBorda),
                            const SizedBox(height: 4),
                            Text(etapas[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: feito ? corTexto : corTextoSuave)),
                          ]),
                        );
                      }),
                    )
                  else
                    Text(status == 'Parcial'
                        ? 'Os itens deste pedido estão em situações diferentes (veja abaixo).'
                        : 'Este pedido foi encerrado.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Itens',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ..._vendas.map((v) => Card(
                child: ListTile(
                  title: Text('${v['produtoNome']}  x${v['quantidade']}'),
                  subtitle: Text(
                      '${formatarPreco((v['preco'] as num) * (v['quantidade'] as num))}${v['motivoDevolicao'] != null ? '\nMotivo: ${v['motivoDevolicao']}' : ''}'),
                  trailing: v['status'] == 'Entregue'
                      ? OutlinedButton(
                          onPressed: _ocupado ? null : () => _devolver(v),
                          child: const Text('Devolver'))
                      : Text(v['status'],
                          style: TextStyle(color: corStatus(v['status']))),
                ),
              )),
          const SizedBox(height: 16),
          if (podeCancelar)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: corErro),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar pedido'),
              onPressed: _ocupado
                  ? null
                  : () async {
                      if (!await confirmar(context, 'Cancelar este pedido?'))
                        return;
                      await _executar(() => Api.cancelarCompra(c['id']),
                          'Pedido cancelado.');
                    },
            ),
          if (podeCancelar)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                  'Você pode cancelar enquanto o pedido estiver em preparo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: corTextoSuave, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// ABA 4 - CONTA
// =====================================================================
class ContaPage extends StatelessWidget {
  const ContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha conta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(Api.nome ?? ''),
              subtitle: Text(Api.email ?? ''),
              trailing: Api.isAdmin ? const Chip(label: Text('Admin')) : null,
            ),
          ),
          const SizedBox(height: 12),
          // Botão que só aparece para administradores
          if (Api.isAdmin)
            FilledButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Área de administração')),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminPage())),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Padding(
                padding: EdgeInsets.all(12), child: Text('Sair da conta')),
            onPressed: () async {
              await Api.logout();
              Carrinho
                  .esquecer(); // limpa a tela; o carrinho fica salvo no banco
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false);
            },
          ),
        ],
      ),
    );
  }
}

// Tela padrão de erro com botão "Tentar de novo" (usada também no admin.dart)
class TelaErro extends StatelessWidget {
  final String mensagem;
  final Future<void> Function() tentarDeNovo;
  const TelaErro({required this.mensagem, required this.tentarDeNovo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off, size: 48, color: corTextoSuave),
          const SizedBox(height: 12),
          Text(mensagem, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(
              onPressed: tentarDeNovo, child: const Text('Tentar de novo')),
        ]),
      ),
    );
  }
}
