import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference autos = FirebaseFirestore.instance.collection('Autos');

  Future<void> addAuto(String marca, String modelo, int ano, String color, double precio) {
    return autos.add({
      'Marca': marca,
      'Modelo': modelo,
      'Año': ano,
      'Color': color,
      'Precio': precio,
      'Timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getAutosStream() {
    final autosStream = autos.orderBy('Timestamp', descending: true).snapshots();
    return autosStream;
  }

  Future<void> updateAuto(String docID, String marca, String modelo, int ano, String color, double precio) {
    return autos.doc(docID).update({
      'Marca': marca,
      'Modelo': modelo,
      'Año': ano,
      'Color': color,
      'Precio': precio,
      'Timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteAuto(String docID) {
    return autos.doc(docID).delete();
  }
}
