import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'models/filme.dart';
import 'views/lista_filmes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Insere os filmes de teste após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inserirFilmesDeTeste();
    });

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaFilmesPage(),
    );
  }

  Future<void> inserirFilmesDeTeste() async {
    final db = DBHelper();
    final filmes = await db.listarFilmes();

    // Só insere se o banco estiver vazio
    if (filmes.isEmpty) {
      Filme filme1 = Filme(
        imagemUrl: 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        titulo: 'A Origem',
        genero: 'Ficção Científica',
        faixaEtaria: '14',
        duracao: 148,
        pontuacao: 3.5,
        descricao: 'Um ladrão que invade sonhos para roubar segredos corporativos.',
        ano: 2010,
      );

      Filme filme2 = Filme(
        imagemUrl: 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg',
        titulo: 'Interestelar',
        genero: 'Drama / Ficção',
        faixaEtaria: '10',
        duracao: 169,
        pontuacao: 1,
        descricao: 'Uma equipe viaja por um buraco de minhoca em busca de um novo lar para a humanidade.',
        ano: 2014,
      );


      await db.inserirFilme(filme1);
      await db.inserirFilme(filme2);
      debugPrint('🎬 Filmes fictícios inseridos com sucesso!');
    } else {
      debugPrint('📁 Banco já possui filmes, nada foi inserido.');
    }
  }
}
