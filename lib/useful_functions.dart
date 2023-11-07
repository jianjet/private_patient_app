//reference
// final firestore = FirebaseFirestore.instance;
// final user = FirebaseAuth.instance.currentUser;

// Future<void> updateDocumentByFieldValue(String collectionName, String fieldName, dynamic fieldValue, Map<String, dynamic> updateFields) async {
//   final QuerySnapshot querySnapshot = await firestore.collection(collectionName).where(fieldName, isEqualTo: fieldValue).get();

//   if (querySnapshot.docs.isNotEmpty) {
//     final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
//     final DocumentReference docRef = documentSnapshot.reference;

//     try {
//       await docRef.update(updateFields);
//       print("Document successfully updated!");
//     } catch (error) {
//       print("Error updating document: $error");
//     }
//   } else {
//     print("No matching document found.");
//   }
// }

bool IsNullOrEmpty(value) {
  if (['', null, 0, false].contains(value)) {
    return true;
  } else {
    return false;
  }
}