
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mischwaldscore/pages/card.dart';
import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';
import 'package:provider/provider.dart';

class AddTreeDialog extends StatefulWidget {
  final TreeDecision decision;
  const AddTreeDialog(this.decision, {super.key});

  @override
  State<AddTreeDialog> createState() => _AddTreeDialogState();
}

class _AddTreeDialogState extends State<AddTreeDialog> {

  String errorString = "";

  @override
  Widget build(BuildContext context) {
    GameProvider gp = context.watch<GameProvider>();
    return AlertDialog(
      title: const Text("Neuer Baum"),
      actions: [
        OutlinedButton(onPressed: () {
          widget.decision.clear();
          Navigator.of(context).pop();
        }, child: const Text("Cancel")),
        OutlinedButton(onPressed: () {
          if(widget.decision.left.isNotEmpty && widget.decision.left.first == Cards.Reh.longname && widget.decision.leftPoints == 0){
            errorString = "Bitte beim Reh auf der linken Seite eine Punktzahl angeben.";
            setState(() {});
            return;
          }
          if(widget.decision.right.isNotEmpty && widget.decision.right.first == Cards.Reh.longname && widget.decision.rightPoints == 0){
            errorString = "Bitte beim Reh auf der rechten Seite eine Punktzahl angeben.";
            setState(() {});
            return;
          }
          gp.player[gp.activePlayer].addTree(widget.decision.createTree(), gp);
          widget.decision.clear();
          Navigator.of(context).pop();
        }, child: const Text("OK und noch ein Baum")),
        OutlinedButton(onPressed: () {
          if(widget.decision.left.isNotEmpty && widget.decision.left.first == Cards.Reh.longname && widget.decision.leftPoints == 0){
            errorString = "Bitte beim Reh auf der linken Seite eine Punktzahl angeben.";
            setState(() {});
            return;
          }
          if(widget.decision.right.isNotEmpty && widget.decision.right.first == Cards.Reh.longname && widget.decision.rightPoints == 0){
            errorString = "Bitte beim Reh auf der rechten Seite eine Punktzahl angeben.";
            setState(() {});
            return;
          }
          gp.player[gp.activePlayer].addTree(widget.decision.createTree(), gp);
          widget.decision.clear();
          showDialog(
              context: context,
              builder: (context) {
                return const HoehleWertenDialog();
              });
        }, child: const Text("OK und Fertig")),
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(errorString.isNotEmpty)
              Text(errorString),
            SizedBox(
                height: 250,
                width: 250,
                child: Card(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    childAspectRatio: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: [
                      const Text(" "),
                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeCardDialog(widget.decision.top.first, widget.decision.topAmount, 0, Pos.top, (card, amount, points) {
                                widget.decision.top = card == null ? [] : [card];
                                widget.decision.topAmount = amount;
                                context.read<GameProvider>().notify();
                                setState(() {});
                              });
                            }),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Center(
                          child: widget.decision.topAmount > 1
                              ? Text(widget.decision.top.isNotEmpty ? "${widget.decision.top.first}\n(${widget.decision.topAmount}x)" : " ")
                              : Text(widget.decision.top.isNotEmpty ? widget.decision.top.first : "/"),
                              ),
                        ),
                      ),
                    const Text(" "),

                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeCardDialog(widget.decision.left.first, widget.decision.leftAmount, widget.decision.leftPoints, Pos.left, (card, amount, points) {
                                widget.decision.left = card == null ? [] : [card];
                                widget.decision.leftAmount = amount;
                                widget.decision.leftPoints = points;
                                context.read<GameProvider>().notify();
                                setState(() {});
                              });
                            }),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Center(
                            child: widget.decision.leftAmount > 1
                                ? Text(widget.decision.left.isNotEmpty ? "${widget.decision.left.first}\n(${widget.decision.leftAmount}x)" : " ")
                            : widget.decision.leftPoints > 0
                              ? Text(widget.decision.left.isNotEmpty ? "${widget.decision.left.first}\n(${widget.decision.leftPoints})" : " ")
                                : Text(widget.decision.left.isNotEmpty ? widget.decision.left.first : "/"),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeCardDialog(widget.decision.mid.first, 1, 0, Pos.mid, (card, amount, points) {
                                widget.decision.mid = card == null ? [] : [card];
                                context.read<GameProvider>().notify();
                                setState(() {});
                              });
                            }),
                        child: Container(
                            color: Colors.green,
                            child: Center(
                                child: Text(widget.decision.mid.isNotEmpty
                                    ? widget.decision.mid.first
                                    : " "))),
                      ),

                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeCardDialog(widget.decision.right.first, widget.decision.rightAmount, widget.decision.rightPoints, Pos.right, (card, amount, points) {
                                widget.decision.right = card == null ? [] : [card];
                                widget.decision.rightAmount = amount;
                                widget.decision.rightPoints = points;
                                context.read<GameProvider>().notify();
                                setState(() {});
                              });
                            }),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Center(
                            child: widget.decision.rightAmount > 1
                                ? Text(widget.decision.right.isNotEmpty ? "${widget.decision.right.first}\n(${widget.decision.rightAmount}x)" : " ")
                                : widget.decision.rightPoints > 0
                                ? Text(widget.decision.right.isNotEmpty ? "${widget.decision.right.first}\n(${widget.decision.rightPoints})" : " ")
                                : Text(widget.decision.right.isNotEmpty ? widget.decision.right.first : "/"),
                          ),
                        ),
                      ),

                      const Text(" "),

                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeCardDialog(widget.decision.bottom.first, widget.decision.bottomAmount, 0, Pos.bottom, (card, amount, points) {
                                widget.decision.bottom = card == null ? [] : [card];
                                widget.decision.bottomAmount = amount;
                                context.read<GameProvider>().notify();
                                setState(() {});
                              });
                            }),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Center(
                            child: widget.decision.bottomAmount > 1
                                ? Text(widget.decision.bottom.isNotEmpty ? "${widget.decision.bottom.first}\n(${widget.decision.bottomAmount}x)" : " ")
                                : Text(widget.decision.bottom.isNotEmpty ? widget.decision.bottom.first : "/"),
                          ),
                        ),
                      ),

                      const Text(" "),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}



class ChangeCardDialog extends StatefulWidget {

  final String? card;
  final int amount;
  final int points;
  final Pos posFilter;
  final void Function(String? card, int amount, int points) callback;

  const ChangeCardDialog(this.card, this.amount, this.points, this.posFilter, this.callback, {super.key});

  @override
  State<ChangeCardDialog> createState() => _ChangeCardDialogState();
}

class _ChangeCardDialogState extends State<ChangeCardDialog> {

  final TextEditingController _textFieldControllerPunkte = TextEditingController();
  final TextEditingController _textFieldControllerAnzahl = TextEditingController();

  late List<String> list;
  late String dropdownValue;
  late String errorText = "";

  @override
  void initState() {
    super.initState();
    list = Cards.values.where((element) => element.pos.contains(widget.posFilter)).map((e) => e.longname).toList();
    dropdownValue = widget.card == null ? list.first : widget.card!;

    _textFieldControllerPunkte.text = widget.points.toString();
    _textFieldControllerAnzahl.text = widget.amount.toString();

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Karte ändern'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

       DropdownMenu<String>(
      initialSelection: dropdownValue,
        onSelected: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
            if(dropdownValue != Cards.Reh.longname || dropdownValue != Cards.Gaemse.longname){
              _textFieldControllerPunkte.text = "0";
            }
            if(dropdownValue != Cards.Feldhase.longname || dropdownValue != Cards.Erdkroete.longname){
              _textFieldControllerAnzahl.text = "1";
            }

          });
        },
        dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),

          if(errorText.isNotEmpty)
            Text(errorText, style: const TextStyle(color: Colors.red),),
          if(dropdownValue == Cards.Reh.longname || dropdownValue == Cards.Gaemse.longname)
            const Text("Bitte die Punkte von Hand auszählen."),
          if(dropdownValue == Cards.Reh.longname || dropdownValue == Cards.Gaemse.longname)
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              //
              controller: _textFieldControllerPunkte,
              decoration: const InputDecoration(hintText: "Punkte"),
            ),
          if(dropdownValue == Cards.Feldhase.longname || dropdownValue == Cards.Erdkroete.longname)
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              //
              controller: _textFieldControllerAnzahl,
              decoration: const InputDecoration(hintText: "Anzahl"),
            ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            widget.callback(null,0,0);
            Navigator.pop(context);
          },
        ),
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        OutlinedButton(
          child: const Text('OK'),
          onPressed: () {
            var amountNew = 1;
            var pointsNew = 0;
            try {
              amountNew = int.parse(_textFieldControllerAnzahl.text);
              if(amountNew == 0){
                errorText = "Bitte eine gültige Anzahl (> 0) eingeben.";
                setState(() {});
                return;
              }
            } catch(_) {
              errorText = "Bitte eine gültige Anzahl eingeben.";
              setState(() {});
              return;
            }
            try {
              pointsNew = int.parse(_textFieldControllerPunkte.text);
            } catch(_) {
              errorText = "Bitte eine gültige Punktzahl eingeben.";
              setState(() {});
              return;
            }
            widget.callback(dropdownValue,amountNew,pointsNew);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class HoehleWertenDialog extends StatefulWidget {

  const HoehleWertenDialog({super.key});

  @override
  State<HoehleWertenDialog> createState() => _HoehleWertenDialogState();
}

class _HoehleWertenDialogState extends State<HoehleWertenDialog> {

  final TextEditingController _textFieldControllerPunkte = TextEditingController();

  late String errorText = "";

  @override
  void initState() {
    super.initState();
    _textFieldControllerPunkte.text = context.read<GameProvider>().getActivePlayer()!.hoehlenPunkte.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Höhle werten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(errorText.isNotEmpty)
            Text(errorText, style: const TextStyle(color: Colors.red),),

            const Text("Wieviele Punkte liegen in der Höhle?"),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              //
              controller: _textFieldControllerPunkte,
              decoration: const InputDecoration(hintText: "Punkte"),
            ),
        ],
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
            var pointsNew = 0;
            try {
              pointsNew = int.parse(_textFieldControllerPunkte.text);
            } catch(_) {
              errorText = "Bitte eine gültige Punktzahl eingeben.";
              setState(() {});
              return;
            }
            var gp = context.read<GameProvider>();
            gp.getActivePlayer()!.hoehlenPunkte = pointsNew;
            gp.notify();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}







