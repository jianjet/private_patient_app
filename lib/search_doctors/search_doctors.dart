import 'package:flutter/material.dart';
import 'package:patient_app/errorpage.dart';
import 'package:patient_app/search_doctors/doctor_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDoctor extends StatefulWidget {
  const SearchDoctor({Key? key}) : super(key: key);
  @override
  SearchDoctorState createState() => SearchDoctorState();
}

class SearchDoctorState extends State<SearchDoctor> {

  final _searchController = TextEditingController();
  bool _needSearch=false;
  bool _searchIconExist=true;
  String name = "";

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
                setState(() {
                  name = value;
                });
              }),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search doctors according to their name...",
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
        stream: FirebaseFirestore.instance.collection('doctor_users').snapshots(),
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
                var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                if (name.isEmpty){
                  return DoctorList(
                    name: data['Name'],
                    about: data['About'],
                    uid: data['uid']
                  );
                }

                if (name.isNotEmpty && data['Name'].toString().toLowerCase().startsWith(name.toLowerCase())){
                  return DoctorList(
                    name: data['Name'],
                    about: data['About'],
                    uid: data['uid']
                  );
                }

                return Container();
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
        title: const Text('Search Doctors'),
        actions: [
          IconButton(
            onPressed: _searchIconExist ? () {
              setState(() {
                _searchIconExist=!_searchIconExist;
                _needSearch=!_needSearch;
              });
            } : null, 
            icon: const Icon(Icons.search)
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