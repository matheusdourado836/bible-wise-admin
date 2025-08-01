class Devocional {
  String? id;
  String? ownerId;
  String? contactEmail;
  String? createdAt;
  String? titulo;
  List<dynamic>? styles;
  String? plainText;
  String? nomeAutor;
  String? bgImagem;
  String? bgImagemUser;
  bool? hasFrost;
  int? status;
  int? qtdComentarios;
  int? qtdCurtidas;
  int? qtdViews;
  bool? public;
  String? argument;

  Devocional(
      {this.id,
        this.ownerId,
        this.contactEmail,
        this.createdAt,
        this.titulo,
        this.styles,
        this.plainText,
        this.nomeAutor,
        this.bgImagem,
        this.bgImagemUser,
        this.hasFrost,
        this.status,
        this.qtdComentarios,
        this.qtdCurtidas,
        this.qtdViews,
        this.public,
        this.argument
      });

  Devocional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    contactEmail = json['contactEmail'];
    createdAt = json['createdAt'];
    titulo = json['titulo'];
    styles = json['styles'];
    plainText = json['plainText'];
    nomeAutor = json['nomeAutor'];
    bgImagem = json['bgImagem'];
    bgImagemUser = json['bgImagemUser'];
    hasFrost = json['hasFrost'];
    status = json['status'];
    qtdComentarios = json['qtdComentarios'];
    qtdCurtidas = json['qtdCurtidas'];
    qtdViews = json['qtdViews'];
    public = json["public"];
    argument = json["argument"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['contactEmail'] = contactEmail;
    data['createdAt'] = createdAt;
    data['titulo'] = titulo;
    data['styles'] = styles;
    data['plainText'] = plainText;
    data['bgImagem'] = bgImagem;
    data['nomeAutor'] = nomeAutor;
    data['bgImagemUser'] = bgImagemUser;
    data['hasFrost'] = hasFrost;
    data['status'] = status;
    data['qtdComentarios'] = qtdComentarios;
    data['qtdCurtidas'] = qtdCurtidas;
    data['qtdViews'] = qtdViews;
    data["public"] = public;
    data["argument"] = argument;
    return data;
  }
}