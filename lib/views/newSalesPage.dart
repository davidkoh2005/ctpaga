import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/verifyDataClientPage.dart';
import 'package:ctpaga/views/contacts_dialog.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/providers/provider.dart';

import 'package:ctpaga/env.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewSalesPage extends StatefulWidget {
  
  @override
  _NewSalesPageState createState() => _NewSalesPageState();
}

class _NewSalesPageState extends State<NewSalesPage> {
  final _formKeyNewSales = new GlobalKey<FormState>();
  final _controllerName = TextEditingController();
  bool _statusButton = false, _statusButtonName = false;
  String _nameContacts, _initialsContacts;
  List<int> _avatarContacts = [];
  List<Contact> contacts = [];
  Iterable<Contact> _contacts;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Navbar("Nuevo Cobro", true),
                  Expanded(
                    child: formNewSales(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: buttonContinue()
                  ),
                ],
              ),

              AnimatedPositioned(
                duration: Duration(milliseconds:250),
                top: 0,
                bottom: 0,
                left: myProvider.statusButtonMenu? 0 : -size.width,
                right: myProvider.statusButtonMenu? 0 : size.width,
                child: MenuPage(),
              ),
            ],
          ), 
        );
      }
    );
  }

  formNewSales(){
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "CLIENTE",
              style: TextStyle(
                color: colorText,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: new TextFormField(
            controller: _controllerName,
            maxLines: 1,
            textCapitalization:TextCapitalization.words,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
              BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
            ], 
            autofocus: false,
            maxLength: 50,
            validator: _validateName,
            onSaved: (value) => _nameContacts = value.trim(),
            onChanged: (value) => value.length >=3? setState(() => _statusButton = true): setState(() => _statusButton = false) ,
            textInputAction: TextInputAction.next,
            cursorColor: colorGreen,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(
              color: colorText,
              fontSize: size.width / 15,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(80, 20, 80, 40),
          child: Text(
            "Escribe el nombre de tu cliente o búscalo en tus contactos",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorText,
              fontSize: size.width / 22,
            ),
          ),
        ),
        buttonSearch(),
      ],
    );
  }

  Widget buttonSearch(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        setState(() => _statusButtonName = true);
        await Future.delayed(Duration(milliseconds: 150));
        setState(() => _statusButtonName = false);
        _showContactList(context);
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              _statusButtonName? colorGreen : colorGrey,
              _statusButtonName? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "BUSCAR CLIENTE",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonContinue(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(_statusButton)
          nextPage();
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              _statusButton? colorGreen : colorGrey,
              _statusButton? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "CONTINUAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  
  // Asking Contact permissions
  Future<PermissionStatus> _getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  

  // Showing contact list.
  Future<Null> _showContactList(BuildContext context) async {
    List<Contact> favoriteElements = [];
    final InputDecoration searchDecoration = const InputDecoration();

    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      _onLoading();
      var contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });

      Navigator.pop(context);

      if (_contacts != null)
      {
        //SelectionDialogContacts class file contacts_dialog.dart
        showDialog(
          context: context,
          builder: (_) =>
              SelectionDialogContacts(
                _contacts.toList(),
                favoriteElements,
                showCountryOnly: false,
                emptySearchBuilder: null,
                searchDecoration: searchDecoration,
              ),
        ).then((e) {
          if (e != null) {
            setState(() {
              _controllerName.clear();
              _controllerName.text = e.displayName;
              _statusButton = true;
            });

            _nameContacts = e.displayName;
            _avatarContacts = e.avatar;
            _initialsContacts = e.initials();
          }
        });
      } 
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Error de permisos'),
              content: Text('Habilite el acceso a los contactos'
                  'permiso en la configuración del sistema'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
    }
  }

  Future<void> _onLoading() async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Cargando ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width / 20,
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: size.width / 20,
                          )
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  nextPage()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() =>_statusButton = false);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>_statusButton = true);

    if(_controllerName.text == _nameContacts){
      myProvider.nameClient = _nameContacts;
      myProvider.avatarClient = _avatarContacts;
      myProvider.initialsClient = _initialsContacts;
    }else{
      myProvider.nameClient = _controllerName.text;
      myProvider.avatarClient = [];
      myProvider.initialsClient = initialsClient(_controllerName.text);
    }

    Navigator.push(context, SlideLeftRoute(page: VerifyDataClientPage()));
  }

  initialsClient(value){
    var listName = value.split(" ");

    if(listName.length >=2)
      return listName[0].substring(0, 1)+listName[listName.length-1].substring(0, 1);
    else
      return listName[0].substring(0, 1);
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name didn't match the regex above.
    return 'Ingrese nombre del cliente correctamente';
  }

}