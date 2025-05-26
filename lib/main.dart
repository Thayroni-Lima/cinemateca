import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'models/filme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Executa testarDB() após o build da interface
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testarDB();
    });

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Testando DB... Veja o Logcat com filtro "flutter".'),
        ),
      ),
    );
  }

  Future<void> testarDB() async {
    try {
      final db = DBHelper();

      // Criar filme de teste
      Filme novoFilme = Filme(
        imagemUrl: 'https://via.placeholder.com/150',
        titulo: 'Filme Teste',
        genero: 'Ação',
        faixaEtaria: '14',
        duracao: 120,
        pontuacao: 4.5,
        descricao: 'Filme criado para teste.',
        ano: 2024,
      );

      // Inserir
      await db.inserirFilme(novoFilme);
      debugPrint('✅ Filme inserido.');

      // Listar
      List<Filme> filmes = await db.listarFilmes();
      for (var filme in filmes) {
        debugPrint('🎬 Título: ${filme.titulo}, Nota: ${filme.pontuacao}');
      }

      // Atualizar
      if (filmes.isNotEmpty) {
        Filme primeiro = filmes[0];
        primeiro.titulo = 'Filme Atualizado';
        await db.atualizarFilme(primeiro);
        debugPrint('✏️ Filme atualizado.');
      }

      // Deletar
      if (filmes.isNotEmpty) {
        await db.deletarFilme(filmes[0].id!);
        debugPrint('🗑️ Filme deletado.');
      }
    } catch (e, stack) {
      debugPrint('⚠️ Erro ao testar DB: $e');
      debugPrint(stack.toString());
    }
  }
}
