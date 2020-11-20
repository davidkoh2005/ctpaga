import 'package:ctpaga/views/productsServicesPage.dart';
import 'package:ctpaga/views/exchangeRatePage.dart';
import 'package:ctpaga/views/newCommercePage.dart';
import 'package:ctpaga/views/salesReportPage.dart';
import 'package:ctpaga/views/documentsPage.dart';
import 'package:ctpaga/views/shippingPage.dart';
import 'package:ctpaga/views/depositsPage.dart';
import 'package:ctpaga/views/discountPage.dart';
import 'package:ctpaga/views/selfiePage.dart';
import 'package:ctpaga/views/perfilPage.dart';
import 'package:ctpaga/views/loginPage.dart';

import 'package:flutter/material.dart';

//TODO: Url Api (LocalHost)
//String url = "http://192.168.1.119:8000";

//TODO: Url Api (AWS)
String url = "http://54.196.181.42";

String urlApi = "$url/api/auth/";

Color colorGreen = Color.fromRGBO(0,204,96,1);
Color colorGrey = Color.fromRGBO(230,230,230,1);
Color colorText = Colors.grey;

String phoneCtpaga = "584141295359";
String messageHelp = "Hola! Necesito ayuda con ";
String recommend = "¡Chequea *Ctpaga* , un app que te deja vender en línea y por redes sociales rápido y fácil! +🛍%EF%B8%8F+📲 \n\n Bájatela aquí: \n iOS: https://www.google.com \n Android: https://play.google.com/";

List listMenu = [
  {
    "title": "Perfil",
    "icon": "assets/icons/perfilMenu.png",
    "page": PerfilPage(),
  },
  {
    "title": "Banco",
    "icon": "assets/icons/depositos.png",
    "page": DepositsPage(),
  },
  {
    "title": "Productos",
    "icon": "assets/icons/productos.png",
    "page": ProductsServicesPage(false),
  },
  {
    "title": "Servicios",
    "icon": "assets/icons/servicios.png",
    "page": ProductsServicesPage(false),
  },
  {
    "title": "Envíos",
    "icon": "assets/icons/envios.png",
    "page": ShippingPage(),
  },
  {
    "title": "Descuento",
    "icon": "assets/icons/descuento.png",
    "page": DiscountPage(),
  },
  {
    "title": "Tasa de cambio",
    "icon": "assets/icons/tasa.png",
    "page": ExchangeRatePage(true),
  },
  {
    "title": "Transacciones",
    "icon": "assets/icons/reporte.png",
    "page": SalesReportPage(true),
  },
  {
    "title": "Agregar comercio",
    "icon": "assets/icons/crearComercio.png",
    "page": NewCommercePage(),
  },
  {
    "title": "Compartir un comercio",
    "icon": "assets/icons/recomendarComercio.png",
    "page": null,
  },
  {
    "title": "Pedir ayuda",
    "icon": "assets/icons/ayuda.png",
    "page": null,
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
    "title": "Agregar selfie",
    "icon": "assets/icons/selfie.png",
    "page": SelfiePage(),
  },
  {
    "title": "Agregar identificacion",
    "icon": "assets/icons/tarjeta-de-identificacion.png",
    "page": DocumentsPage("Identification"),
  },
   {
    "title": "Agregar registro jurídico",
    "icon": "assets/icons/tarjeta-de-identificacion.png",
    "page": DocumentsPage("RIF"),
  },
];

var listBankUSA = [
  {
   "title": "Alex. Brown & Sons",
   "img": "assets/banks/USA/Alex_Brown.png",
  },
  {
   "title": "American Express",
   "img": "assets/banks/USA/American-express.png",
  },
  {
   "title": "Apple Bank for Savings",
   "img": "assets/banks/USA/Apple-bank.png",
  },
  {
   "title": "Bank of America",
   "img": "assets/banks/USA/Bank-of-american.png",
  },
  {
   "title": "Bank One Corporation",
   "img": "assets/banks/USA/Bank-one-corporation.png",
  },
  {
   "title": "BankBoston",
   "img": "assets/banks/USA/Bank-boston.png",
  },
  {
   "title": "BB&T",
   "img": "assets/banks/USA/BBYT.png",
  },
  {
   "title": "BBVA",
   "img": "assets/banks/USA/BBVA.png",
  },
  {
   "title": "Bessemer Trust",
   "img": "assets/banks/USA/Bessemer-trust.png",
  },
  {
   "title": "Chase Manhattan Bank",
   "img": "assets/banks/USA/Chase-manhattan-bank.png",
  },
  {
   "title": "Chemical Bank",
   "img": "assets/banks/USA/Chemical-bank.png",
  },
  {
   "title": "Citibank",
   "img": "assets/banks/USA/citi-bank.png",
  },
  {
   "title": "Citigroup",
   "img": "assets/banks/USA/citi-group.png",
  },
  {
   "title": "Dime Savings Bank of New York",
   "img": "assets/banks/USA/Dime-savings-bank-of-new-york.png",
  },
  {
   "title": "Drexel Burnham Lambert",
   "img": "assets/banks/USA/Dexel-burmham-lambert.png",
  },
  {
   "title": "First Boston",
   "img": "assets/banks/USA/First-Boston.png",
  },
  {
   "title": "Goldman Sachs",
   "img": "assets/banks/USA/Goldman-sachs.png",
  },
  {
   "title": "JP Morgan Chase",
   "img": "assets/banks/USA/JP-Morgan-chase.png",
  },
  {
   "title": "Lehman Brothers",
   "img": "assets/banks/USA/lehman_brothers.png",
  },
  {
   "title": "Merrill Lynch",
   "img": "assets/banks/USA/Merril-lynch.png",
  },
  {
   "title": "Morgan Stanley",
   "img": "assets/banks/USA/Morgan-stanley.png",
  },
  {
   "title": "Santander Bank",
   "img": "assets/banks/USA/Santander-bank.png",
  },
  {
   "title": "SunTrust Banks",
   "img": "assets/banks/USA/Sun-trust-banks.png",
  },
  {
   "title": "Wachovia",
   "img": "assets/banks/USA/Wachovia.png",
  },
  {
   "title": "Washington Mutual",
   "img": "assets/banks/USA/washington-mutual.png",
  },
  {
   "title": "Wells Fargo",
   "img": "assets/banks/USA/Wells-fargo.png",
  },
];

var listBankPanama = [
  {
   "title": "Allbank Corp",
   "img": "assets/banks/Panama/allbank.png",
  },
  {
   "title": "Balboa Bank & Trust Corp",
   "img": "assets/banks/Panama/balboa_bank.png",
  },
  {
   "title": "Banco BCA credomatic",
   "img": "assets/banks/Panama/bacredomatic_logo.png",
  },
  {
   "title": "Banco Aliado, S.A.",
   "img": "assets/banks/Panama/banco_aliado.png",
  },
  {
   "title": "Banco Azteca, S.A.",
   "img": "assets/banks/Panama/banco-azteca-panama-logo.png",
  },
  {
   "title": "Banco Citibank, S.A.",
   "img": "assets/banks/Panama/Citibank-logo.png",
  },
  {
   "title": "Banco Davivienda, S.A.",
   "img": "assets/banks/Panama/davivienda.png",
  },
  {
   "title": "Banco de Bogotá, S.A.",
   "img": "assets/banks/Panama/Banco_de_Bogotá_logo.png",
  },
  {
   "title": "Banco del Pacífico, S.A.",
   "img": "assets/banks/Panama/Banco-del-pacifico.png",
  },
  {
   "title": "Banco Delta, S.A.",
   "img": "assets/banks/Panama/banco-delta.png",
  },
  {
   "title": "Banco Ficohsa, S.A.",
   "img": "assets/banks/Panama/Ficohsa_logo.png",
  },
  {
   "title": "Banco G&T Continental, S.A.",
   "img": "assets/banks/Panama/Logo_G&T.png",
  },
  {
   "title": "Banco Hipotecario Nacional",
   "img": "assets/banks/Panama/Banco_Hipotecario.png",
  },
  {
   "title": "Banco General, S.A.",
   "img": "assets/banks/Panama/banco_general.png",
  },
  {
   "title": "Banco Internacional de Costa Rica S.A",
   "img": "assets/banks/Panama/BICSA.png",
  },
  {
   "title": "Banco La Hipotecaria, S.A.",
   "img": "assets/banks/Panama/BANCO-LA-HIPOTECARIA.png",
  },
  {
   "title": "Banco Lafise Panamá, S.A.",
   "img": "assets/banks/Panama/LA-FISE.png",
  },
  {
   "title": "Banco Latinoamericano de Comercio Exterior, S.A.",
   "img": "assets/banks/Panama/logo_bladex.png",
  },
  {
   "title": "Banco Nacional de Panamá",
   "img": "assets/banks/Panama/Bnp.png",
  },
  {
   "title": "Banco Panamá, S.A",
   "img": "assets/banks/Panama/banco_panama.png",
  },
  {
   "title": "Banco Panameño de la Vivienda, S.A.",
   "img": "assets/banks/Panama/banvivienda.png",
  },
  {
   "title": "Banco Pichincha Panamá, S.A.",
   "img": "assets/banks/Panama/Banco_Pichincha.png",
  },
  {
   "title": "Banco Prival, S.A.",
   "img": "assets/banks/Panama/logo-prival.png",
  },
  {
   "title": "Bancolombia S.A.",
   "img": "assets/banks/Panama/Bancolombia.png",
  },
  {
   "title": "Banesco, S.A.",
   "img": "assets/banks/Panama/logo_banesco.png",
  },
  {
   "title": "BANISI, S.A.",
   "img": "assets/banks/Panama/logo_banisi.png",
  },
  {
   "title": "Banistmo, S.A.",
   "img": "assets/banks/Panama/logo_banistmo.png",
  },
  {
   "title": "Bank Leumi-Le Israel B.M.",
   "img": "assets/banks/Panama/logo_Bank_Leumi.png",
  },
  {
   "title": "Bank of China Limited",
   "img": "assets/banks/Panama/Bank_Of_China_logo.png",
  },
    {
   "title": "BBP Bank, S.A",
   "img": "assets/banks/Panama/BBP-bank.png",
  },
  {
   "title": "BCT Bank, S.A.",
   "img": "assets/banks/Panama/bct_bank.png",
  },
  {
   "title": "Caja de Ahorros",
   "img": "assets/banks/Panama/logo_caja_ahorro.png",
  },
  {
   "title": "Capital Bank Inc.",
   "img": "assets/banks/Panama/capital-bank.png",
  },
  {
   "title": "Credicorp Bank S.A.",
   "img": "assets/banks/Panama/Credicorp-bank.png",
  },
  {
   "title": "Global Bank Corporation",
   "img": "assets/banks/Panama/logo_global_valores.png",
  },
  {
   "title": "Korea Exchange Bank, Ltd.",
   "img": "assets/banks/Panama/Korea-exchage-bank.png",
  },
   {
   "title": "Mega International Commercial Bank Co. Ltd.",
   "img": "assets/banks/Panama/Mega-internacional-commercial-bank.png",
  },
  {
   "title": "Mercantil Bank , S.A.",
   "img": "assets/banks/Panama/mercantil.png",
  },
  {
   "title": "Metrobank, S.A.",
   "img": "assets/banks/Panama/metrobank.png",
  },
  {
   "title": "MMG Bank Corporation",
   "img": "assets/banks/Panama/mmg_bank.png",
  },
  {
   "title": "Multibank Inc.",
   "img": "assets/banks/Panama/multibank.png",
  },
  {
   "title": "St. Georges Bank & Company, Inc",
   "img": "assets/banks/Panama/St-Georges-Bank-Logo.png",
  },
  {
   "title": "The Bank of Nova Scotia",
   "img": "assets/banks/Panama/ScotiaBank.png",
  },
  {
   "title": "Towerbank International Inc.",
   "img": "assets/banks/Panama/towerbank.png",
  },
  {
   "title": "Unibank, S.A.",
   "img": "assets/banks/Panama/unibank.png",
  },

];

var listBankBs = [
  {
   "title": "100% BANCO",
   "img": "assets/banks/Venezuela/100banco.png",
  },
  {
   "title": "BANCAMIGA BANCO MICROFINANCIERO, C.A.",
   "img": "assets/banks/Venezuela/bancamiga.png",
  },
  {
   "title": "BANCARIBE C.A. BANCO UNIVERSAL",
   "img": "assets/banks/Venezuela/bancaribe.png",
  },
  {
   "title": "BANCO ACTIVO BANCO COMERCIAL, C.A.",
   "img": "assets/banks/Venezuela/banco-activo.png",
  },
  {
   "title": "BANCO BICENTENARIO",
   "img": "assets/banks/Venezuela/banco-bicentenario.png",
  },
  {
   "title": "BANCO CARONI, C.A. BANCO UNIVERSAL",
   "img": "assets/banks/Venezuela/banco-caroni.png",
  },
    {
   "title": "BANCO DE LA FANB",
   "img": "assets/banks/Venezuela/banfanb.png",
  },
  {
   "title": "BANCO DE VENEZUELA S.A.I.C.A.",
   "img": "assets/banks/Venezuela/banco-venezuela.png",
  },
  {
   "title": "BANCO DEL TESORO",
   "img": "assets/banks/Venezuela/banco-de-tesoro.png",
  },
  {
   "title": "BANCO EXTERIOR C.A.",
   "img": "assets/banks/Venezuela/Banco-Exterior.png",
  },
  {
   "title": "BANCO INDUSTRIAL DE VENEZUELA",
   "img": "assets/banks/Venezuela/banco-industrial-venezuela.png",
  },
  {
   "title": "BANCO MERCANTIL C.A.",
   "img": "assets/banks/Venezuela/mercantil.png",
  },
  {
   "title": "BANCO NACIONAL DE CRÉDITO",
   "img": "assets/banks/Venezuela/bnc.png",
  },
  {
   "title": "BANCO OCCIDENTAL DE DESCUENTO",
   "img": "assets/banks/Venezuela/bod.png",
  },
  {
   "title": "BANCO PLAZA",
   "img": "assets/banks/Venezuela/banco-plaza.png",
  },
  {
   "title": "BANCO PROVINCIAL BBVA",
   "img": "assets/banks/Venezuela/banco-provincial.png",
  },
  {
   "title": "BANCO VENEZOLANO DE CRÉDITO S.A.",
   "img": "assets/banks/Venezuela/banco-venezolano-credito.png",
  },
  {
   "title": "BANCRECER S.A. BANCO DE DESARROLLO",
   "img": "assets/banks/Venezuela/bancrecer.png",
  },
  {
   "title": "BANESCO BANCO UNIVERSAL",
   "img": "assets/banks/Venezuela/banesco.png",
  },
  {
   "title": "BANPLUS BANCO COMERCIAL C.A",
   "img": "assets/banks/Venezuela/banplus.png",
  },
  {
   "title": "DELSUR BANCO UNIVERSAL",
   "img": "assets/banks/Venezuela/Banco-DelSur.png",
  },
  {
   "title": "BFC BANCO FONDO COMUN",
   "img": "assets/banks/Venezuela/bfc.png",
  },
  {
   "title": "MIBANCO BANCO DE DESARROLLO, C.A.",
   "img": "assets/banks/Venezuela/mi-banco.png",
  },
  {
   "title": "BANCO SOFITASA",
   "img": "assets/banks/Venezuela/banco-sofitasa.png",
  },
];