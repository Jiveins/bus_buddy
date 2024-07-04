import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 98, 96, 1),//background: rgba(255, 98, 96, 1);
        surfaceTintColor: const Color.fromRGBO(255, 98, 96, 1),//background: rgba(255, 98, 96, 1);
        title: const Text("Wallet",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
        actions: [
          Image.asset("assets/images/girldp.png",height: 45,width: 45),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: screensize.height,
          child: Stack(
              children: [
                Positioned(
                    bottom: 555,
                    child: Container(
                      height: 296,
                      width: screensize.width,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 98, 96,1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Text('₹500',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 34,color: Colors.white),)
                            ,Text('Wallet Balance',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white),)
                          ]),
                    )
                ),

                Positioned(
                  top: 186,
                  left: 110,
                  child: ElevatedButton(
                    onPressed: () {},style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(245, 165, 34, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15)
                  ),
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 5,),
                        Text('Add Money',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 300,
                  bottom: 150,
                  child: Container(
                    height: screensize.height,
                    width: screensize.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.separated(itemBuilder: (context, index) {
                        return ListTile(
                          title: const Text('Added money to wallet'),
                          subtitle: Row(
                              children: [
                                Text(DateTime.now().day.toString()),
                                const SizedBox(width: 5,),
                                Text(DateTime.now().month.toString()),
                                const SizedBox(width: 5,),
                                Text(DateTime.now().year.toString()),
                                const SizedBox(width: 5,),
                                Text(DateTime.now().hour.toString()),
                                const SizedBox(width: 5,child: Text(':'),),
                                Text(DateTime.now().minute.toString()),]
                          ),
                          trailing: const Text('+ ₹ 400',style: TextStyle(fontSize: 19,color: Colors.green,fontWeight: FontWeight.bold),),
                        );
                      }, separatorBuilder: (context, index) {
                        return const Divider(height: 8,thickness: 5,);
                      }, itemCount: 6),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
