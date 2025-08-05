import 'package:bible_wise_admin/screens/posts/rejected_reason_dialog.dart';
import 'package:bible_wise_admin/screens/posts/tab_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/devocional.dart';
import '../../provider/devocional_provider.dart';
import '../../widgets/expandable_container.dart';
import '../../widgets/frosted_container.dart';
import '../../widgets/no_bg_image.dart';
import '../../widgets/no_bg_user.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  late final DevocionalProvider devocionalProvider;
  int _selectedPage = 0;
  List<Devocional> _pendingDevocionais = [];
  List<Devocional> _rejectedDevocionais = [];
  List<Devocional> _toReviewDevocionais = [];
  Future<void> _update() async {
    if(_selectedPage == 0) {
      getPendingDevocionais();
    }else if(_selectedPage == 1) {
      getRejectedDevocionais();
    }else {
      getToReviewDevocionais();
    }
  }

  Future<void> getPendingDevocionais() async {
    _pendingDevocionais = await devocionalProvider.getPendingDevocionais();
    setState(() => _pendingDevocionais);
  }

  Future<void> getRejectedDevocionais() async {
    _rejectedDevocionais = await devocionalProvider.getRejectedDevocionais();
    setState(() => _rejectedDevocionais);
  }

  Future<void> getToReviewDevocionais() async {
    _toReviewDevocionais = await devocionalProvider.getToReviewDevocionais();
    setState(() => _toReviewDevocionais);
  }

  @override
  void initState() {
    devocionalProvider = Provider.of<DevocionalProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pendingDevocionais = await devocionalProvider.getPendingDevocionais();
      _rejectedDevocionais = await devocionalProvider.getRejectedDevocionais();
      _toReviewDevocionais = await devocionalProvider.getToReviewDevocionais();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => _update(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(12, 20, 12, 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(191, 170, 140, 1)
                ),
                child: TabBar(
                    controller: _tabController,
                    indicatorWeight: 3,
                    dividerColor: Colors.transparent,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    onTap: (index) {
                      setState(() => _selectedPage = index);
                    },
                    tabs: [
                      TabItem(title: 'Pendentes', count: _pendingDevocionais.length),
                      TabItem(title: 'Rejeitados', count: _rejectedDevocionais.length),
                      TabItem(title: 'Revisar', count: _toReviewDevocionais.length),
                    ]
                ),
              ),
            ),
            Consumer<DevocionalProvider>(
              builder: (context, value, _) {
                if (value.isLoading) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }

                if (_selectedPage == 0) {
                  if(_pendingDevocionais.isEmpty) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'Nenhum post para ser aprovado ainda...',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                                textAlign: TextAlign.center
                            ),
                            const SizedBox(height: 12),
                            IconButton(onPressed: () => getPendingDevocionais(), icon: const Icon(Icons.refresh, size: 32))
                          ],
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _pendingDevocionais.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final devocional = _pendingDevocionais[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              PostContainer(devocional: devocional, update: () => _update()),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }else if(_selectedPage == 1) {
                  if(_rejectedDevocionais.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Nenhum post rejeitado ainda...',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 12),
                          IconButton(onPressed: () => getRejectedDevocionais(), icon: const Icon(Icons.refresh, size: 32))
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _rejectedDevocionais.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final devocional = _rejectedDevocionais[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              RejectedPostContainer(devocional: devocional, update: () => _update()),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }else if(_selectedPage == 2) {
                  if(_toReviewDevocionais.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Nenhum post rejeitado pediu review ainda...',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 12),
                          IconButton(onPressed: () => getRejectedDevocionais(), icon: const Icon(Icons.refresh, size: 32))
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _toReviewDevocionais.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final devocional = _toReviewDevocionais[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              RejectedPostContainer(devocional: devocional, update: () => _update()),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Argumento: '),
                                    Expanded(
                                      child: Text(devocional.argument ?? ''),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Não foi possível recuperar os posts...',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center
                      ),
                      const SizedBox(height: 12),
                      IconButton(onPressed: () => _update(), icon: const Icon(Icons.refresh, size: 32))
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class PostContainer extends StatefulWidget {
  final Devocional devocional;
  final Function() update;
  const PostContainer({super.key, required this.devocional, required this.update});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> with SingleTickerProviderStateMixin {
  String todayDate = '';
  late DevocionalProvider devocionalProvider;

  String formattedDate({required String dateString}) {
    final createdAt = DateTime.parse(dateString);
    String day = createdAt.day < 10 ? '0${createdAt.day}' : createdAt.day.toString();
    String month = createdAt.month < 10 ? '0${createdAt.month}' : createdAt.month.toString();
    int year = createdAt.year;

    return '$day/$month/$year';
  }

  @override
  void initState() {
    devocionalProvider = Provider.of<DevocionalProvider>(context, listen: false);
    todayDate = formattedDate(dateString: widget.devocional.createdAt!);
    super.initState();
  }

  Widget iconInfo({required Widget icon, required String text}) => Column(
    children: [
      icon,
      const SizedBox(height: 4),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );

  Widget heartIcon({required IconData icon, required Color color}) => Icon(
    icon,
    color: color,
    size: 21,
  );

  Widget bgImagem() => Container(
    height: 250,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
            colorFilter: (widget.devocional.hasFrost ?? false)
                ? ColorFilter.mode(Colors.black.withValues(alpha: 0.45), BlendMode.darken)
                : null,
            fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.devocional.bgImagem!)
        )
    ),
    child: (widget.devocional.hasFrost ?? false)
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FrostedContainer(title: widget.devocional.titulo!),
    ) : const SizedBox(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.brown,
          boxShadow: kElevationToShadow[1]
      ),
      child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                    onTap: (() {
                      Navigator.pushNamed(
                          context, 'devocional_selected',
                          arguments: {"devocional": widget.devocional}
                      );
                    }),
                    child: (widget.devocional.bgImagem != null && widget.devocional.bgImagem!.isNotEmpty)
                        ? bgImagem()
                        : NoBgImage(title: widget.devocional.titulo!)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: ExpandableContainer(
                    header: widget.devocional.titulo!,
                    expandedText: widget.devocional.plainText!,
                    devocional: widget.devocional,
                    verCompleto: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        (widget.devocional.bgImagemUser != null && widget.devocional.bgImagemUser!.isNotEmpty)
                            ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(widget.devocional.bgImagemUser!,)
                              )
                          ),
                        )
                            : const NoBgUser(),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: constraints.maxWidth * .5,
                                child: Text(widget.devocional.nomeAutor!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.white, fontSize: 12))
                            ),
                            const SizedBox(height: 8),
                            Text('Em $todayDate', style: const TextStyle(color: Colors.white, fontSize: 10))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.chat_bubble,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.heart_fill, color: Colors.red,),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(
                        onPressed: () {
                          devocionalProvider.sendPostApprovedNotification(devocionalId: widget.devocional.id!, ownerId: widget.devocional.ownerId!, title: widget.devocional.titulo!);
                          devocionalProvider.updateUserData(widget.devocional.id!, {"status": 0}).whenComplete(() => widget.update());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Aprovar'),
                            SizedBox(width: 4),
                            Icon(Icons.check, size: 18)
                          ],
                        ))
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => RejectedReasonDialog(devocionalId: widget.devocional.id!,)
                        ).then((res) {
                          if(res ?? false) {
                            widget.update();
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Rejeitar'),
                            SizedBox(width: 4),
                            Icon(Icons.close, size: 18)
                          ],
                        ))
                    ),
                  ],
                )
              ],
            );
          }
      ),
    );
  }
}

class RejectedPostContainer extends StatefulWidget {
  final Devocional devocional;
  final Function() update;
  const RejectedPostContainer({super.key, required this.devocional, required this.update});

  @override
  State<RejectedPostContainer> createState() => _RejectedPostContainerState();
}

class _RejectedPostContainerState extends State<RejectedPostContainer> with SingleTickerProviderStateMixin {
  String todayDate = '';
  late DevocionalProvider devocionalProvider;

  String formattedDate({required String dateString}) {
    final createdAt = DateTime.parse(dateString);
    String day = createdAt.day < 10 ? '0${createdAt.day}' : createdAt.day.toString();
    String month = createdAt.month < 10 ? '0${createdAt.month}' : createdAt.month.toString();
    int year = createdAt.year;

    return '$day/$month/$year';
  }

  @override
  void initState() {
    devocionalProvider = Provider.of<DevocionalProvider>(context, listen: false);
    todayDate = formattedDate(dateString: widget.devocional.createdAt!);
    super.initState();
  }

  Widget iconInfo({required Widget icon, required String text}) => Column(
    children: [
      icon,
      const SizedBox(height: 4),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );

  Widget heartIcon({required IconData icon, required Color color}) => Icon(
    icon,
    color: color,
    size: 21,
  );

  Widget bgImagem() => Container(
    height: 250,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
            colorFilter: (widget.devocional.hasFrost ?? false)
                ? ColorFilter.mode(Colors.black.withValues(alpha: 0.45), BlendMode.darken)
                : null,
            fit: BoxFit.cover, image: CachedNetworkImageProvider(widget.devocional.bgImagem!)
        )
    ),
    child: (widget.devocional.hasFrost ?? false)
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FrostedContainer(title: widget.devocional.titulo!),
    ) : const SizedBox(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.brown,
          boxShadow: kElevationToShadow[1]
      ),
      child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                    onTap: (() {
                      Navigator.pushNamed(
                          context, 'devocional_selected',
                          arguments: {"devocional": widget.devocional}
                      );
                    }),
                    child: (widget.devocional.bgImagem != null && widget.devocional.bgImagem!.isNotEmpty)
                        ? bgImagem()
                        : NoBgImage(title: widget.devocional.titulo!)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: ExpandableContainer(
                    header: widget.devocional.titulo!,
                    expandedText: widget.devocional.plainText!,
                    devocional: widget.devocional,
                    verCompleto: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        (widget.devocional.bgImagemUser != null && widget.devocional.bgImagemUser!.isNotEmpty)
                            ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(widget.devocional.bgImagemUser!,)
                              )
                          ),
                        )
                            : const NoBgUser(),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: constraints.maxWidth * .5,
                                child: Text(widget.devocional.nomeAutor!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.white, fontSize: 12))
                            ),
                            const SizedBox(height: 8),
                            Text('Em $todayDate', style: const TextStyle(color: Colors.white, fontSize: 10))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.chat_bubble,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.heart_fill, color: Colors.red,),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(
                        onPressed: () => devocionalProvider.updateUserData(widget.devocional.id!, {"status": 0}).whenComplete(() => widget.update()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Aprovar'),
                            SizedBox(width: 4),
                            Icon(Icons.check, size: 18)
                          ],
                        ))
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton(
                        onPressed: () => devocionalProvider.deleteDevocional(devocionalId: widget.devocional.id!).whenComplete(() => widget.update()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Excluir'),
                            SizedBox(width: 4),
                            Icon(Icons.delete, size: 18)
                          ],
                        ))
                    ),
                  ],
                )
              ],
            );
          }
      ),
    );
  }
}