import 'package:flutter/material.dart';
import 'package:flutter_sqlite/Pessoa.dart';
import 'package:flutter_sqlite/PessoaDAO.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "SQLite CRUD", home: Pagina1());
  }
}

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  State<Pagina1> createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  final PessoaDAO _pessoaDAO = PessoaDAO();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _creditCardController = TextEditingController();

  List<Pessoa> _listaPessoas = [];
  Pessoa? _pessoaAtual;

  

  @override
  void initState() {
    super.initState();
    _loadPessoas();
  }

  void _salvarOuEditarPessoa() async {
    if (_pessoaAtual == null) {
      await _pessoaDAO.insertPessoa(
        Pessoa(
            nome: _nomeController.text,
            cpf: _cpfController.text,
            creditcard: _creditCardController.text),
      );
    } else {
      _pessoaAtual!.nome = _nomeController.text;
      _pessoaAtual!.cpf = _cpfController.text;
      _pessoaAtual!.creditcard = _creditCardController.text;
      await _pessoaDAO.updatePessoa(_pessoaAtual!);
    }
    _nomeController.clear();
    _cpfController.clear();
    _creditCardController.clear();
    setState(() {
      _pessoaAtual = null;
    });
    _loadPessoas();
  }

  void _editarPessoa(Pessoa pessoa) {
    setState(() {
      _pessoaAtual = pessoa;
      _nomeController.text = pessoa.nome;
      _cpfController.text = pessoa.cpf;
      _creditCardController.text = pessoa.creditcard;
    });
  }

  void _deletePessoa(int index) async {
    await _pessoaDAO.deletePessoa(Pessoa(
      id: index,
      nome: '',
      cpf: '',
      creditcard: '',
    ));
    _loadPessoas();
  }

  void _loadPessoas() async {
    List<Pessoa> listaTemp = await _pessoaDAO.selectPessoa();
    setState(() {
      _listaPessoas = listaTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
        backgroundColor: const Color.fromARGB(255, 240, 52, 52),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 225, 161),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _creditCardController,
                decoration: const InputDecoration(labelText: 'Credit Card'),
              )),
          ElevatedButton(
            onPressed: _salvarOuEditarPessoa,
            child: Text(_pessoaAtual == null ? 'Salvar' : "Atualizar"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaPessoas.length,
              itemBuilder: (context, index) {
                final Pessoa pessoa = _listaPessoas[index];
                return ListTile(
                  title: Text(
                      'Nome: ${pessoa.nome} - CPF: ${pessoa.cpf} - Credit Card: ${pessoa.creditcard}'),
                  trailing: IconButton(
                      onPressed: () {
                        _deletePessoa(pessoa.id!);
                      },
                      icon: const Icon(Icons.delete)),
                  onTap: () {
                    _editarPessoa(pessoa);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
