import 'package:bible_wise_admin/models/comentario.dart';
import 'package:bible_wise_admin/provider/comentarios_provider.dart';
import 'package:bible_wise_admin/widgets/no_bg_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComentariosScreen extends StatefulWidget {
  const ComentariosScreen({super.key});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  late final ComentariosProvider _comentariosProvider;
  List<Comentario> _comentarios = [];
  Future<void> _update() async {
    _comentarios = await _comentariosProvider.getReportedComments();
    setState(() => _comentarios);
  }

  @override
  void initState() {
    _comentariosProvider = Provider.of<ComentariosProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _comentarios = await _comentariosProvider.getReportedComments();
    });
    super.initState();
  }

  String timeAgo(String isoDate) {
    final DateTime date = DateTime.parse(isoDate);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutos' : 'minuto'}';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours} ${difference.inHours > 1 ? 'horas' : 'hora'}';
    } else if (difference.inDays == 1) {
      return 'ontem';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return 'há $weeks ${weeks > 1 ? 'semanas' : 'semana'}';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return 'há $months ${months > 1 ? 'meses' : 'mês'}';
    } else {
      final int years = (difference.inDays / 365).floor();
      return 'há $years ${years > 1 ? 'anos' : 'ano'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentários'),
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => _update(),
        child: Consumer<ComentariosProvider>(
          builder: (context, value, _) {
            if(value.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if(_comentarios.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Nenhum comentário reportado ainda...', textAlign: TextAlign.center,),
                  IconButton(onPressed: () => _update(), icon: const Icon(Icons.refresh))
                ],
              );
            }

            return ListView.builder(
              itemCount: _comentarios.length,
              itemBuilder: (context, index) {
                final comentario = _comentarios[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onLongPress: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('Remover denúncia?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 1);
                                  _comentariosProvider.removeReport(reportId: comentario.reportId!);
                                  setState(() => _comentarios.removeAt(index));
                                },
                                child: const Text('Sim')
                            ),
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Não')),
                          ],
                        );
                      }).then((res) {
                        if(res == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Denúncia removida com sucesso!'),
                              )
                          );
                        }
                      });
                    },
                    child: Card(
                      color: Theme.of(context).cardColor,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const NoBgUser(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comentario.autor ?? '', style: const TextStyle(fontWeight: FontWeight.w700),),
                                        const SizedBox(height: 4),
                                        Text(comentario.comment ?? ''),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text('"${comentario.reportText!}"')),
                                  const SizedBox(width: 8),
                                  Text(timeAgo(comentario.createdAt!), style: const TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    child: Text(comentario.reportReason!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Remover comentário?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 1);
                                                  _comentariosProvider.removeComment(commentId: comentario.commentId!, devocionalId: comentario.devocionalId!);
                                                  setState(() => _comentarios.removeAt(index));
                                                  },
                                                child: const Text('Sim')
                                            ),
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Não')),
                                          ],
                                        );
                                      }).then((res) {
                                        if(res == 1) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Comentário removido com sucesso!'),
                                              )
                                          );
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white.withValues(alpha: .95),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                    ),
                                    child: const Row(
                                      children: [
                                        Text('Remover'),
                                        SizedBox(width: 4),
                                        Icon(Icons.delete, size: 18)
                                      ],
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          },
        ),
      ),
    );
  }
}
