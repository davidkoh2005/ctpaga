import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/commerce.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
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
  int _statusCoin = 1;
  File _image;
  bool _statusCountry = false, _statusClickUSD = false, _statusClickBs = false;
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  var urlProfileUser;
  
  void initState() {
    super.initState();
    removeCache();
  }

  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Perfil", true),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(top:20, bottom: 5),
                      child: showImage()
                    ),
                    Consumer<MyProvider>(
                      builder: (context, myProvider, child) {
                        if(myProvider.dataCommercesUser.length <=1){
                          return Container(
                            padding: EdgeInsets.only(top:5),
                            child: Center(
                              child: Text(
                                myProvider.dataCommercesUser.length == 0? 'NOMBRE DE LA EMPRESA' : myProvider.dataCommercesUser[myProvider.selectCommerce].name,
                                style: TextStyle(
                                  fontSize: size.width / 14,
                                  color: colorText,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          padding: EdgeInsets.only(top:5),
                          child: Center(
                            child: DropdownButton<Commerce>(
                              value: myProvider.dataCommercesUser[myProvider.selectCommerce],
                              icon: Icon(Icons.arrow_drop_down, color: colorGreen),
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: colorGreen,
                              ),
                              onChanged: (Commerce newValue) {
                                // ignore: unused_local_variable
                                int count = 0;
                                for (var item in myProvider.dataCommercesUser) {
                                  if(item == newValue){
                                    DefaultCacheManager().emptyCache();
                                    myProvider.selectCommerce = count;
                                    break;
                                  }
                                  
                                  count++;
                                }
                              },
                              items: myProvider.dataCommercesUser.map((commerce) {
                                  return DropdownMenuItem<Commerce>(
                                    value: commerce,
                                    child: Text(commerce.name),
                                  );
                              }).toList(),
                            ),
                          ),
                        ); 
                      }
                    ),
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
                            buttonBs(),
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                "< >",
                                style: TextStyle(
                                  color: colorGreen,
                                  fontSize: size.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ),
                            buttonUSD(),
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
    var urlProfile;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if(myProvider.dataPicturesUser != null && myProvider.dataPicturesUser.length != 0){
          //DefaultCacheManager().removeFile(url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg");
          //DefaultCacheManager().emptyCache();


          if(myProvider.dataPicturesUser != null){
            for (var item in myProvider.dataPicturesUser) {
              if(item != null && item.description == 'Profile' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
                urlProfile = item.url;
                break;
              }
            }
            if (urlProfile != null)
            {
              return GestureDetector(
                onTap: () => _showSelectionDialog(context),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: url+urlProfile,
                    fit: BoxFit.cover,
                    height: size.width / 3,
                    width: size.width / 3,
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
          } 
        }

        return GestureDetector(
          onTap: () => _showSelectionDialog(context),
          child: ClipOval(
            child: Image(
              image: AssetImage("assets/icons/addPhoto.png"),
              width: size.width / 3,
              height: size.width / 3,
            ),
          ),
        );
      }
    );
  }

  void removeCache()async{
    var result;
      try {
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          DefaultCacheManager().emptyCache();
        }
      } on SocketException catch (_) {
        print("error network");
      } 
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
        
        //TODO: Eliminar if
        if(!urlApi.contains("herokuapp")){
          String base64Image = base64Encode(File(picture.path).readAsBytesSync());
          String fileName = picture.path.split("/").last;

          var response = await http.post(
            urlApi+"updateUserImg",
            headers:{
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: {
              "image": base64Image,
              "name": fileName,
              "description": "Profile",
              "commerce_id": myProvider.dataCommercesUser.length == 0? '0' : myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
            }
          );

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            DefaultCacheManager().emptyCache();
            setState(() =>_image = File(picture.path));
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }  
        }else{
          Navigator.pop(context);
          showMessage("No se puede guardar la imagen en el servidor", false);
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
          //TODO: Verificar rif
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].rif,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'RIF',
                labelStyle: TextStyle(
                  color: colorText,
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
              initialValue: myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].name,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nombre de la empresa',
                labelStyle: TextStyle(
                  color: colorText
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _nameCompany = value,
              validator: (value) => value.isEmpty? 'Ingrese el nombre de la empresa válido' : null,
              textInputAction: TextInputAction.next,
              focusNode: _nameCompanyFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_addressCompanyFocus),
              cursorColor: colorGreen,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].address,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Dirección',
                labelStyle: TextStyle(
                  color: colorText
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
              initialValue: myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].phone,
              autofocus: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorText
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
              initialValue: myProvider.dataUser == null? '' : myProvider.dataUser.email,
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: colorText
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
              ),
              validator: _validateEmail,
              onSaved: (String value) => _email = value.toLowerCase().trim(),
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
              initialValue: myProvider.dataUser == null ? '' : myProvider.dataUser.name,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ], 
              decoration: InputDecoration(
                labelText: 'Nombre y Apellido',
                labelStyle: TextStyle(
                  color: colorText
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
              initialValue: myProvider.dataUser == null? '' : myProvider.dataUser.address,
              autofocus: false,
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Dirección',
                labelStyle: TextStyle(
                  color: colorText
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
              initialValue: myProvider.dataUser == null? '' : myProvider.dataUser.phone,
              autofocus: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorText
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
      padding: EdgeInsets.only(right:0),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 0), 
        child: Container(
          child: Center(
            child: Text(
              "\$",
              style: TextStyle(
                color: _statusCoin == 0? colorGreen : Colors.grey,
                fontSize: size.width / 15,
                fontWeight: FontWeight.bold,
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
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 1), 
        child: Container(
          child: Center(
            child: Text(
              "Bs",
              style: TextStyle(
                color: _statusCoin == 1? colorGreen : Colors.grey,
                fontSize: size.width / 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }


  Widget formBanking(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    if(_statusCoin == 0){
      setState(() {
        _nameBankingUSD = myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].bankName;
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
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].country,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                  BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                ], 
                decoration: InputDecoration(
                  labelText: 'País (Panamá o USA)',
                  labelStyle: TextStyle(
                    color: colorText
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
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].accountName,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                  BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                ], 
                decoration: InputDecoration(
                  labelText: 'Nombre de la Cuenta',
                  labelStyle: TextStyle(
                    color: colorText
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
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].accountNumber,
                autofocus: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Cuenta',
                  labelStyle: TextStyle(
                    color: colorText
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
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].route,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                maxLength: 9,
                decoration: InputDecoration(
                  labelText: 'Ruta o Aba (si es USA)',
                  labelStyle: TextStyle(
                    color: colorText
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

            //INPUT SWIFT

            /* Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].swift,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Swift (si es Usa)',
                  labelStyle: TextStyle(
                    color: colorText
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
            ), */

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].address,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  labelStyle: TextStyle(
                    color: colorText
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
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].accountType,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                maxLength: 1,
                decoration: InputDecoration(
                  labelText: 'Tipo de cuenta (C o A)',
                  labelStyle: TextStyle(
                    color: colorText
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
                  buttonClickSaveBanking(); 
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
                initialValue: myProvider.dataBanksUser[1] == null? '' : myProvider.dataBanksUser[1].accountName,
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
                initialValue: myProvider.dataBanksUser[1] == null? '' : myProvider.dataBanksUser[1].idCard,
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
                initialValue: myProvider.dataBanksUser[1] == null? '' : myProvider.dataBanksUser[1].accountNumber,
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
                value: myProvider.dataBanksUser[1] == null? null : myProvider.dataBanksUser[1].bankName,
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
                initialValue: myProvider.dataBanksUser[1] == null? '' : myProvider.dataBanksUser[1].accountType,
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
                  buttonClickSaveBanking(); 
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
            urlApi+"updateCommerceUser",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              'rif': _rifCompany,
              'name': _nameCompany,
              'address': _addressCompany,
              'phone': _phoneCompany,
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);

          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
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
            urlApi+"updateUser",
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

          print(jsonResponse);

          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
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
            urlApi+"updateUser",
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
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
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
            urlApi+"updateBankUser/$parameters",
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
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }  
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
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

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
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
              _statusCorrectly? Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.check_circle,
                  color: colorGreen,
                  size: size.width / 8,
                )
              )
              : Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: size.width / 8,
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