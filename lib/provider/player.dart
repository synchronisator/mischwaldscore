import 'package:mischwaldscore/pages/card.dart';
import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';

class Player {
  String name;
  int ergebnisPunkte = 0;
  int hoehlenPunkte = 0;
  
  List<Tree> trees = [];

  Map<Typen, int> typenAnzahl = {};
  Map<Typen, Set<String>> typenUnique = {};
  Map<String, int> karteAnzahl = {};
  Map<String, int> kartePunkte = {};
  Map<String, int> kartePunkteGesamt = {};


  Player(this.name){
    for (var e in Cards.values) {
      karteAnzahl.putIfAbsent(e.longname, () => 0);
      kartePunkte.putIfAbsent(e.longname, () => 0);
      kartePunkteGesamt.putIfAbsent(e.longname, () => 0);
    }
    for (var e in Typen.values) {
      typenAnzahl.putIfAbsent(e, () => 0);
      typenUnique.putIfAbsent(e, () => {});
    }
  }
  
  int getGesamtpunktzahl(){
    return ergebnisPunkte + hoehlenPunkte;
  }

  void addTree(Tree t, GameProvider gameprovider){
    trees.add(t);
    t.getCards().forEach((card) {
      karteAnzahl[card] = karteAnzahl[card]! + 1;
      for (var typ in CardsExtension.asMap()[card]!.typen) {
        typenAnzahl[typ] = typenAnzahl[typ]! + 1;
        typenUnique[typ]!.add(card);
      }
    });

    // typenAnzahl.forEach((key, value) {print("$key => $value");});
    // typenUnique.forEach((key, value) {print("$key => $value");});
    // karteAnzahl.forEach((key, value) {print("$key => $value");});
    // kartePunkte.forEach((key, value) {print("$key => $value");});

    calcPoints(gameprovider);
  }

  void calcPoints(GameProvider gameprovider) {
    //Reset Punkte
    kartePunkte = {};
    kartePunkteGesamt = {};
    for (var e in Cards.values) {
      kartePunkte.putIfAbsent(e.longname, () => 0);
      kartePunkteGesamt.putIfAbsent(e.longname, () => 0);
    }

    List<String> allCards = _getAllCards();
    int punkte = 0;

    int bieneBuche = 0;
    int bieneLinde = 0;
    int bieneKastanie = 0;

    //Punkte für einzelne Karten:
    for (var i = 0; i < trees.length; ++i) {
      Tree t = trees[i];
      List<String> cards = t.getCards();
      for (var j = 0; j < cards.length; ++j) {
        int einzelPunkte = CardsExtension.asMap()[cards[j]]!.getPoints(t, this, allCards);
        kartePunkte[cards[j]] = einzelPunkte;
        kartePunkteGesamt[cards[j]] = kartePunkteGesamt[cards[j]]! + einzelPunkte;
        punkte += einzelPunkte;
        if(cards[j] == Cards.Holzbiene.longname){
          if(t.mid == Cards.Buche.longname) bieneBuche++;
          if(t.mid == Cards.Linde.longname) bieneLinde++;
          if(t.mid == Cards.Kastanie.longname) bieneKastanie++;
        }
      }
      // Rehe / Gämse
      if(t.left == Cards.Reh.longname ||t.left == Cards.Gaemse.longname ){
        kartePunkte[t.left!] = t.leftPoints;
        kartePunkteGesamt[t.left!] = kartePunkteGesamt[t.left!]! + t.leftPoints;
        punkte += t.leftPoints;
      }
      if(t.right == Cards.Reh.longname ||t.right == Cards.Gaemse.longname ){
        kartePunkte[t.right!] = t.rightPoints;
        kartePunkteGesamt[t.right!] = kartePunkteGesamt[t.right!]! + t.rightPoints;
        punkte += t.rightPoints;
      }
    }

    //Punkte für Sets:
    //Schmetterlinge:
    var schmetterlingsPunkte = [0, 0 , 3, 6, 12 , 20, 35][typenUnique[Typen.Schmetterling]!.length];
    kartePunkteGesamt["Schmetterlinge"] = schmetterlingsPunkte;
    punkte += schmetterlingsPunkte;

    //Linde
    int anzahlLinde = karteAnzahl[Cards.Linde.longname]!;
    int maxLinden = gameprovider.getMaxLinden();
    int lindenPunkte = 0;
    if(anzahlLinde + bieneLinde >= maxLinden) {
      lindenPunkte = anzahlLinde * 3;
      kartePunkte[Cards.Linde.longname] = 3;
    } else {
      lindenPunkte = anzahlLinde;
      kartePunkte[Cards.Linde.longname] = 1;
    }
    kartePunkteGesamt[Cards.Linde.longname] = lindenPunkte;
    punkte += lindenPunkte;

    //Kastanie
    var kastanienPunkte = [0, 1, 4, 9, 16, 25, 36, 49, 49, 49, 49, 49, 49, 49, 49, 49][karteAnzahl[Cards.Kastanie.longname]! + bieneKastanie];
    kartePunkteGesamt[Cards.Kastanie.longname] = kastanienPunkte;
    punkte += kastanienPunkte;

    // Gluehwuermchen
    var gluehwuermchenPunkte = [0, 0, 10, 15, 20][karteAnzahl[Cards.Gluehwuermchen.longname]!];
    kartePunkteGesamt[Cards.Gluehwuermchen.longname] = gluehwuermchenPunkte;
    punkte += gluehwuermchenPunkte;

    // Feuersalamander
    var feuersalamanderPunkte = [0, 5, 15, 25, 25][karteAnzahl[Cards.Feuersalamander.longname]!];
    kartePunkteGesamt[Cards.Feuersalamander.longname] = feuersalamanderPunkte;
    punkte += feuersalamanderPunkte;

    //Buche
    if(karteAnzahl[Cards.Buche.longname]! + bieneBuche >= 4){
      kartePunkte[Cards.Buche.longname] = 5;
      var buchenPunkte = (karteAnzahl[Cards.Buche.longname]!) * 5;
      kartePunkteGesamt[Cards.Buche.longname] = buchenPunkte;
      punkte += buchenPunkte;
    }

    // Buntspecht
    int maxBaeume = gameprovider.getMaxAnzahlBaeume();
    if(typenAnzahl[Typen.Baum]! + karteAnzahl[Cards.Holzbiene.longname]! >= maxBaeume) {
      kartePunkte[Cards.Buntspecht.longname] = 10;
      var buntspechtPunkte = 10 * karteAnzahl[Cards.Buntspecht.longname]!;
      kartePunkteGesamt[Cards.Buntspecht.longname] = buntspechtPunkte;
      punkte += buntspechtPunkte;
    }
    ergebnisPunkte = punkte;
  }

  List<String> _getAllCards() {
    return [
      for (var i = 0; i < trees.length; ++i)
        ...trees[i].getCards()
    ];
  }

  int getMaxBaeume() {
    return typenAnzahl[Typen.Baum]! + karteAnzahl[Cards.Holzbiene.longname]!;
  }

  int getMaxLinden() {
    int bieneLinde = 0;
    for (var i = 0; i < trees.length; ++i) {
      Tree t = trees[i];
      if(t.mid == Cards.Linde.longname && t.left == Cards.Holzbiene.longname) bieneLinde++;
      if(t.mid == Cards.Linde.longname && t.right == Cards.Holzbiene.longname) bieneLinde++;
    }
    return karteAnzahl[Cards.Linde.longname]! + bieneLinde;
  }

  void replaceCards(String? oldCard, String? newCard) {
    if(oldCard != null){
      Cards c = CardsExtension.asMap()[oldCard]!;
      karteAnzahl[oldCard] = karteAnzahl[oldCard]! - 1;
      for (var i = 0; i < c.typen.length; ++i) {
        Typen typ = c.typen[i];
        typenAnzahl[typ] = typenAnzahl[typ]! - 1;
        if(_getAllCards().where((String element) => element == c.longname).toList().length == 1){
          typenUnique[typ]!.remove(oldCard);
        }
      }
    }
    if(newCard != null){
      Cards c = CardsExtension.asMap()[newCard]!;
      karteAnzahl[newCard] = karteAnzahl[newCard]! + 1;
      for (var i = 0; i < c.typen.length; ++i) {
        Typen typ = c.typen[i];
        typenAnzahl[typ] = typenAnzahl[typ]! + 1;
        if(_getAllCards().where((String element) => element == c.longname).toList().isEmpty){
          typenUnique[typ]!.add(newCard);
        }
      }
    }
  }
}
