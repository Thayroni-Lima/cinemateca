import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../models/filme.dart';
import '../database/db_helper.dart';
import '../controllers/controller_filme.dart';

class CriaFilmePage extends StatefulWidget {
  const CriaFilmePage({super.key});

  @override
  State<CriaFilmePage> createState() => _CriaFilmePageState();
}

class _CriaFilmePageState extends State<CriaFilmePage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _generoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _anoController = TextEditingController();
  final FilmeController _controller = FilmeController();

  String? _faixaEtariaSelecionada;
  double _pontuacao = 0;

  final List<String> _faixasEtarias = ['Livre', '10', '12', '14', '16', '18'];

  void _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      Filme novoFilme = Filme(
        imagemUrl: _imagemUrlController.text,
        titulo: _tituloController.text,
        genero: _generoController.text,
        faixaEtaria: _faixaEtariaSelecionada ?? 'Livre',
        duracao: int.tryParse(_duracaoController.text) ?? 0,
        pontuacao: _pontuacao,
        descricao: _descricaoController.text,
        ano: int.tryParse(_anoController.text) ?? 0,
      );

      try {
        await _controller.inserirFilme(novoFilme);
        Navigator.pop(context); // Volta para tela de listagem
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Filme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value!.isEmpty ? 'Preencha o título' : null,
              ),
              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(labelText: 'Gênero'),
                validator: (value) =>
                value!.isEmpty ? 'Preencha o gênero' : null,
              ),
              TextFormField(
                controller: _imagemUrlController,
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) =>
                value!.isEmpty ? 'Preencha a URL da imagem' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? 'Preencha a descrição' : null,
              ),
              TextFormField(
                controller: _duracaoController,
                decoration: const InputDecoration(labelText: 'Duração (min)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Faixa Etária'),
                value: _faixaEtariaSelecionada,
                items: _faixasEtarias
                    .map((faixa) => DropdownMenuItem(
                  value: faixa,
                  child: Text(faixa),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _faixaEtariaSelecionada = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Pontuação:'),
              SmoothStarRating(
                allowHalfRating: true,
                onRatingChanged: (value) {
                  setState(() {
                    _pontuacao = value;
                  });
                },
                starCount: 5,
                rating: _pontuacao,
                size: 35.0,
                color: Colors.amber,
                borderColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarFilme,
                child: const Text('Salvar Filme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
