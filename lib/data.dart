import 'package:complain_register_1/complete_work.dart';
import 'package:complain_register_1/customer_data.dart';
import 'package:complain_register_1/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final TextEditingController _searchController = TextEditingController();
  String _search = "";
  int _selectedindex = 0;
  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("book")
      .where('status', isEqualTo: null)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
                              child:
                                  // Text(ind.toString()),
                                  _record(ind, _data),
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

  void _onSelectedtab(int value) {
    setState(() {
      _selectedindex = value;
      switch (value) {
        case 0:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: null)
              .snapshots();
          break;
        case 1:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: 'open')
              .snapshots();
          break;
        case 2:
          _stream = FirebaseFirestore.instance
              .collection("book")
              .where('status', isEqualTo: 'closed')
              .snapshots();
          break;
        default:
      }
    });
  }

  _record(int ind, QueryDocumentSnapshot data) {
    bool _isOpen = data['status'] == 'open';
    return ListTile(
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
                  view_data("Customer Name: ", data["name"]),
                  view_data('Phone.no: ', data["number"]),
                  view_data('Address: ', data["address"]),
                  view_data('Complaint: ', data["complaint"]),
                  view_data('Date: ', data["date"]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
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
      trailing: Wrap(
        spacing: -2,
        children: [
          IconButton(
              iconSize: 18,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return _isOpen
                      ? Edit_CustomerData(document: data, id: data.id)
                      : Work_Complete(document: data, id: data.id);
                }));
              }),
          IconButton(
            iconSize: 18,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("book")
                  .doc(data.id)
                  .delete();
            },
          ),
        ],
      ),
      leading: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(Icons.person),
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
