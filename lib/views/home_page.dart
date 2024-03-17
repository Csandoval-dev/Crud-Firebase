import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_firebase_carlos_sandoval/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _openAutoBox({String? docID}) {
    String? marca;
    String? modelo;
    int? ano;
    String? color;
    double? precio;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => marca = value,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              onChanged: (value) => modelo = value,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              onChanged: (value) => ano = int.tryParse(value),
              decoration: InputDecoration(labelText: 'Año'),
            ),
            TextField(
              onChanged: (value) => color = value,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              onChanged: (value) => precio = double.tryParse(value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Precio'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (marca != null && modelo != null && ano != null && color != null && precio != null) {
                if (docID == null) {
                  _firestoreService.addAuto(marca!, modelo!, ano!, color!, precio!);
                } else {
                  _firestoreService.updateAuto(docID, marca!, modelo!, ano!, color!, precio!);
                }
                Navigator.pop(context);
              }
            },
            child: Text(docID == null ? "Add" : "Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAutoBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAutosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List autosList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: autosList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = autosList[index];
                String docID = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String marcaText = data['Marca'];
                String modeloText = data['Modelo'];
                int anoText = data['Año'];
                String colorText = data['Color'];
                double precioText = data['Precio'];

                return ListTile(
                  title: Text('$marcaText - $modeloText'),
                  subtitle: Text('Año: $anoText - Color: $colorText - Precio: $precioText'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _openAutoBox(docID: docID),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => _firestoreService.deleteAuto(docID),
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
