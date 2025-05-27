import '../models/filme.dart';
import '../database/db_helper.dart';

class FilmeController {
  final DBHelper _db = DBHelper();

  Future<List<Filme>> listarFilmes() async {
    return await _db.listarFilmes();
  }

  Future<void> inserirFilme(Filme filme) async {
    // Validação simples (poderia ser mais robusta)
    if (filme.titulo.isEmpty || filme.genero.isEmpty || filme.imagemUrl.isEmpty) {
      throw Exception('Título, gênero e imagem são obrigatórios.');
    }
    await _db.inserirFilme(filme);
  }

  Future<void> atualizarFilme(Filme filme) async {
    if (filme.id == null) throw Exception('ID do filme é necessário.');
    await _db.atualizarFilme(filme);
  }

  Future<void> deletarFilme(int id) async {
    await _db.deletarFilme(id);
  }
}
