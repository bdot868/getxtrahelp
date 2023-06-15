<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	https://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There are three reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router which controller/method to use if those
| provided in the URL cannot be matched to a valid route.
|
|	$route['translate_uri_dashes'] = FALSE;
|
| This is not exactly a route, but allows you to automatically route
| controller and method names that contain dashes. '-' isn't a valid
| class or method name character, so it requires translation.
| When you set this option to TRUE, it will replace ALL dashes in the
| controller and method URI segments.
|
| Examples:	my-controller/index	-> my_controller/index
|		my-controller/my-method	-> my_controller/my_method
*/

$route['default_controller'] = 'home';
$route['404_override'] = '';
$route['worker'] = 'background/worker';
$route['translate_uri_dashes'] = FALSE;
$route['image/(:any)/(:any)/(:any)'] = 'home/image/$3/$1/$2';
$route['image/(:any)'] = 'home/image/$1';
$route['stripe-onboard-return'] = 'home/stripeOnboardReturn';
$route['stripe-onboard-refresh'] = 'home/stripeOnboardRefresh';

defined('ABOUT_US')  OR define('ABOUT_US', 'about-us');
defined('CONTACT_US')  OR define('CONTACT_US', 'about/contact');
defined('TERMS_CONDITIONS')  OR define('TERMS_CONDITIONS', 'terms-conditions');
defined('PRIVACY_POLICY')  OR define('PRIVACY_POLICY', 'privacy-policy');

// User 
defined('DASHBOARD')  OR define('DASHBOARD', 'dashboard');
defined('SIGNUP')  OR define('SIGNUP', 'signup');
defined('VERIFY_ACCOUNT')  OR define('VERIFY_ACCOUNT', 'verify-account');
defined('LOGIN')  OR define('LOGIN', 'login');
defined('FORGOT_PASSWORD')  OR define('FORGOT_PASSWORD', 'forgot-password');
defined('LOGOUT')  OR define('LOGOUT', 'logout');
defined('MY_PROFILE')  OR define('MY_PROFILE', 'my-profile');
defined('CALENDAR_SETTINGS')  OR define('CALENDAR_SETTINGS', 'calendar-settings');
defined('SECURITY')  OR define('SECURITY', 'security');

$route[ABOUT_US] = 'home/aboutUs';
$route[CONTACT_US] = 'home/contactUs';
$route[TERMS_CONDITIONS] = 'home/terms_conditions';
$route[PRIVACY_POLICY] = 'home/privacy_policy';

$route[SIGNUP] = 'home/signup';
$route[VERIFY_ACCOUNT] = 'home/verify_account';
$route[LOGIN] = 'home/login';
$route[FORGOT_PASSWORD] = 'home/forgot_password';
$route[LOGOUT] = 'webapp/auth/logout';


$webappUser = 'webapp/user/';
$route[DASHBOARD] = $webappUser.'dashboard';
$route[MY_PROFILE] = $webappUser.'my_profile';
$route[CALENDAR_SETTINGS] = $webappUser.'calendar_settings';
$route[SECURITY] = $webappUser.'security';

$admin = 'admin/';
$route['admin'] = $admin.'login/index';
$route['admin/logout'] = $admin.'login/logout';
$route['admin/setting'] = $admin.'admin/setting';
$route['admin/changePassword'] = $admin.'admin/changePassword';