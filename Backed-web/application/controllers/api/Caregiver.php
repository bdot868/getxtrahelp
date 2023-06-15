<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Caregiver extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('User_Job_Model');
        $this->load->model('User_Job_Detail_Model');
        $this->load->model('User_Work_Detail_Model');
        $this->load->model('User_Search_History_Model');
        $this->load->model('User_Job_Media_Model');
        $this->load->model('User_Job_Question_Model');
        $this->load->model('User_Job_Apply_Model');
        $this->load->model('User_Job_Question_Answer_Model');
        $this->load->model('Job_Category_Model');
        $this->load->model('Resources_Model');
        $this->load->model('User_Work_Job_Category_Model');
        $this->load->model('User_Work_Experience_Model');
        $this->load->model('User_Transaction_Model');
        $this->load->model('User_Job_Uploaded_Model');
        $this->load->model('User_Job_Substitute_Request_Model');
        $this->load->model('User_Card_Model');
        $this->load->model('User_Job_Award_Model');
    }

    
    public function getCaregiverDashboard_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $this->User->setData(['timezone'=>$apiData['data']['timezone']],$user->id);
            $myUserTimeZone = $apiData['data']['timezone'];
        }else{
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        }

        $response = array();
        // Upcoming job list
        $response['upcomingJobs'] = $this->User_Job_Model->get(['apiResponse'=>true,'getUserData'=>true,'getOnlyJobApply'=>$user->id,'status'=>1,'jobHireStatus'=>1,'getJobDetailData'=>1,'limit'=>5]);
        if(!empty($response['upcomingJobs'])){
            foreach( $response['upcomingJobs'] as $value ){
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($value->starTimestamp);
                $value->startDateTime = $startDateTime->format('d M Y  h:i A');
            }
        }

        // Nearest job list
        $caregiverWorkDetail = $this->User_Work_Detail_Model->get(['userId'=>$user->id,'status'=>1],true);
        $data = array();
        $data['apiResponse'] = true;
        $data['getUserData'] = true;
        $data['getCategoryData'] = true;
        $data['isHire'] = 0;
        $data['status'] = 1;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        $data['getInRadius']['miles'] = (isset($caregiverWorkDetail->maxDistanceTravel) && !empty($caregiverWorkDetail->maxDistanceTravel) ? $caregiverWorkDetail->maxDistanceTravel : 60);
        $data['latestFirst'] = true;
        $data['limit'] = 5;
        $response['nearestJobs'] = $this->User_Job_Model->get($data);
        if(!empty($response['nearestJobs'])){
            foreach( $response['nearestJobs'] as $value ){
                $value->startDateTime = "";
                $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$value->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                if(!empty($jobDetailData)){
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($jobDetailData->startTime);
                    $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                }
            }
        }

        $response['categories'] = $this->Job_Category_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC','limit'=>5]);
        $response['resourcesAndBlogs'] = $this->Resources_Model->get(['apiResponse'=>true,'status'=>'1','orderstate'=>'DESC','orderby'=>'id','limit'=>5]);
        if(!empty($response['resourcesAndBlogs'])){
            foreach($response['resourcesAndBlogs'] as $value){
                $value->timing = $this->Common_Model->get_time_ago($value->createdDate);
            }
        }
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common->GetNotification("getDashboardDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common->GetNotification("dashboardDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getCaregiverMyProfile_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        $data = array();
        $data['id'] = $user->id;
        $data['role'] = 3;
        $data['status'] = 1;
        $data['getCaregiverReview'] = true;
        $data['getCaregiverWorkDetail'] = true;
        $data['countTotalJobCompleted'] = true;
        $data['getHearAboutUsDetail'] = true;
 		$responseData = $this->Users_Model->get($data,true);

        if (!empty($responseData)) {
            $finalData = array();
            $finalData['id'] = $responseData->id;
            $finalData['firstName'] = $responseData->firstName;
            $finalData['lastName'] = $responseData->lastName;
            $finalData['fullName'] = $responseData->firstName.' '.$responseData->lastName;
            $finalData['email'] = $responseData->email;
            $finalData['phone'] = $responseData->phone;
            $finalData['latitude'] = $responseData->latitude;
            $finalData['longitude'] = $responseData->longitude;
            $finalData['address'] = $responseData->address;
            $finalData['age'] = $responseData->age;
            $finalData['gender'] = $responseData->gender;
            $finalData['familyVaccinated'] = $responseData->familyVaccinated;
            $finalData['hearAboutUsId'] = $responseData->hearAboutUsId;
            $finalData['hearAboutUsName'] = $responseData->hearAboutUsName;
            $finalData['profileImageUrl'] = $responseData->profileImageUrl;
            $finalData['profileImageThumbUrl'] = $responseData->profileImageThumbUrl;
            $finalData['ratingAverage'] = $responseData->ratingAverage;
            $finalData['totalJobCompleted'] = $responseData->totalJobCompleted;
            $finalData['caregiverBio'] = $responseData->caregiverBio;
            $finalData['status'] = $responseData->status;
            $finalData['totalJobs'] = $this->User_Job_Apply_Model->get(['getUserJobStatusWise'=>[1,3],'userId'=>$responseData->id,'isHire'=>1,'status'=>1],false,true);
            $completeJob = $this->User_Job_Apply_Model->get(['getUserJobStatusWise'=>3,'userId'=>$responseData->id,'isHire'=>1,'status'=>1],false,true);
            if(!empty($finalData['totalJobs']) && !empty($completeJob)){
                $successPercent = (100 / $finalData['totalJobs']) * $completeJob;
                $finalData['successPercentage'] = round($successPercent,2)."%";
            }else{
                $finalData['successPercentage'] = "0%";
            }

            // Upcoming job list
            $data = array();
            $data['apiResponse'] = true;
            $data['getOnlyJobApply'] = $responseData->id;
            $data['jobHireStatus'] = 1;
            $data['getJobDetailData'] = 3;
            $data['isHire'] = 1;
            $data['status'] = [1,3];
            $completeJobDetailData = $this->User_Job_Model->get($data);
            if(!empty($completeJobDetailData)){
                $second = 0;
                foreach($completeJobDetailData as $value){
                    $second = $second + ($value->endTimestamp - $value->starTimestamp);
                }
                //$finalData['totalJobsHours'] = gmdate("H:i", $second);
                $finalData['totalJobsHours'] = round(($second * (1/3600)),2);
            }else{
                //$finalData['totalJobsHours'] = "00:00";
                $finalData['totalJobsHours'] = "0";
            }

            $finalData['workSpecialityName'] = "";
            $finalData['workMethodOfTransportationName'] = "";
            $finalData['workDisabilitiesWillingTypeName'] = "";
            $finalData['workDistancewillingTravel'] = "";
            $finalData['totalYearWorkExperience'] = "";
            $workDetail = $this->User_Work_Detail_Model->get(['apiResponse'=>true,'userId'=>$responseData->id,'getExtraData'=>true,'status'=>1],true);
            if(!empty($workDetail)){
                $finalData['workSpecialityName'] = $workDetail->workSpecialityName;
                $finalData['workMethodOfTransportationName'] = $workDetail->workMethodOfTransportationName;
                $finalData['workDisabilitiesWillingTypeName'] = $workDetail->workDisabilitiesWillingTypeName;
                $finalData['workDistancewillingTravel'] = $workDetail->maxDistanceTravel.'mi';
                $finalData['totalYearWorkExperience'] = $workDetail->experienceOfYear;
            }
            
            $finalData['workExperienceData'] = $this->User_Work_Experience_Model->get(['apiResponse'=>true,'userId'=>$responseData->id,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
            /*$finalData['totalYearWorkExperience'] = "0";
            if(!empty($finalData['workExperienceData'])){
                $days = 0;
                foreach($finalData['workExperienceData'] as $value){
                    $startDate = date("Y-m-d",strtotime('15-'.str_replace('/', '-',$value->startDate)));
                    if(!empty($value->endDate)){
                        $endDate = date("Y-m-d",strtotime('15-'.str_replace('/', '-',$value->endDate)));
                    }else{
                        $endDate = date("Y-m-d");
                    }
                    
                    $startDate = new DateTime($startDate);
                    $endDate = new DateTime($endDate);
                    $interval = $endDate->diff($startDate);
                    $days = $days + $interval->days;
                }
                $finalData['totalYearWorkExperience'] = floor(($days / 30) / 12);
            }*/
            $finalData['categoryData'] = $this->User_Work_Job_Category_Model->get(['apiResponse'=>true,'userId'=>$responseData->id,'getJobCategoryData'=>true,'status'=>1]);
			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getMyProfileSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $finalData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "myProfileDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getUserJobList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}
        $caregiverWorkDetail = $this->User_Work_Detail_Model->get(['userId'=>$user->id,'status'=>1],true);
        $data = array();
        $data['apiResponse'] = true;
        $data['getUserData'] = true;
        $data['getCategoryData'] = true;
        $data['isHire'] = 0;
        $data['status'] = 1;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        $data['getInRadius']['miles'] = (isset($caregiverWorkDetail->maxDistanceTravel) && !empty($caregiverWorkDetail->maxDistanceTravel) ? $caregiverWorkDetail->maxDistanceTravel : 60);
        
        if(isset($apiData['data']['startMiles']) && !empty($apiData['data']['startMiles'])){
            $data['getInRadius']['startMiles'] = $apiData['data']['startMiles'];
        }

        if(isset($apiData['data']['endMiles']) && !empty($apiData['data']['endMiles'])){
            $data['getInRadius']['endMiles'] = $apiData['data']['endMiles'];
        }

        if(isset($apiData['data']['search']) && $apiData['data']['search'] != ""){
            $this->User_Search_History_Model->setData(['userId'=>$user->id,'keyword'=>$apiData['data']['search']]);
            $data['allsearch'] = $apiData['data']['search'];
        }
        if(isset($apiData['data']['category']) && !empty($apiData['data']['category'])){
            $data['categoryId'] = $apiData['data']['category'];
        }
        if(isset($apiData['data']['isFirst']) && $apiData['data']['isFirst'] == '1'){
            $data['isNewestFirst'] = true;
        }elseif(isset($apiData['data']['isFirst']) && $apiData['data']['isFirst'] == '2'){
            $data['isOldestFirst'] = true;
        }
        
        if(isset($apiData['data']['isBehavioral']) && in_array($apiData['data']['isBehavioral'], array(1,2)) ){
            $data['getJobAboutLovedFilterData'] = true;
            $data['getBehavioralRelatedData'] = $apiData['data']['isBehavioral'];
        }
        if(isset($apiData['data']['isVerbal']) && in_array($apiData['data']['isVerbal'], array(1,2)) ){
            $data['getJobAboutLovedFilterData'] = true;
            $data['getVerbalRelatedData'] = $apiData['data']['isVerbal'];
        }
        if(isset($apiData['data']['allergiesName']) && !empty($apiData['data']['allergiesName'])){
            $data['getJobAboutLovedFilterData'] = true;
            $data['getAllergiesRelatedData'] = $apiData['data']['allergiesName'];
        }
        if(isset($apiData['data']['specialitieId']) && !empty($apiData['data']['specialitieId'])){
            $data['getLovedSpecialities'] = $apiData['data']['specialitieId'];
        }
        if(isset($apiData['data']['isFamilyVaccinated']) && in_array($apiData['data']['isFamilyVaccinated'], array(1,2)) ){
            $data['checkIsFamilyVaccinated'] = $apiData['data']['isFamilyVaccinated'];
        }
        if(isset($apiData['data']['isJobType']) && in_array($apiData['data']['isJobType'], array(1,2)) ){
            $data['isJob'] = $apiData['data']['isJobType'];
        }

		$totalData = count($this->User_Job_Model->get($data));
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Job_Model->get($data);
		
        if (!empty($responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $xtrahelpComission = (!empty(getenv('XTRAHELP_COMISSION')) ? getenv('XTRAHELP_COMISSION') : 0);
            foreach( $responseData as $value ){
                $comissionAmount = (($value->price*$xtrahelpComission) / 100);
                $value->formatedPrice = "$".number_format($value->price-$comissionAmount,2);
                $value->distance = round($value->distance,1);
                $value->startDateTime = "";
                $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$value->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                if(!empty($jobDetailData)){
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($jobDetailData->startTime);
                    $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                }
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getUserJobListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "userJobListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getUserJobDetail_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data['id'] = $apiData['data']['jobId'];
        $data['apiResponse'] = true;
        $data['getUserData'] = true;
        $data['getCategoryData'] = true;
        $data['checkIsApply'] = $user->id;
        //$data['isHire'] = 0;
        $data['status'] = 1;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        
		$responseData = $this->User_Job_Model->get($data,true);
		
        if (!empty($responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $xtrahelpComission = (!empty(getenv('XTRAHELP_COMISSION')) ? getenv('XTRAHELP_COMISSION') : 0);
            $comissionAmount = (($responseData->price*$xtrahelpComission) / 100);
            $responseData->formatedPrice = "$".number_format($responseData->price-$comissionAmount,2);
            $responseData->createdDateFormat = $this->Common_Model->get_time_ago($responseData->createdDate);
            $responseData->distance = round($responseData->distance,1);
            $responseData->startDateTime = "";
            $responseData->startTime = "";
            $responseData->endTime = "";
            $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
            if(!empty($jobDetailData)){
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($jobDetailData->startTime);
                $endTimeTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $endTimeTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $endTimeTime->setTimestamp($jobDetailData->endTime);
                $responseData->startDateTime = $startDateTime->format('d M Y  h:i A');
                $responseData->startTime = $startDateTime->format('h:i A');
                $responseData->endTime = $endTimeTime->format('h:i A');
            }
            $responseData->media = $this->User_Job_Media_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->questions = $this->User_Job_Question_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getJobDetailSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "jobDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getUserSearchHistory_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $page_number = (isset($apiData['data']['page']) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
        $limit = (isset($apiData['data']['limit']) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 5;
        if (isset($apiData['data']['page']) && $apiData['data']['page'] == 1) {
            $offset = 0;
        } else {
            if (isset($apiData['data']['page']) && $apiData['data']['page'] != '1') {
                $offset = ($page_number * $limit) - $limit;
            } else {
                $offset = 0;
            }
        }

        $data = array();
        $data['userId'] = $user->id;
        $data['apiResponse'] = true;
        $data['search'] = (isset($apiData['data']['search']) ? $apiData['data']['search'] : "");
        $data['status'] = 1;
        $totalData = $this->User_Search_History_Model->get($data,false,true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
        $response = $this->User_Search_History_Model->get($data);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getUserSearchHistorySuccess", $apiData['data']['langType']);
            $this->apiResponse['totalPages'] = ceil($totalData / $limit) . "";
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification(($offset > 0 ? 'allcatchedUp' : "userSearchHistoryNotFound"), $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function clearUserSearchHistory_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        $response = $this->User_Search_History_Model->delete($user->id);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("clearSearchHistorySuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToClearSearchHistory", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function removeUserSearchHistory_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['userSearchHistoryId']) || empty($apiData['data']['userSearchHistoryId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userSearchHistoryIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $response = $this->User_Search_History_Model->delete($user->id,$apiData['data']['userSearchHistoryId']);
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("removeSearchHistorySuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRemoveSearchHistory", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function applyUserJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'status'=>1],true);
        if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Apply_Model->get(['jobId'=>$apiData['data']['jobId'],'userId'=>$user->id],true);
        
        if(!empty($existJobData)){
            if($existJobData->isHire = 1 && $existJobData->status == 1){
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreAlreadyHiredForThisJob", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $jobApplyId = $this->User_Job_Apply_Model->setData(['isHire'=>'0','status'=>'1'],$existJobData->id);
        }else{
            $jobApplyId = $this->User_Job_Apply_Model->setData(['jobId'=>$apiData['data']['jobId'],'userId'=>$user->id,'isHire'=>'0','status'=>'1']);
        }
        if (!empty($jobApplyId)) {
            if (isset($apiData['data']['questionsAnswer']) && !empty($apiData['data']['questionsAnswer'])) {
                foreach( $apiData['data']['questionsAnswer'] as $value ) {
                    if(!isset($value["questionId"]) || empty($value["questionId"])){
                        continue;
                    }
                    if(!isset($value["answer"]) || empty($value["answer"])){
                        continue;
                    }
                    $quesAndArray = array();
                    $quesAndArray["userId"] = $user->id;
                    $quesAndArray["jobId"] = $apiData['data']['jobId'];
                    $quesAndArray["userJobQuestionId"] = $value["questionId"];
                    $quesAndArray["userJobApplyId"] = $jobApplyId;
                    $existAnswerData = $this->User_Job_Question_Answer_Model->get($quesAndArray,true);
                    $quesAndArray["answer"] = $value["answer"];
                    if(!empty($existAnswerData)){
                        $quesAndArray["status"] = 1;
                        $this->User_Job_Question_Answer_Model->setData($quesAndArray,$existAnswerData->id);
                    }else{
                        $this->User_Job_Question_Answer_Model->setData($quesAndArray);
                    }
                }
            }

            // Set notification for apply user job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobData->userId;
            $notiData['model_id'] = (int)$apiData['data']['jobId'];
            $notiData['jobName'] = $jobData->name;
            $this->Common_Model->backroundCall('applyUserJobByCaregiver', $notiData);
            // ./ Set notification for apply user job by caregiver

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("applyJobSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToApplyJob", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getCaregiverRelatedJobList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}
        //Need to change this APi
        $data = array();
        $data['apiResponse'] = true;
        $data['getUserData'] = true;
        $data['getOnlyJobApply'] = $user->id;
        $data['getCaregiverJobReview'] = $user->id;
        
        if(isset($apiData['data']['search']) && !empty($apiData['data']['search'])) {
            $data['allsearch'] = $apiData['data']['search'];
        }

        if(isset($apiData['data']['type']) && $apiData['data']['type'] == '1') {
            $data['status'] = 1;
            $data['jobHireStatus'] = 1;
            $data['getJobDetailData'] = 1;
        }elseif(isset($apiData['data']['type']) && $apiData['data']['type'] == '2') {
            $data['isHire'] = 1;
            $data['status'] = 3;
            $data['jobHireStatus'] = 1;
            $data['getJobDetailData'] = 3;
        }elseif(isset($apiData['data']['type']) && $apiData['data']['type'] == '3') {
            $data['status'] = 1;
            $data['jobHireStatus'] = 0;
        }else{
            $data['jobHireStatus'] = 1;
            $data['status'] = [1,3];
            $data['getJobDetailData'] = [1,3];
        }
        
		$totalData = $this->User_Job_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Job_Model->get($data);
		
        $totalWorkTimeData = $this->User_Job_Detail_Model->get(['getJobCompletedTimingData'=>$user->id,'status'=>'3'],true);
        
        if (!empty( $responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $xtrahelpComission = (!empty(getenv('XTRAHELP_COMISSION')) ? getenv('XTRAHELP_COMISSION') : 0);
            foreach( $responseData as $value ){
                $comissionAmount = (($value->price*$xtrahelpComission) / 100);
                $value->formatedPrice = "$".number_format($value->price-$comissionAmount,2);
                // jobStatus = 1->Upcoming, 2->Completed, 3->Applied
                $value->jobStatus = "0";
                if($value->status == "1" && $value->userJobIsHire == "1"){
                    $value->jobStatus = "1";
                }elseif($value->status == "3" && $value->userJobIsHire == "1"){
                    $value->jobStatus = "2";
                }elseif($value->status == "1" && $value->userJobIsHire == "0" && !empty($value->userJobApplyId)){
                    $value->jobStatus = "3";
                }
               
                if($value->jobStatus == 3){
                    $value->startDateTime = "";
                    $value->userJobDetailId = "";
                    $value->starTimestamp = "";
                    $value->endTimestamp = "";
                    $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$value->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                    if(!empty($jobDetailData)){
                        $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                        $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                        $startDateTime->setTimestamp($jobDetailData->startTime);
                        $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                        $value->userJobDetailId = $jobDetailData->userJobDetailId;
                        $value->starTimestamp = $jobDetailData->startTime;
                        $value->endTimestamp = $jobDetailData->endTime;
                    }
                }else{
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($value->starTimestamp);
                    $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                }
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getUserJobListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['totalWorkTime'] = (isset($totalWorkTimeData->totalWorkTime) && !empty($totalWorkTimeData->totalWorkTime) ? $totalWorkTimeData->totalWorkTime : '0 hrs 0 mins');
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "userJobListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
            $this->apiResponse['totalWorkTime'] = (isset($totalWorkTimeData->totalWorkTime) && !empty($totalWorkTimeData->totalWorkTime) ? $totalWorkTimeData->totalWorkTime : '0 hrs 0 mins');
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getCaregiverRelatedJobDetail_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'status'=> [1,3]],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data['apiResponse'] = true;
        $data['id'] = $jobDetailData->jobId;
        $data['getUserData'] = true;
        $data['getOnlyJobApply'] = $user->id;
        $data['getCategoryData'] = true;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        $data['getCaregiverJobReview'] = $user->id;
        $data['status'] = [1,3];

		$responseData = $this->User_Job_Model->get($data,true);
        
        if (!empty($responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $xtrahelpComission = (!empty(getenv('XTRAHELP_COMISSION')) ? getenv('XTRAHELP_COMISSION') : 0);
            $comissionAmount = (($responseData->price*$xtrahelpComission) / 100);
            $responseData->formatedPrice = "$".number_format($responseData->price-$comissionAmount,2);
            $responseData->userJobDetailId = $jobDetailData->id;
            $responseData->startJobStatus = $jobDetailData->isJobStatus;
            $responseData->ongoingJobPendingTiming = "0";
            $responseData->ongoingJobPendingMinutes = "0";
            $responseData->ongoingJobPendingSeconds = "0";
            $responseData->starTimestamp = $jobDetailData->startTime;
            $responseData->endTimestamp = $jobDetailData->endTime;
            $responseData->createdDateFormat = $this->Common_Model->get_time_ago($responseData->createdDate);
            $responseData->distance = round($responseData->distance,1);
        
            // jobStatus = 1->Upcoming, 2->Completed, 3->Applied
            $responseData->jobStatus = "0";
            if($responseData->status == "1" && $responseData->userJobIsHire == "1"){
                $responseData->jobStatus = "1";
            }elseif($responseData->status == "3" && $responseData->userJobIsHire == "1"){
                $responseData->jobStatus = "2";
            }elseif($responseData->status == "1" && $responseData->userJobIsHire == "0" && !empty($responseData->userJobApplyId)){
                $responseData->jobStatus = "3";
            }
            if($responseData->jobStatus == 3){
                $responseData->startDateTime = "";
                $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                if(!empty($jobDetailData)){
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($jobDetailData->startTime);
                    $endTimeTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $endTimeTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $endTimeTime->setTimestamp($jobDetailData->endTime);
                    $responseData->startDateTime = $startDateTime->format('d M Y  h:i A').' to '.$endTimeTime->format('h:i A');
                    $responseData->startTime = $startDateTime->format('h:i A');
                    $responseData->endTime = $endTimeTime->format('h:i A');
                }
            }else{
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($responseData->starTimestamp);
                $endTimeTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $endTimeTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $endTimeTime->setTimestamp($responseData->endTimestamp);
                $responseData->startDateTime = $startDateTime->format('d M Y  h:i A').' to '.$endTimeTime->format('h:i A');
                $responseData->startTime = $startDateTime->format('h:i A');
                $responseData->endTime = $endTimeTime->format('h:i A');

                if($responseData->startJobStatus == "1"){
                    $currentDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    if($responseData->starTimestamp < $jobDetailData->caregiverStartingTime){
                        $second = ($responseData->endTimestamp + ($jobDetailData->caregiverStartingTime - $responseData->starTimestamp)) - $currentDateTime->format('U');
                    }else{
                        $second = $responseData->endTimestamp - $currentDateTime->format('U');
                    }
                    if($second > 1){
                        $responseData->ongoingJobPendingTiming = str_pad(floor($second / 60),2,"0",STR_PAD_LEFT).":".str_pad($second % 60,2,"0",STR_PAD_LEFT)."min";
                        $responseData->ongoingJobPendingMinutes = floor($second / 60);
                        $responseData->ongoingJobPendingSeconds = $second;
                    }else{
                        $responseData->ongoingJobPendingTiming = "00:00min";
                        $responseData->ongoingJobPendingMinutes = 0;
                        $responseData->ongoingJobPendingSeconds = 0;
                    }
                }
            }

            $responseData->media = $this->User_Job_Media_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->uploadedMedia = $this->User_Job_Uploaded_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'jobDetailId'=>$responseData->userJobDetailId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->questions = $this->User_Job_Question_Model->get(['apiResponse'=>true,'getJonQestionAnswer'=>$user->id,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getJobDetailSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "jobDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function cancelJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobApplyId']) || empty($apiData['data']['userJobApplyId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobApplyIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobApplyData = $this->User_Job_Apply_Model->get(['id'=>$apiData['data']['userJobApplyId'],'userId'=>$user->id,'status'=>'1'],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobRequestNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobId = $this->User_Job_Apply_Model->setData(['isHire'=>'0','status'=>'2'],$jobApplyData->id);
        if (!empty($jobId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cancelJobRequestSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToCancelJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function modifyJobAnswer_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userJobApplyId']) || empty($apiData['data']['userJobApplyId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobApplyIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        if (isset($apiData['data']['questionsAnswer']) && !empty($apiData['data']['questionsAnswer'])) {
            foreach( $apiData['data']['questionsAnswer'] as $value ) {
                if(!isset($value["questionId"]) || empty($value["questionId"])){
                    continue;
                }
                if(!isset($value["answer"]) || empty($value["answer"])){
                    continue;
                }
                $quesAndArray = array();
                $quesAndArray["userId"] = $user->id;
                $quesAndArray["jobId"] = $apiData['data']['jobId'];
                $quesAndArray["userJobQuestionId"] = $value["questionId"];
                $quesAndArray["userJobApplyId"] = $apiData['data']['userJobApplyId'];
                $existAnswerData = $this->User_Job_Question_Answer_Model->get($quesAndArray,true);
                $quesAndArray["answer"] = $value["answer"];
                if(!empty($existAnswerData)){
                    $quesAndArray["status"] = 1;
                    $this->User_Job_Question_Answer_Model->setData($quesAndArray,$existAnswerData->id);
                }else{
                    $this->User_Job_Question_Answer_Model->setData($quesAndArray);
                }
            }
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("modifyJobAnswerSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToModifyJobAnswer", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function cancelUpcomingJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userJobApplyId']) || empty($apiData['data']['userJobApplyId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobApplyIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existJobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobApplyData = $this->User_Job_Apply_Model->get(['id'=>$apiData['data']['userJobApplyId'],'userId'=>$user->id,'status'=>'1'],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobApplyNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobId = $this->User_Job_Model->setData(['isHire'=>'0'],$existJobData->id);
        $jobApplyId = $this->User_Job_Apply_Model->setData(['isHire'=>'0','status'=>'2'],$jobApplyData->id);
        if (!empty($jobApplyId) && !empty($jobId)) {
            // Set notification for cancel upcoming job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existJobData->userId;
            $notiData['model_id'] = (int)$existJobData->id;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('cancelUpcomingJobByCaregiver', $notiData);
            // ./ Set notification for cancel upcoming job by caregiver
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cancelJobSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToCancelJob", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
    
    public function getCaregiverList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}
        
        $data = array();
        $data['idNotInclude'] = $user->id;
        $data['role'] = 3;
        $data['profileStatus'] = 8;
        $data['status'] = 1;
        if(isset($apiData['data']['search']) && $apiData['data']['search'] != ""){
            $this->User_Search_History_Model->setData(['userId'=>$user->id,'keyword'=>$apiData['data']['search']]);
            $data['search'] = $apiData['data']['search'];
        }
       
		$totalData = count($this->Users_Model->get($data));
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->Users_Model->get($data);
		
        if (!empty( $responseData )) {
            $finalData = array();
            foreach( $responseData as $value ){
                $tmp = array();
                $tmp['id'] = $value->id;
                $tmp['firstName'] = $value->firstName;
                $tmp['lastName'] = $value->lastName;
                $tmp['email'] = $value->email;
                $tmp['profileImageUrl'] = $value->profileImageUrl;
                $tmp['profileImageThumbUrl'] = $value->profileImageThumbUrl;
                $tmp['status'] = $value->status;
                $finalData[] = $tmp;
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getCaregiverListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $finalData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "caregiverListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function caregiverSubstituteJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userJobApplyId']) || empty($apiData['data']['userJobApplyId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobApplyIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existJobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobApplyData = $this->User_Job_Apply_Model->get(['id'=>$apiData['data']['userJobApplyId'],'userId'=>$user->id,'status'=>'1'],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobApplyNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobApplyId = $this->User_Job_Apply_Model->setData(['userId'=>$apiData['data']['caregiverId']],$jobApplyData->id);
        if (!empty($jobApplyId)) {
            // Set notification for substitute job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $apiData['data']['caregiverId'];
            $notiData['model_id'] = (int)$existJobData->id;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobByCaregiver', $notiData);
            // ./ Set notification for substitute job by caregiver
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSubstituteJob", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function verifyJobVerificationCode_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['verificationCode']) || empty($apiData['data']['verificationCode'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobVerificationCodeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobData = $this->User_Job_Model->get(['apiResponse'=>true,'id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'jobId'=>$jobData->userJobId,'status'=> 1],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $currentDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        
        if( $jobDetailData->startTime > $currentDateTime->format('U') ){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobStartTimeNotMatchOfCurrentTime", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if ($jobData->verificationCode == $apiData['data']['verificationCode']) {
            $this->User_Job_Detail_Model->setData(['isJobStatus'=>1,'caregiverStartingTime'=>$currentDateTime->format('U')],$apiData['data']['userJobDetailId']);
            $jobData->userJobDetailId = $jobDetailData->id;
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $startDateTime->setTimestamp($jobDetailData->startTime);
            $jobData->startDateTime = $startDateTime->format('d M Y  h:i A');
            $second = $jobDetailData->endTime - $jobDetailData->startTime;
            //$second = $jobDetailData->endTime - $currentDateTime->format('U');
            if($second > 1){
                $jobData->totalTiming = str_pad(floor($second / 60),2,"0",STR_PAD_LEFT).":".str_pad($second % 60,2,"0",STR_PAD_LEFT)."min";
                $jobData->totalMinutes = floor($second / 60);
                $jobData->TotalSeconds = $second;
            }else{
                $jobData->totalTiming = "00:00min";
                $jobData->totalMinutes = 0;
                $jobData->TotalSeconds = 0;
            }

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobVerificationCodeVerifySuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $jobData;
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("invalidJobVerificationCode", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function endUserJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobData = $this->User_Job_Model->get(['apiResponse'=>true,'id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'jobId'=>$jobData->userJobId,'status'=> 1],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $lastId = $this->User_Job_Detail_Model->setData(['isJobStatus'=>2,'status'=> 3],$apiData['data']['userJobDetailId']);
        $checkJobData = $this->User_Job_Detail_Model->get(['jobId'=>$jobData->userJobId,'status'=> 1]);
        if(empty($checkJobData)){
            $lastId = $this->User_Job_Model->setData(['status'=>3],$apiData['data']['jobId']);
        }

        if (!empty($lastId)) {
            $minutes = floor(($jobDetailData->endTime - $jobDetailData->startTime) / 60);
            if($minutes <= 60){
                // If job less of 60 mint then give money as per work hours
                $countMinutes = $minutes;
            }else{
                $currentDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $workMinutes = floor(($currentDateTime->format('U') - $jobDetailData->startTime) / 60);
                
                if($workMinutes <= 60){
                    // If job of 60+ mint but caregiver job end less 60 mint then give money of minimum 60 mint
                    $countMinutes = 60;
                }elseif($minutes <= $workMinutes){
                    // If job of 120 mint  but caregiver job end 130 mint then give money of 120 mint
                    $countMinutes = $minutes;
                }else{
                    // If job of 120 mint  but caregiver job end 90 mint then give money of 90 mint
                    $countMinutes = $workMinutes;
                }
            }
 
            $amount = ($jobData->price / 60);
            $totalPayableAmount = $amount * $minutes;
            $totalPaidAmount = $amount * $countMinutes;
            $amount = $amount * $countMinutes;
            $xtrahelpComission = (!empty(getenv('XTRAHELP_COMISSION')) ? getenv('XTRAHELP_COMISSION') : 0);
            $comissionAmount = (($amount*$xtrahelpComission) / 100);
            $amount = round($amount-$comissionAmount,2);
            $totalRefundableAmount = round($totalPayableAmount - $totalPaidAmount,2);
            if($totalRefundableAmount >= 1){
                $jobTransactionData = $this->User_Transaction_Model->get(['userJobId'=>$apiData['data']['jobId'], 'userJobDetailId'=>$apiData['data']['userJobDetailId'], 'userId'=>$jobData->userId, 'type'=>2, 'payType'=>1, 'tranType'=>2, 'status'=>1,'orderstate'=>'DESC','orderby'=>'id']);
                foreach($jobTransactionData as $value){
                    if($totalRefundableAmount <= 0){
                        break;
                    }
                    $existAmount = $value->amount - $value->refundAmount;
                    if($existAmount >= $totalRefundableAmount){
                        $amountTransfer = round($totalRefundableAmount,2);
                    }else{
                        $amountTransfer = round($existAmount,2);
                    }
                    $this->load->library('stripe');
                    $stripeChargeData['amount'] = $amountTransfer * 100;
                    $stripeChargeData['charge'] = $value->stripeTransactionId;
                    $stripeChargeData['metadata']['description'] ="Job Payment Refund, XtrahelpTransactionId: #".$value->id.",userId: #".$jobData->userId.", caregiverId: #".$user->id.", userCardId: #".$jobData->userCardId." , jobId: #".$apiData['data']['jobId'].", jobDetailId: #".$apiData['data']['userJobDetailId'];
                    $response = $this->stripe->createRefund($stripeChargeData);
                    error_log("\n\n -------------------------------------" . date('c'). " \n Request => ".json_encode($stripeChargeData) . " \n Response => ".json_encode($response,true), 3, FCPATH.'worker/jobPaymentRefund-'.date('d-m-Y').'.txt');
                    if(!empty($response)){
                        if(isset($response['error'])){
                            /*$response['error']['status'] = '0';
                            $this->apiResponse = $response['error'];
                            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);*/
                        }elseif(!isset($response->id) || $response->id==""){ 
                            /*$this->apiResponse['status'] = "0";
                            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToEndJob", $apiData['data']['langType']);
                            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);*/
                        }else{
                            // For user refund transaction record
                            $transactionData = array();
                            $transactionData['userId'] = $jobData->userId;
                            $transactionData['userJobId'] = $apiData['data']['jobId'];
                            $transactionData['userJobDetailId'] = $apiData['data']['userJobDetailId'];
                            $transactionData['stripeTransactionId'] = $response['id'];
                            $transactionData['stripeTranJson'] = json_encode($response);
                            $transactionData['amount'] = $amountTransfer;
                            $transactionData['type'] = 1; // Credit amount
                            $transactionData['payType'] = 4; // Job pending payment refund
                            $transactionData['tranType'] = 2; // Stripe Transaction
                            $transactionData['status'] = 1;
                            $this->User_Transaction_Model->setData($transactionData);
                            $this->User_Transaction_Model->setData(['refundAmount'=> ($value->refundAmount + $amountTransfer)],$value->id);
                            $totalRefundableAmount = $totalRefundableAmount - $amountTransfer;
                        }
                    }
                }
            }

            // For doctor wallet transaction record
            $transactionData = array();
            $transactionData['userId'] = $user->id;
            $transactionData['userIdTo'] = $jobData->userId;
            $transactionData['userJobId'] = $apiData['data']['jobId'];
            $transactionData['userJobDetailId'] = $apiData['data']['userJobDetailId'];
            $transactionData['amount'] = $amount;
            $transactionData['type'] = 1; // Credit amount
            $transactionData['payType'] = 2; // Payment Get For Job 
            $transactionData['tranType'] = 1; //Wallet Transaction
            $transactionData['status'] = 1;
            $this->User_Transaction_Model->setData($transactionData);

            // Send notification doctor to add money in wallet
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $jobData->userId;
            $notiData['send_to'] = $user->id;
            $notiData['model_id'] = (int)$apiData['data']['userJobDetailId'];
            $notiData['jobName'] = $jobData->name;
            $notiData['amount'] = '$'.number_format($amount, 2);
            $this->Common_Model->backroundCall('addMoneyInYourWalletForUserJobPayment', $notiData);
            // ./ Set notification
            $this->User_Job_Detail_Model->setData(['caregiverPaymentStatus'=> 1],$apiData['data']['userJobDetailId']);
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("endJobSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToEndJob", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function uploadJobMedia_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['mediaName']) || empty($apiData['data']['mediaName'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("mediaNameRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'getJobJobDetail'=>true,'status'=> [1,3]],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $data = array();
        $data['jobId'] = $jobDetailData->jobId;
        $data['jobDetailId'] = $jobDetailData->id;
        $data['mediaName'] = $apiData['data']['mediaName'];

        $imgExtn = array('jpeg', 'gif', 'png', 'jpg', 'JPG', 'PNG', 'GIF', 'JPEG');
        $extention = pathinfo($apiData['data']['mediaName'], PATHINFO_EXTENSION);
        if (!in_array($extention, $imgExtn)) {
            $data['isVideo'] = 1;
            $data['videoImage'] = (isset($apiData['data']['videoImage']) ? $apiData['data']['videoImage'] : "");
        }
        $lastId = $this->User_Job_Uploaded_Model->setData($data);
        if (!empty($lastId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveJobMediaSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveJobMedia", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    /*public function userCreateEndJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobData = $this->User_Job_Model->get(['apiResponse'=>true,'id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'jobId'=>$jobData->userJobId,'status'=> 1],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $lastId = $this->User_Job_Detail_Model->setData(['status'=> 3],$apiData['data']['userJobDetailId']);
        $checkJobData = $this->User_Job_Detail_Model->get(['jobId'=>$jobData->userJobId,'status'=> 1]);
        if(empty($checkJobData)){
            $lastId = $this->User_Job_Model->setData(['status'=>3],$apiData['data']['jobId']);
        }

        if (!empty($lastId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("endJobSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToEndJob", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }*/

    public function sendSubstituteJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userJobApplyId']) || empty($apiData['data']['userJobApplyId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobApplyIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existJobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobApplyData = $this->User_Job_Apply_Model->get(['id'=>$apiData['data']['userJobApplyId'],'userId'=>$user->id,'status'=>'1'],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobApplyNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data["send_from"] = $user->id;
        $data["send_to"] = $apiData['data']['caregiverId'];
        $data["send_user"] = $existJobData->userId;
        $data["jobId"] = $apiData['data']['jobId'];
        $data["userJobApplyId"] = $apiData['data']['userJobApplyId'];
        $data["status"] = 1;
        $data["caregiverStatus"] = 0;
        $data["userStatus"] = 3;
        $jobSubstituteRequestExistData = $this->User_Job_Substitute_Request_Model->get($data,true);
        if(!empty($jobSubstituteRequestExistData)){
            $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData($data,$jobSubstituteRequestExistData->id);
        }else{
            $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData($data);
        }
        
        if (!empty($jobSubstituteRequestId)) {
            
            // Set notification for substitute job request by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $apiData['data']['caregiverId'];
            $notiData['model_id'] = (int)$existJobData->id;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestByCaregiver', $notiData);
            // ./ Set notification for substitute job request by caregiver
            
            // Set notification for substitute job request by caregiver to user
            /*$notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existJobData->userId;
            $notiData['caregiver_id'] = $apiData['data']['caregiverId'];
            $notiData['model_id'] = (int)$existJobData->id;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestByCaregiverToUser', $notiData);*/
            // ./ Set notification for substitute job request by caregiver to user
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobRequestSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSubstituteJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function acceptSubstituteJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['substituteRequestId']) || empty($apiData['data']['substituteRequestId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existSubstituteRequestData = $this->User_Job_Substitute_Request_Model->get(['id'=>$apiData['data']['substituteRequestId'],'send_to'=>$user->id,'caregiverStatus'=>'0','status'=>1],true);
        if (empty($existSubstituteRequestData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Model->get(['id'=>$existSubstituteRequestData->jobId,'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData(['caregiverStatus'=>1,'userStatus'=>0],$apiData['data']['substituteRequestId']);
        if (!empty($jobSubstituteRequestId)) {
            // Set notification for substitute job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existSubstituteRequestData->send_from;
            $notiData['model_id'] = (int)$existSubstituteRequestData->jobId;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestAcceptByCaregiver', $notiData);
            // ./ Set notification for substitute job by caregiver
            
            // Set notification for substitute job request by caregiver to user
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existJobData->userId;
            $notiData['caregiver_id'] = $existSubstituteRequestData->send_to;
            $notiData['model_id'] = (int)$existJobData->id;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestByCaregiverToUser', $notiData);
            // ./ Set notification for substitute job request by caregiver to user

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobRequestAcceptSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptSubstituteJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function rejectSubstituteJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['substituteRequestId']) || empty($apiData['data']['substituteRequestId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existSubstituteRequestData = $this->User_Job_Substitute_Request_Model->get(['id'=>$apiData['data']['substituteRequestId'],'send_to'=>$user->id,'caregiverStatus'=>'0','status'=>1],true);
        if (empty($existSubstituteRequestData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Model->get(['id'=>$existSubstituteRequestData->jobId,'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData(['caregiverStatus'=>2],$apiData['data']['substituteRequestId']);
        
        if (!empty($jobSubstituteRequestId)) {
            // Set notification for substitute job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existSubstituteRequestData->send_from;
            $notiData['model_id'] = (int)$existSubstituteRequestData->jobId;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestRejectByCaregiver', $notiData);
            // ./ Set notification for substitute job by caregiver
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobRequestRejectSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRejectSubstituteJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getSubstituteJobRequestList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}
        
        $data = array();
        $data['apiResponse'] = true;
        $data['getUserData'] = true;
        $data['getJobData'] = true;
        $data['caregiverStatus'] = 0;
        $data['send_to'] = $user->id;
        $data['status'] = 1;
        $totalData = count($this->User_Job_Substitute_Request_Model->get($data));
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Job_Substitute_Request_Model->get($data);
		
        if (!empty( $responseData )) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach($responseData as $value){
                $value->oldCaregiverId = $value->send_from;
                $value->newCaregiverId = $value->send_to;
                $value->jobOwnerId = $value->send_user;
                $value->startDateTime = "";
                $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$value->userJobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                if(!empty($jobDetailData)){
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($jobDetailData->startTime);
                    $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                }
            }

            $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getSubstituteJobRequestListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "substituteJobRequestListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getRequestAddJobHoursDetail_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$responseData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'id'=>$apiData['data']['userJobDetailId'],'status'=>'1','getJobJobDetail'=>true,'requestTimeStatus'=>'1'],true);
		
        if (!empty( $responseData )) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $startDateTime->setTimestamp($responseData->startTime);
            
            $endDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $endDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $endDateTime->setTimestamp($responseData->endTime);

            $requestEndDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $requestEndDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $requestEndDateTime->setTimestamp($responseData->requestEndTime);

            $responseData->perviousHours = $startDateTime->format('h:i A').' - '.$endDateTime->format('h:i A');
            $responseData->updatedHours = $startDateTime->format('h:i A').' - '.$requestEndDateTime->format('h:i A');
            
            $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getRequestHoursDetailSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "requestHoursDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function acceptAddJobHoursRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'status'=>'1','getJobJobDetail'=>true,'requestTimeStatus'=>'1'],true);
		if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobAdditionalRequestDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobData = $this->User_Job_Model->get(['id'=>$jobDetailData->jobId,'status'=>1],true);
        if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $userCardData = $this->User_Card_Model->get(['userId'=>$jobData->userId,'id'=>$jobData->userCardId,'status'=>1],true);
        if(empty($userCardData)){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if($userCardData->id != $jobData->userCardId){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK); 
        }
        
        $this->load->library('stripe');
        $minutes = floor(($jobDetailData->requestEndTime - $jobDetailData->requestStartTime) / 60);
        $amount = ($jobData->price / 60);
        $amount = round($amount * $minutes,2);
        $stripeChargeData['customer'] = $userCardData->customerId;
        $stripeChargeData['source'] = $userCardData->cardId;
        $stripeChargeData['amount'] = $amount * 100;
        $stripeChargeData['description'] ="Job Payment for additional hours, userId: #".$jobDetailData->userId.", caregiverId: #".$jobDetailData->caregiverId.", userCardId: #".$userCardData->id." , jobId: #".$jobDetailData->jobId.", jobDetailId: #".$jobDetailData->id;
        $response = $this->stripe->addCharge($stripeChargeData);
        error_log("\n\n -------------------------------------" . date('c'). " \n Request => ".json_encode($stripeChargeData) . " \n Response => ".json_encode($response,true), 3, FCPATH.'worker/jobPayment-'.date('d-m-Y').'.txt');
        if(!empty($response)){
            if(isset($response['error'])){
                $response['error']['status'] = '0';
                $this->apiResponse = $response['error'];
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }elseif(!isset($response->id) || $response->id==""){ 
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptJobAddHourRequest", $apiData['data']['langType']);
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }else{
                $this->User_Job_Detail_Model->setData(['requestTimeStatus'=>2,'requestTimeUserPaymentStatus'=>1,'endTime'=>$jobDetailData->requestEndTime],$jobDetailData->id);
                // For user transaction record
                $transactionData = array();
                $transactionData['userId'] = $jobDetailData->userId;
                $transactionData['userIdTo'] = $jobDetailData->caregiverId;
                $transactionData['cardId'] = $userCardData->id;
                $transactionData['userJobId'] = $jobDetailData->jobId;
                $transactionData['userJobDetailId'] = $jobDetailData->id;
                $transactionData['stripeTransactionId'] = $response['id'];
                $transactionData['stripeTranJson'] = json_encode($response);
                $transactionData['amount'] = $amount;
                $transactionData['type'] = 2; // Debit amount
                $transactionData['payType'] = 1; // Payment Pay For Job 
                $transactionData['tranType'] = 2; //Stripe Transaction
                $transactionData['status'] = 1; 
                $transactionData['createdDate'] = $response['created'];
                $this->User_Transaction_Model->setData($transactionData);
               
                // Set notification 
                $notiData = [];
                $notiData['send_from'] = $jobDetailData->userId;
                $notiData['send_to'] = $jobDetailData->userId;
                $notiData['model_id'] = (int)$jobDetailData->id;
                $notiData['amount'] = '$'.number_format($amount,2);
                $notiData['jobName'] = $jobDetailData->jobName;
                $this->Common_Model->backroundCall('transactionSuccessForAdditionaHoursJobPayment', $notiData);
                // ./ Set notification
                
                // Set notification for decline additional hours time of job by caregiver
                $notiData = [];
                $notiData['send_from'] = $user->id;
                $notiData['send_to'] = $jobDetailData->userId;
                $notiData['model_id'] = (int)$jobDetailData->id;
                $notiData['jobName'] = $jobDetailData->jobName;
                $this->Common_Model->backroundCall('acceptExtraTimeRequestOfCurrentJobByCaregiver', $notiData);
                // ./ Set notification for decline additional hours time of job by caregiver
                
                $this->apiResponse['status'] = "1";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobAddHourRequestAcceptSuccess", $apiData['data']['langType']);
            }
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptJobAddHourRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function declineAddJobHoursRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'status'=>'1','getJobJobDetail'=>true,'requestTimeStatus'=>'1'],true);
		if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobAdditionalRequestDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobRequestHoursId = $this->User_Job_Detail_Model->setData(['requestTimeStatus'=>3],$jobDetailData->id);
        
        if (!empty($jobRequestHoursId)) {
            // Set notification for decline additional hours time of job by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobDetailData->userId;
            $notiData['model_id'] = (int)$jobDetailData->id;
            $notiData['jobName'] = $jobDetailData->jobName;
            $this->Common_Model->backroundCall('declineExtraTimeRequestOfCurrentJobByCaregiver', $notiData);
            // ./ Set notification for decline additional hours time of job by caregiver
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobAddHourRequestDeclineSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToDeclineJobAddHourRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getAwardJobRequestList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}

        $data = array();
        $data['apiResponse'] = true;
        $data['userId'] = $user->id;
        $data['getJobData'] = true;
        //$data['getCaregiverDetails'] = true;
        $data['orderby'] = "id";
        $data['orderstate'] = "DESC";
        
        if(isset($apiData['data']['search']) && !empty($apiData['data']['search'])) {
            $data['allsearch'] = $apiData['data']['search'];
        }
        
        $data['status'] = 1;
        
		$totalData = $this->User_Job_Award_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Job_Award_Model->get($data);
		
        $totalWorkTimeData = $this->User_Job_Detail_Model->get(['getJobCompletedTimingData'=>$user->id,'status'=>'3'],true);
        
        if (!empty( $responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach( $responseData as $value ){
                $value->startDateTime = "";
                $value->userJobDetailId = "";
                $value->starTimestamp = "";
                $value->endTimestamp = "";
                $jobDetailData = $this->User_Job_Detail_Model->get(['apiResponse'=>true,'jobId'=>$value->jobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
                if(!empty($jobDetailData)){
                    $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                    $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                    $startDateTime->setTimestamp($jobDetailData->startTime);
                    $value->startDateTime = $startDateTime->format('d M Y  h:i A');
                    $value->userJobDetailId = $jobDetailData->userJobDetailId;
                    $value->starTimestamp = $jobDetailData->startTime;
                    $value->endTimestamp = $jobDetailData->endTime;
                }
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getAwardJobRequestListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['totalWorkTime'] = (isset($totalWorkTimeData->totalWorkTime) && !empty($totalWorkTimeData->totalWorkTime) ? $totalWorkTimeData->totalWorkTime : '0 hrs 0 mins');
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "awardJobRequestNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
            $this->apiResponse['totalWorkTime'] = (isset($totalWorkTimeData->totalWorkTime) && !empty($totalWorkTimeData->totalWorkTime) ? $totalWorkTimeData->totalWorkTime : '0 hrs 0 mins');
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function acceptAwardJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobAwardId']) || empty($apiData['data']['userJobAwardId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobAwardIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$jobAwardData = $this->User_Job_Award_Model->get(['id'=>$apiData['data']['userJobAwardId'],'userId'=>$user->id,'getJobData'=>true,'status' => '1'],true);
		if (empty($jobAwardData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("awardJobRequestNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if ($jobAwardData->isHire == 1) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("alreadyHiredCaregiverForThisJob", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobApplyData = $this->User_Job_Apply_Model->get(['jobId'=>$jobAwardData->jobId,'isHire'=>'1','status'=>'1'],true);
        if (!empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("alreadyHiredCaregiverForThisJob", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $this->User_Job_Award_Model->setData(['status'=>2],$apiData['data']['userJobAwardId']);

        $verificationCode = $this->Common->random_string(4);
        $jobApplyId = $this->User_Job_Apply_Model->setData(['jobId'=>$jobAwardData->jobId, 'userId'=>$user->id, 'isHire'=>'1','status'=>1]);
        $jobId = $this->User_Job_Model->setData(['isHire'=>'1','verificationCode'=>$verificationCode],$jobAwardData->jobId);

        if (!empty($jobApplyId) && !empty($jobId)) {
            // Set notification for accept award job request by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobAwardData->jobUserId;
            $notiData['model_id'] = (int)$jobAwardData->jobId;
            $notiData['jobName'] = $jobAwardData->jobName;
            $this->Common_Model->backroundCall('acceptAwardJobRequestByCaregiver', $notiData);
            // ./ Set notification for accept award job request by caregiver
            
            // Send Mail and SMS in Authentication code
            $notiData = [];
            $notiData['userId'] = $jobAwardData->jobUserId;
            $notiData['verificationCode'] = $verificationCode;
            $notiData['jobName'] = $jobAwardData->jobName;
            $this->Common_Model->backroundCall('sendJobVerificationCodeForUser', $notiData);
            // ./ Send Mail and SMS in Authentication code

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("awardJobRequestAcceptSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptAwardJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function declineAwardJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '3') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotACaregiver", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobAwardId']) || empty($apiData['data']['userJobAwardId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobAwardIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$jobAwardData = $this->User_Job_Award_Model->get(['id'=>$apiData['data']['userJobAwardId'],'userId'=>$user->id,'getJobData'=>true,'status' => '1'],true);
		if (empty($jobAwardData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("awardJobRequestNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $awardJobRequestId = $this->User_Job_Award_Model->setData(['status'=>3],$jobAwardData->id);
        
        if (!empty($awardJobRequestId)) {
            // Set notification for decline award job request by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobAwardData->jobUserId;
            $notiData['model_id'] = (int)$jobAwardData->jobId;
            $notiData['jobName'] = $jobAwardData->jobName;
            $this->Common_Model->backroundCall('declineAwardJobRequestByCaregiver', $notiData);
            // ./ Set notification for decline award job request by caregiver
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("awardJobRequestDeclineSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToDeclineAwardJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
}
