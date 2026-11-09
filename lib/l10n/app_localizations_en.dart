// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SneakHub';

  @override
  String get welcome => 'Welcome to SneakHub';

  @override
  String get loginSubtitle => 'Enter your credentials to continue';

  @override
  String get login => 'Sign in';

  @override
  String get logout => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMin => 'At least 4 characters';

  @override
  String get completeFields => 'Please complete all fields';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle => 'Sign up to buy your favorite sneakers';

  @override
  String get register => 'Sign up';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get home => 'Home';

  @override
  String get sneakers => 'Sneakers';

  @override
  String get sneaker => 'Sneaker';

  @override
  String get catalog => 'Catalog';

  @override
  String get brands => 'Brands';

  @override
  String get brand => 'Brand';

  @override
  String get categories => 'Categories';

  @override
  String get category => 'Category';

  @override
  String get orders => 'Orders';

  @override
  String get myOrders => 'My orders';

  @override
  String get cart => 'Cart';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get settings => 'Preferences';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleCustomer => 'Customer';

  @override
  String hello(String name) {
    return 'Hi, $name';
  }

  @override
  String get dashboardSubtitle => 'Here is your store at a glance';

  @override
  String get customerSubtitle => 'Find your next pair of sneakers';

  @override
  String get lowStock => 'Low stock';

  @override
  String get lowStockTitle => 'Low stock (5 or fewer)';

  @override
  String get stockOk => 'The whole catalog has enough stock';

  @override
  String get pendingOrders => 'Pending orders';

  @override
  String get sales => 'Sales';

  @override
  String get recentOrders => 'Recent orders';

  @override
  String get newArrivals => 'New arrivals';

  @override
  String get seeAll => 'See all';

  @override
  String get goToCatalog => 'Browse catalog';

  @override
  String get searchSneakers => 'Search sneakers by name';

  @override
  String get all => 'All';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noSneakers => 'No sneakers match';

  @override
  String get newSneaker => 'New sneaker';

  @override
  String get editSneaker => 'Edit sneaker';

  @override
  String get outOfStock => 'Sold out';

  @override
  String unitsLeft(int count) {
    return '$count left';
  }

  @override
  String inStock(int count) {
    return '$count available';
  }

  @override
  String get sizes => 'Sizes';

  @override
  String get size => 'Size';

  @override
  String get quantity => 'Quantity';

  @override
  String get chooseSize => 'Choose a size';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get viewCart => 'View cart';

  @override
  String alreadyInCart(int count) {
    return 'You already have $count in your cart';
  }

  @override
  String notEnoughStock(int count) {
    return 'Not enough stock (available: $count)';
  }

  @override
  String get genderMen => 'Men';

  @override
  String get genderWomen => 'Women';

  @override
  String get genderUnisex => 'Unisex';

  @override
  String get deleteSneaker => 'Delete sneaker';

  @override
  String deleteSneakerConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This can\'t be undone.';
  }

  @override
  String get sneakerDeleted => 'Sneaker deleted';

  @override
  String get sneakerSaved => 'Sneaker saved';

  @override
  String sneakerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sneakers',
      one: '1 sneaker',
      zero: 'No sneakers',
    );
    return '$_temp0';
  }

  @override
  String get name => 'Name';

  @override
  String get price => 'Price';

  @override
  String get stock => 'Stock';

  @override
  String get gender => 'Gender';

  @override
  String get colors => 'Colors';

  @override
  String get colorsHint => 'E.g. White, Black';

  @override
  String get description => 'Description';

  @override
  String get images => 'Images';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get addImage => 'Add';

  @override
  String get noImages =>
      'No images. Add at least one URL so it shows in the catalog.';

  @override
  String get sizesRequired => 'Choose at least one size';

  @override
  String get priceInvalid => 'Must be greater than 0';

  @override
  String get requiredField => 'Required field';

  @override
  String get optional => 'Optional';

  @override
  String get logoUrl => 'Logo URL';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get newBrand => 'New brand';

  @override
  String get brandCreated => 'Brand created';

  @override
  String get noBrands => 'No brands yet';

  @override
  String get newCategory => 'New category';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get noCategories => 'No categories yet';

  @override
  String orderNumber(int id) {
    return 'Order #$id';
  }

  @override
  String get noOrders => 'No orders';

  @override
  String get noOrdersCustomer => 'You haven\'t placed any orders yet';

  @override
  String unitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    return '$_temp0';
  }

  @override
  String get products => 'Products';

  @override
  String get total => 'Total';

  @override
  String get changeStatus => 'Change status';

  @override
  String statusUpdated(String status) {
    return 'Status updated: $status';
  }

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelOrderConfirm =>
      'Cancelling returns the stock to the catalog, and the order can\'t change status anymore.';

  @override
  String get orderCancelledInfo =>
      'This order is cancelled and can\'t change status anymore.';

  @override
  String get orderCancelledNotice =>
      'Order cancelled. The stock was returned to the catalog.';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get checkout => 'Checkout';

  @override
  String get orderCreated => 'Order placed!';

  @override
  String get errorUnauthorized =>
      'Your session isn\'t valid. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have permission to do this.';

  @override
  String errorServer(int status) {
    return 'Server error: $status';
  }

  @override
  String get errorTimeout =>
      'The connection is too slow and the server didn\'t respond in time. Try again.';

  @override
  String get errorNetwork =>
      'Can\'t reach the server. Check your internet connection and try again.';

  @override
  String get errorUnexpected => 'Something went wrong.';

  @override
  String get heroTag => 'New season';

  @override
  String get heroTitle => 'FIND\nYOUR NEXT\nPAIR.';

  @override
  String get heroSubtitle =>
      'The best sneaker brands in one place: running, basketball, skate and lifestyle.';

  @override
  String get heroBrands =>
      'NIKE · ADIDAS · PUMA · NEW BALANCE · CONVERSE · VANS';

  @override
  String get adminTag => 'Admin panel';
}
