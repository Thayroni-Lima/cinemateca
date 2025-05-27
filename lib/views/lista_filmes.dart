import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../database/db_helper.dart';
import 'cria_filme.dart';
import '../controllers/controller_filme.dart';


class ListaFilmesPage extends StatefulWidget {
  const ListaFilmesPage({super.key});

  @override
  State<ListaFilmesPage> createState() => _ListaFilmesPageState();
}

class _ListaFilmesPageState extends State<ListaFilmesPage> {
  final FilmeController _controller = FilmeController();
  List<Filme> _filmes = [];

  @override
  void initState() {
    super.initState();
    carregarFilmes();
  }

  Future<void> carregarFilmes() async {
    final filmes = await _controller.listarFilmes();
    setState(() {
      _filmes = filmes;
    });
  }

  void mostrarAlertaDoGrupo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sobre o Grupo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Desenvolvido por:'),
            SizedBox(height: 8),
            Text('- Anne Xavier'),
            Text('- Thayroni Lima'),
            Text('- Leonardo Costa'),
            Text('- Fernando Albuquerque')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Cadastrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => mostrarAlertaDoGrupo(context),
          ),
        ],
      ),
      body: _filmes.isEmpty
          ? const Center(child: Text('Nenhum filme cadastrado.'))
          : ListView.builder(
        itemCount: _filmes.length,
        itemBuilder: (context, index) {
          final filme = _filmes[index];
          return Dismissible(
            key: Key(filme.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmação'),
                  content: const Text('Deseja realmente excluir este filme?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) async {
              await _controller.deletarFilme(filme.id!);
              setState(() {
                _filmes.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filme "${filme.titulo}" excluído.')),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    filme.imagemUrl,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                title: Text(filme.titulo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gênero: ${filme.genero}'),
                    Text('Ano: ${filme.ano}'),
                    const SizedBox(height: 5),
                    RatingBarIndicator(
                      rating: filme.pontuacao,
                      itemCount: 5,
                      itemSize: 20,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CriaFilmePage()),
          ).then((_) => carregarFilmes()); // recarrega ao voltar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
