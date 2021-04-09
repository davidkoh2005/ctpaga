import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/commerce.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/updatePasswordPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  final _formKeyCompany = new GlobalKey<FormState>();
  final _formKeyUser = new GlobalKey<FormState>();
  final _formKeyContact = new GlobalKey<FormState>();
  final _formKeyBankingUSD = new GlobalKey<FormState>();
  final _formKeyBankingBs = new GlobalKey<FormState>();
  final FocusNode _nameCompanyFocus = FocusNode();
  final FocusNode _addressCompanyFocus = FocusNode();  
  final FocusNode _phoneCompanyFocus = FocusNode();
  final FocusNode _userCompanyFocus = FocusNode();
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
  final _controllerUser = TextEditingController();

  String _statusDropdown = "",
         _rifCompany, _nameCompany, _addressCompany, _phoneCompany, _userCompany,
        _email, _name, _address, _phone,
        // ignore: unused_field
        _valueListCountry, _countryBankingUSD, _accountNameBankingUSD, _accountNumberBankingUSD, _routeBankingUSD, _swiftBankingUSD, _addressBankingUSD, _nameBankingUSD, _accountTypeBankingUSD,
        _accountNameBankingBs, _idCardBankingBs, _accountNumberBankingBs,_nameBankingBs, _accountTypeBankingBs;
  String _selectDocument = 'J' , _selectDocumentCompany = 'J';
  List _listDocument = ["R","J","G","C","V","E", "P"], _listDocumentCompany = ["R","J","G","C","V","E", "P"];
  int _statusCoin = 1 , _positionDocument = 1 , _positionDocumentCompany = 1;
  // ignore: unused_field
  File _image;
  bool _statusCountry = true, _statusClickUSD = false, _statusClickBs = false;
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  var urlProfile;
  double _positionTopFirst = 35,
        _positionTopSecond = 0;

  
  void initState() {
    super.initState();
    initialVariable();
  }

  void dispose(){
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    //myProvider.statusUrlCommerce = myProvider.dataCommercesUser.length == 0? false : true;
    _controllerUser.text = myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl;
    setState(() {
      _valueListCountry = myProvider.dataBanksUser[0] == null? 'USA' : myProvider.dataBanksUser[0].country;
      _statusCountry = myProvider.dataBanksUser[0] == null? true: myProvider.dataBanksUser[0].country == 'USA'? true : false;
      _nameBankingUSD = myProvider.dataBanksUser[0] == null? null : myProvider.dataBanksUser[0].bankName; 
      _nameBankingBs = myProvider.dataBanksUser[1] == null? null : myProvider.dataBanksUser[1].bankName;

      _positionDocumentCompany = myProvider.dataCommercesUser.length == 0? 1 : myProvider.dataCommercesUser[myProvider.selectCommerce].rif.length == 0? 1 : _listDocumentCompany.indexOf(myProvider.dataCommercesUser[myProvider.selectCommerce].rif.substring(0,1).toUpperCase());
      _selectDocumentCompany = _listDocumentCompany[_positionDocumentCompany];
      
      _positionDocument = myProvider.dataBanksUser[1] == null? 1 : _listDocument.indexOf(myProvider.dataBanksUser[1].idCard.substring(0,1).toUpperCase());
      _selectDocument = _listDocument[_positionDocument];
    });
    
  }


  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if(myProvider.statusButtonMenu){
          myProvider.statusButtonMenu = false;
          return false;
        }else{
          myProvider.clickButtonMenu = 0;
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
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
                          padding: EdgeInsets.only(bottom: 5),
                          child: showImage()
                        ),
                        Consumer<MyProvider>(
                          builder: (context, myProvider, child) {
                            if(myProvider.dataCommercesUser.length <=1){
                              return Container(
                                padding: EdgeInsets.only(top:5, bottom: 5),
                                child: Center(
                                  child: AutoSizeText(
                                    myProvider.dataCommercesUser.length == 0? 'NOMBRE DE LA EMPRESA' : myProvider.dataCommercesUser[myProvider.selectCommerce].name == ''? 'NOMBRE DE LA EMPRESA' : myProvider.dataCommercesUser[myProvider.selectCommerce].name,
                                    style: TextStyle(
                                      color: colorText,
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize:14
                                    ),
                                    maxFontSize: 14,
                                    minFontSize: 14,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              padding: EdgeInsets.only(top:5, bottom: 5),
                              child: Center(
                                child: DropdownButton<Commerce>(
                                  value: myProvider.dataCommercesUser[myProvider.selectCommerce],
                                  icon: Icon(Icons.arrow_drop_down, color: colorGreen),
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: colorGreen,
                                  ),
                                  onChanged: (Commerce newValue) async{
                                    int count = 0;
                                    if(myProvider.dataCommercesUser[myProvider.selectCommerce].id != newValue.id){
                                      for( var i = 0 ; i <= myProvider.dataCommercesUser.length; i++ ) {
                                        if(myProvider.dataCommercesUser[i].id == newValue.id){
                                          count = i;
                                          break;
                                        }
                                      }
                                      DefaultCacheManager().emptyCache();

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      myProvider.selectCommerce = count;
                                      prefs.setInt('selectCommerce', count);
                                      _onLoading();
                                      await myProvider.getDataUser(false, true, context);
                                      _controllerUser.clear();
                                      _controllerUser.text = myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl;
                                      setState(() {
                                        urlProfile = null;
                                        _statusDropdown = '';
                                      });
                                    }
                                  },
                                  style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize:14
                                  ),
                                  items: myProvider.dataCommercesUser.map((commerce) {
                                      return DropdownMenuItem<Commerce>(
                                        value: commerce,
                                        child: Container(
                                          child: AutoSizeText(
                                            commerce.name == ''? 'NOMBRE DE LA EMPRESA' : commerce.name,
                                            style: TextStyle(
                                              color: colorText,
                                              fontFamily: 'MontserratSemiBold',
                                              fontSize:14
                                            ),
                                            maxFontSize: 18,
                                            minFontSize: 18,
                                          ),
                                        ),
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
                          child: GestureDetector(
                            onTap: () async {
                              setState(() => _statusCoin = _statusCoin == 0 ? 1 : 0);
                              await Future.delayed(Duration(milliseconds: 200));
                              setState(() {
                                _positionTopFirst == 0? _positionTopFirst = 35 : _positionTopFirst = 0; 
                                _positionTopSecond == 0? _positionTopSecond = 35 : _positionTopSecond = 0; 
                              }); 
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(left:20, top: 15),
                                width: size.width / 3,
                                height: size.width / 3.5,
                                child: Stack(
                                  children: _statusCoin == 0 ?[
                                    coinSecond(),
                                    coinFirst(),
                                  ]
                                  :
                                  [
                                    coinFirst(),
                                    coinSecond(),
                                  ],
                                ),
                              )
                            )
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
            Consumer<MyProvider>(
              builder: (context, myProvider, child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds:250),
                  top: 0,
                  bottom: 0,
                  left: myProvider.statusButtonMenu? 0 : -size.width,
                  right: myProvider.statusButtonMenu? 0 : size.width,
                  child: MenuPage(),
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Widget coinSecond(){
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopSecond,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopSecond == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopSecond == 0? colorGreen : colorGrey,
          ),
          child: Container(
            child: AutoSizeText(
              "Bs",
              style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
              maxFontSize: 18,
              minFontSize: 18,
            )
          ),
        )
      ),
    );
  }

  Widget coinFirst(){
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopFirst,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopFirst == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopFirst == 0? colorGreen : colorGrey,
          ),
          child: AutoSizeText(
            "\$" ,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'MontserratSemiBold',
              fontSize:14
            ),
            maxFontSize: 18,
            minFontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget showImage(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if(myProvider.dataPicturesUser != null && myProvider.dataPicturesUser.length != 0){
          //DefaultCacheManager().removeFile(url+"/storage/Users/${myProvider.dataUser.id}/Profile.jpg");
          //DefaultCacheManager().emptyCache();

          if(myProvider.dataPicturesUser != null){
            if(urlProfile != null)
              if(urlProfile.indexOf('/storage/Users/')<0){
                DefaultCacheManager().emptyCache();
                urlProfile = null;
              }

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
                  child: new CachedNetworkImage(
                    imageUrl: "http://"+url+urlProfile,
                    fit: BoxFit.cover,
                    height: size.width / 3.5,
                    width: size.width / 3.5,
                    placeholder: (context, url) {
                      return Container(
                        margin: EdgeInsets.all(15),
                        child:CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8),
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

  Future<void> _showSelectionDialog(BuildContext context) {
    
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
                  title: new AutoSizeText(
                    "Galeria",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                  onTap: () => _getImage(context, ImageSource.gallery),       
                ),
                new ListTile(
                  leading: new Icon(Icons.camera, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Camara",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
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

    var cropped;

    if(picture != null){
      cropped = await ImageCropper.cropImage(
        sourcePath: picture.path,
        aspectRatio:  CropAspectRatio(
          ratioX: 1, ratioY: 1
        ),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Editar Foto",
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.black,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Editar Foto',
        )
      );

      if(cropped != null){

        Navigator.of(context).pop();

        _onLoading();
        try
        {
          String base64Image = base64Encode(cropped.readAsBytesSync());
          var response = await http.post(
            urlApi+"updateUserImg",
            headers:{
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: {
              "image": base64Image,
              "description": "Profile",
              "commerce_id": myProvider.dataCommercesUser.length == 0? '0' : myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
              "urlPrevious": urlProfile== null? '' : urlProfile,
            }
          );

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            setState(() =>_image = cropped);
            await myProvider.getDataUser(false, true, context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }  
        }on SocketException catch (_) {
          print("error network");
        }
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
          color: colorGreyOpacity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AutoSizeText(
                _title,
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
                maxFontSize: 14,
                minFontSize: 14,
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
    var size = MediaQuery.of(context).size;
    return new Form(
      key: _formKeyCompany,
      child: new ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: AutoSizeText(
                "Rif",
                style: TextStyle(
                  color:colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: Row(
              children : [
                new PopupMenuButton(
                  child: Container(
                    width: size.width / 3.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectDocumentCompany,
                          style: TextStyle(
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
                          ),
                        ),
                        Icon(Icons.arrow_drop_down_sharp, color: colorGreen,),
                      ],
                    )
                  ),
                  onSelected: (value) => setState(() => _selectDocumentCompany = value),
                  itemBuilder: (BuildContext bc) {
                    return _listDocumentCompany.map((document) =>
                      PopupMenuItem(
                        child: CheckedPopupMenuItem(
                          checked: _selectDocumentCompany == document,
                          value: document,
                          child: new Text(document),
                        ),
                      ),
                    ).toList();
                  }
                ),
                Container(
                  padding: EdgeInsets.only(left:10),
                  width: size.width - 175,
                  child: new TextFormField(
                    initialValue:  myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].rif.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].rif.substring(2),
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textCapitalization:TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: '123456789',
                      labelStyle: TextStyle(
                        color: colorText,
                        fontFamily: 'MontserratSemiBold',
                        fontSize:14
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorGreen),
                      ),
                    ),
                    onSaved: (String value) => _rifCompany = _selectDocumentCompany+"-"+value,
                    validator: _validateRif,
                    textInputAction: TextInputAction.next,
                    cursorColor: colorGreen,
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
                    ),
                  )
                ),
              ],
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
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14,
              ),
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
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              )
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              initialValue: myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].phone,
              autofocus: false,
              keyboardType: TextInputType.phone,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGreen),
                ),
              ),
              onSaved: (String value) => _phoneCompany = value,
              validator: _validatePhone,
              focusNode: _phoneCompanyFocus,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_userCompanyFocus),
              cursorColor: colorGreen,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
            ),
          ),

          Consumer<MyProvider>(
            builder: (context, myProvider, child) {
              
              return Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new TextFormField(
                        controller: _controllerUser,
                        autofocus: false,
                        focusNode: _userCompanyFocus,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z 0-9]")),
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorGreen),
                          ),
                          prefixText: url+"/",
                          prefixStyle: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
                          ),
                        ),
                        validator: _validateUrl,
                        onSaved: (String value) => _userCompany = value,
                        onFieldSubmitted: (term){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          verifyUrl(_controllerUser.text).then((_)=> buttonClickSaveCompany());
                        },
                        cursorColor: colorGreen,
                        style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          fontSize:14
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _controllerUser.text.length!=0? !myProvider.statusUrlCommerce : false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.00),
                        child: new AutoSizeText(
                          "Usuario ingresado ya existe",
                          style: TextStyle(
                            color:Colors.red,
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              );
            }
          ),

          buttonSave("Company"),
        ],
      ),
    );
  }

  verifyUrl(value)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    var userCommerce = myProvider.dataCommercesUser.length == 0? '' : myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl;
    if(userCommerce == value){
      myProvider.statusUrlCommerce = true;
      return true;
    }else{
      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await http.post(
            urlApi+"verifyUrl",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: jsonEncode({
              "userUrl": value,
            }),

          ); 

          var jsonResponse = jsonDecode(response.body); 

          if (jsonResponse['statusCode'] == 201) {
            myProvider.statusUrlCommerce = true;
            return true;
          }else{
            myProvider.statusUrlCommerce = false;
            return false;
          }
        }
      } on SocketException catch (_) {
        showMessage("Sin conexión a internet", false);
      }
    }
  }

  Widget formUser(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    
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
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: FlatButton(
          
              onPressed: () => nextPage(),
              child: AutoSizeText(
                "Cambiar contraseña",
                style: TextStyle(
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
                maxFontSize: 14,
                minFontSize: 14,
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
              decoration: InputDecoration(
                labelText: 'Nombre y Apellido',
                labelStyle: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
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
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
            child: new TextFormField(
              initialValue: myProvider.dataUser == null? '' : myProvider.dataUser.phone,
              autofocus: false,
              keyboardType: TextInputType.phone,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
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
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
            ),
          ),

          buttonSave("Contact"),
        ],
      ),
    );
  }

  Widget formBanking(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    var _listCountry = ['Panamá','USA'];
    if(_statusCoin == 0){
      return new Form(
        key: _formKeyBankingUSD,
        child: new ListView(
          padding: EdgeInsets.only(top: 0),
          controller: _scrollController,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: AutoSizeText(
                "Pais",
                style: TextStyle(
                  color:colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: DropdownButton<String>(
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  color: Colors.black,
                ),
                value: _valueListCountry,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: colorGreen),
                elevation: 16,
                items: _listCountry.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String value) {                  
                  setState(() {
                    if(value == "USA")
                      _statusCountry = true;
                    else
                      _statusCountry = false;

                    _valueListCountry = value;
                    _countryBankingUSD = value;

                  });
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: new TextFormField(
                initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].accountName,
                autofocus: false,
                textCapitalization:TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Cuenta',
                  labelStyle: TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
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
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                )
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
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNumberBankingUSD = value,
                validator: (value) => value.length <=7 && value.length >=20? "Ingrese numero de cuenta válido" : null ,
                focusNode: _accountNumberBankingUSDFocus,
                cursorColor: colorGreen,
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: AutoSizeText(
                "Nombre del banco",
                style: TextStyle(
                  color:colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: SearchableDropdown.single(
                displayClearIcon: false,
                items: _statusCountry? listBankUSA.map((result) {
                    return (DropdownMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(result['img'], width: size.width / 8, height: size.width / 8),
                          ),
                          SizedBox(width: 20),
                          Expanded(child: AutoSizeText(
                            result['title'],
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize:14
                            ),
                          ),),
                        ],
                      ),
                      value: result['title']
                    )
                  );
                }).toList()
                : listBankPanama.map((result) {
                    return (DropdownMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(result['img'], width: size.width / 8, height: size.width / 8),
                          ),
                          SizedBox(width: 20),
                          Expanded(child: AutoSizeText(
                            result['title'],
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize:14
                            ),
                          ),),
                        ],
                      ),
                      value: result['title']
                    )
                  );
                }).toList(),
                closeButton: "Cerrar",
                hint: _nameBankingUSD,
                searchHint: "Nombre del Banco",
                keyboardType: TextInputType.text,
                onChanged: (value)=> setState(()=>_nameBankingUSD = value),
                isExpanded: true,
                validator: (value) => _nameBankingUSD == null && _statusClickUSD? "Ingrese el nombre del banco correctamente": null,
              ),
            ),

            Visibility(
              visible: _statusCountry,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].route == "null"? "" : myProvider.dataBanksUser[0].route,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences,
                  maxLength: 9,
                  decoration: InputDecoration(
                    labelText: 'Ruta o Aba',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
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
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                ),
              )
            ),

            //INPUT SWIFT

            /* Visibility(
              visible: _statusCountry,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child: new TextFormField(
                  initialValue: myProvider.dataBanksUser[0] == null? '' : myProvider.dataBanksUser[0].swift,
                  autofocus: false,
                  textCapitalization:TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Swift (si es Usa)',
                    labelStyle: TextStyle(
                      color: colorText,
                      fontFamily: 'MontserratSemiBold',
                      fontSize:14
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
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                )
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
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
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
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
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
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountTypeBankingUSD = value.toUpperCase(),
                validator: (value) => value.toUpperCase() == 'C' || value.toUpperCase() == 'A'? null : "Ingrese tipo de cuenta válido",
                textInputAction: TextInputAction.done,
                focusNode: _accountTypeBankingUSDFocus,
                onEditingComplete: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                  buttonClickSaveBanking(); 
                },
                cursorColor: colorGreen,
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                )
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
                decoration: InputDecoration(
                  labelText: 'Nombre de la cuenta',
                  labelStyle: TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
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
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: AutoSizeText(
                "Rif o Cedula",
                style: TextStyle(
                  color:colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: Row(
                children : [
                  new PopupMenuButton(
                    child: Container(
                      width: size.width / 3.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectDocument,
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize:14
                            ),
                          ),
                          Icon(Icons.arrow_drop_down_sharp, color: colorGreen,),
                        ],
                      )
                    ),
                    onSelected: (value) => setState(() => _selectDocument = value),
                    itemBuilder: (BuildContext bc) {
                      return _listDocument.map((document) =>
                        PopupMenuItem(
                          child: CheckedPopupMenuItem(
                            checked: _selectDocument == document,
                            value: document,
                            child: new Text(document),
                          ),
                        ),
                      ).toList();
                    }
                  ),
                  Container(
                    padding: EdgeInsets.only(left:10),
                    width: size.width - 175,
                    child: new TextFormField(
                      initialValue: myProvider.dataBanksUser[1] == null? '' : myProvider.dataBanksUser[1].idCard.substring(2),
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      textCapitalization:TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: '123456789',
                        labelStyle: TextStyle(
                          color: colorText,
                          fontFamily: 'MontserratSemiBold',
                          fontSize:14
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorGreen),
                        ),
                      ),
                      onSaved: (String value) => _idCardBankingBs = _selectDocument+"-"+value,
                      validator: _validateIdCard,
                      focusNode: _idCardBankingBsFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(_accountNumberBankingBsFocus),
                      cursorColor: colorGreen,
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        fontSize:14
                      ),
                    )
                  ),
                ],
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
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Número de Cuenta',
                  labelStyle: TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorGreen),
                  ),
                ),
                onSaved: (String value) => _accountNumberBankingBs = value,
                validator: (value) => value.length !=20? "Ingrese numero de cuenta válido" : null ,
                focusNode: _accountNumberBankingBsFocus,
                cursorColor: colorGreen,
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: AutoSizeText(
                "Nombre del banco",
                style: TextStyle(
                  color:colorText,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: SearchableDropdown.single(
                displayClearIcon: false,
                items: listBankBs.map((result) {
                  return (DropdownMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(result['img'], width: size.width / 8, height: size.width / 8),
                          ),
                          SizedBox(width: 20),
                          Expanded(child: AutoSizeText(
                            result['title'],
                            style: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize:14
                            ),
                          ),),
                        ],
                      ),
                      value: result['title'],
                    )
                  );
                }).toList(),
                hint: _nameBankingBs,
                searchHint: "Nombre del Banco",
                closeButton: "Cerrar",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                ),
                keyboardType: TextInputType.text,
                onChanged: (String newItem) {
                  setState((){_nameBankingBs = newItem;});
                },
                isExpanded: true,
                validator: (value) => _nameBankingBs == null && _statusClickBs? "Ingrese el nombre del banco correctamente": null,
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
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
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
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  fontSize:14
                )
              ),
            ),

            buttonSave("Banking"),
          ],
        ),
      );
    }
  }
  
  String _validateRif(value){
    value = _selectDocumentCompany+"-"+value;
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
    String p = r'^(?:(\+)58|0)(?:2(?:12|4[0-9]|5[1-9]|6[0-9]|7[0-8]|8[1-35-8]|9[1-5]|3[45789])|4(?:1[246]|2[46]))\d{7}$';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=9) {
      // So, the phone is valid
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese un número de teléfono válido';
  }

  String _validateUrl(String value) {
    // This is just a regular expression for userUrl*$

    if (value.length >=4) {
      // So, the userUrl is valid
      return null;
    }

    // The pattern of the userUrl didn't match the regex above.
    return 'Ingrese un usuario correctamente';
  }
  
  String _validateIdCard(value){
    value = _selectDocument+"-"+value;

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
              verifyUrl(_controllerUser.text).then((_)=> buttonClickSaveCompany());
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
            color: colorGreen,
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: AutoSizeText(
              "GUARDAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
                fontSize:14
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),
      )
    );
  }

  void buttonClickSaveCompany()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    await verifyUrl(_controllerUser.text);
    if (_formKeyCompany.currentState.validate() && myProvider.statusUrlCommerce) {
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
              'commerce_id': myProvider.dataCommercesUser.length != 0? myProvider.dataCommercesUser[myProvider.selectCommerce].id : 0,
              'userUrl': _userCompany
            }),
          ); 

          jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);

          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            await myProvider.getDataUser(false, false, context);
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

          jsonResponse = jsonDecode(response.body); 

          print(jsonResponse);

          if (jsonResponse['statusCode'] == 201) {
            setState(() => _statusDropdown = "");
            await myProvider.getDataUser(false, false, context);
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
            await myProvider.getDataUser(false, false, context);
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
            'country': _statusCoin == 0? _valueListCountry : "Venezuela",
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
          await myProvider.getDataUser(false, false, context);
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

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    Navigator.push(context, SlideLeftRoute(page: UpdatePasswordPage()));
  }
  
  Future<void> _onLoading() async {
    
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
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'MontserratSemiBold',
                            fontSize:14
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

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: true,
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
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}