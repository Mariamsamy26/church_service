import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/child.dart';

class FirebaseService {
  Map<int, List<ChildData>> childrenByLevel = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add child data to Firestore
  Future<void> addChildData(ChildData childData) async {
    try {
      String collectionName = 'Level_${childData.level}_${childData.gender}';
      var docRef = await _firestore.collection(collectionName).add(childData.toJson());
      childData.id = docRef.id;  // Firestore generates the ID and assigns it
      print('Child data added with id: ${childData.id}');
    } catch (e) {
      print('Error adding child data: $e');
    }
  }


  // Save child data method, without needing to pass `id`
   saveChildData({
    required String name,
    required String bDay,
    required int level,
    required String gender,
    required String notes,
    String? imgUrl,
  }) {
    // Create the new child object
    ChildData newAccount = ChildData(
      name: name,
      bDay: bDay,
      level: level,
      gender: gender,
      notes: notes,
      imgUrl: imgUrl ?? 'https://example.com/default_profile.jpg', // Default if null
      att: [], // Empty array for attendance
      id: '', // Firestore will generate the ID
    );

    // Add the new child data to Firestore
    addChildData(newAccount);
  }

  // Add child to local map by level
  void addChild(ChildData child) {
    if (!childrenByLevel.containsKey(child.level)) {
      childrenByLevel[child.level] = [];
    }
    childrenByLevel[child.level]?.add(child);
  }

  Stream<List<ChildData>> getChildrenByLevelAndGender(int level, String gender) {
    String collectionName = 'Level_${level}_${gender}';
    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        var children = querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data() as Map<String, dynamic>))
            .where((child) => child.name != null)
            .toList();

        children.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });

        return children;
      },
    );
  }


  Stream<List<ChildData>> bDChildrenByLevelAndGender(int level, String gender, String m) {
    String collectionName = 'Level_${level}_${gender}';
    return _firestore.collection(collectionName).snapshots().map(
          (querySnapshot) {
        return querySnapshot.docs
            .map((doc) => ChildData.fromJson(doc.data() as Map<String, dynamic>))
            .where((child) {
          // Check if bDay is not null and filter by the month
          DateTime? parsedBDay = child.getParsedBDay();
          return parsedBDay != null && parsedBDay.month == m; // Filtering by the month of bDay
        })
            .toList();
      },
    );
  }

  // Clear data from Firestore for multiple levels and genders
  Future<void> clearCollection({
    required List<int> levels,
    required List<String> genders,
  }) async {
    try {
      for (int level in levels) {
        for (String gender in genders) {
          String collectionName = 'Level_${level}_${gender}';
          var querySnapshot = await _firestore.collection(collectionName).get();

          for (var doc in querySnapshot.docs) {
            await _firestore.collection(collectionName).doc(doc.id).delete();
          }
          print('All data cleared in $collectionName');
        }
      }
    } catch (e) {
      print('Error clearing collection: $e');
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
      print('Error clearing collection: $e');
    }
  }
}
