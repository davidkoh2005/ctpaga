import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarPerfil.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKeyCompany = new GlobalKey<FormState>();
  String _statusDropdown = "",
        _addressCompany,
        _phoneCompany;
  String _rif, _nameCompany;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarPerfil(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget> [
                    showImage(),
                    SizedBox(height:20),
                    dropdownList("Datos de la empresa"),
                    Visibility(
                      visible: _statusDropdown == "Datos de la empresa"? true : false,
                      child: formCompany(),
                    ),
                    dropdownList("Datos de Usuario"),
                    dropdownList("Persona de Contacto"),
                    dropdownList("Datos Bancarios"),
                  ]
                ),
              ),
            ),
          ],
        ),
      );
  }

  showImage(){

    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => print("entro"),//TODO: ruta
      child: ClipOval(
        child: Image(
          image: AssetImage("assets/icons/addPhoto.png"),
          width: size.width/4,
          height: size.width/4,
        ),
      ),
    );
  }

  Widget dropdownList(_title){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: 	EdgeInsets.only(top: 5, bottom: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          if(_statusDropdown == _title){
            _statusDropdown = "";
          }else{
            _statusDropdown = _title;
          }
        }),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          width: size.width,
          height: 50,
          color: colorGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _title,
                style: TextStyle(
                  fontSize: size.width / 20,
                ),
              ),
              Icon(
                _statusDropdown == _title? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: colorGreen,
              ),
            ]
          ),
        )
      )
    );
  }

  Widget formCompany(){
    return new Form(
      key: _formKeyCompany,
      child: new ListView(
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'RIF',
                labelStyle: TextStyle(
                  color: colorGrey
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _rif = value,
              validator: _validateRif,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ], 
              decoration: InputDecoration(
                labelText: 'Nombre de la empresa',
                labelStyle: TextStyle(
                  color: colorGrey
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _nameCompany = value,
              validator: (value) => value.isEmpty? 'Nombre de la Compañia no puede estar vacío' : null,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Dirección',
                labelStyle: TextStyle(
                  color: colorGrey
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _addressCompany = value,
              validator: _validateAddressCompany,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
            child: new TextFormField(
              autofocus: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorGrey
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _phoneCompany = value,
              validator: _validatePhoneCompany,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
            ),
          ),

          buttonSaveCompany(),
        ],
      ),
    );
  }
  
  String _validateRif(value){
    String p = r'^[c|e|g|j|p|v|C|E|G|J|P|V][-][0-9]+';
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      _rif = value;
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese el RIF correctamente';
  }

  String _validateAddressCompany(value){
    return 'error';
  }

  String _validatePhoneCompany(value){
    return 'error';
  }

  Widget buttonSaveCompany(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30, right:30, bottom:30),
      child: GestureDetector(
        onTap: () => buttonClickSaveCompany(),
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorGreen,
                colorGreen
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "GUARDAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  void buttonClickSaveCompany(){
    if (_formKeyCompany.currentState.validate()) {
      _formKeyCompany.currentState.save();
      //_onLoading();
      //TODO: Guardar Datos
    }

  }

  nextPage(page, index)async{
    //setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    //setState(() =>statusButton.remove(index));
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}