<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Users extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model');
        $this->load->model('Background_Model');
        $this->load->model('Users_Model', 'User');
        $this->load->model('User_Certifications_Licenses_Model');
        $this->load->model('User_Work_Job_Category_Model');
        $this->load->model('User_Work_Detail_Model');
        $this->load->model('User_Work_Experience_Model');
        $this->load->model('User_Insurance_Model');
        $this->load->model('User_About_Loved_Model');
        $this->load->model('User_Loved_Category_Model');
        $this->load->model('User_Loved_Specialities_Model');
        $this->load->model('User_Availability_Offtime_Model');
        $this->load->model('User_Availability_Setting_Model');
        $this->load->model('User_Work_Disabilities_Willing_Type_Model');
        $this->load->model('User_Availability_Model');
        $this->load->model('User_Availability_Setting_New_Model');
    }

    public function getUserInfo_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $data = $this->User->userData($user->id, false);
        if (!empty($data)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getUserinfoSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userInfoNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function savePersonalDetails_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        // (caregiver = 1->Subscription, 2->Personal Details, 3->Certifications/Licenses, 4->Your Address, 5->Work Details, 6->Insurance, 7->Set Availability and Under Review, 8->Review and Accepted)
        // (user = 1->Subscription, 2->Personal Details, 3->About your loved one, 4->Location)
        $setData = array();
        if (isset($apiData['data']['firstName']) && !empty($apiData['data']['firstName'])) {
            $setData['firstName'] = $apiData['data']['firstName'];
        }
        if (isset($apiData['data']['lastName']) && !empty($apiData['data']['lastName'])) {
            $setData['lastName'] = $apiData['data']['lastName'];
        }
        if (isset($apiData['data']['image']) && !empty($apiData['data']['image'])) {
            $setData['image'] = $apiData['data']['image'];
        }
        if (isset($apiData['data']['age']) && !empty($apiData['data']['age'])) {
            $setData['age'] = $apiData['data']['age'];
        }
        if (isset($apiData['data']['phone']) && !empty($apiData['data']['phone'])) {
            $setData['phone'] = $apiData['data']['phone'];
        }
        if (isset($apiData['data']['gender']) && !empty($apiData['data']['gender'])) {
            $setData['gender'] = $apiData['data']['gender'];
        }
        if (isset($apiData['data']['familyVaccinated']) && !empty($apiData['data']['familyVaccinated'])) {
            $setData['familyVaccinated'] = $apiData['data']['familyVaccinated'];
        }
        if (isset($apiData['data']['hearAboutUsId']) && !empty($apiData['data']['hearAboutUsId'])) {
            $setData['hearAboutUsId'] = $apiData['data']['hearAboutUsId'];
        }
        if (isset($apiData['data']['soonPlanningHireDate']) && !empty($apiData['data']['soonPlanningHireDate'])) {
            $setData['soonPlanningHireDate'] = date('Y-m-d',strtotime($apiData['data']['soonPlanningHireDate']));
        }

        if (isset($apiData['data']['inboxMsgText']) && in_array($apiData['data']['inboxMsgText'], array(1,2))) {
            $setData['inboxMsgText'] = $apiData['data']['inboxMsgText'];
        }

        if (isset($apiData['data']['inboxMsgMail']) && in_array($apiData['data']['inboxMsgMail'], array(1,2))) {
            $setData['inboxMsgMail'] = $apiData['data']['inboxMsgMail'];
        }

        if (isset($apiData['data']['jobMsgText']) && in_array($apiData['data']['jobMsgText'], array(1,2))) {
            $setData['jobMsgText'] = $apiData['data']['jobMsgText'];
        }

        if (isset($apiData['data']['jobMsgMail']) && in_array($apiData['data']['jobMsgMail'], array(1,2))) {
            $setData['jobMsgMail'] = $apiData['data']['jobMsgMail'];
        }

        if (isset($apiData['data']['caregiverUpdateText']) && in_array($apiData['data']['caregiverUpdateText'], array(1,2))) {
            $setData['caregiverUpdateText'] = $apiData['data']['caregiverUpdateText'];
        }

        if (isset($apiData['data']['caregiverUpdateMail']) && in_array($apiData['data']['caregiverUpdateMail'], array(1,2))) {
            $setData['caregiverUpdateMail'] = $apiData['data']['caregiverUpdateMail'];
        }

        if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
            $setData['profileStatus'] = $apiData['data']['profileStatus'];
        }

        if(empty($setData)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("savePersonalDetailsFail", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $set = $this->User->setData($setData, $user->id);
        if (!empty($set)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("savePersonalDetailsSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("savePersonalDetailsFail", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function updateProfileStatus_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
         
        if (!isset($apiData['data']['profileStatus']) || $apiData['data']['profileStatus'] == "") {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("profileStatusRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $userData['profileStatus'] = $apiData['data']['profileStatus'];
        
        $setData = $this->User->setData($userData, $user->id);
        if(!empty($setData)){
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("profileStatusUpdatedSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id,TRUE);
        }else{
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToUpdateProfileStatus", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveCertificationsLicenses_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['haveCertificationsOrLicenses']) || empty($apiData['data']['haveCertificationsOrLicenses'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("haveCertificationsOrLicensesRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if($apiData['data']['haveCertificationsOrLicenses'] == "1"){
            $set = $this->User_Certifications_Licenses_Model->setData(['userIds'=>$user->id,'status'=>2]);
            $set = 1;
            if (isset($apiData['data']['certificationsOrLicenses']) && !empty($apiData['data']['certificationsOrLicenses'])) {
               
                foreach($apiData['data']['certificationsOrLicenses'] as $value){
                    if(!isset($value['licenceTypeId']) || !isset($value['licenceName']) || !isset($value['licenceNumber']) || !isset($value['issueDate']) || !isset($value['expireDate']) || !isset($value['licenceImage'])){
                        continue;
                        
                    }
                    $certLicArray = array();
                    $certLicArray['userId'] = $user->id;
                    $certLicArray['licenceTypeId'] = $value['licenceTypeId'];
                    $certLicArray['licenceName'] = $value['licenceName'];
                    $certLicArray['licenceNumber'] = $value['licenceNumber'];
                    $certLicArray['issueDate'] = date('Y-m-d',strtotime($value['issueDate']));
                    $certLicArray['expireDate'] = date('Y-m-d',strtotime($value['expireDate']));
                    $certLicArray['licenceImage'] = $value['licenceImage'];
                    $certLicArray['description'] = (isset($value['description']) ? $value['description'] : "");
                    $certLicArray['status'] = 1;
                    $certLicExistData = $this->User_Certifications_Licenses_Model->get(['licenceNumber'=>$value['licenceNumber']],true);
                    if(!empty($certLicExistData)){
                        $this->User_Certifications_Licenses_Model->setData($certLicArray,$certLicExistData->id);
                    }else{
                        $this->User_Certifications_Licenses_Model->setData($certLicArray);
                    }
                }
            }
        }else{
            $set = $this->User_Certifications_Licenses_Model->setData(['userIds'=>$user->id,'status'=>2]);
            $set = 1;
        }
        if (!empty($set)) {
            $setData = array();
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveCertificationsorLicensesSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveCertificationsorLicenses", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getCertificationsLicenses_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = $this->User_Certifications_Licenses_Model->get(['apiResponse'=>true,'userId'=>$user->id,'getLicenceTypeData'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($data)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getCertificationsorLicensesDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("certificationsorLicensesDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveAddressOrLocation_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        $setData = array();
        if (isset($apiData['data']['address']) && !empty($apiData['data']['address'])) {
            $setData['address'] = $apiData['data']['address'];
        }
        if (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude'])) {
            $setData['latitude'] = $apiData['data']['latitude'];
        }
        if (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude'])) {
            $setData['longitude'] = $apiData['data']['longitude'];
        }
      
        if(empty($setData)){
            $this->apiResponse['status'] = "0";
            if ($user->role == '3') {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAddress", $apiData['data']['langType']);
            }else{
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveLocation", $apiData['data']['langType']);
            }
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $set = $this->User->setData($setData, $user->id);
        if (!empty($set)) {
            $setData = array();
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            $this->apiResponse['status'] = "1";
            if ($user->role == '3') {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAddressSuccess", $apiData['data']['langType']);
            }else{
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveLocationSuccess", $apiData['data']['langType']);
            }
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            if ($user->role == '3') {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAddress", $apiData['data']['langType']);
            }else{
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveLocation", $apiData['data']['langType']);
            }
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveWorkDetails_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['jobCategory']) || empty($apiData['data']['jobCategory'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobCategoryRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['workSpecialityId']) || empty($apiData['data']['workSpecialityId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("workSpecialityIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['maxDistanceTravel']) || empty($apiData['data']['maxDistanceTravel'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("maxDistanceTravelRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['workMethodOfTransportationId']) || empty($apiData['data']['workMethodOfTransportationId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("workMethodOfTransportationIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['workDisabilitiesWillingType']) || empty($apiData['data']['workDisabilitiesWillingType'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("workDisabilitiesWillingTypeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['experienceOfYear']) || $apiData['data']['experienceOfYear'] == "") {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("experienceOfYearRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['inspiredYouBecome']) || empty($apiData['data']['inspiredYouBecome'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("inspiredYouBecomeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['bio']) || empty($apiData['data']['bio'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("bioRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $data = array();
        $data['userId'] = $user->id;
        $data['workSpecialityId'] = $apiData['data']['workSpecialityId'];
        $data['maxDistanceTravel'] = $apiData['data']['maxDistanceTravel'];
        $data['workMethodOfTransportationId'] = $apiData['data']['workMethodOfTransportationId'];
        $data['experienceOfYear'] = $apiData['data']['experienceOfYear'];
        $data['inspiredYouBecome'] = $apiData['data']['inspiredYouBecome'];
        $data['bio'] = $apiData['data']['bio'];
        $data['status'] = 1;

        $existWordDetailData = $this->User_Work_Detail_Model->get(['userId'=>$user->id],true);
        if(!empty($existWordDetailData)){
            $set = $this->User_Work_Detail_Model->setData($data,$existWordDetailData->id);
        }else{
            $set = $this->User_Work_Detail_Model->setData($data);
        }
        if (!empty($set)) {
            // Set Category
            $this->User_Work_Job_Category_Model->setData(['userIds'=>$user->id,'status'=>2]);
            foreach($apiData['data']['jobCategory'] as $value){
                if(empty($value)){
                    continue;
                }
                $existCategoryData = $this->User_Work_Job_Category_Model->get(['userId'=>$user->id,'jobCategoryId'=>trim($value)],true);
                if(!empty($existCategoryData)){
                    $this->User_Work_Job_Category_Model->setData(['userId'=>$user->id,'jobCategoryId'=>trim($value),'status'=>1],$existCategoryData->id);
                }else{
                    $this->User_Work_Job_Category_Model->setData(['userId'=>$user->id,'jobCategoryId'=>trim($value)]);
                }
            }
            // ./ Set Category

            // Set Work Disabilities Willing Type
            $this->User_Work_Disabilities_Willing_Type_Model->setData(['userIds'=>$user->id,'status'=>2]);
            foreach($apiData['data']['workDisabilitiesWillingType'] as $value){
                if(empty($value)){
                    continue;
                }
                $existDisabilitiesWillingTypeData = $this->User_Work_Disabilities_Willing_Type_Model->get(['userId'=>$user->id,'workDisabilitiesWillingTypeId'=>trim($value)],true);
                if(!empty($existDisabilitiesWillingTypeData)){
                    $this->User_Work_Disabilities_Willing_Type_Model->setData(['userId'=>$user->id,'workDisabilitiesWillingTypeId'=>trim($value),'status'=>1],$existDisabilitiesWillingTypeData->id);
                }else{
                    $this->User_Work_Disabilities_Willing_Type_Model->setData(['userId'=>$user->id,'workDisabilitiesWillingTypeId'=>trim($value)]);
                }
            }
            // ./ Set Work Disabilities Willing Type

            // Work Experience
            $this->User_Work_Experience_Model->delete($user->id);
            if (isset($apiData['data']['workExperience']) && !empty($apiData['data']['workExperience'])) {
                foreach($apiData['data']['workExperience'] as $value){
                    if(!isset($value['workPlace']) || !isset($value['startDate'])){
                        continue;
                    }
                    $workExpArray = array();
                    $workExpArray['userId'] = $user->id;
                    $workExpArray['workPlace'] = $value['workPlace'];
                    $workExpArray['startDate'] = $value['startDate'];
                    $workExpArray['endDate'] = (isset($value['endDate']) ? $value['endDate'] : "");
                    $workExpArray['leavingReason'] = (isset($value['leavingReason']) ? $value['leavingReason'] : "");
                    $workExpArray['description'] = (isset($value['description']) ? $value['description'] : "");
                    $this->User_Work_Experience_Model->setData($workExpArray);
                }
            }
            // ./ Work Experience

            $setData = array();
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveWorkDetailsSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveWorkDetails", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getWorkDetails_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = $this->User_Work_Detail_Model->get(['apiResponse'=>true,'userId'=>$user->id,'getExtraData'=>true,'status'=>1],true);
        if (!empty($data)) {
            $data->categoryData = $this->User_Work_Job_Category_Model->get(['apiResponse'=>true,'getJobCategoryData'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
            $data->workExperienceData = $this->User_Work_Experience_Model->get(['apiResponse'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
            $data->workDisabilitiesWillingTypeData = $this->User_Work_Disabilities_Willing_Type_Model->get(['apiResponse'=>true,'getWorkJobDisabilitiesWillingTypeData'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getWorkDetailsSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("workDetailsNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveInsurance_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['haveInsurance']) || empty($apiData['data']['haveInsurance'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("haveAnyInsuranceRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if($apiData['data']['haveInsurance'] == "1"){
            $set = $this->User_Insurance_Model->setData(['userIds'=>$user->id,'status'=>2]);
            $set = 1;
            if (isset($apiData['data']['insurance']) && !empty($apiData['data']['insurance'])) {
               
                foreach($apiData['data']['insurance'] as $value){
                    if(!isset($value['insuranceTypeId']) || !isset($value['insuranceName']) || !isset($value['insuranceNumber']) || !isset($value['expireDate']) || !isset($value['insuranceImage'])){
                        continue;
                        
                    }
                    $insuArray = array();
                    $insuArray['userId'] = $user->id;
                    $insuArray['insuranceTypeId'] = $value['insuranceTypeId'];
                    $insuArray['insuranceName'] = $value['insuranceName'];
                    $insuArray['insuranceNumber'] = $value['insuranceNumber'];
                    $insuArray['expireDate'] = date('Y-m-d',strtotime($value['expireDate']));;
                    $insuArray['insuranceImage'] = $value['insuranceImage'];
                    $insuArray['status'] = 1;
                    $certLicExistData = $this->User_Insurance_Model->get(['insuranceNumber'=>$value['insuranceNumber']],true);
                    if(!empty($certLicExistData)){
                        $this->User_Insurance_Model->setData($insuArray,$certLicExistData->id);
                    }else{
                        $this->User_Insurance_Model->setData($insuArray);
                    }
                }
            }
        }else{
            $set = $this->User_Insurance_Model->setData(['userIds'=>$user->id,'status'=>2]);
            $set = 1;
        }
        if (!empty($set)) {
            $setData = array();
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveInsuranceDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveInsuranceData", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getInsurance_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = $this->User_Insurance_Model->get(['apiResponse'=>true,'userId'=>$user->id,'getInsuranceTypeData'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($data)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getInsuranceDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("insuranceDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
    
    public function saveAboutLoved_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        /*if (!isset($apiData['data']['lovedDisabilitiesTypeId']) || empty($apiData['data']['lovedDisabilitiesTypeId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("lovedDisabilitiesTypeIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['lovedAboutDesc']) || empty($apiData['data']['lovedAboutDesc'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("lovedAboutDescRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['lovedBehavioral']) || empty($apiData['data']['lovedBehavioral'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("lovedBehavioralRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['lovedVerbal']) || empty($apiData['data']['lovedVerbal'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("lovedVerbalRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['lovedSpecialities']) || empty($apiData['data']['lovedSpecialities'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("lovedSpecialitiesRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $setData = array();
        $setData['userId'] = $user->id;
        $setData['lovedDisabilitiesTypeId'] = $apiData['data']['lovedDisabilitiesTypeId'];
        $setData['lovedAboutDesc'] = $apiData['data']['lovedAboutDesc'];
        $setData['lovedBehavioral'] = $apiData['data']['lovedBehavioral'];
        $setData['lovedVerbal'] = $apiData['data']['lovedVerbal'];
        $setData['allergies'] = (isset($apiData['data']['allergies']) ? $apiData['data']['allergies'] : "");
        $setData['lovedOtherCategoryText'] = (isset($apiData['data']['lovedOtherCategoryText']) ? $apiData['data']['lovedOtherCategoryText'] : "");
        $setData['status'] = 1;
        $aboutLovedExistData = $this->User_About_Loved_Model->get(['userId'=>$user->id],true);
        if(!empty($aboutLovedExistData)){
            $set = $this->User_About_Loved_Model->setData($setData,$aboutLovedExistData->id);
        }else{
            $set = $this->User_About_Loved_Model->setData($setData);
        }

        */

        $this->User_About_Loved_Model->delete($user->id);
        $this->User_Loved_Specialities_Model->delete($user->id);
        $this->User_Loved_Category_Model->delete($user->id);
        $set = 1;
        if (isset($apiData['data']['lovedOne']) && !empty($apiData['data']['lovedOne'])) {
            foreach($apiData['data']['lovedOne'] as $value){
                if(!isset($value['lovedDisabilitiesTypeId']) || !isset($value['lovedAboutDesc']) || !isset($value['lovedBehavioral']) || !isset($value['lovedVerbal'])){
                    continue;
                }
                $setData = array();
                $setData['userId'] = $user->id;
                $setData['lovedDisabilitiesTypeId'] = $value['lovedDisabilitiesTypeId'];
                $setData['lovedAboutDesc'] = $value['lovedAboutDesc'];
                $setData['lovedBehavioral'] = $value['lovedBehavioral'];
                $setData['lovedVerbal'] = $value['lovedVerbal'];
                $setData['allergies'] = (isset($value['allergies']) ? $value['allergies'] : "");
                $setData['lovedOtherCategoryText'] = (isset($value['lovedOtherCategoryText']) ? $value['lovedOtherCategoryText'] : "");
                $setData['status'] = 1;

                if (isset($value['userAboutLovedId']) && !empty($value['userAboutLovedId'])) {
                    $aboutLovedExistData = $this->User_About_Loved_Model->get(['id'=>$value['userAboutLovedId']],true);
                    if(!empty($aboutLovedExistData)){
                        $set = $this->User_About_Loved_Model->setData($setData,$aboutLovedExistData->id);
                    }else{
                        $set = $this->User_About_Loved_Model->setData($setData);
                    }
                }else{
                    $set = $this->User_About_Loved_Model->setData($setData);
                }
                if(!empty($set)){
                    // Set Category
                    foreach($value['lovedCategory'] as $cvalue){
                        if(empty($cvalue)){
                            continue;
                        }
                        $existCategoryData = $this->User_Loved_Category_Model->get(['userId'=>$user->id,'lovedCategoryId'=>trim($cvalue),'userAboutLovedId'=>$set],true);
                        if(!empty($existCategoryData)){
                            $this->User_Loved_Category_Model->setData(['userId'=>$user->id,'lovedCategoryId'=>trim($cvalue),'userAboutLovedId'=>$set,'status'=>1],$existCategoryData->id);
                        }else{
                            $this->User_Loved_Category_Model->setData(['userId'=>$user->id,'lovedCategoryId'=>trim($cvalue),'userAboutLovedId'=>$set]);
                        }
                    }
                    // ./ Set Category

                    // Set Specialities
                    foreach($value['lovedSpecialities'] as $svalue){
                        if(empty($svalue)){
                            continue;
                        }
                        $existSpecialitiesData = $this->User_Loved_Specialities_Model->get(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($svalue),'userAboutLovedId'=>$set],true);
                        if(!empty($existSpecialitiesData)){
                            $this->User_Loved_Specialities_Model->setData(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($svalue),'userAboutLovedId'=>$set,'status'=>1],$existSpecialitiesData->id);
                        }else{
                            $this->User_Loved_Specialities_Model->setData(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($svalue),'userAboutLovedId'=>$set]);
                        }
                    }
                    // ./ Set Specialities
                }
            }
        }

        if (!empty($set)) {
            /*
            // Set Category
            $this->User_Loved_Category_Model->setData(['userIds'=>$user->id,'status'=>2]);
            foreach($apiData['data']['lovedCategory'] as $value){
                if(empty($value)){
                    continue;
                }
                $existCategoryData = $this->User_Loved_Category_Model->get(['userId'=>$user->id,'lovedCategoryId'=>trim($value)],true);
                if(!empty($existCategoryData)){
                    $this->User_Loved_Category_Model->setData(['userId'=>$user->id,'lovedCategoryId'=>trim($value),'status'=>1],$existCategoryData->id);
                }else{
                    $this->User_Loved_Category_Model->setData(['userId'=>$user->id,'lovedCategoryId'=>trim($value)]);
                }
            }
            // ./ Set Category

            // Set Specialities
            $this->User_Loved_Specialities_Model->setData(['userIds'=>$user->id,'status'=>2]);
            foreach($apiData['data']['lovedSpecialities'] as $value){
                if(empty($value)){
                    continue;
                }
                $existSpecialitiesData = $this->User_Loved_Specialities_Model->get(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($value)],true);
                if(!empty($existSpecialitiesData)){
                    $this->User_Loved_Specialities_Model->setData(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($value),'status'=>1],$existSpecialitiesData->id);
                }else{
                    $this->User_Loved_Specialities_Model->setData(['userId'=>$user->id,'lovedSpecialitiesId'=>trim($value)]);
                }
            }
            // ./ Set Specialities
            */
            $setData = array();
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAboutLovedDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAboutLovedData", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getAboutLoved_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = $this->User_About_Loved_Model->get(['apiResponse'=>true,'userId'=>$user->id,'getLovedDisabilitiesTypeData'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($data)) {
            foreach($data as $value){
                $value->lovedCategoryData = $this->User_Loved_Category_Model->get(['apiResponse'=>true,'userAboutLovedId'=>$value->userAboutLovedId,'getLovedCategoryData'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
                $value->loveSpecialitiesData = $this->User_Loved_Specialities_Model->get(['apiResponse'=>true,'userAboutLovedId'=>$value->userAboutLovedId,'getLovedSpecialitiesData'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getAboutLovedDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("aboutLovedDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveCaregiverAvailabilitySetting_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        $lastId = "";
        $this->User_Availability_Offtime_Model->removeData($user->id);
        if(isset($apiData['data']['offDateTime']) && !empty($apiData['data']['offDateTime'])){
            foreach($apiData['data']['offDateTime'] as $value){
                if(!isset($value['day']) || !isset($value['month']) || !isset($value['startTime']) || !isset($value['endTime'])){
                    continue;
                }
                $availabilityOffData = array();
                $availabilityOffData['userId'] = $user->id;
                $availabilityOffData['day'] = $value['day'];
                $availabilityOffData['month'] = $value['month'];
                $availabilityOffData['startTime'] = $value['startTime'];
                $availabilityOffData['endTime'] = $value['endTime'];
                $availabilityOffData['status'] = 1;
                $lastId = $this->User_Availability_Offtime_Model->setData($availabilityOffData);
            }
        }

        $this->User_Availability_Setting_Model->removeData($user->id);
        if(isset($apiData['data']['availability']) && !empty($apiData['data']['availability'])){
            foreach($apiData['data']['availability'] as $value){
                if(!isset($value['type']) || !isset($value['startTime']) || !isset($value['endTime'])){
                    continue;
                }
                
                $availabilityData = array();
                $availabilityData['userId'] = $user->id;
                $availabilityData['type'] = $value['type'];
                $availabilityData['timing'] = 60;
                $availabilityData['startTime'] = $value['startTime'];
                $availabilityData['endTime'] = $value['endTime'];
                $availabilityData['status'] = 1;
                if($value['type'] == 3){
                    if(!isset($value['day'])){
                        continue;
                    }
                    $availabilityData['day'] = $value['day'];
                }
        
                $lastId = $this->User_Availability_Setting_Model->setData($availabilityData);
            }
        }

        if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus']) && $user->profileStatus != "8") {
            $setData = array();
            $setData['profileStatus'] = $apiData['data']['profileStatus'];
            $this->User->setData($setData, $user->id);
        }
        
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySettingDataSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $this->User->userData($user->id, false);

        /*if (!empty($lastId)) {
            if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus']) && $user->profileStatus != "8") {
                $setData = array();
                $setData['profileStatus'] = $apiData['data']['profileStatus'];
                $this->User->setData($setData, $user->id);
            }
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySettingDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAvailabilitySettingData", $apiData['data']['langType']);
        }*/
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getCaregiverAvailabilitySetting_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role  != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $response = array();
        $response['availabilitySetting'] = $this->User_Availability_Setting_Model->get(['apiResponse'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $response['timeOff'] = $this->User_Availability_Offtime_Model->get(['apiResponse'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($response['availabilitySetting']) || !empty($response['timeOff'])) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getAvailabilitySettingSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("availabilitySettingNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    // New availability setting of date or week wise data
    public function saveCaregiverAvailability_OLDone_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['type']) || !in_array($apiData['data']['type'], array(1,2))) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("typeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['startTime']) || empty($apiData['data']['startTime'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("startTimeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['endTime']) || empty($apiData['data']['endTime'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("endTimeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        if($apiData['data']['type'] == 1){
            if (!isset($apiData['data']['dates']) || empty($apiData['data']['dates'])) {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("dateRequired", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $this->User_Availability_Setting_New_Model->removeData($user->id);
            $currentdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $currentdatetime->setTimezone(new DateTimeZone($myUserTimeZone));
            $settingData = array();
            $settingData['userId'] = $user->id;
            $settingData['type'] = 1;
            $settingData['timing'] = 60;
            $settingData['startTime'] = $apiData['data']['startTime'];
            $settingData['endTime'] = $apiData['data']['endTime'];
            
            $this->User_Availability_Model->setData(['userIds'=>$user->id,'notbooked'=>true,'status'=>2]);
            if(is_array($apiData['data']['dates'])){
                foreach($apiData['data']['dates'] as $value){
                    $startdatetime = new DateTime($value.' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
                    $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    
                    $enddatetime = new DateTime($value.' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
                    $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $data = array();
                    $data['userId'] = $user->id;
                    $data['startDateTime'] = $startdatetime->format('U');
                    $data['endDateTime'] = $enddatetime->format('U');
                    $data['timing'] = 60;
                    $data['status'] = 1;

                    $settingData['date'] = $startdatetime->format('Y-m-d');
                    $this->User_Availability_Setting_New_Model->setData($settingData);
                    
                    $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'startDateTime'=>$startdatetime->format('U'),'endDateTime'=>$enddatetime->format('U')],true);
                    if(!empty($existAvailabilityData)){
                        $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                    }else{
                        $this->User_Availability_Model->setData($data);
                    }
                }
            }else{
                $startdatetime = new DateTime($apiData['data']['dates'].' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
                $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                
                $enddatetime = new DateTime($apiData['data']['dates'].' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
                $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $data = array();
                $data['userId'] = $user->id;
                $data['startDateTime'] = $startdatetime->format('U');
                $data['endDateTime'] = $enddatetime->format('U');
                $data['timing'] = 60;
                $data['status'] = 1;

                $settingData['date'] = $startdatetime->format('Y-m-d');
                $this->User_Availability_Setting_New_Model->setData($settingData);
                
                $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'startDateTime'=>$startdatetime->format('U'),'endDateTime'=>$enddatetime->format('U')],true);
                if(!empty($existAvailabilityData)){
                    $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                }else{
                    $this->User_Availability_Model->setData($data);
                }
            }
        }else{
            if (!isset($apiData['data']['repeatType']) || !in_array($apiData['data']['repeatType'], array(1,2))) {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("repeatTypeRequired", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $this->User_Availability_Setting_New_Model->removeData($user->id);
            $currentdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $currentdatetime->setTimezone(new DateTimeZone($myUserTimeZone));

            $startdatetime = new DateTime($currentdatetime->format('Y-m-d').' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
            $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $enddatetime = new DateTime($currentdatetime->format('Y-m-d').' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
            $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));

            
            $settingData = array();
            $settingData['userId'] = $user->id;
            $settingData['type'] = 2;
            $settingData['timing'] = 60;
            $settingData['repeatType'] = $apiData['data']['repeatType'];
            $settingData['startTime'] = $apiData['data']['startTime'];
            $settingData['endTime'] = $apiData['data']['endTime'];
            $this->User_Availability_Setting_New_Model->setData($settingData);
            
            $this->User_Availability_Model->setData(['userIds'=>$user->id,'notbooked'=>true,'status'=>2]);
            if($apiData['data']['repeatType'] == 1){
                for ($x = 1; $x <= 30; $x++) {
                    if(in_array($startdatetime->format('w'),array(1,2,3,4,5))){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'startDateTime'=>$startdatetime->format('U'),'endDateTime'=>$enddatetime->format('U')],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }else{
                for ($x = 1; $x <= 30; $x++) {
                    $data = array();
                    $data['userId'] = $user->id;
                    $data['startDateTime'] = $startdatetime->format('U');
                    $data['endDateTime'] = $enddatetime->format('U');
                    $data['timing'] = 60;
                    $data['status'] = 1;
                    $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'startDateTime'=>$startdatetime->format('U'),'endDateTime'=>$enddatetime->format('U')],true);
                    if(!empty($existAvailabilityData)){
                        $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                    }else{
                        $this->User_Availability_Model->setData($data);
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }
        }
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $this->User->userData($user->id, false);
        /*if (!empty($lastId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAvailability", $apiData['data']['langType']);
        }*/
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
    
    public function saveCaregiverAvailability_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['type']) || !in_array($apiData['data']['type'], array(1,2))) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("typeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['startTime']) || empty($apiData['data']['startTime'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("startTimeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['endTime']) || empty($apiData['data']['endTime'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("endTimeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        if($apiData['data']['type'] == 1){
            if (!isset($apiData['data']['dates']) || empty($apiData['data']['dates'])) {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("dateRequired", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $this->User_Availability_Setting_New_Model->removeData($user->id);
            $currentdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $currentdatetime->setTimezone(new DateTimeZone($myUserTimeZone));
            $settingData = array();
            $settingData['userId'] = $user->id;
            $settingData['type'] = 1;
            $settingData['timing'] = 60;
            $settingData['startTime'] = $apiData['data']['startTime'];
            $settingData['endTime'] = $apiData['data']['endTime'];
            
            //$this->User_Availability_Model->setData(['userIds'=>$user->id,'notbooked'=>true,'status'=>2]);
            if(is_array($apiData['data']['dates'])){
                foreach($apiData['data']['dates'] as $value){
                    $startdatetime = new DateTime($value.' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
                    $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    
                    $enddatetime = new DateTime($value.' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
                    $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $data = array();
                    $data['userId'] = $user->id;
                    $data['startDateTime'] = $startdatetime->format('U');
                    $data['endDateTime'] = $enddatetime->format('U');
                    $data['timing'] = 60;
                    $data['status'] = 1;

                    $settingData['date'] = $startdatetime->format('Y-m-d');
                    $this->User_Availability_Setting_New_Model->setData($settingData);
                    
                    $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                    if(!empty($existAvailabilityData)){
                        $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                    }else{
                        $this->User_Availability_Model->setData($data);
                    }
                }
            }else{
                $startdatetime = new DateTime($apiData['data']['dates'].' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
                $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                
                $enddatetime = new DateTime($apiData['data']['dates'].' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
                $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $data = array();
                $data['userId'] = $user->id;
                $data['startDateTime'] = $startdatetime->format('U');
                $data['endDateTime'] = $enddatetime->format('U');
                $data['timing'] = 60;
                $data['status'] = 1;

                $settingData['date'] = $startdatetime->format('Y-m-d');
                $this->User_Availability_Setting_New_Model->setData($settingData);
                
                $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                if(!empty($existAvailabilityData)){
                    $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                }else{
                    $this->User_Availability_Model->setData($data);
                }
            }
        }else{
            if (!isset($apiData['data']['repeatType']) || !in_array($apiData['data']['repeatType'], array(1,2,3,4,5,6,7,8))) {
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("repeatTypeRequired", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $this->User_Availability_Setting_New_Model->removeData($user->id);
            $currentdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $currentdatetime->setTimezone(new DateTimeZone($myUserTimeZone));

            $startdatetime = new DateTime($currentdatetime->format('Y-m-d').' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
            $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $enddatetime = new DateTime($currentdatetime->format('Y-m-d').' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
            $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));

            $settingData = array();
            $settingData['userId'] = $user->id;
            $settingData['type'] = 2;
            $settingData['timing'] = 60;
            $settingData['repeatType'] = $apiData['data']['repeatType'];
            $settingData['startTime'] = $apiData['data']['startTime'];
            $settingData['endTime'] = $apiData['data']['endTime'];
            $this->User_Availability_Setting_New_Model->setData($settingData);
            
            //$this->User_Availability_Model->setData(['userIds'=>$user->id,'notbooked'=>true,'status'=>2]);
            $todayDate =new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $todayDate->setTimezone(new DateTimeZone($myUserTimeZone));
            $todayDateDay = $todayDate->format('j');
            $todayDate->modify('last day of this month');
            $monthEndDateDay = $todayDate->format('j');
            
            if($apiData['data']['repeatType'] == 1){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 1){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 2){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 2){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 3){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 3){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 4){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 4){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 5){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 5){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 6){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 6){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 7){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    if($startdatetime->format('w') == 0){
                        $data = array();
                        $data['userId'] = $user->id;
                        $data['startDateTime'] = $startdatetime->format('U');
                        $data['endDateTime'] = $enddatetime->format('U');
                        $data['timing'] = 60;
                        $data['status'] = 1;
                        $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                        if(!empty($existAvailabilityData)){
                            $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                        }else{
                            $this->User_Availability_Model->setData($data);
                        }
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }if($apiData['data']['repeatType'] == 8){
                for ($x = $todayDateDay; $x <= $monthEndDateDay; $x++) {
                    $data = array();
                    $data['userId'] = $user->id;
                    $data['startDateTime'] = $startdatetime->format('U');
                    $data['endDateTime'] = $enddatetime->format('U');
                    $data['timing'] = 60;
                    $data['status'] = 1;
                    $existAvailabilityData = $this->User_Availability_Model->get(['userId'=>$user->id,'checkdate'=>['startDate'=>$startdatetime->format('Y-m-d'),'endDate'=>$enddatetime->format('Y-m-d')]],true);
                    if(!empty($existAvailabilityData)){
                        $this->User_Availability_Model->setData($data,$existAvailabilityData->id);
                    }else{
                        $this->User_Availability_Model->setData($data);
                    }
                    $startdatetime->modify('+1 day');
                    $enddatetime->modify('+1 day');
                }
            }
        }
        
        $setData = array();
        if (isset($apiData['data']['profileStatus']) && !empty($apiData['data']['profileStatus'])) {
            $setData['profileStatus'] = $apiData['data']['profileStatus'];
            $this->User->setData($setData, $user->id);
        }
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $this->User->userData($user->id, false);
        /*if (!empty($lastId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveAvailabilitySuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $this->User->userData($user->id, false);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveAvailability", $apiData['data']['langType']);
        }*/
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    // New availability setting of date or week wise data
    public function getCaregiverAvailabilitySettingNew_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role  != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $response = $this->User_Availability_Setting_New_Model->get(['apiResponse'=>true,'userId'=>$user->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getAvailabilitySettingSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
            $this->apiResponse['startTime'] = $response[0]->startTime;
            $this->apiResponse['endTime'] = $response[0]->endTime;
            $this->apiResponse['repeatType'] = $response[0]->repeatType;
            $this->apiResponse['type'] = $response[0]->type;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("availabilitySettingNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    // New availability wise get date and slot
    public function getCaregiverAvailabilityNew_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $caregiverData = $this->User->get(['id'=>$apiData['data']['caregiverId'],'role'=>'3','status'=>'1'],true);
        if (empty($caregiverData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        $caregiverTimeZone = (!empty($caregiverData->timezone) ? $caregiverData->timezone : getenv('SYSTEMTIMEZON'));

        $response = $this->Background_Model->getCaregiverAvailabilityNew($caregiverData->id, $myUserTimeZone, $caregiverTimeZone);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getAvailabilityDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("availabilityDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    // New availability wise get date and time
    public function getCaregiverCalendarAvailabilityNew_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        $caregiverTimeZone =  (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));

        $response = $this->Background_Model->getCaregiverAvailabilityNew($user->id, $myUserTimeZone, $caregiverTimeZone,true);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getAvailabilityDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("availabilityDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    // New availability remove single availability
    public function removeSingleAvailabilityNew_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['availabilityId']) || empty($apiData['data']['availabilityId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("availabilityIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $availabilityId = $this->User_Availability_Model->setData(['status'=>2],$apiData['data']['availabilityId']);

        if (!empty($availabilityId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("removeAvailabilityDataSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRemoveAvailabilityData", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

}
