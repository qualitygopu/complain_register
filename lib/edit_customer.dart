import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Edit_CustomerData extends StatefulWidget {
  const Edit_CustomerData(
      {super.key, required this.document, required this.id});

  final QueryDocumentSnapshot<Object?> document;
  final String id;
  @override
  State<Edit_CustomerData> createState() => _Edit_CustomerDataState();
}

class _Edit_CustomerDataState extends State<Edit_CustomerData> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _complaint = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _date.text = widget.document["date"];
    _name.text = widget.document["name"];
    _number.text = widget.document["number"];
    _address.text = widget.document["address"];
    _complaint.text = widget.document["complaint"];
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
        child: Column(
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
                  label: Text("Mobile No / ID"), border: OutlineInputBorder()),
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
              controller: _complaint,
              decoration: const InputDecoration(
                  label: Text("Complaint"), border: OutlineInputBorder()),
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
