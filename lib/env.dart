
import 'package:ctpaga/views/depositsPage.dart';
import 'package:ctpaga/views/loginPage.dart';
import 'package:ctpaga/views/productsPage.dart';
import 'package:ctpaga/views/perfilPage.dart';

import 'package:flutter/material.dart';

//TODO: Url Api (LocalHost)
String url = "192.168.1.117:8000";
String urlApi = "http://$url/api/auth/";

Color colorGreen = Color.fromRGBO(0,204,96,1);
Color colorGrey = Color.fromRGBO(230,230,230,1);


List listMenu = [
  {
    "title": "Perfil",
    "icon": "assets/icons/perfilMenu.png",
    "page": PerfilPage(),
  },
  {
    "title": "Depósitos",
    "icon": "assets/icons/depositos.png",
    "page": DepositsPage(),
  },
  {
    "title": "Productos",
    "icon": "assets/icons/productos.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Envios",
    "icon": "assets/icons/envios.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Códigos de descuento",
    "icon": "assets/icons/descuento.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Reporte de ventas",
    "icon": "assets/icons/reporte.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Crear otro comercio",
    "icon": "assets/icons/crearComercio.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Recomentar a un comercio",
    "icon": "assets/icons/recomendarComercio.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Pedir ayuda",
    "icon": "assets/icons/ayuda.png",
    "page": ProductsPage(false),
  },
  {
    "title": "Cerrar sesión",
    "icon": "",
    "page": LoginPage(),
  },
];

var listBankUSA = [
  "Alex. Brown & Sons",
  "American Express",
  "Apple Bank for Savings",
  "Bank of America",
  "Bank One Corporation",
  "BankBoston",
  "BB&T",
  "BBVA",
  "Bessemer Trust",
  "Brooklyn Savings Bank",
  "Chase Manhattan Bank",
  "Chemical Bank",
  "Citibank",
  "Citigroup",
  "Dime Savings Bank of New York",
  "Dime Savings Bank of Williamsburgh",
  "Drexel Burnham Lambert",
  "First Boston",
  "Goldman Sachs",
  "Greenwich Savings Bank",
  "JP Morgan Chase",
  "Lehman Brothers",
  "Merrill Lynch",
  "Moore Capital Management",
  "Morgan Stanley",
  "New York Savings Bank",
  "Primer Banco de los Estados Unidos",
  "Riggs Bank",
  "Salomon Brothers",
  "Santander Bank",
  "State Street Corporation",
  "SunTrust Banks",
  "Wachovia",
  "Washington Mutual",
  "Wells Fargo"
  "White Weld & Co.",
];

var listBankBs = [
 "100% BANCO",
 "ABN AMRO BANK",
 "BANCAMIGA BANCO MICROFINANCIERO, C.A.",
 "BANCO ACTIVO BANCO COMERCIAL, C.A.",
 "BANCO AGRICOLA",
 "BANCO BICENTENARIO",
 "BANCO CARONI, C.A. BANCO UNIVERSAL",
 "BANCO DE DESARROLLO DEL MICROEMPRESARIO",
 "BANCO DE VENEZUELA S.A.I.C.A.",
 "BANCO DEL CARIBE C.A.",
 "BANCO DEL PUEBLO SOBERANO C.A.",
 "BANCO DEL TESORO",
 "BANCO ESPIRITO SANTO, S.A.",
 "BANCO EXTERIOR C.A.",
 "BANCO INDUSTRIAL DE VENEZUELA",
 "BANCO INTERNACIONAL DE DESARROLLO, C.A.",
 "BANCO MERCANTIL C.A.",
 "BANCO NACIONAL DE CRÉDITO",
 "BANCO OCCIDENTAL DE DESCUENTO",
 "BANCO PLAZA",
 "BANCO PROVINCIAL BBVA",
 "BANCO VENEZOLANO DE CRÉDITO S.A.",
 "BANCRECER S.A. BANCO DE DESARROLLO",
 "BANESCO BANCO UNIVERSAL"  ,
 "BANFANB",
 "BANGENTE",
 "BANPLUS BANCO COMERCIAL C.A",
 "CITIBANK",
 "CORP BANCA",
 "DELSUR BANCO UNIVERSAL",
 "FONDO COMUN",
 "INSTITUTO MUNICIPAL DE CRÉDITO POPULAR",
 "MIBANCO BANCO DE DESARROLLO, C.A.",
 "SOFITASA",
];