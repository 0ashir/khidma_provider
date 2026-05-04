import '../config.dart';



class NavigationClass {
  pushNamedAndRemoveUntil(context, pageName, {arg}) =>
      Navigator.pushNamedAndRemoveUntil(
        context,
        pageName,
        arguments: arg,
            (route) => false,
      );

  pushNamed(context, pageName, {arg}) async{
    final result = await  Navigator.pushNamed(context, pageName, arguments: arg,);
    return result;
  }

  push(context, pageName, {arg}) async{
    final result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => pageName,));
    return result;
  }



  pop(context,{arg}) {
    Navigator.pop(context, arg);
  }

  popAndPushNamed(context,pageName, {arg,result}) {
    Navigator.popAndPushNamed(context, pageName,arguments: arg,result: result,);

  }

  pushReplacementNamed(context,pageName,{args}){
    Navigator.pushReplacementNamed(context, pageName,arguments: args,);
  }

  pushAndRemoveUntil(context,pageName){
    Navigator.of(context).pushAndRemoveUntil(context, pageName);


  }
}