import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/newCategoryPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NewSalesPage extends StatefulWidget {
  
  @override
  _NewSalesPageState createState() => _NewSalesPageState();
}

class _NewSalesPageState extends State<NewSalesPage> {

  @override
  void initState() {
    super.initState();
    initialVariable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Nuevo Cobro", false),

        ],
      ),
    );
  }

}