import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarPerfil.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _scrollController = ScrollController();
  final _formKeyCompany = new GlobalKey<FormState>();
  final _formKeyUser = new GlobalKey<FormState>();
  final _formKeyContact = new GlobalKey<FormState>();
  final _formKeyBankingUSD = new GlobalKey<FormState>();
  final _formKeyBankingBs = new GlobalKey<FormState>();
  final FocusNode _nameCompanyFocus = FocusNode();
  final FocusNode _addressCompanyFocus = FocusNode();  
  final FocusNode _phoneCompanyFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _accountNameBankingUSDFocus = FocusNode();
  final FocusNode _accountNumberBankingUSDFocus = FocusNode();
  final FocusNode _routeBankingUSDFocus = FocusNode();
  final FocusNode _swiftBankingUSDFocus = FocusNode();
  final FocusNode _addressBankingUSDFocus = FocusNode();
  final FocusNode _accountTypeBankingUSDFocus = FocusNode();
  final FocusNode _accountNameBankingBsFocus = FocusNode();
  final FocusNode _idCardBankingBsFocus = FocusNode();
  final FocusNode _accountNumberBankingBsFocus = FocusNode();

  String _statusDropdown = "",
         _rifCompany, _nameCompany, _addressCompany, _phoneCompany,
        _email, _name, _address, _phone,
        _countryBankingUSD, _accountNameBankingUSD, _accountNumberBankingUSD, _routeBankingUSD, _swiftBankingUSD, _addressBankingUSD, _nameBankingUSD, _accountTypeBankingUSD,
        _accountNameBankingBs, _idCardBankingBs, _accountNumberBankingBs,_nameBankingBs, _accountTypeBankingBs;
  int _statusCoin = 0;
  File _image;
  bool _statusCountry = false, _statusClickUSD = false, _statusClickBs = false;
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  
  void initState() {
    super.initState();
    initVariable(context);
  }

  void dispose(){
    super.dispose();
  }

  initVariable(BuildContext context){
    Provider.of<MyProvider>(context, listen: false).getDataUser(false, context);
    _statusCoin = Provider.of<MyProvider>(context, listen: false).dataUser.coin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarPerfil(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                    Visibility(
                      visible: _statusDropdown == "Datos de Usuario"? true : false,
                      child: formUser(),
                    ),
                    dropdownList("Persona de Contacto"),
                    Visibility(
                      visible: _statusDropdown == "Persona de Contacto"? true : false,
                      child: formContact(),
                    ), 
                    dropdownList("Datos Bancarios"),
                    Visibility(
                      visible: _statusDropdown == "Datos Bancarios"? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(right:30, top:20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            buttonUSD(),
                            buttonBs(),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _statusDropdown == "Datos Bancarios"? true : false,
                      child: formBanking(),
                    ), 
                  ]
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget showImage(){
    var size = MediaQuery.of(context).size;
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(_image != null){
      return GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: ClipOval(
          child: Image.file(
            _image,
            width: size.width / 4,
            height: size.width / 4,
            fit: BoxFit.cover
          ),
        )
      );
    }else if(myProvider.dataUser.statusProfile){
      //DefaultCacheManager().removeFile(url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg");

      return GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg",
            fit: BoxFit.cover,
            height: size.width / 4,
            width: size.width / 4,
            placeholder: (context, url) {
              return Container(
                margin: EdgeInsets.all(15),
                child:CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red,),
          ),
        )
      );
    }

    return GestureDetector(
      onTap: () => _showSelectionDialog(context),
      child: ClipOval(
        child: Image(
          image: AssetImage("assets/icons/addPhoto.png"),
          width: size.width / 4,
          height: size.width / 4,
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              spacing: 20,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.crop_original, color:Colors.black, size: 30.0),
                  title: new Text(
                    "Galeria",
                    style: TextStyle(
                      fontSize: size.width / 20,
                    ),
                  ),
                  onTap: () => _getImage(context, ImageSource.gallery),       
                ),
                new ListTile(
                  leading: new Icon(Icons.camera, color:Colors.black, size: 30.0),
                  title: new Text(
                    "Camara",
                    style: TextStyle(
                      fontSize: size.width / 20,
                    ),
                  ),
                  onTap: () => _getImage(context, ImageSource.camera),          
                ),
              ],
            ),
          );
      }
    );
  }

  _getImage(BuildContext context, ImageSource source) async {
    var picture = await ImagePicker().getImage(source: source,  imageQuality: 50, maxHeight: 600, maxWidth: 900);
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    Navigator.of(context).pop();

    if(picture != null){
      _onLoading();
      try
      {
        String base64Image = base64Encode(File(picture.path).readAsBytesSync());
        String fileName = picture.path.split("/").last;

        var response = await http.post(
          urlApi+"updateUserImg/",
          headers:{
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: {
            "image": base64Image,
            "name": fileName,
          }
        );

        print(response.body);

        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse); 
        if (jsonResponse['statusCode'] == 201) {
          DefaultCacheManager().removeFile(url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg");
          setState(() =>_image = File(picture.path));
          myProvider.getDataUser(false, context);
          Navigator.pop(context);
          showMessageCorrectly("Guardado Correctamente");
          await Future.delayed(Duration(seconds: 1));
          Navigator.pop(context);
        }  

      }on SocketException catch (_) {
        print("error network");
      }
    }
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
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return new Form(
      key: _formKeyCompany,
      child: new ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.rifCompany,
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
              onSaved: (String value) => _rifCompany = value,
              validator: _validateRif,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.nameCompany,
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
              validator: (value) => value.isEmpty? 'Nombre de la empresa no puede estar vacío' : null,
              textInputAction: TextInputAction.next,
              focusNode: _nameCompanyFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_addressCompanyFocus),
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.addressCompany,
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
              validator: _validateAddress,
              textInputAction: TextInputAction.next,
              focusNode: _addressCompanyFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneCompanyFocus),
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.phoneCompany,
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
              validator: _validatePhone,
              focusNode: _phoneCompanyFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode());
                buttonClickSaveCompany();
              },
              cursorColor: colorGreen,
            ),
          ),

          buttonSave("Company"),
        ],
      ),
    );
  }

  Widget formUser(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    
    return new Form(
      key: _formKeyUser,
      child: new ListView(
        padding: EdgeInsets.only(top: 0),
        controller: _scrollController,
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.email,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
              ),
              validator: _validateEmail,
              onSaved: (String value) => _email = value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode());
                buttonClickSaveUser();
              },
              cursorColor: colorGreen,
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: null,//TODO: Boton
              child: Text(
                "Cambiar contraseña",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: size.width / 20,
                  decoration: TextDecoration.underline,
                )
              ),
            ),
          ),

          buttonSave("User"),
        ],
      ),
    );
  }

  Widget formContact(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
 
    return new Form(
      key: _formKeyContact,
      child: new ListView(
        padding: EdgeInsets.only(top: 0),
        controller: _scrollController,
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.name,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ], 
              decoration: InputDecoration(
                labelText: 'Nombre y Apellido',
                labelStyle: TextStyle(
                  color: colorGrey
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _name = value,
              validator: _validateName,
              textInputAction: TextInputAction.next,
              focusNode: _nameFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_addressFocus),
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.address,
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
              onSaved: (String value) => _address = value,
              validator: _validateAddress,
              textInputAction: TextInputAction.next,
              focusNode: _addressFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser.phone,
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
              onSaved: (String value) => _phone = value,
              validator: _validatePhone,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode());
                buttonClickSaveContact();
              },
              cursorColor: colorGreen,
            ),
          ),

          buttonSave("Contact"),
        ],
      ),
    );
  }

  Widget buttonUSD(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () => saveStatusMoney(0), 
        child: Container(
          width:size.width / 5,
          height: size.height / 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusCoin == 0? colorGreen : colorGrey,
                _statusCoin == 0? colorGreen : colorGrey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "\$",
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

  Widget buttonBs(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:20),
      child: GestureDetector(
        onTap: () => saveStatusMoney(1), 
        child: Container(
          width:size.width / 5,
          height: size.height / 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusCoin == 1? colorGreen : colorGrey,
                _statusCoin == 1? colorGreen : colorGrey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "Bs",
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

  saveStatusMoney(money)async{
    setState(() => _statusCoin = money);
    
    var result, response, jsonResponse;
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var myProvider = Provider.of<MyProvider>(context, listen: false);

        response = await http.post(
          urlApi+"updateUser/",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: jsonEncode({
            'coin': money,
          }),
        ); 

        jsonResponse = jsonDecode(response.body); 
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getDataUser(false, context);
        } 
      }
    } on SocketException catch (_) {
      print("error network");
    } 
  }

  Widget formBanking(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    if(_statusCoin == 0){
      setState(() {
        _nameBankingUSD = myProvider.dataBankUser[0] == null? null : myProvider.dataBankUser[0].bankName;
      });
      return new Form(
        key: _formKeyBankingUSD,
        child: new ListView(
          padding: EdgeInsets.only(top: 0),
          controller: _scrollController,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].country,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                  BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                ], 
                decoration: InputDecoration(
                  labelText: 'País (Panamá o USA)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _countryBankingUSD = value.toLowerCase(),
                validator: _validateCountry,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_accountNameBankingUSDFocus),
                onChanged: (value) {
                  if(value.toLowerCase() == "usa")
                    setState(()=>_statusCountry = true);
                    
                  else
                    setState(()=>_statusCountry = false);
                },
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].accountName,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                  BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                ], 
                decoration: InputDecoration(
                  labelText: 'Nombre de la cuenta',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNameBankingUSD = value,
                validator: _validateName,
                textInputAction: TextInputAction.next,
                focusNode: _accountNameBankingUSDFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_accountNumberBankingUSDFocus),
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].accountNumber,
                autofocus: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Cuenta',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNumberBankingUSD = value,
                validator: (value) => value.length <=4? "Ingrese numero de cuenta válido" : null ,
                focusNode: _accountNumberBankingUSDFocus,
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: SearchableDropdown.single(
                items: _statusCountry? listBankUSA.map((result) {
                    return (DropdownMenuItem(
                        child: Text(result), value: result));
                  }).toList()
                : listBankPanama.map((result) {
                    return (DropdownMenuItem(
                        child: Text(result), value: result));
                  }).toList(),
                value: _nameBankingUSD,
                hint: "Nombre del Banco",
                searchHint: null,
                onChanged: (value)=> _nameBankingUSD = value,
                dialogBox: false,
                isExpanded: true,
                validator: (value) => value == null && _statusClickUSD? "Ingrese el nombre del banco correctamente": null,
                menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].route,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                maxLength: 9,
                decoration: InputDecoration(
                  labelText: 'Ruta o Aba (si es USA)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _routeBankingUSD = value,
                validator: (value) => value.length != 9 && _statusCountry? "Ingrese numero de ruta o aba válido" : null ,
                textInputAction: TextInputAction.next,
                focusNode: _routeBankingUSDFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_swiftBankingUSDFocus),
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].swift,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Swift (si es Usa)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _swiftBankingUSD = value,
                validator: (value) => (!(value.length >=8 && value.length <=11)) && _statusCountry? "Ingrese el Swift válido": null,
                textInputAction: TextInputAction.next,
                focusNode: _swiftBankingUSDFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_addressBankingUSDFocus),
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].address,
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
                onSaved: (String value) => _addressBankingUSD = value,
                validator: _validateAddress,
                textInputAction: TextInputAction.next,
                focusNode: _addressBankingUSDFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_accountTypeBankingUSDFocus),
                cursorColor: colorGreen,
              ),
            ),
                     
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[0] == null? '' : myProvider.dataBankUser[0].accountType,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                maxLength: 1,
                decoration: InputDecoration(
                  labelText: 'Tipo de cuenta (C o A)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountTypeBankingUSD = value,
                validator: (value) => value.toLowerCase() != 'c' || value.toLowerCase() != 'c'? "Ingrese tipo de cuenta válido": null,
                textInputAction: TextInputAction.done,
                focusNode: _accountTypeBankingUSDFocus,
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                  buttonClickSaveBanking(); //TODO:falta
                },
                cursorColor: colorGreen,
              ),
            ),

            buttonSave("Banking"),
          ],
        ),
      );
    }else{
      return new Form(
        key: _formKeyBankingBs,
        child: new ListView(
          padding: EdgeInsets.only(top: 0),
          controller: _scrollController,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[1] == null? '' : myProvider.dataBankUser[1].accountName,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                  BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                ], 
                decoration: InputDecoration(
                  labelText: 'Nombre de la cuenta',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNameBankingBs = value,
                validator: _validateName,
                textInputAction: TextInputAction.next,
                focusNode: _accountNameBankingBsFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_accountNumberBankingBsFocus),
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[1] == null? '' : myProvider.dataBankUser[1].idCard,
                autofocus: false,
                keyboardType: TextInputType.text,
                textCapitalization:TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Cedula (V-123456789)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _idCardBankingBs = value,
                validator: _validateIdCard,
                focusNode: _idCardBankingBsFocus,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).requestFocus(_accountNumberBankingBsFocus),
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[1] == null? '' : myProvider.dataBankUser[1].accountNumber,
                autofocus: false,
                keyboardType: TextInputType.number,
                maxLength: 20,
                inputFormatters: [  
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Número de Cuenta',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNumberBankingBs = value,
                validator: (value) => value.length !=20? "Ingrese numero de cuenta válido" : null ,
                focusNode: _accountNumberBankingBsFocus,
                cursorColor: colorGreen,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: SearchableDropdown.single(
                items: listBankBs.map((result) {
                  return (DropdownMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(result['img'], width: size.width / 8, height: size.width / 8),
                          ),
                          SizedBox(width: 5),
                          Expanded(child: Text(result['title']),),
                        ],
                      ),
                      value: result['title']
                    )
                  );
                }).toList(),
                value: myProvider.dataBankUser[1] == null? null : myProvider.dataBankUser[1].bankName,
                hint: "Nombre del Banco",
                searchHint: null,
                onChanged: (value)=> _nameBankingBs = value,
                dialogBox: false,
                isExpanded: true,
                validator: (value) => value == null && _statusClickBs? "Ingrese el nombre del banco correctamente": null,
                menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
              child: new TextFormField(
                initialValue: myProvider.dataBankUser[1] == null? '' : myProvider.dataBankUser[1].accountType,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                maxLength: 1,
                decoration: InputDecoration(
                  labelText: 'Tipo de cuenta (C o A)',
                  labelStyle: TextStyle(
                    color: colorGrey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountTypeBankingBs = value.toUpperCase(),
                validator: (value) => value.toUpperCase() == 'C' || value.toUpperCase() == 'A'? null : "Ingrese tipo de cuenta válido",
                textInputAction: TextInputAction.done,
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                  buttonClickSaveBanking(); //TODO:falta
                },
                cursorColor: colorGreen,
              ),
            ),

            buttonSave("Banking"),
          ],
        ),
      );
    }
  }
  
  String _validateRif(value){
    // This is just a regular expression for RIF
    String p = r'^[c|e|g|j|p|v|C|E|G|J|P|V][-][0-9]+';
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    // The pattern of the RIf didn't match the regex above.
    return 'Ingrese el RIF correctamente';
  }

  String _validateEmail(String value) {
    value = value.trim().toLowerCase();
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty &&regExp.hasMatch(value)) {
      return null;     
    }

    // The pattern of the email didn't match the regex above.
    return 'Ingrese un email válido';
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name and surname didn't match the regex above.
    return 'Ingrese nombre y apellido válido';
  }

  String _validateAddress(String value) {

    if (value.length >=3) {
      // So, the address is valid
      return null;
    }

    // The pattern of the address didn't match the regex above.
    return 'Ingrese una dirección válido';
  }

  String _validatePhone(String value) {
    // This is just a regular expression for phone*$
    String p = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=9) {
      // So, the phone is valid
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese un número de teléfono válido';
  }

  String _validateCountry(value){
    value = value.toLowerCase();
    // This is just a regular expression for RIF
    String p = r'^(panama|panamá|usa)+';
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    // The pattern of the RIf didn't match the regex above.
    return 'Ingrese el país correctamente';
  }

  
  String _validateIdCard(value){
    // This is just a regular expression for RIF
    String p = r'^[c|e|g|j|p|v|C|E|G|J|P|V][-][0-9]+';
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    // The pattern of the RIf didn't match the regex above.
    return 'Ingrese la cedula correctamente';
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget buttonSave(button){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30, right:30, bottom:30),
      child: GestureDetector(
        onTap: () {
          switch (button) {
            case "Company":
              buttonClickSaveCompany();
              break;
            case "User":
              buttonClickSaveUser();
              break;
            case "Contact":
              buttonClickSaveContact();
              break;
            case "Banking":
              setState(() {
                if (_statusCoin == 0){
                  _statusClickUSD = true;
                  _statusClickBs = false;
                }else{
                  _statusClickUSD = false;
                  _statusClickBs = true;
                }
              });
              buttonClickSaveBanking();
              break;
          }
        },
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

  void buttonClickSaveCompany()async{
    if (_formKeyCompany.currentState.validate()) {
      _formKeyCompany.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateUser/",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              'rifCompany': _rifCompany,
              'nameCompany': _nameCompany,
              'addressCompany': _addressCompany,
              'phoneCompany': _phoneCompany,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            showMessageCorrectly("Guardado Correctamente");
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        print("error network");
      } 
    }
  }

  void buttonClickSaveUser()async{
    if (_formKeyUser.currentState.validate()) {
      _formKeyUser.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateUser/",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              'email': _email,
            }),
          ); 

          //TODO: agregar seguridad cambio de email

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
             Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        print("error network");
      } 
    }
  }

  void buttonClickSaveContact()async{
    if (_formKeyContact.currentState.validate()) {
      _formKeyContact.currentState.save();
      _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          response = await http.post(
            urlApi+"updateUser/",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              'name': _name,
              'address': _address,
              'phone': _phone,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            showMessageCorrectly("Guardado Correctamente");
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        print("error network");
      } 
    }
  }

  void buttonClickSaveBanking(){
    if(_statusCoin == 0){
      if (_formKeyBankingUSD.currentState.validate()) {
        _formKeyBankingUSD.currentState.save();
        saveDataBanking();
      }
    }else{
      if (_formKeyBankingBs.currentState.validate()) {
        _formKeyBankingBs.currentState.save();
        saveDataBanking();
      }
    }
  }

  void saveDataBanking()async{
    _onLoading();
      var result, response, jsonResponse;
       try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var myProvider = Provider.of<MyProvider>(context, listen: false);

          var parameters = jsonToUrl(jsonEncode({
              'coin': _statusCoin == 0? "USD" : "Bs",
              'country': _statusCoin == 0? _countryBankingUSD == "usa"? _countryBankingUSD.toUpperCase() : capitalize(_countryBankingUSD) : "Venezuela",
              'accountName': _statusCoin == 0? _accountNameBankingUSD : _accountNameBankingBs,
              'accountNumber': _statusCoin == 0? _accountNumberBankingUSD : _accountNumberBankingBs,
              'idCard': _idCardBankingBs,
              'route': _routeBankingUSD,
              'swift': _swiftBankingUSD,
              'address': _addressBankingUSD,
              'bankName': _statusCoin == 0? _nameBankingUSD : _nameBankingBs,
              'accountType': _statusCoin == 0? _accountTypeBankingUSD : _accountTypeBankingBs,
            }));

          response = await http.get(
            urlApi+"bankUser/$parameters",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
          ); 

          jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            showMessageCorrectly("Guardado Correctamente");
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }  
        }
      } on SocketException catch (_) {
        print("error network");
      } 
  }

  String jsonToUrl(value){
    String parametersUrl="?";
    final json = jsonDecode(value) as Map;
    for (final name in json.keys) {
      final value = json[name];
      parametersUrl = parametersUrl + "$name=$value&";
    }
    
    return parametersUrl.substring(0, parametersUrl.length-1);
  }

  nextPage(page, index)async{
    //setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    //setState(() =>statusButton.remove(index));
    Navigator.push(context, SlideLeftRoute(page: page));
  }
  
  Future<void> _onLoading() async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  Future<void> showMessageCorrectly(_titleMessage) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  "assets/icons/correctly.png",
                  width: size.width / 6,
                  height: size.width / 6,
                )
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  _titleMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width / 20,
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}