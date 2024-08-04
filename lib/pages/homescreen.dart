import 'package:flutter/material.dart';
import 'package:mischwaldscore/pages/playerpage.dart';
import 'package:mischwaldscore/provider/gameprovider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mischwald - Scoring"),
        actions: [
          IconButton(onPressed: () => context.read<GameProvider>().clear(), icon: const Icon(Icons.clear)),
          IconButton(onPressed: () => context.read<GameProvider>().recalcPoints(), icon: const Icon(Icons.calculate)),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...context.watch<GameProvider>().player.map((e) => Card(
              child: InkWell(
                onTap: () {
                      context.read<GameProvider>().setActivePlayer(e);
                      Navigator.push(
                      context,
                      MaterialPageRoute<PlayerPage>(
                        builder: (BuildContext context) => const PlayerPage(),
                      ),
                    );
                    },
                child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        SizedBox(width: 100, child: Text("${e.getGesamtpunktzahl()} Punkte")),
                        Text(e.name),
                        const Spacer(),
                        Text("${e.trees.length} Bäume"),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              context.read<GameProvider>().removePlayer(e);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete)),
                      ]),
                    ),
              ),
            )),
            Center(
              child: OutlinedButton(
                  onPressed: () {
                    context.read<GameProvider>().addPlayer();
                    setState(() {});
                  },
                  child: const Icon(Icons.add)),
            )
          ],
        ),
      ),
    );
  }
}
