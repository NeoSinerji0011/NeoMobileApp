 
import 'package:sigortadefterim/utils/Utils.dart';
 

//Api faturası ödenince çalışacak...
class UserResponse {
   
 static List<String> userInfo = List<String>(); 
  Future getUserInfo() async {
   await Utils.getKullaniciInfo().then((value) {
      userInfo = value;
    });
  }
}
