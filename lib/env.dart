import 'package:ctpaga/views/identificationPage.dart';
import 'package:ctpaga/views/depositsPage.dart';
import 'package:ctpaga/views/productsPage.dart';
import 'package:ctpaga/views/selfiePage.dart';
import 'package:ctpaga/views/perfilPage.dart';
import 'package:ctpaga/views/loginPage.dart';

import 'package:flutter/material.dart';

//TODO: Url Api (LocalHost)
//String url = "http://192.168.1.111:8000";

//TODO: Url Api (heroku)
String url = "http://ctpaga.herokuapp.com";
String urlApi = "$url/api/auth/";

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
    "title": "Tasa de cambio",
    "icon": "assets/icons/tasa.png",
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

List listMenuDeposits = [
  {
    "title": "Cuenta Bancaria",
    "icon": "assets/icons/depositos.png",
    "page": PerfilPage(),
  },
  {
    "title": "Agregar identificacion",
    "icon": "assets/icons/tarjeta-de-identificacion.png",
    "page": IdentificationPage(),
  },
  {
    "title": "Agregar selfie",
    "icon": "assets/icons/selfie.png",
    "page": SelfiePage(),
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

var listBankPanama = [
  "Allbank Corp",
  "BAC International Bank, Inc.",
  "Balboa Bank & Trust Corp",
  "Banco Aliado S.A.",
  "Banco Azteca (Panamá), S.A.",
  "Banco BAC de Panamá, S.A.",
  "Banco Bolivariano (Panamá), S.A.",
  "Banco Citibank (Panamá,) S.A.",
  "Banco Davivienda (Panamá) S.A.",
  "Banco de Bogotá, S.A.",
  "Banco del Pacífico (Panamá), S.A.",
  "Banco Delta, S.A.",
  "Banco Ficohsa (Panamá), S.A.",
  "Banco G&T Continental (Panamá) S.A. (BMF)",
  "Banco HIPOTECARIO NACIONAL",
  "Banco General, S.A.",
  "Banco Internacional de Costa Rica, S.A (BICSA)",
  "Banco La Hipotecaria, S.A.",
  "Banco Lafise Panamá S.A.",
  "Banco Latinoamericano de Comercio Exterior, S.A. (BLADEX)",
  "Banco Nacional de Panamá",
  "Banco Panamá, S.A",
  "Banco Panameño de la Vivienda, S.A. (BANVIVIENDA)",
  "Banco Pichincha Panamá, S.A.",
  "Banco Prival, S.A. (Español) o Prival Bank, S.A. (en inglés)",
  "Banco Universal, S.A.",
  "Bancolombia S.A.",
  "Banesco S.A.",
  "BANISI, S.A.",
  "Banistmo S.A.",
  "Bank Leumi-Le Israel B.M.",
  "Bank of China Limited",
  "BBP Bank S.A.",
  "BCT Bank International S.A.",
  "Caja de Ahorros",
  "Capital Bank Inc.",
  "Citibank, N.A. Sucursal Panamá",
  "Credicorp Bank S.A.",
  "FPB Bank Inc.",
  "Global Bank Corporation",
  "Korea Exchange Bank, Ltd.",
  "Mega International Commercial Bank Co. Ltd.",
  "Mercantil Bank (Panamá), S.A.",
  "Metrobank, S.A.",
  "MiBanco, S.A.BMF",
  "MMG Bank Corporation",
  "Multibank Inc.",
  "Produbank (Panamá) S.A.",
  "St. Georges Bank & Company, Inc.",
  "The Bank of Nova Scotia (Panamá), S.A.",
  "The Bank of Nova Scotia (SCOTIABANK)",
  "Towerbank International Inc.",
  "Unibank, S.A.",
];

var listBankBs = [
  {
   "title": "100% BANCO",
   "img": "assets/banks/Bs/100banco.png",
  },
  {
   "title": "BANCAMIGA BANCO MICROFINANCIERO, C.A.",
   "img": "assets/banks/Bs/bancamiga.png",
  },
  {
   "title": "BANCARIBE C.A. BANCO UNIVERSAL",
   "img": "assets/banks/Bs/bancaribe.png",
  },
  {
   "title": "BANCO ACTIVO BANCO COMERCIAL, C.A.",
   "img": "assets/banks/Bs/banco-activo.png",
  },
  {
   "title": "BANCO BICENTENARIO",
   "img": "assets/banks/Bs/banco-bicentenario.png",
  },
  {
   "title": "BANCO CARONI, C.A. BANCO UNIVERSAL",
   "img": "assets/banks/Bs/banco-caroni.png",
  },
    {
   "title": "BANCO DE LA FANB",
   "img": "assets/banks/Bs/banfanb.png",
  },
  {
   "title": "BANCO DE VENEZUELA S.A.I.C.A.",
   "img": "assets/banks/Bs/banco-venezuela.png",
  },
  {
   "title": "BANCO DEL TESORO",
   "img": "assets/banks/Bs/banco-de-tesoro.png",
  },
  {
   "title": "BANCO EXTERIOR C.A.",
   "img": "assets/banks/Bs/Banco-Exterior.png",
  },
  {
   "title": "BANCO INDUSTRIAL DE VENEZUELA",
   "img": "assets/banks/Bs/banco-industrial-venezuela.png",
  },
  {
   "title": "BANCO MERCANTIL C.A.",
   "img": "assets/banks/Bs/mercantil.png",
  },
  {
   "title": "BANCO NACIONAL DE CRÉDITO",
   "img": "assets/banks/Bs/bnc.png",
  },
  {
   "title": "BANCO OCCIDENTAL DE DESCUENTO",
   "img": "assets/banks/Bs/bod.png",
  },
  {
   "title": "BANCO PLAZA",
   "img": "assets/banks/Bs/banco-plaza.png",
  },
  {
   "title": "BANCO PROVINCIAL BBVA",
   "img": "assets/banks/Bs/banco-provincial.png",
  },
  {
   "title": "BANCO VENEZOLANO DE CRÉDITO S.A.",
   "img": "assets/banks/Bs/banco-venezolano-credito.png",
  },
  {
   "title": "BANCRECER S.A. BANCO DE DESARROLLO",
   "img": "assets/banks/Bs/bancrecer.png",
  },
  {
   "title": "BANESCO BANCO UNIVERSAL",
   "img": "assets/banks/Bs/banesco.png",
  },
  {
   "title": "BANPLUS BANCO COMERCIAL C.A",
   "img": "assets/banks/Bs/banplus.png",
  },
  {
   "title": "DELSUR BANCO UNIVERSAL",
   "img": "assets/banks/Bs/Banco-DelSur.png",
  },
  {
   "title": "BFC BANCO FONDO COMUN",
   "img": "assets/banks/Bs/bfc.png",
  },
  {
   "title": "MIBANCO BANCO DE DESARROLLO, C.A.",
   "img": "assets/banks/Bs/mi-banco.png",
  },
  {
   "title": "BANCO SOFITASA",
   "img": "assets/banks/Bs/banco-sofitasa.png",
  },
];