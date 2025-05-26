class Filme {
  int? id;
  String imagemUrl;
  String titulo;
  String genero;
  String faixaEtaria;
  int duracao; // em minutos
  double pontuacao;
  String descricao;
  int ano;

  Filme({
    this.id,
    required this.imagemUrl,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
  });

  // Converte Filme para Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagemUrl': imagemUrl,
      'titulo': titulo,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'pontuacao': pontuacao,
      'descricao': descricao,
      'ano': ano,
    };
  }

  // Construtor a partir de um Map
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      imagemUrl: map['imagemUrl'],
      titulo: map['titulo'],
      genero: map['genero'],
      faixaEtaria: map['faixaEtaria'],
      duracao: map['duracao'],
      pontuacao: map['pontuacao'],
      descricao: map['descricao'],
      ano: map['ano'],
    );
  }
}
