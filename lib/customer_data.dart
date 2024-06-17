import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomerData extends StatefulWidget {
  const CustomerData({super.key});

  @override
  State<CustomerData> createState() => _CustomerDataState();
}

String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

class _CustomerDataState extends State<CustomerData> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _date =
      TextEditingController(text: formattedDate);
  final TextEditingController _number = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _complaint = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                FirebaseFirestore.instance.collection("book").add({
                  "name": _name.text,
                  "number": _number.text,
                  "address": _address.text,
                  "complaint": _complaint.text,
                  "date": _date.text,
                  "status": "open",
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
