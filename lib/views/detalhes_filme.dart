import 'package:flutter/material.dart';
import '../models/filme.dart';

class DetalhesFilmePage extends StatelessWidget {
  final Filme filme;

  const DetalhesFilmePage({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(filme.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              filme.imagemUrl,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gênero: ${filme.genero}'),
                  Text('Ano: ${filme.ano}'),
                  Text('Faixa Etária: ${filme.faixaEtaria}'),
                  Text('Duração: ${filme.duracao} min'),
                  Text('Pontuação: ${filme.pontuacao}'),
                  const SizedBox(height: 8),
                  const Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(filme.descricao),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
