import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/child.dart';

class FirebaseService {
  Map<int, List<ChildData>> childrenByLevel = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لإضافة بيانات الطفل إلى Firebase
  Future<void> addChildData(ChildData childData) async {
    try {
      // بناء اسم المجموعة بناءً على المستوى والجنس
      String collectionName = 'Level_${childData.level}_${childData.gender}';

      // إضافة الطفل إلى Firestore في المجموعة المناسبة
      await _firestore.collection(collectionName).add(childData.toJson());

      print('Child data added to $collectionName');
    } catch (e) {
      print('Error adding child data: $e');
    }
  }


  // دالة لحذف كل البيانات في مجموعة معينة بناءً على المستوى والجنس
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
      level: level ,  // التأكد من تحويل المستوى إلى عدد صحيح
      gender: gender,
      notes: notes,
      imgUrl: 'https://example.com/profile.jpg',
      att: [],
      id: '',  // يمكن أن تكون فارغة أو تم توليدها لاحقًا
    );

    // إضافة البيانات إلى Firebase
    addChildData(newAccount);  // استخدم دالة addChildData بدلاً من addAccountData
  }


  // إضافة الطفل إلى الـ Map
  void addChild(ChildData child) {
    if (!childrenByLevel.containsKey(child.level)) {
      childrenByLevel[child.level] = [];
    }
    childrenByLevel[child.level]?.add(child);
  }

  // جلب الأطفال حسب المستوى
  List<ChildData>? getChildrenByLevel(int level) {
    return childrenByLevel[level];
  }

  // جلب جميع الأطفال
  List<ChildData>? getAllChildren() {
    List<ChildData> allChildren = [];
    for (var childrenList in childrenByLevel.values) {
      allChildren.addAll(childrenList);
    }
    return allChildren;
  }

  // جلب الأطفال من Firestore
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
