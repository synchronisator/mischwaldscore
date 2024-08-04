import 'dart:ui';

import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/pages/text_recognizer_view.dart';

class Tree {
  String? mid;

  String? top;
  String? left;
  String? bottom;
  String? right;

  int topAmount = 1;
  int leftAmount = 1;
  int rightAmount = 1;
  int bottomAmount = 1;

  int leftPoints = 0;
  int rightPoints = 0;

  bool isKomplett(){
    return mid != null
        && top  != null
        && left  != null
        && right  != null
        && bottom  != null;
  }

  List<String> getCards(){
    return [
      if(mid != null)
        mid!,
      if(top != null)
        for (var i = 0; i < topAmount; ++i)
          top!,
      if(left != null)
        for (var i = 0; i < leftAmount; ++i)
          left!,
      if(bottom != null)
        for (var i = 0; i <  bottomAmount; ++i)
          bottom!,
      if(right != null)
        for (var i = 0; i < rightAmount; ++i)
          right!,
    ];
  }

}

class TreeDecision {
  List<String> mid = [];
  List<String> top = [];
  List<String> left = [];
  List<String> bottom = [];
  List<String> right = [];

  int topAmount = 1;
  int leftAmount = 1;
  int rightAmount = 1;
  int bottomAmount = 1;

  int leftPoints = 0;
  int rightPoints = 0;

  Tree createTree(){
    Tree tree = Tree();
    if(mid.isNotEmpty) tree.mid = mid.first;
    if(top.isNotEmpty) tree.top = top.first;
    if(bottom.isNotEmpty) tree.bottom = bottom.first;
    if(left.isNotEmpty) tree.left = left.first;
    if(right.isNotEmpty) tree.right = right.first;
    tree.topAmount = topAmount;
    tree.leftAmount = leftAmount;
    tree.rightAmount = rightAmount;
    tree.bottomAmount = bottomAmount;
    tree.leftPoints = leftPoints;
    tree.rightPoints = rightPoints;
    return tree;
  }

  void add(List<KorrekturBlock> blocks) {
    //TODO Ausrichtung
    Rect? midRect; //TODO Problem Baumsprössling
    List<KorrekturBlock> leftrightblocks = [];
    List<KorrekturBlock> bottomblocks = [];
    for (var i = 0; i < blocks.length; ++i) {
      Cards c = Cards.values.where((element) => element.longname == blocks[i].text).first;
      if(c.pos.contains(Pos.mid)){
        if(!mid.contains(c.longname)) {
          mid.add(c.longname);
        }
        midRect = blocks[i].rect;
      }
      if(c.pos.contains(Pos.top)){
        if(!top.contains(c.longname)) {
          top.add(c.longname);
        }
      }
      if(c.pos.contains(Pos.bottom)){
        if(!bottom.contains(c.longname)) {
          bottom.add(c.longname);
        }
        bottomblocks.add(blocks[i]);
      }
      if(c.pos.contains(Pos.left) || c.pos.contains(Pos.right)){
        leftrightblocks.add(blocks[i]);
      }
    }
    int leftcount = 0;
    int rightcount = 0;
    if(midRect != null){ //TODO kein Baum erkannt, Ausrichtung anders lösen
      for (var i = 0; i < leftrightblocks.length; ++i) {
        Cards c = Cards.values.where((element) => element.longname == leftrightblocks[i].text).first;
        if(leftrightblocks[i].rect.left < midRect.left){
          leftcount++;
          if(!left.contains(c.longname)) {
            left.add(c.longname);
          }
        } else {
          rightcount++;
          if(!right.contains(c.longname)) {
            right.add(c.longname);
          }
        }
      }
    }
    if(leftcount > leftAmount) leftAmount = leftcount;
    if(rightcount > rightAmount) rightAmount = rightcount;
    if(bottomblocks.length > bottomAmount) bottomAmount = bottomblocks.length;
  }

  clear() {
    mid = [];
    top = [];
    left = [];
    bottom = [];
    right = [];
    leftAmount = 1;
    rightAmount = 1;
    bottomAmount = 1;
  }
}