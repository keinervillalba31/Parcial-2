import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'SneakHub'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a SneakHub'**
  String get welcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tus credenciales para continuar'**
  String get loginSubtitle;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'El correo es obligatorio'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo válido'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es obligatoria'**
  String get passwordRequired;

  /// No description provided for @passwordMin.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 4 caracteres'**
  String get passwordMin;

  /// No description provided for @completeFields.
  ///
  /// In es, this message translates to:
  /// **'Por favor completa todos los campos'**
  String get completeFields;

  /// No description provided for @noAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Regístrate'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia sesión'**
  String get haveAccount;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Regístrate para comprar tus tenis favoritos'**
  String get registerSubtitle;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarme'**
  String get register;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDontMatch;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @sneakers.
  ///
  /// In es, this message translates to:
  /// **'Tenis'**
  String get sneakers;

  /// No description provided for @sneaker.
  ///
  /// In es, this message translates to:
  /// **'Tenis'**
  String get sneaker;

  /// No description provided for @catalog.
  ///
  /// In es, this message translates to:
  /// **'Catálogo'**
  String get catalog;

  /// No description provided for @brands.
  ///
  /// In es, this message translates to:
  /// **'Marcas'**
  String get brands;

  /// No description provided for @brand.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @orders.
  ///
  /// In es, this message translates to:
  /// **'Pedidos'**
  String get orders;

  /// No description provided for @myOrders.
  ///
  /// In es, this message translates to:
  /// **'Mis pedidos'**
  String get myOrders;

  /// No description provided for @cart.
  ///
  /// In es, this message translates to:
  /// **'Carrito'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get darkMode;

  /// No description provided for @roleAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get roleAdmin;

  /// No description provided for @roleCustomer.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get roleCustomer;

  /// No description provided for @hello.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String hello(String name);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Este es el resumen de tu tienda'**
  String get dashboardSubtitle;

  /// No description provided for @customerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Encuentra tu próximo par de tenis'**
  String get customerSubtitle;

  /// No description provided for @lowStock.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo'**
  String get lowStock;

  /// No description provided for @lowStockTitle.
  ///
  /// In es, this message translates to:
  /// **'Stock bajo (5 o menos)'**
  String get lowStockTitle;

  /// No description provided for @stockOk.
  ///
  /// In es, this message translates to:
  /// **'Todo el catálogo tiene stock suficiente'**
  String get stockOk;

  /// No description provided for @pendingOrders.
  ///
  /// In es, this message translates to:
  /// **'Pedidos pendientes'**
  String get pendingOrders;

  /// No description provided for @sales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get sales;

  /// No description provided for @recentOrders.
  ///
  /// In es, this message translates to:
  /// **'Pedidos recientes'**
  String get recentOrders;

  /// No description provided for @newArrivals.
  ///
  /// In es, this message translates to:
  /// **'Novedades'**
  String get newArrivals;

  /// No description provided for @seeAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get seeAll;

  /// No description provided for @goToCatalog.
  ///
  /// In es, this message translates to:
  /// **'Ver catálogo'**
  String get goToCatalog;

  /// No description provided for @searchSneakers.
  ///
  /// In es, this message translates to:
  /// **'Buscar tenis por nombre'**
  String get searchSneakers;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get all;

  /// No description provided for @clearFilters.
  ///
  /// In es, this message translates to:
  /// **'Quitar filtros'**
  String get clearFilters;

  /// No description provided for @noSneakers.
  ///
  /// In es, this message translates to:
  /// **'No hay tenis que coincidan'**
  String get noSneakers;

  /// No description provided for @newSneaker.
  ///
  /// In es, this message translates to:
  /// **'Nuevo tenis'**
  String get newSneaker;

  /// No description provided for @editSneaker.
  ///
  /// In es, this message translates to:
  /// **'Editar tenis'**
  String get editSneaker;

  /// No description provided for @outOfStock.
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get outOfStock;

  /// No description provided for @unitsLeft.
  ///
  /// In es, this message translates to:
  /// **'Quedan {count}'**
  String unitsLeft(int count);

  /// No description provided for @inStock.
  ///
  /// In es, this message translates to:
  /// **'{count} disponibles'**
  String inStock(int count);

  /// No description provided for @sizes.
  ///
  /// In es, this message translates to:
  /// **'Tallas'**
  String get sizes;

  /// No description provided for @size.
  ///
  /// In es, this message translates to:
  /// **'Talla'**
  String get size;

  /// No description provided for @quantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// No description provided for @chooseSize.
  ///
  /// In es, this message translates to:
  /// **'Elige una talla'**
  String get chooseSize;

  /// No description provided for @addToCart.
  ///
  /// In es, this message translates to:
  /// **'Agregar al carrito'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In es, this message translates to:
  /// **'Agregado al carrito'**
  String get addedToCart;

  /// No description provided for @viewCart.
  ///
  /// In es, this message translates to:
  /// **'Ver carrito'**
  String get viewCart;

  /// No description provided for @alreadyInCart.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes {count} en el carrito'**
  String alreadyInCart(int count);

  /// No description provided for @notEnoughStock.
  ///
  /// In es, this message translates to:
  /// **'No hay suficiente stock (disponibles: {count})'**
  String notEnoughStock(int count);

  /// No description provided for @genderMen.
  ///
  /// In es, this message translates to:
  /// **'Hombre'**
  String get genderMen;

  /// No description provided for @genderWomen.
  ///
  /// In es, this message translates to:
  /// **'Mujer'**
  String get genderWomen;

  /// No description provided for @genderUnisex.
  ///
  /// In es, this message translates to:
  /// **'Unisex'**
  String get genderUnisex;

  /// No description provided for @deleteSneaker.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tenis'**
  String get deleteSneaker;

  /// No description provided for @deleteSneakerConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{name}\"? Esta acción no se puede deshacer.'**
  String deleteSneakerConfirm(String name);

  /// No description provided for @sneakerDeleted.
  ///
  /// In es, this message translates to:
  /// **'Tenis eliminado'**
  String get sneakerDeleted;

  /// No description provided for @sneakerSaved.
  ///
  /// In es, this message translates to:
  /// **'Tenis guardado'**
  String get sneakerSaved;

  /// No description provided for @sneakerCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin tenis} =1{1 tenis} other{{count} tenis}}'**
  String sneakerCount(int count);

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @price.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get price;

  /// No description provided for @stock.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @gender.
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get gender;

  /// No description provided for @colors.
  ///
  /// In es, this message translates to:
  /// **'Colores'**
  String get colors;

  /// No description provided for @colorsHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Blanco, Negro'**
  String get colorsHint;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @images.
  ///
  /// In es, this message translates to:
  /// **'Imágenes'**
  String get images;

  /// No description provided for @imageUrl.
  ///
  /// In es, this message translates to:
  /// **'URL de la imagen'**
  String get imageUrl;

  /// No description provided for @addImage.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get addImage;

  /// No description provided for @noImages.
  ///
  /// In es, this message translates to:
  /// **'Sin imágenes. Agrega al menos una URL para que se vea en el catálogo.'**
  String get noImages;

  /// No description provided for @sizesRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos una talla'**
  String get sizesRequired;

  /// No description provided for @priceInvalid.
  ///
  /// In es, this message translates to:
  /// **'Debe ser mayor a 0'**
  String get priceInvalid;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get requiredField;

  /// No description provided for @optional.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// No description provided for @logoUrl.
  ///
  /// In es, this message translates to:
  /// **'URL del logo'**
  String get logoUrl;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @newBrand.
  ///
  /// In es, this message translates to:
  /// **'Nueva marca'**
  String get newBrand;

  /// No description provided for @brandCreated.
  ///
  /// In es, this message translates to:
  /// **'Marca creada'**
  String get brandCreated;

  /// No description provided for @noBrands.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay marcas'**
  String get noBrands;

  /// No description provided for @newCategory.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get newCategory;

  /// No description provided for @categoryCreated.
  ///
  /// In es, this message translates to:
  /// **'Categoría creada'**
  String get categoryCreated;

  /// No description provided for @noCategories.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay categorías'**
  String get noCategories;

  /// No description provided for @orderNumber.
  ///
  /// In es, this message translates to:
  /// **'Pedido #{id}'**
  String orderNumber(int id);

  /// No description provided for @noOrders.
  ///
  /// In es, this message translates to:
  /// **'No hay pedidos'**
  String get noOrders;

  /// No description provided for @noOrdersCustomer.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has hecho ningún pedido'**
  String get noOrdersCustomer;

  /// No description provided for @unitCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 unidad} other{{count} unidades}}'**
  String unitCount(int count);

  /// No description provided for @products.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get products;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @changeStatus.
  ///
  /// In es, this message translates to:
  /// **'Cambiar estado'**
  String get changeStatus;

  /// No description provided for @statusUpdated.
  ///
  /// In es, this message translates to:
  /// **'Estado actualizado: {status}'**
  String statusUpdated(String status);

  /// No description provided for @cancelOrder.
  ///
  /// In es, this message translates to:
  /// **'Cancelar pedido'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirm.
  ///
  /// In es, this message translates to:
  /// **'Al cancelar, el stock vuelve al catálogo y el pedido ya no podrá cambiar de estado.'**
  String get cancelOrderConfirm;

  /// No description provided for @orderCancelledInfo.
  ///
  /// In es, this message translates to:
  /// **'Este pedido está cancelado y ya no puede cambiar de estado.'**
  String get orderCancelledInfo;

  /// No description provided for @orderCancelledNotice.
  ///
  /// In es, this message translates to:
  /// **'Pedido cancelado. El stock fue devuelto al catálogo.'**
  String get orderCancelledNotice;

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// No description provided for @statusPaid.
  ///
  /// In es, this message translates to:
  /// **'Pagado'**
  String get statusPaid;

  /// No description provided for @statusShipped.
  ///
  /// In es, this message translates to:
  /// **'Enviado'**
  String get statusShipped;

  /// No description provided for @statusDelivered.
  ///
  /// In es, this message translates to:
  /// **'Entregado'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get statusCancelled;

  /// No description provided for @cartEmpty.
  ///
  /// In es, this message translates to:
  /// **'Tu carrito está vacío'**
  String get cartEmpty;

  /// No description provided for @checkout.
  ///
  /// In es, this message translates to:
  /// **'Finalizar compra'**
  String get checkout;

  /// No description provided for @orderCreated.
  ///
  /// In es, this message translates to:
  /// **'¡Pedido creado!'**
  String get orderCreated;

  /// No description provided for @errorUnauthorized.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión no es válida. Vuelve a iniciar sesión.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para hacer esto.'**
  String get errorForbidden;

  /// No description provided for @errorServer.
  ///
  /// In es, this message translates to:
  /// **'Error del servidor: {status}'**
  String errorServer(int status);

  /// No description provided for @errorTimeout.
  ///
  /// In es, this message translates to:
  /// **'Tiempo de conexión agotado.'**
  String get errorTimeout;

  /// No description provided for @errorNetwork.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar con la API. ¿Está encendida?'**
  String get errorNetwork;

  /// No description provided for @errorUnexpected.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado.'**
  String get errorUnexpected;

  /// No description provided for @heroTag.
  ///
  /// In es, this message translates to:
  /// **'Nueva temporada'**
  String get heroTag;

  /// No description provided for @heroTitle.
  ///
  /// In es, this message translates to:
  /// **'ENCUENTRA\nTU PRÓXIMO\nPAR.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Las mejores marcas de tenis en un solo lugar: running, basketball, skate y lifestyle.'**
  String get heroSubtitle;

  /// No description provided for @heroBrands.
  ///
  /// In es, this message translates to:
  /// **'NIKE · ADIDAS · PUMA · NEW BALANCE · CONVERSE · VANS'**
  String get heroBrands;

  /// No description provided for @adminTag.
  ///
  /// In es, this message translates to:
  /// **'Panel de administración'**
  String get adminTag;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
