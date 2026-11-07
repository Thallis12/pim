import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administração'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            // abas claras sobre a barra azul-marinho; a aba aberta fica sublinhada em âmbar
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFC7D2FE),
            indicatorColor: corDestaque,
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: 'Dashboard'),
              Tab(icon: Icon(Icons.receipt_long), text: 'Vendas'),
              Tab(icon: Icon(Icons.inventory), text: 'Estoque'),
              Tab(icon: Icon(Icons.add_box), text: 'Novo produto'),
              Tab(icon: Icon(Icons.person_add), text: 'Criar admin'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DashboardAba(),
            VendasAba(),
            EstoqueAba(),
            NovoProdutoAba(),
            CriarAdminAba(),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// 1. DASHBOARD
// =====================================================================
class DashboardAba extends StatefulWidget {
  const DashboardAba({super.key});
  @override
  State<DashboardAba> createState() => _DashboardAbaState();
}

class _DashboardAbaState extends State<DashboardAba> {
  Map<String, dynamic>? _resumo;
  List<dynamic> _maisVendidos = [];
  List<dynamic> _renda = [];
  List<dynamic> _estoqueBaixo = [];
  String _periodo = 'dia';
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final r = await Future.wait([
        Api.resumo(),
        Api.maisVendidos(),
        Api.renda(_periodo),
        Api.estoqueBaixo(),
      ]);
      _resumo = r[0] as Map<String, dynamic>;
      _maisVendidos = r[1] as List<dynamic>;
      _renda = r[2] as List<dynamic>;
      _estoqueBaixo = r[3] as List<dynamic>;
    } catch (e) {
      _erro = e.toString();
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _trocarPeriodo(String p) async {
    setState(() => _periodo = p);
    try {
      final r = await Api.renda(p);
      if (mounted) setState(() => _renda = r);
    } catch (e) {
      if (mounted) tratarErro(context, e);
    }
  }

  Widget _cartaoNumero(String titulo, String valor, IconData icone, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Icon(icone, color: cor),
            const SizedBox(height: 4),
            Text(valor,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: corTextoSuave)),
          ]),
        ),
      ),
    );
  }

  // Barra horizontal simples (sem biblioteca de gráficos)
  Widget _barra(
      String rotulo, double valor, double maximo, Color cor, String texto) {
    final fracao = maximo <= 0 ? 0.0 : (valor / maximo).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(
            width: 90,
            child: Text(rotulo,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis)),
        Expanded(
          child: Stack(children: [
            Container(
                height: 18,
                decoration: BoxDecoration(
                    color: corSuperficie2,
                    borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(
              widthFactor: fracao,
              child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                      color: cor, borderRadius: BorderRadius.circular(4))),
            ),
          ]),
        ),
        SizedBox(
            width: 92,
            child: Text(texto,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro != null)
      return TelaErro(mensagem: _erro!, tentarDeNovo: _carregar);

    final r = _resumo ?? {};
    final maxVendidos = _maisVendidos.fold<double>(
        0,
        (m, p) => ((p['quantidadeVendida'] as num).toDouble() > m)
            ? (p['quantidadeVendida'] as num).toDouble()
            : m);
    final maxRenda = _renda.fold<double>(0, (m, p) {
      final maior = [
        (p['renda'] as num).toDouble(),
        (p['perdas'] as num).toDouble()
      ].reduce((a, b) => a > b ? a : b);
      return maior > m ? maior : m;
    });

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(children: [
            _cartaoNumero(
                'Total vendido',
                formatarPreco(r['totalVendido'] ?? 0),
                Icons.attach_money,
                corSucesso),
            _cartaoNumero('Vendas ativas', '${r['qtdVendas'] ?? 0}',
                Icons.shopping_bag, corPrimaria),
          ]),
          Row(children: [
            _cartaoNumero('Em preparo', '${r['qtdEmPreparo'] ?? 0}',
                Icons.inventory_2, corAlerta),
            _cartaoNumero('Cancelamentos', '${r['qtdCancelamentos'] ?? 0}',
                Icons.cancel, corErro),
          ]),
          Row(children: [
            _cartaoNumero('Devoluções', '${r['qtdDevolucoes'] ?? 0}',
                Icons.undo, Color(0xFFC2410C)),
            _cartaoNumero('Perdas (defeito)', '${r['qtdPerdas'] ?? 0}',
                Icons.report, Color(0xFF7F1D1D)),
          ]),
          const SizedBox(height: 12),
          const Text('Produtos mais vendidos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          if (_maisVendidos.isEmpty) const Text('Sem vendas ainda.'),
          ..._maisVendidos.map((p) => _barra(
              p['produtoNome'],
              (p['quantidadeVendida'] as num).toDouble(),
              maxVendidos,
              corPrimaria,
              '${p['quantidadeVendida']} un.')),
          const SizedBox(height: 16),
          const Text('Renda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'dia', label: Text('Dia')),
              ButtonSegment(value: 'mes', label: Text('Mês')),
              ButtonSegment(value: 'ano', label: Text('Ano')),
            ],
            selected: {_periodo},
            onSelectionChanged: (s) => _trocarPeriodo(s.first),
          ),
          const SizedBox(height: 6),
          const Text('Verde = renda   •   Vermelho = cancelado/devolvido',
              style: TextStyle(fontSize: 12, color: corTextoSuave)),
          // mostra os 10 períodos mais recentes
          ..._renda.reversed.take(10).expand((p) => [
                _barra(p['periodo'], (p['renda'] as num).toDouble(), maxRenda,
                    corSucesso, formatarPreco(p['renda'])),
                if ((p['perdas'] as num) > 0)
                  _barra('', (p['perdas'] as num).toDouble(), maxRenda, corErro,
                      formatarPreco(p['perdas'])),
              ]),
          const SizedBox(height: 16),
          const Text('Estoque baixo (2 ou menos)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (_estoqueBaixo.isEmpty)
            const Text('Nenhum produto com estoque baixo.'),
          ..._estoqueBaixo.map((p) => ListTile(
                dense: true,
                leading: Icon(Icons.warning,
                    color: p['quantidade'] == 0 ? corErro : corAlerta),
                title: Text(p['nome'] ?? ''),
                subtitle: Text(nomeTipo(p['tipo'])),
                trailing: Text('${p['quantidade']} un.'),
              )),
        ],
      ),
    );
  }
}

// =====================================================================
// 2. VENDAS - todos os pedidos, agrupados por compra
// =====================================================================
class VendasAba extends StatefulWidget {
  const VendasAba({super.key});
  @override
  State<VendasAba> createState() => _VendasAbaState();
}

class _VendasAbaState extends State<VendasAba> {
  List<dynamic> _vendas = [];
  bool _carregando = true;
  String? _erro;
  String _filtro = 'Todos';
  String _busca = '';

  static const filtros = [
    'Todos',
    'Em Preparo',
    'Em Transporte',
    'Entregue',
    'Cancelada',
    'Devolvida',
    'Perda'
  ];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      _vendas = await Api.vendas();
    } catch (e) {
      _erro = e.toString();
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // Avança o status de uma lista de itens (um item ou a compra inteira)
  Future<void> _avancar(List<dynamic> itens) async {
    try {
      for (final v in itens) {
        if (v['status'] == 'Em Preparo' || v['status'] == 'Em Transporte') {
          await Api.avancarStatus(v['id']);
        }
      }
      await _carregar();
      if (mounted) aviso(context, 'Status atualizado.');
    } catch (e) {
      if (mounted) tratarErro(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro != null)
      return TelaErro(mensagem: _erro!, tentarDeNovo: _carregar);

    // agrupa as vendas por compra (mesmo número de pedido)
    final grupos = <int, List<dynamic>>{};
    for (final v in _vendas) {
      grupos.putIfAbsent(v['compraId'] ?? 0, () => []).add(v);
    }
    final pedidos = grupos.entries.where((g) {
      final status =
          statusGeral(g.value.map((v) => v['status'].toString()).toList(), '');
      final okFiltro =
          _filtro == 'Todos' || g.value.any((v) => v['status'] == _filtro);
      final texto =
          '${g.key} ${g.value.first['usuarioNome']} ${g.value.map((v) => v['produtoNome']).join(' ')}'
              .toLowerCase();
      return okFiltro &&
          texto.contains(_busca.toLowerCase()) &&
          status.isNotEmpty;
    }).toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar por pedido, cliente ou produto',
              isDense: true),
          onChanged: (v) => setState(() => _busca = v),
        ),
      ),
      SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: filtros
              .map((f) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                        label: Text(f),
                        selected: _filtro == f,
                        onSelected: (_) => setState(() => _filtro = f)),
                  ))
              .toList(),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: _carregar,
          child: pedidos.isEmpty
              ? ListView(children: const [
                  Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Nenhuma venda.')))
                ])
              : ListView(
                  children: pedidos.map((g) {
                    final itens = g.value;
                    final status = statusGeral(
                        itens.map((v) => v['status'].toString()).toList(), '');
                    final total = itens.fold<double>(
                        0,
                        (s, v) =>
                            s +
                            ((v['preco'] as num) * (v['quantidade'] as num))
                                .toDouble());
                    final podeAvancar = itens.any((v) =>
                        v['status'] == 'Em Preparo' ||
                        v['status'] == 'Em Transporte');
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ExpansionTile(
                        title: Text(
                            'Pedido #${g.key} - ${itens.first['usuarioNome']}'),
                        subtitle: Text('${formatarPreco(total)}  •  $status',
                            style: TextStyle(color: corStatus(status))),
                        children: [
                          ...itens.map((v) => ListTile(
                                dense: true,
                                title: Text(
                                    '${v['produtoNome']} x${v['quantidade']}'),
                                subtitle: Text(
                                    '${formatarPreco((v['preco'] as num) * (v['quantidade'] as num))}${v['motivoDevolicao'] != null ? '  •  ${v['motivoDevolicao']}' : ''}'),
                                trailing: (v['status'] == 'Em Preparo' ||
                                        v['status'] == 'Em Transporte')
                                    ? TextButton(
                                        onPressed: () => _avancar([v]),
                                        child: Text(v['status'] == 'Em Preparo'
                                            ? 'Enviar'
                                            : 'Entregar'),
                                      )
                                    : Text(v['status'],
                                        style: TextStyle(
                                            color: corStatus(v['status']))),
                              )),
                          if (podeAvancar)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: FilledButton.icon(
                                icon: const Icon(Icons.fast_forward),
                                label: const Text('Avançar todos os itens'),
                                onPressed: () => _avancar(itens),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    ]);
  }
}

// =====================================================================
// 3. ESTOQUE - listar, editar e excluir produtos
// =====================================================================
class EstoqueAba extends StatefulWidget {
  const EstoqueAba({super.key});
  @override
  State<EstoqueAba> createState() => _EstoqueAbaState();
}

class _EstoqueAbaState extends State<EstoqueAba> {
  // A lista vem do Catalogo (main.dart), que se atualiza em tempo real
  String _busca = '';

  Future<void> _editar(dynamic p) async {
    final salvo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Editar produto')),
          body: FormularioProduto(produto: Map<String, dynamic>.from(p)),
        ),
      ),
    );
    if (salvo == true) Catalogo.i.recarregar();
  }

  Future<void> _excluir(dynamic p) async {
    if (!await confirmar(context, 'Excluir "${p['nome']}"?')) return;
    try {
      await Api.excluirProduto(p['id']);
      await Catalogo.i.recarregar();
      if (mounted) aviso(context, 'Produto excluído.');
    } catch (e) {
      if (mounted) tratarErro(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: quando um produto muda (aqui, no site ou por uma compra),
    // a lista se redesenha sozinha
    return ListenableBuilder(
      listenable: Catalogo.i,
      builder: (context, _) => _lista(context),
    );
  }

  Widget _lista(BuildContext context) {
    final cat = Catalogo.i;
    if (cat.carregando) return const Center(child: CircularProgressIndicator());
    if (cat.erro != null && cat.produtos.isEmpty) {
      return TelaErro(mensagem: cat.erro!, tentarDeNovo: cat.recarregar);
    }

    final lista = cat.produtos
        .where((p) =>
            p['nome'].toString().toLowerCase().contains(_busca.toLowerCase()))
        .toList()
      ..sort((a, b) =>
          '${a['tipo']}${a['nome']}'.compareTo('${b['tipo']}${b['nome']}'));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar produto',
              isDense: true),
          onChanged: (v) => setState(() => _busca = v),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: cat.recarregar,
          child: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (_, i) {
              final p = lista[i];
              final novoTipo = i == 0 || lista[i - 1]['tipo'] != p['tipo'];
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (novoTipo)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(nomeTipo(p['tipo']),
                            style: const TextStyle(
                                color: corPrimaria,
                                fontWeight: FontWeight.bold)),
                      ),
                    ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: imagemProduto(p['imagemUrl'], tamanho: 44)),
                      title: Text(p['nome']),
                      subtitle: Text(
                          '${formatarPreco(p['preco'])}  •  estoque ${p['quantidade']}'),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editar(p)),
                        IconButton(
                            icon: const Icon(Icons.delete, color: corErro),
                            onPressed: () => _excluir(p)),
                      ]),
                    ),
                  ]);
            },
          ),
        ),
      ),
    ]);
  }
}

// =====================================================================
// 4. NOVO PRODUTO
// =====================================================================
class NovoProdutoAba extends StatelessWidget {
  const NovoProdutoAba({super.key});
  @override
  Widget build(BuildContext context) => const FormularioProduto();
}

// Formulário usado para CRIAR (produto == null) e para EDITAR um produto
class FormularioProduto extends StatefulWidget {
  final Map<String, dynamic>? produto;
  const FormularioProduto({super.key, this.produto});
  @override
  State<FormularioProduto> createState() => _FormularioProdutoState();
}

class _FormularioProdutoState extends State<FormularioProduto> {
  static const tipos = [
    'CPU',
    'GPU',
    'RAM',
    'PlacaMae',
    'SSD',
    'SSDNVME',
    'HD',
    'Fonte',
    'Gabinete'
  ];

  final _form = GlobalKey<FormState>();
  late final _nome = TextEditingController(text: widget.produto?['nome'] ?? '');
  late final _preco =
      TextEditingController(text: '${widget.produto?['preco'] ?? ''}');
  late final _quantidade =
      TextEditingController(text: '${widget.produto?['quantidade'] ?? ''}');
  late final _socket =
      TextEditingController(text: widget.produto?['socket'] ?? '');
  late final _consumo =
      TextEditingController(text: '${widget.produto?['consumoEnergia'] ?? 0}');
  late final _potencia =
      TextEditingController(text: '${widget.produto?['potencia'] ?? ''}');
  late final _imagem = TextEditingController(
      text: (widget.produto?['imagemUrl'] ?? '').toString().startsWith('data:')
          ? ''
          : widget.produto?['imagemUrl'] ?? '');
  late String _tipo =
      tipos.contains(widget.produto?['tipo']) ? widget.produto!['tipo'] : 'CPU';
  bool _salvando = false;

  bool get _editando => widget.produto != null;

  String? _numero(String? v, {bool obrigatorio = true}) {
    if (v == null || v.trim().isEmpty)
      return obrigatorio ? 'Obrigatório' : null;
    final n = double.tryParse(v.replaceAll(',', '.'));
    if (n == null) return 'Número inválido';
    if (n < 0) return 'Não pode ser negativo';
    return null;
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _salvando = true);

    // imagem em base64 cadastrada pelo site é mantida se o campo ficar vazio
    final imagemAntiga = widget.produto?['imagemUrl'];
    final dados = {
      'nome': _nome.text.trim(),
      'tipo': _tipo,
      'preco': double.parse(_preco.text.replaceAll(',', '.')),
      'quantidade': int.parse(_quantidade.text.trim()),
      'socket': _socket.text.trim().isEmpty ? null : _socket.text.trim(),
      'consumoEnergia': int.tryParse(_consumo.text.trim()) ?? 0,
      'potencia': int.tryParse(_potencia.text.trim()),
      'imagemUrl': _imagem.text.trim().isNotEmpty
          ? _imagem.text.trim()
          : (_editando ? imagemAntiga : null),
    };

    try {
      if (_editando) {
        await Api.editarProduto(widget.produto!['id'], dados);
        Catalogo.i.recarregar();
        if (!mounted) return;
        aviso(context, 'Produto atualizado.');
        Navigator.pop(context, true);
      } else {
        await Api.criarProduto(dados);
        Catalogo.i.recarregar();
        if (!mounted) return;
        aviso(context, 'Produto criado!');
        _form.currentState!.reset();
        for (final c in [
          _nome,
          _preco,
          _quantidade,
          _socket,
          _potencia,
          _imagem
        ]) {
          c.clear();
        }
        _consumo.text = '0';
      }
    } catch (e) {
      if (mounted) tratarErro(context, e);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const espaco = SizedBox(height: 12);
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nome,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
          ),
          espaco,
          DropdownButtonFormField<String>(
            initialValue: _tipo,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: tipos
                .map(
                    (t) => DropdownMenuItem(value: t, child: Text(nomeTipo(t))))
                .toList(),
            onChanged: (v) => setState(() => _tipo = v!),
          ),
          espaco,
          TextFormField(
            controller: _preco,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Preço (R\$)'),
            validator: _numero,
          ),
          espaco,
          TextFormField(
            controller: _quantidade,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Quantidade em estoque'),
            validator: (v) =>
                _numero(v) ??
                (int.tryParse(v!.trim()) == null ? 'Use número inteiro' : null),
          ),
          espaco,
          TextFormField(
              controller: _socket,
              decoration:
                  const InputDecoration(labelText: 'Socket (opcional)')),
          espaco,
          TextFormField(
            controller: _consumo,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Consumo de energia (W)'),
            validator: (v) => _numero(v, obrigatorio: false),
          ),
          espaco,
          TextFormField(
            controller: _potencia,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Potência da fonte (W, opcional)'),
            validator: (v) => _numero(v, obrigatorio: false),
          ),
          espaco,
          TextFormField(
            controller: _imagem,
            decoration: InputDecoration(
              labelText: 'Link da imagem (opcional)',
              helperText:
                  _editando ? 'Deixe vazio para manter a imagem atual' : null,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _salvando ? null : _salvar,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child:
                  Text(_editando ? 'Salvar alterações' : 'Cadastrar produto'),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 5. CRIAR ADMINISTRADOR
// =====================================================================
class CriarAdminAba extends StatefulWidget {
  const CriarAdminAba({super.key});
  @override
  State<CriarAdminAba> createState() => _CriarAdminAbaState();
}

class _CriarAdminAbaState extends State<CriarAdminAba> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();
  bool _salvando = false;

  Future<void> _criar() async {
    setState(() => _salvando = true);
    try {
      final msg = await Api.criarAdmin(
          _email.text.trim(), _senha.text, _confirmar.text);
      if (!mounted) return;
      aviso(context, msg);
      _email.clear();
      _senha.clear();
      _confirmar.clear();
    } catch (e) {
      if (mounted) tratarErro(context, e);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Cadastrar novo administrador',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-mail')),
        const SizedBox(height: 12),
        TextField(
            controller: _senha,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Senha')),
        const SizedBox(height: 12),
        TextField(
            controller: _confirmar,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirmar senha')),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _salvando ? null : _criar,
          child: const Padding(
              padding: EdgeInsets.all(12), child: Text('Criar administrador')),
        ),
      ],
    );
  }
}
