import 'package:flutter/material.dart';
import 'package:patient_app/errorpage.dart';
import 'package:patient_app/medicine/medicine_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchMedicine extends StatefulWidget {
  const SearchMedicine({Key? key}) : super(key: key);
  @override
  SearchMedicineState createState() => SearchMedicineState();
}

class SearchMedicineState extends State<SearchMedicine> {

  final _searchController = TextEditingController();
  bool _needSearch=false;
  bool _searchIconExist=true;

  Stream<QuerySnapshot> fetchData() {
    String searchQuery = _searchController.text;
    searchQuery = searchQuery.toLowerCase();
    // Construct the query based on the search query entered by the user
    Query query = FirebaseFirestore.instance.collection('medicine_server');
    if (searchQuery.isNotEmpty) {
      query = query.where('medicineSearch', arrayContains: searchQuery);
    }
    return query.snapshots();
  }

  Widget _searchBar(){
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5, left: 5),
          child: IconButton(
            onPressed: () {
              setState(() {
                _needSearch=!_needSearch;
                _searchIconExist=!_searchIconExist;
              });
              _searchController.clear();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 40,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 16,left: 16,right: 20),
            child: TextField(
              onChanged: ((value) {
                setState(() {});
              }),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search medicine...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey.shade100
                    )
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
  
  Widget _doctorList(){
    return Container(
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fetchData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError){
            return const ErrorPage();
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: ((context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return MedicineList(
                  description: document['description'],
                  manufactured_by: document['manufactured_by'],
                  med_name: document['medicine_name'],
                  price: document['price'],
                  quantity: document['quantity'],
                  type: document['type'],
                );
              })
            );
          }
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Medicine'),
        actions: [
          IconButton(
            onPressed: _searchIconExist ? () {
              setState(() {
                _searchIconExist=!_searchIconExist;
                _needSearch=!_needSearch;
              });
            } : null, 
            icon: const Icon(Icons.search)
          ),
          IconButton(
            onPressed: () {

            }, 
            icon: const Icon(Icons.delivery_dining_outlined)
          )
        ],
      ),
      body: SafeArea(
        child: _needSearch ? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            _doctorList(),
          ],
        ) : _doctorList()
      ),
    );
  }
}