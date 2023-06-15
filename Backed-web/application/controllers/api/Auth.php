<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Auth extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('Users_Model', 'User');
        $this->load->model('Auth_Model');
        $this->load->model('Usersocialauth_Model','Usersocialauth');
    }

    public function signup_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['password']) || empty($apiData['data']['password'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("passwordRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['name']) || empty($apiData['data']['name'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("nameRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (isset($apiData['data']['email']) && !empty($apiData['data']['email'])) {
            $mailExist = $this->User->get(['email' => strtolower($apiData['data']['email']),'status'=>[0,1,2]], true);
            if(!empty($mailExist)){
                if($mailExist->status == 0 && $mailExist->role == $apiData['data']['role']){
                    $setData['verificationCode'] = $this->Common->random_string(4);
                    $user = $this->User->setData($setData,$mailExist->id);
                    if ($user) {    
                        $this->Background_Model->userSignupMail($user);
                        $this->apiResponse['status'] = "3";
                        $this->apiResponse['message'] = $this->Common->GetNotification("verifyEmail", $apiData['data']['langType']);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    }
                }
                $this->apiResponse['message'] = $this->Common->GetNotification("emailExist", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
        }
        $namearry = explode(" ", $apiData['data']['name'], 2);
        $setData['firstName'] = (isset($namearry[0]) ? $namearry[0] : "");
        $setData['lastName'] = (isset($namearry[1]) ? $namearry[1] : "");
        $setData['role'] = $apiData['data']['role'];
        $setData['email'] = $apiData['data']['email'];
        $setData['verificationCode'] = $this->Common->random_string(4);
        $setData['password'] = $this->Common->convert_to_hash($apiData['data']['password']);
        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $setData['timezone'] = $apiData['data']['timezone'];
        }

        $user = $this->User->setData($setData);
        if ($user) {    
            $this->Background_Model->userSignupMail($user);
            $this->apiResponse['status'] = "3";
            $this->apiResponse['message'] = $this->Common->GetNotification("verifyEmail", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("registerFailed", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function resendVerification_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $user = $this->User->get(['email'=>$apiData['data']['email'], 'role' => $apiData['data']['role'], 'status' => [0]], true);
        if (empty($user)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $this->User->setData(['verificationCode' => $this->Common->random_string(4)], $user->id);
        $this->Background_Model->userVerificationMail($user->id);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("codeSendSuccess", $apiData['data']['langType']);

        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function verify_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['verificationCode']) || empty($apiData['data']['verificationCode'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("verificationCodeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $user = $this->User->get(['email' => $apiData['data']['email'], 'role' => $apiData['data']['role'], 'status' => [0,1,2]], TRUE);

        if (empty($user)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if ($user->status == 2) {
            $this->apiResponse['message'] = $this->Common->GetNotification("accountBlockedByAdmin", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (isset($apiData['data']['auth_provider']) && !empty($apiData['data']['auth_provider'])) {
            $getAuthProvider = $this->Usersocialauth->get(['auth_provider' => $apiData['data']['auth_provider'], 'userId' => $user->id], TRUE);
            if (empty($getAuthProvider)) {
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("userNotExist", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
        }

        $user = $this->User->get(['email' => $apiData['data']['email'], "verificationCode" => strtolower($apiData['data']['verificationCode']), 'status' => [0,1,2]], true);
        if (empty($user)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("invalidVerificationCode", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $authData = array();
        $authData['userId'] = $user->id;
        $authData['token'] = $this->Common_Model->getToken(120);
        if (isset($apiData['data']['deviceType']) && !empty($apiData['data']['deviceType'])) {
            $authData['deviceType'] = $apiData['data']['deviceType'];
        }
        if (isset($apiData['data']['deviceToken']) && !empty($apiData['data']['deviceToken'])) {
            $authData['deviceToken'] = $apiData['data']['deviceToken'];
        }

        if (isset($apiData['data']['deviceId']) && !empty($apiData['data']['deviceId'])) {
            $getAuth = $this->Auth_Model->get(['deviceId'=>$apiData['data']['deviceId'],'userId'=>$user->id],TRUE);
            if(!empty($getAuth)){
                $authid = $this->Auth_Model->setData($authData,$getAuth->id);
            }else{
                $authid = $this->Auth_Model->setData($authData);
            }
        }else{
            $authid = $this->Auth_Model->setData($authData);
        }
       
        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $userdata['timezone'] = $apiData['data']['timezone'];
        }
        $userdata['verificationCode'] = '';
        $userdata['status'] = 1;
        $this->User->setData($userdata, $user->id);    
        if (isset($apiData['data']['auth_provider']) && !empty($apiData['data']['auth_provider'])) {
            $this->Usersocialauth->setData(['status' => '1'], $getAuthProvider->id);
        }
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("loginSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $this->User->userData($user->id, TRUE, $authid);

        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function login_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['password']) || empty($apiData['data']['password'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("passwordRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $mailExist = $this->User->get(['email' => strtolower($apiData['data']['email']), 'role' => $apiData['data']['role'], 'status' => [0,1,2]], true);        

        if (empty($mailExist)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $apiData['data']['password'] = $this->Common->convert_to_hash($apiData['data']['password']);

        $user = $this->User->get(['id' => $mailExist->id, 'password' => $apiData['data']['password'], 'role' => $apiData['data']['role'], 'status' => [0,1,2]], true);

        if (empty($user)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("invalidEmailPassword", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if ($user->status == 0) {
            $this->Background_Model->userSignupMail($user->id);
            $this->apiResponse['status'] = "3";
            $this->apiResponse['message'] = $this->Common->GetNotification("verifyEmail", $apiData['data']['langType']);
            $this->apiResponse['data']['email'] = $mailExist->email;
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        } elseif ($user->status == 2) {
            $this->apiResponse['status'] = "5";
            $this->apiResponse['message'] = $this->Common->GetNotification("accountBlockedByAdmin", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        } 

        $authData = array();
        $authData['userId'] = $user->id;
        $authData['token'] = $this->Common_Model->getToken(120);
        if (isset($apiData['data']['deviceType']) && !empty($apiData['data']['deviceType'])) {
            $authData['deviceType'] = $apiData['data']['deviceType'];
        }
        if (isset($apiData['data']['deviceToken']) && !empty($apiData['data']['deviceToken'])) {
            $authData['deviceToken'] = $apiData['data']['deviceToken'];
        }

        if (isset($apiData['data']['deviceId']) && !empty($apiData['data']['deviceId'])) {
            $getAuth = $this->Auth_Model->get(['deviceId'=>$apiData['data']['deviceId'],'userId'=>$user->id],TRUE);
            if(!empty($getAuth)){
                $authid = $this->Auth_Model->setData($authData,$getAuth->id);
            }else{
                $authid = $this->Auth_Model->setData($authData);
            }
        }else{
            $authid = $this->Auth_Model->setData($authData);
        }

        $request = [];
        if (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude'])) {
            $request['latitude'] = $apiData['data']['latitude'];
        }
        if (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude'])) {
            $request['longitude'] = $apiData['data']['longitude'];
        }
        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $request['timezone'] = $apiData['data']['timezone'];
        }
        if (!empty($request)){
            $this->User->setData($request, $user->id);
        }
            
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("loginSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $this->User->userData($user->id, TRUE, $authid);

        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function logout_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $this->Auth_Model->removeToken($user->token);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("logoutSuccess", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function forgotPassword_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $user = $this->User->get(['email'=>$apiData['data']['email'], 'role' => $apiData['data']['role'], 'status' => [0,1,2]], true);
        if (empty($user)) {
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if ($user->status == 2) {
            $this->apiResponse['message'] = $this->Common->GetNotification("accountBlockedByAdmin", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $this->User->setData(['forgotCode' => $this->Common->random_string(4)], $user->id);
        $this->Background_Model->userForgotPasswordMail($user->id);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("forgotCodeSendSuccess", $apiData['data']['langType']);
        $this->apiResponse['data']['email'] = $user->email;
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function checkForgotCode_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (!isset($apiData['data']['verificationCode']) || empty($apiData['data']['verificationCode'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("verificationCodeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $user = $this->User->get(['email'=>$apiData['data']['email'], 'role' => $apiData['data']['role'], 'status' => [0,1,2]], true);
        if (empty($user)) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if ($user->forgotCode != $apiData['data']['verificationCode']) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("invalidVerificationCode", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!$this->User->setData(['status' => 1], $user->id)) {
            $this->apiResponse['status'] = "3";
            $this->apiResponse['message'] = $this->Common->GetNotification("verificationFailed", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("verificationSuccess", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function resetPassword_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
       
        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['email']) || empty($apiData['data']['email'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("emailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['newPassword']) || empty($apiData['data']['newPassword'])) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("newPasswordRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $user = $this->User->get(['email'=>$apiData['data']['email'], 'role' => $apiData['data']['role'], 'status' => [0,1,2]], true);

        if (empty($user)) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("userNotExist", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $this->User->setData(['password' => $this->Common->convert_to_hash($apiData['data']['newPassword'])], $user->id);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("passwordChangeSuccess", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function changePassword_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (isset($apiData['data']['oldPassword']) && !empty($apiData['data']['oldPassword'])) {
            if (!empty($user->password) && $user->password !== $this->Common->convert_to_hash($apiData['data']['oldPassword'])) {
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common->GetNotification("oldPasswordInvalid", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
        }

        if (!isset($apiData['data']['newPassword']) || empty($apiData['data']['newPassword'])) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("newPasswordRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $this->User->setData(['password' => $this->Common->convert_to_hash($apiData['data']['newPassword'])], $user->id);

        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("passwordChangeSuccess", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function socialLogin_post() {
        $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['auth_provider']) || empty($apiData['data']['auth_provider'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("authProviderRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['auth_id']) || empty($apiData['data']['auth_id'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("authIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['role']) || empty($apiData['data']['role'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("roleRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['isManualEmail']) || $apiData['data']['isManualEmail'] == "") {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("isManualEmailRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (isset($apiData['data']['email']) && !empty($apiData['data']['email'])) {
            $userData['email'] = $apiData['data']['email'];
        }
        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $userData['timezone'] = $apiData['data']['timezone'];
        }
        if (isset($apiData['data']['deviceType']) && !empty($apiData['data']['deviceType'])) {
            $authData['deviceType'] = $apiData['data']['deviceType'];
        }
        if (isset($apiData['data']['deviceToken']) && !empty($apiData['data']['deviceToken'])) {
            $authData['deviceToken'] = $apiData['data']['deviceToken'];
        }
        if (isset($apiData['data']['deviceId']) && !empty($apiData['data']['deviceId'])) {
            $authData['deviceId'] = $apiData['data']['deviceId'];
        }

        $checkDetail = $this->Usersocialauth->get(['auth_provider' => $apiData['data']['auth_provider'], 'auth_id' => $apiData['data']['auth_id'],'status'=>[0,1]], true);

        if (empty($checkDetail)) {
            if (isset($apiData['data']['email']) && !empty($apiData['data']['email'])) {
                $mailExist = $this->User->get(['email' => strtolower($apiData['data']['email']), 'status' => [0,1,2]], TRUE);
                if (!empty($mailExist)) {
                    if ($mailExist->role != $apiData['data']['role']) {
                        $this->apiResponse['status'] = "0";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("emailexist", $apiData['data']['langType']);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    }
                    //Check auth account already exist
                    $socialAuthExist = $this->Usersocialauth->get(['userId' => $mailExist->id, 'auth_provider' => $apiData['data']['auth_provider'],'status'=>[0,1]], TRUE);
                    if(!empty($socialAuthExist)){
                        $this->apiResponse['status'] = "0";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("emailmissmatch", $apiData['data']['langType']);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    }
                    if ($apiData['data']['isManualEmail'] == "0") {
                        $userData['status'] = '1';
                    } else {
                        $userData['verificationCode'] = $this->Common_Model->random_string(4);
                    }
                    if ((empty($mailExist->image) || $mailExist->image == "default_user.jpg") && isset($apiData['data']['image']) && !empty($apiData['data']['image'])) {
                        $userData['image'] = $apiData['data']['image'];
                    }
                    if (empty($mailExist->firstName) && isset($apiData['data']['firstName']) && !empty($apiData['data']['firstName'])) {
                        $userData['firstName'] = $apiData['data']['firstName'];
                    }
                    if (empty($mailExist->lastName) && isset($apiData['data']['lastName']) && !empty($apiData['data']['lastName'])) {
                        $userData['lastName'] = $apiData['data']['lastName'];
                    }
                    $user = $this->User->setData($userData, $mailExist->id);
                    if (empty($user)) {
                        $this->apiResponse['status'] = "0";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("registerFailed", $apiData['data']['langType']);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    } else {
                        $getSocialAuth = $this->Usersocialauth->get(['userId' => $user, 'auth_provider' => $apiData['data']['auth_provider'], 'auth_id' => $apiData['data']['auth_id']], TRUE);
                        if (empty($getSocialAuth)) {
                            $setData['userId'] = $user;
                            $setData['auth_provider'] = $apiData['data']['auth_provider'];
                            $setData['auth_id'] = $apiData['data']['auth_id'];
                            if ($apiData['data']['isManualEmail'] == "0") {
                                $setData['status'] = "1";
                            } else {
                                $setData['status'] = "0";
                            }
                            $this->Usersocialauth->setData($setData);
                        }
                    }
                    if ($apiData['data']['isManualEmail'] == "0") {
                        $authData['userId'] = $user;
                        $authData['token'] = $this->Common->getToken(120);
                        $getAuth = $this->Auth_Model->get(['deviceId'=>$apiData['data']['deviceId'],'userId'=>$user],TRUE);
                        if(!empty($getAuth)){
                            $authid = $this->Auth_Model->setData($authData,$getAuth->id);
                        }else{
                            $authid = $this->Auth_Model->setData($authData);
                        }
                        $this->apiResponse['status'] = "1";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("loginSuccess", $apiData['data']['langType']);
                        $this->apiResponse['data'] = $this->User->userData($user, TRUE, $authid);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    } else {
                        $this->Background_Model->userSignupMail($user);
                        $this->apiResponse['status'] = "3";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("verifyEmail", $apiData['data']['langType']);
                        $this->apiResponse['data'] = ['email' => $apiData['data']['email']];
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    }
                } else {
                    $userData['role'] = $apiData['data']['role'];
                    if ($apiData['data']['isManualEmail'] == "0") {
                        $userData['status'] = '1';
                        $userData['token'] = $this->Common_Model->getToken(120);
                    } else {
                        $userData['status'] = '0';
                        $userData['verificationCode'] = $this->Common_Model->random_string(4);
                    }
                    if (isset($apiData['data']['image']) && !empty($apiData['data']['image'])) {
                        $userData['image'] = $apiData['data']['image'];
                    }
                    if (isset($apiData['data']['firstName']) && !empty($apiData['data']['firstName'])) {
                        $userData['firstName'] = $apiData['data']['firstName'];
                    }
                    if (isset($apiData['data']['lastName']) && !empty($apiData['data']['lastName'])) {
                        $userData['lastName'] = $apiData['data']['lastName'];
                    }
                    $user = $this->User->setData($userData);
                    if (empty($user)) {
                        $this->apiResponse['status'] = "0";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("registerFailed", $apiData['data']['langType']);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    } else {
                        $getSocialAuth = $this->Usersocialauth->get(['userId' => $user, 'auth_provider' => $apiData['data']['auth_provider'], 'auth_id' => $apiData['data']['auth_id']], TRUE);
                        if (empty($getSocialAuth)) {
                            $setData['userId'] = $user;
                            $setData['auth_provider'] = $apiData['data']['auth_provider'];
                            $setData['auth_id'] = $apiData['data']['auth_id'];
                            if ($apiData['data']['isManualEmail'] == "0") {
                                $setData['status'] = "1";
                            } else {
                                $setData['status'] = "0";
                            }
                            $this->Usersocialauth->setData($setData);
                        }
                    }

                    if ($apiData['data']['isManualEmail'] == "0") {
                        $authData['userId'] = $user;
                        $authData['token'] = $this->Common->getToken(120);
                        $getAuth = $this->Auth_Model->get(['deviceId'=>$apiData['data']['deviceId'],'userId'=>$user],TRUE);
                        if(!empty($getAuth)){
                            $authid = $this->Auth_Model->setData($authData,$getAuth->id);
                        }else{
                            $authid = $this->Auth_Model->setData($authData);
                        }
                        $this->apiResponse['status'] = "1";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("loginSuccess", $apiData['data']['langType']);
                        $this->apiResponse['data'] = $this->User->userData($user, TRUE, $authid);
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    } else {
                        $this->Background_Model->userSignupMail($user);
                        $this->apiResponse['status'] = "3";
                        $this->apiResponse['message'] = $this->Common_Model->GetNotification("verifyEmail", $apiData['data']['langType']);
                        $this->apiResponse['data'] = ['email' => $apiData['data']['email']];
                        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
                    }
                }
            } else {
                $this->apiResponse['status'] = "4";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("emailRequired", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
        } else {
            $getuserData = $this->User->get(['id' => $checkDetail->userId, 'status' => [0,1,2]], TRUE);
            if(empty($getuserData)){
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("userNotExist", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            //Check auth account already exist
            if ((isset($apiData['data']['email']) && !empty($apiData['data']['email'])) && $apiData['data']['email'] != $getuserData->email) {
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("emailmissmatch", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            if ($getuserData->role != $apiData['data']['role']) {
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("existWithDiffRole", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            if ($getuserData->status == 2) {
                $this->apiResponse['status'] = "5";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("accountBlockedByAdmin", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            if (($getuserData->status == 0 || $checkDetail->status == 0) && $apiData['data']['isManualEmail'] == "1") {
                $user = $this->User->setData(['verificationCode' => $this->Common_Model->random_string(4)], $getuserData->id);
                $this->Background_Model->userSignupMail($user);
                $this->apiResponse['status'] = "3";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("verifyEmail", $apiData['data']['langType']);
                $this->apiResponse['data'] = ['email' => $getuserData->email];
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $this->Usersocialauth->setData(['status' => '1'], $checkDetail->id);
            $authData['userId'] = $getuserData->id;
            $authData['token'] = $this->Common->getToken(120);
            $getAuth = $this->Auth_Model->get(['deviceId'=>$apiData['data']['deviceId'],'userId'=>$getuserData->id],TRUE);
            if(!empty($getAuth)){
                $authid = $this->Auth_Model->setData($authData,$getAuth->id);
            }else{
                $authid = $this->Auth_Model->setData($authData);
            }
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("loginSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($getuserData->id, TRUE, $authid);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
}