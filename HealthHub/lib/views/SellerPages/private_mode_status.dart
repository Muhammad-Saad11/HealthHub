import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class pmode{
  static var private=false;

  static  getprivateMode()async{
    try{
      var ids=[];
      var data= await  FirebaseFirestore.instance.collection('Venues').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      for(int i=0;i<data.size;i++){
        ids.add(data.docs[i].id);
      }
      var d2=await  FirebaseFirestore.instance.collection('Venues').doc(ids[0]).get();
      private=d2.get('isPrivate');
    }
    catch(e){
    }

  }

  static  privateMode(value)async{
  private=value;
  var ids=[];
  var data= await  FirebaseFirestore.instance.collection('Products').where('sellerUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
  ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
  await  FirebaseFirestore.instance.collection('Products').doc(ids[i]).update({
  'isPrivate':value
  });
  }

  ids.clear();

   data= await  FirebaseFirestore.instance.collection('Gyms').where('gymUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
    ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
    await  FirebaseFirestore.instance.collection('Gyms').doc(ids[i]).update({
      'isPrivate':value
    });
  }
  ids.clear();

   data= await  FirebaseFirestore.instance.collection('Nutritionists').where('nutritionistsUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
    ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
    await  FirebaseFirestore.instance.collection('Nutritionists').doc(ids[i]).update({
      'isPrivate':value
    });
  }

  ids.clear();

  }

}