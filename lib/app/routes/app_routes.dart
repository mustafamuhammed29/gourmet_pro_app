abstract class Routes {
  // --- Main Routes ---
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const pendingApproval = '/pending-approval';
  static const mainWrapper = '/main-wrapper';

  // --- Feature Routes ---
  static const dashboard = '/dashboard';
  static const manageMenu = '/manage-menu';
  static const addEditDish = '/add-edit-dish';
  static const chat = '/chat';
  static const promoTools = '/promo-tools';
  static const digitalMenu = '/digital-menu'; // <-- تمت إضافة السطر الجديد هنا
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const services = '/services';

  // Market Analysis
  static const discoverMap = '/discover-map';
  static const restaurantDetails = '/restaurant-details';

  // AI Features
  static const reviewResponder = '/review-responder';
  static const socialPostGenerator = '/social-post-generator';
  static const chefCorner = '/chef-corner';

  // Other Screens
  static const notifications = '/notifications';
  static const staffManagement = '/staff-management';
  static const orders = '/orders';
}
