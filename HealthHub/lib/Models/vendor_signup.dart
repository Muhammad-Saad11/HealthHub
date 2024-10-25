import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vendor {
  String name;
  String cnic;
  String businessName;
  String email;
  String password;
  String number;
  String address;

  Vendor(
      {this.email = '',
        this.name = '',
        this.businessName = '',
        this.cnic = '',
        this.password = '',
        this.number = '',
        this.address = ''});

  getAllBookings() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('buyer_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  setAvailability(value)async{
    var ids=[];
    var data= await  FirebaseFirestore.instance.collection('Venues').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for(int i=0;i<data.size;i++){
      ids.add(data.docs[i].id);
    }
    for(int i=0;i<ids.length;i++){
      await  FirebaseFirestore.instance.collection('Venues').doc(ids[i]).update({
        'isPrivate':value
      });
    }

    ids.clear();

    data= await  FirebaseFirestore.instance.collection('Jewelerys').where('sellerUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for(int i=0;i<data.size;i++){
      ids.add(data.docs[i].id);
    }
    for(int i=0;i<ids.length;i++){
      await  FirebaseFirestore.instance.collection('Jewelerys').doc(ids[i]).update({
        'isPrivate':value
      });
    }
    ids.clear();

    data= await  FirebaseFirestore.instance.collection('Dresses').where('sellerUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for(int i=0;i<data.size;i++){
      ids.add(data.docs[i].id);
    }
    for(int i=0;i<ids.length;i++){
      await  FirebaseFirestore.instance.collection('Dresses').doc(ids[i]).update({
        'isPrivate':value
      });
    }

    ids.clear();

    data= await  FirebaseFirestore.instance.collection('Bridal Salon').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for(int i=0;i<data.size;i++){
      ids.add(data.docs[i].id);
    }
    for(int i=0;i<ids.length;i++){
      await  FirebaseFirestore.instance.collection('Bridal Salon').doc(ids[i]).update({
        'isPrivate':value
      });
    }
    ids.clear();

  }

  updateTaskStatus({title,status,docId}) async {
    var store = FirebaseFirestore.instance.collection('orders').doc(docId);
    await store.set({
      title:status
    },
        SetOptions(
            merge: true
        )
    );
  }

}
