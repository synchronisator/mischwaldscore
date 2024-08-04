import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mischwaldscore/pages/add_dialog.dart';
import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/pages/text_recognizer_view.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';
import 'package:mischwaldscore/provider/player.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _textFieldControllerHoehle =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Player? player = context.watch<GameProvider>().getActivePlayer();
    return Scaffold(
      appBar: AppBar(
        title: player == null
            ? const Text("ungültiger Spieler")
            : Text("${player.name} - ${player.getGesamtpunktzahl()} Punkte"),
      ),
      body: SafeArea(
        child: player == null
            ? const Text("Kein gültiger Spieler gewählt.")
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<TextRecognizerView>(
                              builder: (BuildContext context) =>
                                  TextRecognizerView(player),
                            )),
                        icon: const Icon(Icons.camera_alt)),
                    Row(
                      children: [
                        Text("Höhle: ${player.hoehlenPunkte} Punkte"),
                        IconButton(
                            onPressed: () => _displayTextInputDialog(context)
                                .then((value) => setState(() {})),
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: const <Widget>[
                        Tab(
                          icon: Icon(Icons.forest_rounded),
                        ),
                        Tab(
                          icon: Icon(Icons.list),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          Center(
                            child: player.trees.isEmpty
                                ? const Text("Bisher keine Bäume eingegeben.")
                                : TreeView(player: player),
                          ),
                          CardTableView(player: player),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    _textFieldControllerHoehle.text = context
            .read<GameProvider>()
            .getActivePlayer()
            ?.hoehlenPunkte
            .toString() ??
        "0";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Höhlenpunkte'),
          content: TextField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            //
            controller: _textFieldControllerHoehle,
            decoration: const InputDecoration(hintText: "Punkte"),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              child: const Text('OK'),
              onPressed: () {
                context.read<GameProvider>().getActivePlayer()?.hoehlenPunkte =
                    _textFieldControllerHoehle.text.isEmpty
                        ? 0
                        : int.parse(_textFieldControllerHoehle.text);
                context.read<GameProvider>().recalcPoints();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class CardTableView extends StatelessWidget {
  const CardTableView({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Icon(Icons.description),
              ),
            ),
            DataColumn(
              label: Icon(Icons.numbers),
            ),
            DataColumn(label: Icon(Icons.control_point)),
            DataColumn(label: Icon(Icons.control_point_duplicate_sharp)),
          ],
          rows: <DataRow>[
            for (String key in player.karteAnzahl.keys)
              if (player.karteAnzahl[key]! > 0)
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(key)),
                    DataCell(SizedBox(
                        width: 25,
                        child: Text(player.karteAnzahl[key]!.toString()))),
                    DataCell(SizedBox(
                        width: 25,
                        child: Text(player.kartePunkte[key]!.toString()))),
                    DataCell(SizedBox(
                        width: 25,
                        child: CardsExtension.asMap()[key]!
                                .typen
                                .contains(Typen.Schmetterling)
                            ? Text(player.kartePunkteGesamt["Schmetterlinge"]!
                                .toString())
                            : Text(player.kartePunkteGesamt[key]!.toString()))),
                  ],
                ),
          ],
        ),
      ),
    );

    // return ListView.builder(
    //     itemCount: player.karteAnzahl.keys.length,
    //     itemBuilder: (context, index) {
    //       String key = player.karteAnzahl.keys.elementAt(index);
    //       if(player.karteAnzahl[key] == 0) return const SizedBox.shrink();
    //       return ListTile(
    //         title: Text(key),
    //         subtitle: Text("${player.karteAnzahl[key]} Karten á ${player.kartePunkte[key]}  = ${player.kartePunkteGesamt[key]} Punkte"),
    //       );
    //     },
    // );
  }
}

class TreeView extends StatelessWidget {
  const TreeView({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (final (index, tree) in player.trees.indexed)
        Card(
          child: SizedBox(
            height: 130,
            child: GridView.count(
              padding: EdgeInsets.zero,
              childAspectRatio: 3 / 1,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: [
                Text("Baum #${index + 1}"),
                InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeCardDialog(
                            tree.top, tree.topAmount, 0, Pos.top,
                            (card, amount, points) {
                          if (card != tree.top) {
                            player.replaceCards(tree.top, card);
                          }
                          tree.top = card;
                          tree.topAmount = amount;
                          context.read<GameProvider>().recalcPoints();
                        });
                      }),
                  child: tree.topAmount > 1
                      ? Center(
                          child: Text(tree.top != null
                              ? "${tree.top!}\n(${tree.topAmount}x)"
                              : ""),
                        )
                      : Center(
                          child: Text(tree.top != null ? tree.top! : ""),
                        ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: SizedBox.square(
                      dimension: 50,
                      child: FittedBox(
                        child: IconButton(
                          onPressed: () {
                            context.read<GameProvider>().removeTree(tree);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    )),
                InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeCardDialog(tree.left, tree.leftAmount,
                            tree.leftPoints, Pos.left, (card, amount, points) {
                          if (card != tree.left) {
                            player.replaceCards(tree.left, card);
                          }
                          tree.left = card;
                          tree.leftAmount = amount;
                          tree.leftPoints = points;
                          context.read<GameProvider>().recalcPoints();
                        });
                      }),
                  child: tree.leftAmount > 1
                      ? Center(
                          child: Text(tree.left != null
                              ? "${tree.left!}\n(${tree.leftAmount}x)"
                              : ""),
                        )
                      : tree.leftPoints > 0
                          ? Center(
                              child: Text(tree.left != null
                                  ? "${tree.left!}\n(${tree.leftPoints})"
                                  : ""),
                            )
                          : Center(
                              child: Text(tree.left != null ? tree.left! : ""),
                            ),
                ),
                InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeCardDialog(tree.mid, 1, 0, Pos.mid,
                            (card, amount, points) {
                          if (card != tree.mid) {
                            player.replaceCards(tree.mid, card);
                          }
                          tree.mid = card;
                          context.read<GameProvider>().recalcPoints();
                        });
                      }),
                  child: Container(
                      color: Colors.green,
                      child: Center(
                          child: Text(tree.mid != null ? tree.mid! : ""))),
                ),
                InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeCardDialog(
                            tree.right,
                            tree.rightAmount,
                            tree.rightPoints,
                            Pos.right, (card, amount, points) {
                          if (card != tree.right) {
                            player.replaceCards(tree.right, card);
                          }
                          tree.right = card;
                          tree.rightAmount = amount;
                          tree.rightPoints = points;
                          context.read<GameProvider>().recalcPoints();
                        });
                      }),
                  child: tree.rightAmount > 1
                      ? Center(
                          child: Text(tree.right != null
                              ? "${tree.right!}\n(${tree.rightAmount}x)"
                              : ""),
                        )
                      : tree.rightPoints > 0
                          ? Center(
                              child: Text(tree.right != null
                                  ? "${tree.right!}\n(${tree.rightPoints})"
                                  : ""),
                            )
                          : Center(
                              child:
                                  Text(tree.right != null ? tree.right! : ""),
                            ),
                ),
                const Text(""),
                InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeCardDialog(
                            tree.bottom, tree.bottomAmount, 0, Pos.bottom,
                            (card, amount, points) {
                          if (card != tree.bottom) {
                            player.replaceCards(tree.bottom, card);
                          }
                          tree.bottom = card;
                          tree.bottomAmount = amount;
                          context.read<GameProvider>().recalcPoints();
                        });
                      }),
                  child: tree.bottomAmount > 1
                      ? Center(
                          child: Text(tree.bottom != null
                              ? "${tree.bottom!}\n(${tree.bottomAmount}x)"
                              : ""),
                        )
                      : Center(
                          child: Text(tree.bottom != null ? tree.bottom! : ""),
                        ),
                ),
                const Text(""),
              ],
            ),
          ),
        ),
    ]);
  }
}
