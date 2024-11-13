import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/child.dart';

class FirebaseService {
  Map<int, List<ChildData>> childrenByLevel = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add child data to Firestore
  Future<void> addChildData(ChildData childModel) async {
    try {
      String collectionName = 'Level_${childModel.level}_${childModel.gender}';
      var docRef = await _firestore
          .collection(collectionName)
          .doc(childModel.id)
          .set(childModel.toJson());
      print('Child data added with id: ${childModel.id}');
    } catch (e) {
      print('Error adding child data: $e');
    }
  }

  // Save child data method
  Future<void> saveChildData({
    required String name,
    required DateTime bDay,
    required int level,
    required int phone,
    required String gender,
    required String notes,
    String? imgUrl,
  }) async {
    String collectionName = 'Level_${level}_$gender';
    var docRef = _firestore.collection(collectionName).doc();

    // Create the ChildData instance with the generated ID
    ChildData newAccount = ChildData(
      id: docRef.id,
      name: name,
      bDay: bDay,
      level: level,
      gender: gender,
      notes: notes,
      imgUrl: imgUrl ??
          (gender == 'G'
              ? 'assets/images/profileG.png'
              : 'assets/images/profileB.png'),
      att: [],
      phone: phone,
    );
    await addChildData(newAccount);
  }

  // Add child to local map by level
  void addChild(ChildData child) {
    if (!childrenByLevel.containsKey(child.level)) {
      childrenByLevel[child.level] = [];
    }
    childrenByLevel[child.level]?.add(child);
  }

  Stream<List<ChildData>> getChildrenByLevelAndGender(int level,
      String gender) {
    String collectionName = 'Level_${level}_$gender';
    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        var children = querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data()))
            .where((child) => child.name != null)
            .toList();

        children.sort(
                (a, b) =>
                a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return children;
      },
    );
  }

  Stream<List<ChildData>> bDChildrenByLevelAndGender({
    required int level,
    required String gender,
    required String monthStr,
  }) {
    String collectionName = 'Level_${level}_$gender';
    int month = int.tryParse(monthStr) ?? 0;

    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        return querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data()))
            .where((child) => child.bDay != null && child.bDay!.month == month)
            .toList();
      },
    );
  }

  Stream<ChildData?> ChildrenById({
    required int level,
    required String gender,
    required String id,
  }) {
    String collectionName = 'Level_${level}_$gender';

    return _firestore
        .collection(collectionName)
        .doc(id)
        .snapshots()
        .map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return ChildData.fromJson(documentSnapshot.data()!);
      } else {
        return null;
      }
    });
  }



}
