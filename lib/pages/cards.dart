// ignore_for_file: constant_identifier_names

import 'package:mischwaldscore/pages/card.dart';
import 'package:mischwaldscore/provider/player.dart';

enum Typen {
  Alpin,
  Amphibie,
  Baum,
  Fledermaus,
  Hirsch,
  Insekt,
  Paarhufer,
  Pflanze,
  Pfotentier,
  Pilz,
  Schmetterling,
  Vogel,
}

enum Pos { top, bottom, left, right, mid }

enum Cards {
  Baumsproessling("Baumsprössling", [Typen.Baum], [Pos.mid]),
  Ahorn("Ahorn", [Typen.Baum], [Pos.mid]),
  Alpen_Apollofalter("Alpen-Apollofalter", [Typen.Alpin,Typen.Insekt,Typen.Schmetterling], [Pos.top]),
  Alpenfledermaus("Alpenfledermaus", [], [Pos.left, Pos.right]), // TODO Typen
  Alpenmurmeltier("Alpenmurmeltier", [Typen.Alpin, Typen.Pfotentier], [Pos.left, Pos.right]),
  Auerhuhn("Auerhuhn", [], [Pos.left, Pos.right]), // TODO Typen
  Bartgeier("Bartgeier", [], [Pos.top]), // TODO Typen
  Baumfarn("Baumfarn", [Typen.Pflanze], [Pos.bottom]),
  Bechsteinfledermaus(
      "Bechsteinfledermaus", [Typen.Fledermaus], [Pos.left, Pos.right]),
  Bergmolch("Bergmolch", [], [Pos.bottom]), // TODO Typen
  Birke("Birke", [Typen.Baum], [Pos.mid]),
  Braunbaer("Braunbär", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Braunes_Langohr("Braunes Langohr", [Typen.Fledermaus], [Pos.left, Pos.right]),
  Braunkehlchen("Braunkehlchen", [], [Pos.top]), // TODO Typen
  Brombeeren("Brombeeren", [Typen.Pflanze], [Pos.bottom]),
  Buche("Buche", [Typen.Baum], [Pos.mid]),
  Buchfink("Buchfink", [Typen.Vogel], [Pos.top]),
  Buntspecht("Buntspecht", [Typen.Vogel], [Pos.top]),
  Dachs("Dachs", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Damhirsch(
      "Damhirsch", [Typen.Paarhufer, Typen.Hirsch], [Pos.left, Pos.right]),
  Douglasie("Douglasie", [Typen.Baum], [Pos.mid]),
  Edelweiss("Edelweiß", [], [Pos.bottom]), // TODO Typen
  Eiche("Eiche", [Typen.Baum], [Pos.mid]),
  Eichelhaeher("Eichelhäher", [Typen.Vogel], [Pos.top]),
  Eichhoernchen("Eichhörnchen", [Typen.Pfotentier], [Pos.top]),
  Enzian("Enzian", [Typen.Alpin, Typen.Pflanze], [Pos.bottom]),
  Erdkroete("Erdkröte", [Typen.Amphibie], [Pos.bottom]),
  Europaeische_Laerche("Europäische Lärche", [Typen.Alpin, Typen.Baum], [Pos.mid]),
  Feldhase("Feldhase", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Feuersalamander("Feuersalamander", [Typen.Amphibie], [Pos.bottom]),
  Fliegenpilz("Fliegenpilz", [Typen.Pilz], [Pos.bottom]),
  Frischling("Frischling", [Typen.Paarhufer], [Pos.left, Pos.right]),
  Fuchs("Fuchs", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Gaemse("Gämse", [Typen.Alpin, Typen.Paarhufer], [Pos.left, Pos.right]),
  Gimpel("Gimpel", [Typen.Vogel], [Pos.top]),
  Gluehwuermchen("Glühwürmchen", [Typen.Insekt], [Pos.bottom]),
  Grosser_Fuchs("Großer Fuchs", [Typen.Insekt, Typen.Schmetterling], [Pos.top]),
  Habicht("Habicht", [Typen.Vogel], [Pos.top]),
  Heidelbeere("Heidelbeere", [Typen.Alpin, Typen.Pflanze], [Pos.bottom]),
  Herbsttrompete("Herbsttrompete", [], [Pos.bottom]), // TODO Typen
  Hirschkaefer("Hirschkäfer", [Typen.Insekt], [Pos.bottom]),
  Holzbiene("Holzbiene", [Typen.Insekt], [Pos.left, Pos.right]),
  Hufeisennase("Hufeisennase", [Typen.Fledermaus], [Pos.left, Pos.right]),
  Igel("Igel", [Typen.Pfotentier], [Pos.bottom]),
  Kaisermantel("Kaisermantel", [Typen.Insekt, Typen.Schmetterling], [Pos.top]),
  Kastanie("Kastanie", [Typen.Baum], [Pos.mid]),
  Kolkrabe("Kolkrabe", [], [Pos.top]), // TODO Typen
  Laubfrosch("Laubfrosch", [Typen.Amphibie], [Pos.bottom]),
  Linde("Linde", [Typen.Baum], [Pos.mid]),
  Luchs("Luchs", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Maulwurf("Maulwurf", [Typen.Pfotentier], [Pos.bottom]),
  Moorbirke("Moorbirke", [Typen.Baum], [Pos.mid]), // TODO
  Moos("Moos", [Typen.Pflanze], [Pos.bottom]),
  Mopsfledermaus("Mopsfledermaus", [Typen.Fledermaus], [Pos.left, Pos.right]),
  Parasol("Parasol", [Typen.Pilz], [Pos.bottom]),
  Pfifferling("Pfifferling", [Typen.Pilz], [Pos.bottom]),
  Reh("Reh", [Typen.Paarhufer, Typen.Hirsch], [Pos.left, Pos.right]),
  Rothirsch(
      "Rothirsch", [Typen.Hirsch, Typen.Paarhufer], [Pos.left, Pos.right]),
  Schillerfalter(
      "Schillerfalter", [Typen.Insekt, Typen.Schmetterling], [Pos.top]),
  Schneehase("Schneehase", [], [Pos.left, Pos.right]), // TODO Typen
  Siebenschlaefer("Siebenschläfer", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Stechmuecke("Stechmücke", [Typen.Insekt], [Pos.left, Pos.right]),
  Steinadler("Steinadler", [Typen.Alpin, Typen.Vogel], [Pos.top]),
  Steinbock("Steinbock", [Typen.Alpin, Typen.Paarhufer], [Pos.left, Pos.right]),
  Steinmarder("Steinmarder", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Steinpilz("Steinpilz", [Typen.Pilz], [Pos.bottom]),
  Sumpfschildkroete("Sumpfschildkröte", [Typen.Amphibie], [Pos.bottom]),
  Tagpfauenauge(
      "Tagpfauenauge", [Typen.Insekt, Typen.Schmetterling], [Pos.top]),
  Tanne("Tanne", [Typen.Baum], [Pos.mid]),
  Trauermantel("Trauermantel", [Typen.Insekt, Typen.Schmetterling], [Pos.top]),
  Waldameise("Waldameise", [Typen.Insekt], [Pos.bottom]),
  Walderdbeeren("Walderdbeeren", [Typen.Pflanze], [Pos.bottom]),
  Waldkauz("Waldkauz", [Typen.Vogel], [Pos.top]),
  Waschbaer("Waschbär", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Wildschwein("Wildschwein", [Typen.Paarhufer], [Pos.left, Pos.right]),
  Wolf("Wolf", [Typen.Pfotentier], [Pos.left, Pos.right]),
  Zirbelkiefer("Zirbelkiefer", [Typen.Alpin, Typen.Baum], [Pos.mid]);

  final String longname;
  final List<Typen> typen;
  final List<Pos> pos;

  const Cards(this.longname, this.typen, this.pos);
}

extension CardsExtension on Cards {
  static Map<String, Cards>? _map;

  static Map<String, Cards> asMap() {
    _map ??= Cards.values
        .asMap()
        .map((key, value) => MapEntry(value.longname, value));
    return _map!;
  }

  int getPoints(Tree tree, Player player, List<String> allCards) {
    switch (this) {
      case Cards.Baumsproessling:
        return 0;
      case Cards.Ahorn:
        return player.trees.length;
      case Cards.Alpen_Apollofalter:
        return 0; // Schmetterling
      case Cards.Alpenfledermaus:
        return player.typenUnique[Typen.Fledermaus]!.length >= 3 ? 5 : 0;
      case Cards.Alpenmurmeltier:
        return player.typenUnique[Typen.Pflanze]!.length * 3;
      case Cards.Auerhuhn:
        return player.typenAnzahl[Typen.Pflanze]!;
      case Cards.Bartgeier:
        return player.hoehlenPunkte;
      case Cards.Baumfarn:
        return player.typenAnzahl[Typen.Amphibie]! * 6;
      case Cards.Bechsteinfledermaus:
        return player.typenUnique[Typen.Fledermaus]!.length >= 3 ? 5 : 0;
      case Cards.Bergmolch:
        return player.typenAnzahl[Typen.Insekt]! * 2;
      case Cards.Birke:
        return 1;
      case Cards.Braunbaer:
        return 0; // siehe Höhle
      case Cards.Braunes_Langohr:
        return player.typenUnique[Typen.Fledermaus]!.length >= 3 ? 5 : 0;
      case Cards.Braunkehlchen:
        return player.typenAnzahl[Typen.Pflanze]!;
      case Cards.Brombeeren:
        return player.typenAnzahl[Typen.Pflanze]! * 2;
      case Cards.Buche:
        return 0; // nicht einzeln zu werten
      case Cards.Buchfink:
        return (tree.mid == "Buche") ? 5 : 0;
      case Cards.Buntspecht:
        return 0; // nicht einzeln zu werten
      case Cards.Dachs:
        return 2;
      case Cards.Damhirsch:
        return player.typenAnzahl[Typen.Paarhufer]! * 3;
      case Cards.Douglasie:
        return 5;
      case Cards.Edelweiss:
        return 3;
      case Cards.Eiche:
        return player.typenUnique[Typen.Baum]!.length >= 8 ? 10 : 0;
      case Cards.Eichelhaeher:
        return 3;
      case Cards.Eichhoernchen:
        return (tree.mid == "Eiche") ? 5 : 0;
      case Cards.Enzian:
        return player.typenAnzahl[Typen.Schmetterling]! * 3;
      case Cards.Erdkroete:
        return tree.bottomAmount == 2 ? 5 : 0;
      case Cards.Europaeische_Laerche:
        return 3;
      case Cards.Feldhase:
        return allCards
            .where(
                (element) => element == "Feldhase" || element == "Schneehase")
            .toList()
            .length;
      case Cards.Feuersalamander:
        return 0;
      case Cards.Fliegenpilz:
        return 0;
      case Cards.Frischling:
        return 1;
      case Cards.Fuchs:
        return allCards
                .where((element) => element == "Feldhase")
                .toList()
                .length *
            2;
      case Cards.Gaemse:
        return 0; // händische Wertung
      case Cards.Gimpel:
        return player.typenAnzahl[Typen.Insekt]! * 2;
      case Cards.Gluehwuermchen:
        return 0;
      case Cards.Grosser_Fuchs:
        return 0; // Schmetterling
      case Cards.Habicht:
        return player.typenAnzahl[Typen.Vogel]! * 3;
      case Cards.Heidelbeere:
        return player.typenUnique[Typen.Vogel]!.length * 2;
      case Cards.Herbsttrompete:
        return 0;
      case Cards.Hirschkaefer:
        return player.typenAnzahl[Typen.Pfotentier]! * 3;
      case Cards.Holzbiene:
        return 0;
      case Cards.Hufeisennase:
        return player.typenUnique[Typen.Fledermaus]!.length >= 3 ? 5 : 0;
      case Cards.Igel:
        return player.typenAnzahl[Typen.Schmetterling]! * 2;
      case Cards.Kaisermantel:
        return 0; // Schmetterling
      case Cards.Kastanie:
        return 0;
      case Cards.Kolkrabe:
        return 5;
      case Cards.Laubfrosch:
        return allCards
                .where((element) => element == "Stechmücke")
                .toList()
                .length *
            5;
      case Cards.Linde:
        return 1;
      case Cards.Luchs:
        return allCards.where((element) => element == "Reh").toList().isNotEmpty
            ? 10
            : 0;
      case Cards.Maulwurf:
        return 0;
      case Cards.Moorbirke:
        return 1; //TODO
      case Cards.Moos:
        return (player.typenAnzahl[Typen.Baum]! +
                    player.karteAnzahl[Cards.Holzbiene.longname]!) >=
                10
            ? 10
            : 0;
      case Cards.Mopsfledermaus:
        return player.typenUnique[Typen.Fledermaus]!.length >= 3 ? 5 : 0;
      case Cards.Parasol:
        return 0;
      case Cards.Pfifferling:
        return 0;
      case Cards.Reh:
        return 0; // nicht einzeln werten
      case Cards.Rothirsch:
        return player.typenAnzahl[Typen.Baum]! +
            player.typenAnzahl[Typen.Pflanze]!;
      case Cards.Schillerfalter:
        return 0; // Schmetterling
      case Cards.Schneehase:
        return allCards
            .where(
                (element) => element == "Feldhase" || element == "Schneehase")
            .toList()
            .length;
      case Cards.Siebenschlaefer:
        return CardsExtension.asMap()[tree.left]!
                    .typen
                    .contains(Typen.Fledermaus) ||
                CardsExtension.asMap()[tree.right]!
                    .typen
                    .contains(Typen.Fledermaus)
            ? 15
            : 0;
      case Cards.Stechmuecke:
        return player.typenAnzahl[Typen.Fledermaus]!;
      case Cards.Steinadler:
        return player.typenAnzahl[Typen.Pfotentier]! +
            player.typenAnzahl[Typen.Amphibie]!;
      case Cards.Steinbock:
        return 10;
      case Cards.Steinmarder:
        return player.trees
            .where((element) => element.isKomplett())
            .toList()
            .length * 5;
      case Cards.Steinpilz:
        return 0;
      case Cards.Sumpfschildkroete:
        return 5;
      case Cards.Tagpfauenauge:
        return 0; // Schmetterling
      case Cards.Tanne:
        return (tree.getCards().length - 1) * 2;
      case Cards.Trauermantel:
        return 0; // Schmetterling
      case Cards.Waldameise:
        int pointsWaldameise = 0;
        for (var element in player.trees) {
          if (element.bottom != null) {
            pointsWaldameise += 2;
          }
        }
        return pointsWaldameise;
      case Cards.Walderdbeeren:
        return player.typenUnique[Typen.Baum]!.length >= 8 ? 10 : 0;
      case Cards.Waldkauz:
        return 5;
      case Cards.Waschbaer:
        return 0; // Höhle
      case Cards.Wildschwein:
        return allCards.contains("Frischling") ? 10 : 0;
      case Cards.Wolf:
        return player.typenAnzahl[Typen.Hirsch]! * 5;
      case Cards.Zirbelkiefer:
        return player.typenAnzahl[Typen.Alpin]!;
    }
  }
}
