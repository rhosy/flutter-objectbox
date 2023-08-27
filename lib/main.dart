import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:objectbox_example/entities/objectbox.dart';
import 'package:objectbox_example/entities/person.dart';

import 'objectbox.g.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = (await ObjectBox.create()).store;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Object Box Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Object Box'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController inputController = TextEditingController();
  final Box<Person> personBox = store.box<Person>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: inputController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Type person name",
                label: Text("Name"),
              ),
              validator: (value) {
                return (value != null && value.contains('@'))
                    ? "Don't use the @ character"
                    : null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              onPressed: () {
                personBox.put(Person(name: inputController.text));
                inputController.clear();
                setState(() {});
              },
              child: const Text(
                "Create",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FilledButton(
              onPressed: () {
                for (var element in personBox.getAll()) {
                  log('${element.personId} - ${element.name}');
                }
              },
              child: const Text("Retrive/Read"),
            ),
            const SizedBox(
              height: 8,
            ),
            FilledButton(
              onPressed: () {
                List<String> strings = inputController.text.split("-");
                if (strings.length == 2) {
                  int id = int.tryParse(strings[0]) ?? 0;

                  if (id > 0) {
                    personBox.put(Person(personId: id, name: strings[1]));
                  }
                }
                inputController.clear();
                setState(() {});
              },
              child: const Text("Update"),
            ),
            const SizedBox(
              height: 8,
            ),
            FilledButton(
              onPressed: () {
                int id = int.tryParse(inputController.text) ?? 0;
                if (id > 0) {
                  personBox.remove(id);
                }
                inputController.clear();
                setState(() {});
              },
              child: const Text("Delete"),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: personBox
                  .getAll()
                  .map((e) => ListTile(
                        leading: Text(e.personId.toString()),
                        title: Text(e.name),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
