import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Work_Complete extends StatefulWidget {
  const Work_Complete({super.key, required this.document, required this.id});

  final QueryDocumentSnapshot<Object?> document;
  final String id;
  @override
  State<Work_Complete> createState() => _Work_CompleteState();
}

class _Work_CompleteState extends State<Work_Complete> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _complaint = TextEditingController();
  final TextEditingController _installer = TextEditingController();
  final TextEditingController _material = TextEditingController();
  final TextEditingController _charges = TextEditingController();

  List<String> _instllersName = ["Name"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _date.text = widget.document["date"];
    _name.text = widget.document["name"];
    _number.text = widget.document["number"];
    _address.text = widget.document["address"];
    _complaint.text = widget.document["complaint"];
    if (widget.document["status"] == 'closed') {
      _installer.text = widget.document["installer"];
      _material.text = widget.document["materials"];
      _charges.text = widget.document["charges"];
    }
    getStName();
  }

  void getStName() {
    Future<QuerySnapshot<Map<String, dynamic>>> _stName = FirebaseFirestore
        .instance
        .collection("book")
        .orderBy('installer')
        .get();
    _stName.then((value) {
      setState(() {
        value.docs.forEach((element) {
          if (_instllersName.contains(element["installer"]) ||
              element["installer"].toString().trim() == '')
            return;
          else
            _instllersName.add(element["installer"]);
        });
        _instllersName.sort();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, bottom: 10, right: 20, top: 30),
        child: ListView(
          children: [
            TextField(
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2101),
                ).then((value) =>
                    _date.text = DateFormat('dd/MM/yyyy').format(value!));
              },
              controller: _date,
              decoration: const InputDecoration(
                  label: Text("Date"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                  label: Text("Customer Name"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _number,
              decoration: const InputDecoration(
                  label: Text("Mobile No"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _address,
              maxLines: 3,
              decoration: const InputDecoration(
                  label: Text("Address"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 3,
              controller: _complaint,
              decoration: const InputDecoration(
                  label: Text("Complaint"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 1,
              controller: _installer,
              decoration: InputDecoration(
                  label: Text("Installer"),
                  border: OutlineInputBorder(),
                  suffixIcon: PopupMenuButton<String>(
                      onSelected: (String value) {
                        _installer.text = value;
                      },
                      constraints: BoxConstraints(minWidth: 200),
                      icon: Icon(Icons.arrow_drop_down),
                      itemBuilder: (BuildContext context) {
                        return _instllersName.map((String item) {
                          return PopupMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList();
                      })),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 3,
              controller: _material,
              decoration: const InputDecoration(
                  label: Text("Materials to be Used"),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 1,
              controller: _charges,
              decoration: const InputDecoration(
                  label: Text("Charges"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("book")
                    .doc(widget.id)
                    .update({
                  "name": _name.text,
                  "number": _number.text,
                  "address": _address.text,
                  "complaint": _complaint.text,
                  "date": _date.text,
                  "status": "closed",
                  "installer": _installer.text,
                  "materials": _material.text,
                  "charges": _charges.text
                });
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
