
import 'package:ctpaga/views/depositsPage.dart';
import 'package:ctpaga/views/productsPage.dart';
import 'package:ctpaga/views/perfilPage.dart';

import 'package:flutter/material.dart';

//TODO: Url Api (LocalHost)
String urlApi = "http://192.168.1.104:8000/api/auth/";

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
    "page": null,
  },
];

