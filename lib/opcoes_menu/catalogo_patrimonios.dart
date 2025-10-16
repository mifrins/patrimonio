import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogoPatrimonios extends StatelessWidget {
  const CatalogoPatrimonios({super.key});

  Future<String?> readSpecificField(String collectionPath, String docId, String fieldName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot docSnapshot = await firestore.collection(collectionPath).doc(docId).get();

      if (docSnapshot.exists) {

        final dynamic fieldValue = docSnapshot.get(fieldName);

        if (fieldValue != null) {
          return fieldValue.toString();
        } else {
          print('Field "$fieldName" does not exist or is null in document "$docId".');
          return null;
        }
      } else {
        print('Document "$docId" does not exist in collection "$collectionPath".');
        return null;
      }
    } catch (e) {
      print("Error reading document field: $e");
      return null;
    }

  }
  

  void _aaaaaa() async {
    String? value = await readSpecificField("patrimônios", "hyhcmyyWQlNf5J3XhpOy", "conservacao");
    print(value);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Patrimônio Coltec', style: TextStyle(color:Colors.black),),
          backgroundColor: const Color(0xFF018B7B),
      ),

      body: Column(
        children: [
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('Age', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('Role', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Sarah')),
                  DataCell(Text('19')),
                  DataCell(Text('Student')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Janine')),
                  DataCell(Text('43')),
                  DataCell(Text('Professor')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('27')),
                  DataCell(Text('27')),
                  DataCell(Text('Associate Professor')),
                ],
              ),
              
            ],
          ),
          ElevatedButton(onPressed: _aaaaaa, child: Text("aaaaaa"))
        ]
      )
    );
  }
}
