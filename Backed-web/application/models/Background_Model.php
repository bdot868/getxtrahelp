<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Background_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->load->library('email');
        $this->load->model('Users_Model');
        $this->load->model('Common_Model');
        $this->load->model('Notification_Model','Notification');
        $this->load->model('Auth_Model');
        $this->load->library('fcm');
    }

    public function userSignupMail($data) {
        if (empty($data)) {
            return false;
        }

        $user = $this->Users_Model->get(['id' => $data]);
        if (empty($user) || empty($user->email)) {
            return false;
        }

        if (!empty($user->email)) {
            $mailBody = $this->load->view('Mail/UserSignUpMail', ['user' => $user], TRUE);
            $this->Common_Model->mailsend($user->email, "Welcome to " . getenv('EMAIL_SUBJECT') . ".", $mailBody);
        }
    }

    public function userVerificationMail($data) {
        if (empty($data)) {
            return false;
        }

        $user = $this->Users_Model->get(['id' => $data]);

        if (empty($user)) {
            return false;
        }

        if (!empty($user->email)) {
            $mailBody = $this->load->view('Mail/UserVerificationMail', ['user' => $user], TRUE);
            $this->Common_Model->mailsend($user->email, getenv('EMAIL_SUBJECT') . " account verification code.", $mailBody);
        }
    }

    public function userForgotPasswordMail($data) {
        if (empty($data)) {
            return false;
        }

        $user = $this->Users_Model->get(['id' => $data]);

        if (empty($user)) {
            return false;
        }

        if (!empty($user->email)) {
            $mailBody = $this->load->view('Mail/UserForgotPasswordMail', ['user' => $user], TRUE);
            $this->Common_Model->mailsend($user->email, getenv('EMAIL_SUBJECT') . " Forgot Password.", $mailBody);
        }
    }

    public function pushNotification($deviceToken, $notification, $extData, $badgeCount) {
        $result = array();
        if (!empty($deviceToken)) {
            $result = $this->fcm->sendMessageNew($extData, $notification, $deviceToken);
        }
        error_log("\n\n -------------------------------------" . date('c'). " \n". json_encode($notification)." \n". $deviceToken." \n". json_encode($extData)." \n". json_encode($result) , 3, FCPATH.'worker/notification.log');
        return $result; 
    }


    public function testpushNotification($deviceToken, $notification, $extData, $badgeCount) {
        $result = array();
        if (!empty($deviceToken)) {
            $result = $this->fcm->sendMessageNew($extData, $notification, $deviceToken);
        }
        //error_log("\n\n -------------------------------------" . date('c'). " \n". json_encode($notification)." \n". $deviceToken." \n". json_encode($extData)." \n". json_encode($result) , 3, FCPATH.'worker/notification.log');
        return $result; 
    }
    function objectToArray($data) {
        if (is_array($data) || is_object($data)) {
            $result = array();
            foreach ($data as $key => $value) {
                $result[$key] = $this->objectToArray($value);
            }
            return $result;
        }
        return $data;
    }

    // for local upload
    public function base64ToImage($image){
        if(!empty($image)){
            $image_parts = explode(";base64,", $image);
            $pos  = strpos($image, ';');
            $image_type = $type = explode(':', substr($image, 0, $pos))[1];
            $image_type = explode('/', $image_type)[1];
            $image_base64 = base64_decode($image_parts[1]);
            $fileName = time().''.rand("0000","9999"). '.'.$image_type;
            $file = getenv('UPLOADPATH')."".$fileName;
            if(file_put_contents($file, $image_base64)){
                return $fileName;
            }
        }
        return '';
    }

    public function localMediaUpload() {
        
        $apiResponse = array();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $pageURL = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? "https://" : "http://";
        $pageURL .= $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
        error_log("\n\n -------------------------------------" . date('c') . " \n" . $pageURL . " \n" . print_r($_POST, TRUE) . " \n" . print_r($_FILES, TRUE), 3, FCPATH . 'worker/api_fileuploadlog-' . date('d-m-Y') . '.log');
        ini_set('max_execution_time', 999999);
        ini_set('memory_limit', '999999M');
        ini_set('upload_max_filesize', '500M');
        ini_set('max_input_time', '-1');
        ini_set('max_execution_time', '-1');
        $imgData = array();
      
        if (isset($_FILES['files']) && !empty($_FILES['files'])) {
            
            //$image_type = $this->input->post('imageType');
            $upload_path = getenv('UPLOADPATH');
            $allowed_types = array(".jpg", ".gif", ".png", ".jpeg", ".mp4", ".m4a", ".MOV", ".MPEG-4", ".mpeg-4", ".mov");
            foreach ($_FILES as $key => $file) {
   
                if (is_array($_FILES[$key]["name"])) {
                    foreach ($_FILES[$key]["name"] as $_key => $value) {
                        $_FILES['file']['name'] = $_FILES[$key]['name'][$_key];
                        $_FILES['file']['type'] = $_FILES[$key]['type'][$_key];
                        $_FILES['file']['tmp_name'] = $_FILES[$key]['tmp_name'][$_key];
                        $_FILES['file']['error'] = $_FILES[$key]['error'][$_key];
                        $_FILES['file']['size'] = $_FILES[$key]['size'][$_key];

                        $fileExt = $this->Common_Model->getFileExtension($_FILES[$key]["name"][$_key]);
                        if (in_array($fileExt, $allowed_types)) {
                            $fileName = date('ymdhis') . $this->Common_Model->random_string(6) . $fileExt;
                            $upload_dir = $upload_path . "/" . $fileName;
                            if (move_uploaded_file($_FILES[$key]["tmp_name"][$_key], $upload_dir)) {
                                $tmp = array();
                                $tmp['name'] = $fileName;
                                $tmp['url'] = base_url(getenv('UPLOAD_URL')) . "" . $fileName;
                                $imgData[] = $fileName;
                            }
                        }
                    }
                } else {
                    $fileExt = $this->Common_Model->getFileExtension($_FILES[$key]["name"]);
                    if (in_array($fileExt, $allowed_types)) {
                        $fileName = date('ymdhis') . $this->Common_Model->random_string(6) . $fileExt;
                        $upload_dir = $upload_path . "/" . $fileName;
                        if (move_uploaded_file($_FILES[$key]["tmp_name"], $upload_dir)) {
                            $tmp = array();
                            $tmp['name'] = $fileName;
                            $tmp['url'] = base_url(getenv('UPLOAD_URL')) . "" . $fileName;
                            $imgData[] = $fileName;
                        }
                    }
                }
            }
           
        }
        if (!empty($imgData)) {
            $imgExtn = array('jpeg', 'gif', 'png', 'jpg', 'JPG', 'PNG', 'GIF', 'JPEG');
            $finalData = array();
            foreach ($imgData as $img) {
                $tmp = [];
                $tmp['mediaName'] = $img;
                $tmp['mediaBaseUrl'] = base_url(getenv('UPLOAD_URL')) . $img;
                $tmp['medialThumUrl'] = base_url(getenv('THUMBURL')) . $img;
                //Generate Video thumb image
                $extention = pathinfo($img, PATHINFO_EXTENSION);
                if (!in_array($extention, $imgExtn)) {
                    $videoThumbImgName = date('ymdhis') . $this->Common_Model->random_string(6) . '.jpg';
                    exec('ffmpeg  -i ' . $upload_path . $img . ' -deinterlace -an -ss 2 -f mjpeg -t 1 -r 1 -y ' . $upload_path . $videoThumbImgName . ' 2>&1');
                    $tmp['videoThumbImgName'] = $videoThumbImgName;
                    $tmp['videoThumbImgUrl'] = base_url(getenv('THUMBURL')) . $videoThumbImgName;
                } else {
                    $tmp['videoThumbImgName'] = "";
                    $tmp['videoThumbImgUrl'] = "";
                }
                // ./Generate Video thumb image
                $finalData[] = $tmp;
            }
            $apiResponse['status'] = "1";
            $apiResponse['data'] = $finalData;
            $apiResponse['base_url'] = base_url(getenv('UPLOAD_URL'));
            $apiResponse['message'] = $this->Common_Model->GetNotification("mediaUploaded", 1);
        } else {
            $apiResponse['status'] = "0";
            $apiResponse['message'] = $this->Common_Model->GetNotification("failtoUploadMedia", 1);
        }
        return $apiResponse;
    }

    // Start from hear

    public function acceptRequestCarGiver($data) {
        if (empty($data)) {
            return false;
        }
        $user = $this->Users_Model->get(['id' => $data, 'role'=> '3'], TRUE);
        
        if (empty($user)) {
            return false;
        }
        
        if (!empty($user->email)) {
            // echo "<pre>";print_r($user); die();
            $mailBody = $this->load->view('Mail/CargiverAcceptRequst', ['user' => $user], TRUE);
            $this->Common_Model->mailsend($user->email, "Welcome to " . getenv('EMAIL_SUBJECT') . ".", $mailBody);
        }
    }

    public function acceptJobRequestByUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "acceptJobRequestByUser";
        $data['title'] = "Job Request Accept";
        $data['desc'] = "Your job request is accepted by ".$senderData->firstName.' '.$senderData->lastName;
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "acceptJobRequestByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function rejectJobRequestByUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "rejectJobRequestByUser";
        $data['title'] = "Job Request Reject";
        $data['desc'] = "Your job request rejected by ".$senderData->firstName.' '.$senderData->lastName;
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "rejectJobRequestByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function cancelUpcomingJobByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "cancelUpcomingJobByCaregiver";
        $data['title'] = "Upcoming Job Cancel";
        $data['desc'] = "Your ".$data['jobName']." job has been canceled by ".$senderData->firstName.' '.$senderData->lastName;
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "cancelUpcomingJobByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function cancelUpcomingJobByAutoSystemForUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "cancelUpcomingJobByAutoSystemForUser";
        $data['title'] = "Upcoming Job Cancel By Xtrahelp";
        $data['desc'] = "Your upcoming ".$data['jobName']." job has been canceled by Xtrahelp";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "cancelUpcomingJobByAutoSystemForUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function cancelUpcomingJobByAutoSystemForCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "cancelUpcomingJobByAutoSystemForCaregiver";
        $data['title'] = "Upcoming Job Cancel By Xtrahelp";
        $data['desc'] = "Your upcoming ".$data['jobName']." job has been canceled by Xtrahelp. Reason: Payment transfer did not succeed";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "cancelUpcomingJobByAutoSystemForCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobByCaregiver";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." wants to transfer a job ".$data['jobName']." to you, click here to accept.";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestByCaregiver";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." has sent you a job substitute request for the ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestAcceptByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestAcceptByCaregiver";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." has accepted your transfer request";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestAcceptByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestAcceptByUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestAcceptByUser";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." has accepted your transfer request";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestAcceptByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestRejectByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestRejectByCaregiver";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." has rejected your transfer request";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestRejectByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestRejectByUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestRejectByUser";
        $data['title'] = "Substitute Job";
        $data['desc'] = $senderData->firstName.' '.$senderData->lastName." has rejected your transfer request";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestRejectByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function caregiverSubstituteJobRequestByCaregiverToUser($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        $caregiverData = $this->Users_Model->get(['id'=>$data['caregiver_id'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "caregiverSubstituteJobRequestByCaregiverToUser";
        $data['title'] = "Substitute Job";
        $data['desc'] = "Your job ".$data['jobName']." has been transferred to a new caregiver. Please review ".$caregiverData->firstName.' '.$caregiverData->lastName." profile and accept or Decline the transfer.";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "caregiverSubstituteJobRequestByCaregiverToUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function sendJobVerificationCodeForUser($data){
        if (empty($data)) {
            return false;
        }
        $user = $this->Users_Model->get(['id' => $data['userId']]);
        
        if (empty($user)) {
            return false;
        }
      
        $user->verificationCode = $data['verificationCode'];
        $user->jobName = $data['jobName'];
        if (!empty($user->email)) {
            $mailBody = $this->load->view('Mail/JobVerificationCode', ['user' => $user], TRUE);
            $this->Common_Model->mailsend($user->email," Job Verification Code", $mailBody);
        }
    }
    
    public function transactionSuccessForJobPayment($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "transactionSuccessForJobPayment";
        $data['title'] = "Job Payment";
        $data['desc'] = $data['amount']." has been successfully charged to your card for ".$data['jobName']." job payment";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "transactionSuccessForJobPayment",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
    
    public function transactionFailForJobPayment($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "transactionFailForJobPayment";
        $data['title'] = "Job Payment Transaction Failed";
        $data['desc'] = $data['amount']." job payment transaction failed. Reason: ".$data['errorMsg'];
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "transactionFailForJobPayment",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
    
    public function transactionSuccessForAdditionaHoursJobPayment($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "transactionSuccessForAdditionaHoursJobPayment";
        $data['title'] = "Additional Hours Job Payment";
        $data['desc'] = $data['amount']." has been successfully charged to your card for ".$data['jobName']." job additional hours payment";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "transactionSuccessForAdditionaHoursJobPayment",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
 
    public function addMoneyInYourWalletForUserJobPayment($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "addMoneyInYourWalletForUserJobPayment";
        $data['title'] = "Money Added In Your Wallet";
        $data['desc'] = $data["amount"]." added in your wallet for completing the ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "addMoneyInYourWalletForUserJobPayment",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
 
    public function applyUserJobByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "applyUserJobByCaregiver";
        $data['title'] = "Apply Job";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName." has applied for your ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "applyUserJobByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
 
    public function alertCaregiverMessageBeforeStartjobOf30Mint($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "alertCaregiverMessageBeforeStartjobOf30Mint";
        $data['title'] = "Job Starting Soon";
        $data['desc'] =  "Your ".$data['jobName']." job is starting soon";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "alertCaregiverMessageBeforeStartjobOf30Mint",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function alertUserMessageBeforeStartjobOf30Mint($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "alertUserMessageBeforeStartjobOf30Mint";
        $data['title'] = "Job Starting Soon";
        $data['desc'] =  "Your ".$data['jobName']." job is starting soon";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "alertUserMessageBeforeStartjobOf30Mint",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function sendJobImageRequest($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "sendJobImageRequest";
        $data['title'] = "Job Image Request";
        $data['desc'] =  "Tap here and upload a image for ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "sendJobImageRequest",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function sendJobVideoRequest($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "sendJobVideoRequest";
        $data['title'] = "Job Video Request";
        $data['desc'] =  "Tap here and upload a video for ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "sendJobVideoRequest",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function ongoingJobMediaRequestOfCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "ongoingJobMediaRequestOfCaregiver";
        $data['title'] = "Job Media Request";
        $data['desc'] =  "Tap here and upload a image or video for ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "ongoingJobMediaRequestOfCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function ongoingJobReviewRequestCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "ongoingJobReviewRequestCaregiver";
        $data['title'] = "Job Review Request";
        $data['desc'] =  "Tap here and give a review for ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "ongoingJobReviewRequestCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function ongoingJobReviewRequestUser($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "ongoingJobReviewRequestUser";
        $data['title'] = "Caregiver Review Request";
        $data['desc'] =  "Tap here and give a review in caregiver for ".$data['jobName']." job";
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "ongoingJobReviewRequestUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function sendExtraTimeRequestOfCurrentJobByUser($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "sendExtraTimeRequestOfCurrentJobByUser";
        $data['title'] = "Job Additional Time Request";
        $data['desc'] =  "Tap here and accept or decline for ".$data['jobName']." job additional ".$data['hours']." hours";
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "sendExtraTimeRequestOfCurrentJobByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function declineExtraTimeRequestOfCurrentJobByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "declineExtraTimeRequestOfCurrentJobByCaregiver";
        $data['title'] = "Decline Job Additional Time Request";
        //$data['desc'] =  $senderData->firstName.' '.$senderData->lastName." is declined your ".$data['jobName']." job for additional hours request";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName."  has declined your additional hours request for ".$data['jobName'];
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "declineExtraTimeRequestOfCurrentJobByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function acceptExtraTimeRequestOfCurrentJobByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "acceptExtraTimeRequestOfCurrentJobByCaregiver";
        $data['title'] = "Accept Job Additional Time Request";
        //$data['desc'] =  $senderData->firstName.' '.$senderData->lastName." is accepted your ".$data['jobName']." job for additional hours request";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName." has accepted your additional hours request for ".$data['jobName'];
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "acceptExtraTimeRequestOfCurrentJobByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return true;
    }
 
    public function sendAwardJobRequestByUser($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "sendAwardJobRequestByUser";
        $data['title'] = "Job Request";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName." has send you request for ".$data['jobName']." job";
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "sendAwardJobRequestByUser",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
 
    public function declineAwardJobRequestByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "declineAwardJobRequestByCaregiver";
        $data['title'] = "Job Request Decline";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName." has decline your request for ".$data['jobName']." job";
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "declineAwardJobRequestByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }
 
    public function acceptAwardJobRequestByCaregiver($data){
        if(empty($data)){
            return false;
        }
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        $receiverData = $this->Users_Model->get(['id'=>$data['send_to'],'status'=>1],true);
        if(empty($senderData) || empty($receiverData)){
            return false;
        }
    
        // Send friend request
        $data['model'] = "acceptAwardJobRequestByCaregiver";
        $data['title'] = "Job Request Accept";
        $data['desc'] =  $senderData->firstName.' '.$senderData->lastName." has accept your request for ".$data['jobName']." job";
        
        $notification = array(
            "title" => $data['title'],
            "body" => $data['desc'],
            "badge" => intval(0),
            "sound" => "default"
        );
        $extData = array(
            "category" => "acceptAwardJobRequestByCaregiver",
            "messageData" => $data,
            "unread" => (string) 0
        );

        $savedId = $this->Notification->setData($data);
        $receiverAuthData = $this->Auth_Model->get(['userId'=>$data['send_to'],'status'=>1]);
        if(!empty($receiverAuthData)){
            foreach($receiverAuthData as $value){
                $this->pushNotification($value->deviceToken, $notification, $extData, 0);
            }
        }
        return $savedId;
    }

    public function testNotification($deviceToken, $notification, $extData, $b ) {
        $result = array();
        if (!empty($deviceToken)) {
            $result = $this->fcm->sendMessageNew($extData, $notification, $deviceToken);
        }
        error_log("\n\n -------------------------------------" . date('c'). " \n". json_encode($notification)." \n". $deviceToken." \n". json_encode($extData)." \n". json_encode($result) , 3, FCPATH.'worker/notification.log');
        return $result; 
    }

    // Update provider availability entry NEW FLOW
    public function getCaregiverAvailabilityNew($userId = "", $userTimeZone = "", $caregiverTimeZone = "", $ignoreSlot = false) {
        if(empty($userId)){
            return false;
        }
        $this->load->model('User_Availability_Model');
        
        $userAvailability = $this->User_Availability_Model->get(['userId'=>$userId,'getFutureAvailability'=>true,'status'=>1,'orderby'=>'startDateTime','orderstate'=>'ASC']);
        if(empty($userAvailability)){
            return false;
        }

        $availabilitySlot = array();
        foreach($userAvailability as $value){
            $startdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $startdatetime->setTimezone(new DateTimeZone($userTimeZone));
            $startdatetime->setTimestamp($value->startDateTime);

            $enddatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $enddatetime->setTimezone(new DateTimeZone($userTimeZone));
            $enddatetime->setTimestamp($value->endDateTime);

            $temparray = array();
            $temparray['availabilityId'] = $value->id;
            $temparray['startTimeStamp'] = $value->startDateTime;
            $temparray['endTimeStamp'] = $value->endDateTime;
            $temparray['caregiverStartTimeStamp'] = $startdatetime->format('U');
            $temparray['caregiverEndTimeStamp'] = $enddatetime->format('U');
            $temparray['caregiverStartDateTime'] = $startdatetime->format('Y-m-d H:i:s');
            $temparray['caregiverEndDateTime'] = $enddatetime->format('Y-m-d H:i:s');
            $temparray['date'] = $startdatetime->format('Y-m-d');
            $temparray['startTime'] = $startdatetime->format('h:i A');
            $temparray['endTime'] = $enddatetime->format('h:i A');
            $temparray["dayAndDate"] = $this->Common_Model->getDayAndDateName($value->startDateTime,$userTimeZone);
            if($ignoreSlot == true){
                $availabilitySlot[] = $temparray;
            }else{
                $temparray['slot'] = $this->getTimeSlots($value->startDateTime, $value->endDateTime, $value->timing, $userTimeZone, $caregiverTimeZone, $userId);
                if(!empty($temparray['slot'])){
                    $availabilitySlot[] = $temparray;
                }
            }
        }
        return $availabilitySlot;
    }

    function getTimeSlots($StartTime, $EndTime, $Duration="30", $userTimeZone = "", $caregiverTimeZone = "", $userId = ""){
        $this->load->model('User_Job_Detail_Model');

        $currentdate = new DateTime();
        //$currentdate->setTimezone(new DateTimeZone($userTimeZone));

        $ReturnArray = array();// Define output
        $AddMins = $Duration * 60;
        
        $skiparrays = array();
        while ($StartTime <= $EndTime) //Run loop
        {
            if($currentdate->format('U') > $StartTime){
                $StartTime += $AddMins; //Endtime check
                continue;
            }

            if(($StartTime+$AddMins) <= $EndTime){
                $startdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startdatetime->setTimezone(new DateTimeZone($userTimeZone));
                $startdatetime->setTimestamp($StartTime);

                $enddatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $enddatetime->setTimezone(new DateTimeZone($userTimeZone));
                $enddatetime->setTimestamp($StartTime+$AddMins);
                $isBooked = 0;
                $checkSlotExist = $this->User_Job_Detail_Model->get(['checkBookedSlot'=>['startDateTime'=>$StartTime,'endDateTime'=>$StartTime+$AddMins,'userId'=>$userId],'status'=>1],true);
                //echo $this->db->last_query(); die;
                if(!empty($checkSlotExist)){
                    $isBooked = 1;
                }
                
                $ReturnTempArray = array();
                $ReturnTempArray['caregiverStartTimeStamp'] = $startdatetime->format('U');
                $ReturnTempArray['caregiverEndTimeStamp'] = $enddatetime->format('U');
                $ReturnTempArray['startDateTime'] = $startdatetime->format('Y-m-d H:i:s');
                $ReturnTempArray['endDateTime'] = $enddatetime->format('Y-m-d H:i:s');
                $ReturnTempArray['startTimestamp'] = $StartTime;
                $ReturnTempArray['endTimestamp'] = ($StartTime+$AddMins);
                $ReturnTempArray['date'] = $startdatetime->format("Y-m-d");
                $ReturnTempArray['time'] = $startdatetime->format("h:i a");
                $ReturnTempArray['duration'] = $Duration;
                $ReturnTempArray['isBooked'] = $isBooked;
                $ReturnArray[] = $ReturnTempArray;
            }
            $StartTime += $AddMins; //Endtime check
        }
        return $ReturnArray;
    }

    function collectPaymentUseApi($jobId = ""){
        if(empty($jobId)){
            return false;
        }
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => base_url().'/cron/C001_1hour_take_job_advance_payment_from_user/'.$jobId,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'GET',
        ));
        $response = curl_exec($curl);

        curl_close($curl);
        //print_r(json_decode($response)); die;
    }

    public function sendChatNotification($data) {
        if(empty($data['users'])) {
            return false;
        } 
        
        $savedId = "";
        $senderData = $this->Users_Model->get(['id'=>$data['send_from'],'status'=>1],true);
        foreach ($data['users'] as $userId) {
            $receiverData = $this->Users_Model->get(['id' => $userId, 'status' =>1], true);
            if(/* empty($senderData) || */ empty($receiverData)){
                return false;
            }

            // Send message
            $data['model'] = "userCaregiverChatPushNotification";
            $data['title'] = $senderData->firstName.' '.$senderData->lastName;
            $data['desc'] =($data['message']->type == 2 ? "Image" : ($data['message']->type == 3 ? "Video" : ($data['message']->type == 4 ? "Suggest Caregiver" : ($data['message']->type == 5 ? "Attachment" : json_decode('"'.$data['message']->message.'"')))));
            $data['model_id'] = (int) $senderData->id;
            $data['receiverName'] = $senderData->firstName.' '.$senderData->lastName;
            $data['send_to'] = $userId;
            $notification = array(
                "title" => $data['title'],
                "body" => $data['desc'],
                "badge" => intval(0),
                "sound" => "default"
            );
            $extData = array(
                "category" => "userCaregiverChatPushNotification",
                "messageData" => $data,
                "unread" => (string) 0
            );
    
            //$savedId = $this->Notification->setData($data);
            $receiverAuthData = $this->Auth_Model->get(['userId' => $userId, 'status' => 1]);
            if (!empty($receiverAuthData)) {
                foreach($receiverAuthData as $value) {
                    $this->pushNotification($value->deviceToken, $notification, $extData, 0);
                }
            }
            // return $savedId;
        }
    }
}
