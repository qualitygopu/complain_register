import 'package:complain_register_1/complete_work.dart';
import 'package:complain_register_1/customer_data.dart';
import 'package:complain_register_1/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final TextEditingController _searchController = TextEditingController();
  String _search = "";
  int _selectedindex = 1;
  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("book")
      .where('status', isEqualTo: 'open')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complain Register"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                label: Text(
                  "Search",
                  style: TextStyle(color: Colors.blue[900]),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, ind) {
                      QueryDocumentSnapshot _data = snapshot.data!.docs[ind];

                      if (_data['number']
                          .toString()
                          .contains(_search.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              child: _record(ind, _data),
                            ),
                          ),
                        );
                      } else if (_search.isEmpty) {
                        return _record(ind, _data);
                      } else {
                        return Container();
                      }
                    });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CustomerData()),
          );
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        splashColor: Colors.blue,
        hoverColor: Colors.blue[800],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox), label: 'Show All'),
          BottomNavigationBarItem(icon: Icon(Icons.all_inbox), label: 'Open'),
          BottomNavigationBarItem(icon: Icon(Icons.all_inbox), label: 'Closed')
        ],
        currentIndex: _selectedindex,
        onTap: _onSelectedtab,
      ),
    );
  }

  Widget view_data(String field, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                child: Text(
                  field,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onSelectedtab(int value) async {
    setState(() {
      _selectedindex = value;
      switch (value) {
        case 0:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: null)
              .orderBy('date', descending: true)
              .snapshots();
          break;
        case 1:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: 'open')
              .orderBy('date', descending: true)
              .snapshots();
          break;
        case 2:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: 'closed')
              .orderBy('date', descending: true)
              .snapshots();
          break;
        default:
      }
    });
  }

  _record(int ind, QueryDocumentSnapshot data) {
    bool _isOpen = data['status'] == 'open';

    return ListTile(
      onLongPress: () {
        Clipboard.setData(ClipboardData(
                text: "Customer Name: " +
                    data["name"] +
                    "\nPhone.no: " +
                    data["number"] +
                    "\nAddress: " +
                    data["address"] +
                    "\nComplaint: " +
                    data["complaint"]))
            .whenComplete(() {
          SnackBar sbar = SnackBar(content: Text("Copied to clipboard"));
          ScaffoldMessenger.of(context).showSnackBar(sbar);
        });
      },
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text("Customer Details",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline))),
                  SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          view_data("Customer Name: ", data["name"]),
                          view_data('Phone.no: ', data["number"]),
                          view_data('Address: ', data["address"]),
                          view_data('Complaint: ', data["complaint"]),
                          view_data('Date: ', data["date"]),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: "Customer Name: " +
                                  data["name"] +
                                  "\nPhone.no: " +
                                  data["number"] +
                                  "\nAddress: " +
                                  data["address"] +
                                  "\nComplaint: " +
                                  data["complaint"]));
                        },
                        child: const Text('Copy'),
                      ),
                      _isOpen
                          ? SizedBox(
                              width: 20,
                            )
                          : SizedBox(),
                      _isOpen
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Work_Complete(
                                        document: data,
                                        id: data.id,
                                      ),
                                    ));
                              },
                              child: const Text('Completed'),
                            )
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      trailing: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return _isOpen
                  ? Edit_CustomerData(document: data, id: data.id)
                  : Work_Complete(document: data, id: data.id);
            }));
          } else if (value == 2) {
            FirebaseFirestore.instance.collection("book").doc(data.id).delete();
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: ListTile(leading: Icon(Icons.edit), title: Text("Edit")),
              value: 1,
            ),
            PopupMenuItem(
              child:
                  ListTile(leading: Icon(Icons.delete), title: Text("Delete")),
              value: 2,
            ),
          ];
        },
      ),
      leading: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(_isOpen ? Icons.pending_actions : Icons.done_all),
      ),
      title: Row(
        children: [
          Text(
            data['name'],
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mobile No / ID: " + data['number'],
            ),
            SizedBox(width: 25),
            Text(
              "Date: " + data['date'],
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
