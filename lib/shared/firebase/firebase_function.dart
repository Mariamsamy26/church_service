import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/child.dart';

class FirebaseService {
  Map<int, List<ChildData>> childrenByLevel = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addChildData(ChildData childData) async {
    try {
      String collectionName = 'Level_${childData.level}_${childData.gender}';
      var docRef = await _firestore.collection(collectionName).add(childData.toJson());
      childData.id = docRef.id;  // Firebase generates the ID and assigns it to childData
      print('Child data added with id: ${childData.id}');
    } catch (e) {
      print('Error adding child data: $e');
    }
  }

  Future<void> clearCollectionByLevelAndGender(int level, String gender) async {
    try {
      String collectionName = 'Level_${level}_${gender}';
      var querySnapshot = await _firestore.collection(collectionName).get();

      for (var doc in querySnapshot.docs) {
        await _firestore.collection(collectionName).doc(doc.id).delete();
      }

      print('All data cleared in $collectionName');
    } catch (e) {
      print('Error clearing collection : $e');
    }
  }

  void saveChildtData({
    required String name,
    required String bDay,
    required int level,
    required String gender,
    required String notes,
  }) {
    ChildData newAccount = ChildData(
      name: name,
      bDay: bDay,
      level: level,
      gender: gender,
      notes: notes,
      imgUrl: 'https://example.com/profile.jpg', // Replace with dynamic image URL if needed
      att: [], // Empty array for attendance (you can update it later)
      id: '', // Leave empty as Firestore will generate it
    );

    addChildData(newAccount);
  }


  void addChild(ChildData child) {
    if (!childrenByLevel.containsKey(child.level)) {
      childrenByLevel[child.level] = [];
    }
    childrenByLevel[child.level]?.add(child);
  }

  List<ChildData>? getChildrenByLevel(int level) {
    return childrenByLevel[level];
  }

  List<ChildData>? getAllChildren() {
    List<ChildData> allChildren = [];
    for (var childrenList in childrenByLevel.values) {
      allChildren.addAll(childrenList);
    }
    return allChildren;
  }

  Future<List<ChildData>> getChildrenFromFirestore() async {
    List<ChildData> childrenList = [];

    try {
      for (int level = 1; level <= 6; level++) {
        String collectionName = 'Level_${level}_Male';
        var querySnapshot = await _firestore.collection(collectionName).get();

        for (var doc in querySnapshot.docs) {
          var childData = ChildData.fromJson(doc.data() as Map<String, dynamic>);
          childrenList.add(childData);
        }
      }
      return childrenList;
    } catch (e) {
      print('Error fetching children from Firestore: $e');
      return [];
    }
  }
}
