import 'package:flutter/material.dart';
import 'package:knaw_news/util/images.dart';
import 'package:get/get.dart';

import '../../../util/styles.dart';

class Delete extends StatefulWidget {
  Delete({Key? key}) : super(key: key);

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  bool valuefirst = false;
  bool valuesecond = false;
  bool valuethird = false;
  bool valueforth = false;
  bool valuefifth = false;
  @override
  Widget build(BuildContext context) {
    var viewinset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          child: Image.asset(
            Images.back,
            width: 50,
          ),
          onTap: () => Get.back(),
        ),
        title: SizedBox(
          height: 20,
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex: 1, child: Image.asset(r'assets/image/icon.png')),
              const Flexible(
                  flex: 2,
                  child: Text('knaw App',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: viewinset > 0
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 5,),
              Center(
                child: Text('Why do you want to delete your\nKnaw App account?',
                  style: openSansRegular.copyWith(color: textBlack),textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10,),
              Row(children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.amber,
                  value: this.valuefirst,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valuefirst = value!;
                    });
                  },
                ),
                Text('I concerned about my personal data',style:openSansRegular.copyWith(color: textColor) ,),
              ],),
              Row(children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.amber,
                  value: this.valuesecond,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valuesecond = value!;
                    });
                  },
                ),
                Text('I have another Knaw App account',style:openSansRegular.copyWith(color: textColor) ,),
              ],),
              Row(children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.amber,
                  value: this.valuethird,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valuethird = value!;
                    });
                  },
                ),
                Text('I want to remove app from my mobile',style:openSansRegular.copyWith(color: textColor) ,),
              ],),
              Row(children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.amber,
                  value: this.valueforth,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valueforth = value!;
                    });
                  },
                ),
                Text('I got too many emails from Knaw App',style:openSansRegular.copyWith(color: textColor) ,),
              ],),
              Row(children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.amber,
                  value: this.valuefifth,
                  onChanged: (bool? value) {
                    setState(() {
                      this.valuefifth = value!;
                    });
                  },
                ),
                Text('Other',style:openSansRegular.copyWith(color: textColor) ,),
              ],),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: Text('Comments(optional)'),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:15.0,right: 15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.17,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber,
                      width: 1.5,
                      style: BorderStyle.solid
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      maxLines: 4,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Please provide additional information here...',
                        hintStyle: openSansLight,)
                      ),
                    ),
                  ),
                  ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap:(){ Navigator.pop(context);},
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text('Delete',style:TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white
                      ),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
