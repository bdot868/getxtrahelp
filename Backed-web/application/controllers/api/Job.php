<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Job extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('User_Job_Model');
        $this->load->model('User_Job_Sub_Category_Model');
        $this->load->model('User_Job_Question_Model');
        $this->load->model('User_Job_Media_Model');
        $this->load->model('User_Job_Detail_Model');
        $this->load->model('User_Job_Apply_Model');
        $this->load->model('User_Search_History_Model');
        $this->load->model('User_Review_Model');
        $this->load->model('Job_Category_Model');
        $this->load->model('Resources_Model');
        $this->load->model('User_Card_Model','User_Card');
        $this->load->model('User_Work_Detail_Model');
        $this->load->model('User_Work_Experience_Model');
        $this->load->model('User_Work_Job_Category_Model');
        $this->load->model('User_Job_Question_Answer_Model');
        $this->load->model('User_Job_Uploaded_Model');
        $this->load->model('User_Ongoing_Job_Review_Model');
        $this->load->model('User_Job_Substitute_Request_Model');
        $this->load->model('User_Job_Award_Model');
        $this->load->model('Notification_Model');
    }

    public function getUserDashboard_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (isset($apiData['data']['timezone']) && !empty($apiData['data']['timezone'])) {
            $this->User->setData(['timezone'=>$apiData['data']['timezone']],$user->id);
            $myUserTimeZone = $apiData['data']['timezone'];
        }else{
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        }

        $response = array();
        // Ongoing job list
        $data = array();
        $data['apiResponse'] = true;
        $data['userId'] = $user->id;
        $data['getHiredCaregiverData'] = true;
        $data['jobHireStatus'] = 1;
        $data['getOngoingJobDetailData'] = true;
        $data['isHire'] = 1;
        $data['status'] = [1,3];
        $response['ongoingJobs'] = $this->User_Job_Model->get($data);
        if(!empty($response['ongoingJobs'])){
            foreach( $response['ongoingJobs'] as $value ){
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($value->starTimestamp);
                $value->startDateTime = $startDateTime->format('d M Y  h:i A');

                $endDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $endDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $endDateTime->setTimestamp($value->endTimestamp);
                
                $diff = $endDateTime->diff(new DateTime());
                $value->leftTime = ($diff->days * 24 * 60) + ($diff->h * 60) + $diff->i .':'.$diff->s.' mins left';
            }
        }
        
        // Upcoming job list
        $data = array();
        $data['apiResponse'] = true;
        $data['userId'] = $user->id;
        $data['getHiredCaregiverData'] = true;
        $data['jobHireStatus'] = 1;
        $data['getJobDetailData'] = 1;
        $data['isHire'] = 1;
        $data['status'] = [1,3];
        $data['limit'] = 5;
        $response['upcomingJobs'] = $this->User_Job_Model->get($data);
        if(!empty($response['upcomingJobs'])){
            foreach( $response['upcomingJobs'] as $value ){
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($value->starTimestamp);
                $value->startDateTime = $startDateTime->format('d M Y  h:i A');
            }
        }

        // Near caregiver list
        $data = array();
        $data['role'] = 3;
        $data['profileStatus'] = 8;
        $data['status'] = 1;
        $data['getCaregiverCategory'] = true;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        $data['getInRadius']['miles'] = (isset($apiData['data']['miles']) && !empty($apiData['data']['miles']) ? $apiData['data']['miles'] : 60);
        $data['limit'] = 5;
       
		$response['nearestCaregiver'] = array();
		$nearestCaregiver = $this->Users_Model->get($data);
        if(!empty($nearestCaregiver)){
            foreach( $nearestCaregiver as $value ){
                $tmp = array();
                $tmp['id'] = $value->id;
                $tmp['firstName'] = $value->firstName;
                $tmp['lastName'] = $value->lastName;
                $tmp['fullName'] = $value->firstName.' '.$value->lastName;
                $tmp['email'] = $value->email;
                $tmp['profileImageUrl'] = $value->profileImageUrl;
                $tmp['profileImageThumbUrl'] = $value->profileImageThumbUrl;
                $tmp['categoryNames'] = $value->categoryNames;
                $tmp['distance'] = $value->distance;
                $tmp['status'] = $value->status;
                $response['nearestCaregiver'][] = $tmp;
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

    public function saveUserJob_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['categoryId']) || empty($apiData['data']['categoryId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobCategoryIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['subCategoryId']) || empty($apiData['data']['subCategoryId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobSubCategoryIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['name']) || empty($apiData['data']['name'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobNameRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['price']) || empty($apiData['data']['price'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobPriceRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['location']) || empty($apiData['data']['location'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobLocationRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['latitude']) || empty($apiData['data']['latitude'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobLatitudeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['longitude']) || empty($apiData['data']['longitude'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobLongitudeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        /*if (!isset($apiData['data']['description']) || empty($apiData['data']['description'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDescriptionRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }*/
    
        if (!isset($apiData['data']['isJob']) || !in_array($apiData['data']['isJob'], array('1','2'))) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("isJobRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobTiming']) || empty($apiData['data']['jobTiming'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobTimingRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
     
        $data = array();
        $data['userId'] = $user->id;
        $data['categoryId'] = $apiData['data']['categoryId'];
        $data['name'] = $apiData['data']['name'];
        $data['price'] = $apiData['data']['price'];
        $data['location'] = $apiData['data']['location'];
        $data['latitude'] = $apiData['data']['latitude'];
        $data['longitude'] = $apiData['data']['longitude'];
        $data['description'] = (isset($apiData['data']['description']) ? $apiData['data']['description'] : "");
        $data['isJob'] = $apiData['data']['isJob'];
        $data['ownTransportation'] = (isset($apiData['data']['ownTransportation']) && $apiData['data']['ownTransportation'] == 1 ? 1 : 0);
        $data['nonSmoker'] = (isset($apiData['data']['nonSmoker']) && $apiData['data']['nonSmoker'] == 1 ? 1 : 0);
        $data['currentEmployment'] = (isset($apiData['data']['currentEmployment']) && $apiData['data']['currentEmployment'] == 1 ? 1 : 0);
        $data['minExperience'] = (isset($apiData['data']['minExperience']) && $apiData['data']['minExperience'] == 1 ? 1 : 0);
        $data['yearExperience'] = (isset($apiData['data']['yearExperience']) && $apiData['data']['minExperience'] != "" ? $apiData['data']['minExperience'] : "");
        $jobId = $this->User_Job_Model->setData($data);

        if (!empty($jobId)) {
            // Set Category
            $this->User_Job_Sub_Category_Model->setData(['jobIds'=>$jobId,'status'=>2]);
            if (isset($apiData['data']['subCategoryId']) && !empty($apiData['data']['subCategoryId'])) {
                foreach($apiData['data']['subCategoryId'] as $value){
                    if(empty($value)){
                        continue;
                    }
                    $existCategoryData = $this->User_Job_Sub_Category_Model->get(['jobId'=>$jobId,'jobSubCategoryId'=>trim($value)],true);
                    if(!empty($existCategoryData)){
                        $this->User_Job_Sub_Category_Model->setData(['jobId'=>$jobId,'jobSubCategoryId'=>trim($value),'status'=>1],$existCategoryData->id);
                    }else{
                        $this->User_Job_Sub_Category_Model->setData(['jobId'=>$jobId,'jobSubCategoryId'=>trim($value)]);
                    }
                }
            }
            // ./ Set Category

            // Set Additional Questions
            if (isset($apiData['data']['additionalQuestions']) && !empty($apiData['data']['additionalQuestions'])) {
                foreach($apiData['data']['additionalQuestions'] as $value){
                    if(!isset($value['name']) && empty($value['name'])){
                        continue;
                    }

                    if(isset($value['userJobQuestionId']) && !empty($value['userJobQuestionId'])){
                        $existQuestionData = $this->User_Job_Question_Model->get(['id'=>$value['userJobQuestionId'],'jobId'=>$jobId],true);
                        if(!empty($existQuestionData)){
                            $this->User_Job_Question_Model->setData(['jobId'=>$jobId,'question'=>trim($value['name']),'status'=>1],$existQuestionData->id);
                        }else{
                            $this->User_Job_Question_Model->setData(['jobId'=>$jobId,'question'=>trim($value['name'])]);
                        }
                    }else{
                        $this->User_Job_Question_Model->setData(['jobId'=>$jobId,'question'=>trim($value['name'])]);
                    }
                }
            }
            // ./ Set Additional Questions

            // Save Media
            if (isset($apiData['data']['media']) && !empty($apiData['data']['media'])) {
                $this->User_Job_Media_Model->setData(['jobIds' => $jobId, 'status' => 2]);
                $imgExtn = array('jpeg', 'gif', 'png', 'jpg', 'JPG', 'PNG', 'GIF', 'JPEG');
                foreach ($apiData['data']['media'] as $key => $media) {
                    if (!isset($media['mediaName']) && empty($media['mediaName'])) {
                        continue;
                    }
                    $tmp = [];
                    $existMedialData = $this->User_Job_Media_Model->get(['mediaName' => $media['mediaName'], 'jobId' => $jobId], true);
                    if (!empty($existMedialData)) {
                        $tmp['jobId'] = $jobId;
                        $tmp['status'] = 1;
                        $this->User_Job_Media_Model->setData($tmp, $existMedialData->id);
                    } else {
                        $tmp['jobId'] = $jobId;
                        $tmp['mediaName'] = $media['mediaName'];
                        $extention = pathinfo($media['mediaName'], PATHINFO_EXTENSION);
                        if (!in_array($extention, $imgExtn)) {
                            $tmp['isVideo'] = 1;
                            $tmp['videoImage'] = (isset($media['videoImage']) ? $media['videoImage'] : "");
                        }
                        $this->User_Job_Media_Model->setData($tmp);
                    }
                }
            }
            // Save Media
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach($apiData['data']['jobTiming']['date'] as $value){
                $startdatetime = new DateTime($value.' '.$apiData['data']['jobTiming']['startTime'], new DateTimeZone( $myUserTimeZone ));
                $startdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
                
                $enddatetime = new DateTime($value.' '.$apiData['data']['jobTiming']['endTime'], new DateTimeZone( $myUserTimeZone ));
                $enddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));

                $jobTiming = array();
                $jobTiming['jobId'] = $jobId;
                $jobTiming['startTime'] = $startdatetime->format('U');
                $jobTiming['endTime'] = $enddatetime->format('U');
                $this->User_Job_Detail_Model->setData($jobTiming);
            }

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveUserJobDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data']['jobId'] = $jobId;
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveUserJobData", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function cancelMyPostedJob_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobId']) || empty($apiData['data']['userJobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Model->get(['id'=>$apiData['data']['userJobId'],'status'=> 1],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$jobId = $this->User_Job_Model->setData(['status'=>4],$apiData['data']['userJobId']);
		
        if (!empty($jobId)) {
            $this->User_Job_Sub_Category_Model->setData(['jobIds'=>$jobId,'status'=>2]);
            $this->User_Job_Media_Model->setData(['jobIds' => $jobId, 'status' => 2]);
            $this->User_Job_Question_Model->setData(['jobIds'=>$jobId,'status' => 2]);
            $this->User_Job_Detail_Model->setData(['jobIds'=>$jobId,'status' => 2]);
            $this->User_Job_Apply_Model->setData(['jobIds'=>$jobId,'status' => 2]);
            $this->apiResponse['status'] = "1";
            $this->Notification_Model->removeData(['send_to'=>$user->id,'model'=>'acceptAwardJobRequestByCaregiver','model_id'=>$jobId]);
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "postedJobCancelSuccess", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToCancelPostedJob", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getMyPostedJob_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
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

		$responseData = $this->User_Job_Model->get(['apiResponse'=>true,'userId' => $user->id, 'getApplicationsCount'=>true,'status' => '1', 'limit' => $limit, 'offset' => $offset]);		
		$totalData = $this->User_Job_Model->get(['apiResponse'=>true,'userId' => $user->id, 'getApplicationsCount'=>true, 'status' => '1' ], false, true);
		
        if (!empty( $responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach( $responseData as $value ){
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
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getPostedJobSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "postedJobDataNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getMyPostedJobDetail_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$responseData = $this->User_Job_Model->get(['apiResponse'=>true,'id'=>$apiData['data']['jobId'],'userId'=>$user->id,'getCategoryData'=>true,'getApplicationsCount'=>true,'status' => '1'],true);
		
        if (!empty($responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            $responseData->createdDateFormat = $this->Common_Model->get_time_ago($responseData->createdDate);
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
            $responseData->applicants = $this->User_Job_Apply_Model->get(['apiResponse'=>true,'getUserData'=>true,'jobId'=>$responseData->userJobId,'status'=>'1','orderby'=>'id','orderstate'=>'ASC','limit'=>4]);
            $responseData->media = $this->User_Job_Media_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->questions = $this->User_Job_Question_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getPostedJobDetailSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "postedJobDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getMyPostedJobApplicants_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
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

		$responseData = $this->User_Job_Apply_Model->get(['apiResponse'=>true,'jobId'=>$apiData['data']['jobId'],'getUserData'=>true,'status' => '1', 'limit' => $limit, 'offset' => $offset]);		
		$totalData = $this->User_Job_Apply_Model->get(['apiResponse'=>true,'jobId'=>$apiData['data']['jobId'],'getUserData'=>true,'status' => '1' ], false, true);
		
        if (!empty( $responseData)) {
           $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getPostedJobApplicantSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "postedJobApplicantDataNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function acceptCaregiverJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userCardId']) || empty($apiData['data']['userCardId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userCardIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        $existCardData = $this->User_Card->get(['id'=>$apiData['data']['userCardId'],'userId'=>$user->id,'status'=>1],true);
        if(empty($existCardData)){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'userId'=>$user->id,'status'=> '1'],true);
        if (isset($existJobData->isHire) && $existJobData->isHire == 1) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youHaveAlreadyHiredCaregiverForThisJob", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("postedJobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobApplyData = $this->User_Job_Apply_Model->get(['jobId'=>$apiData['data']['jobId'],'isHire'=>'1','status'=>'1'],true);
        if (!empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youHaveAlreadyHiredCaregiverForThisJob", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobApplyData = $this->User_Job_Apply_Model->get(['jobId'=>$apiData['data']['jobId'],'isHire'=>'0','userId'=>$apiData['data']['caregiverId']],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("postedJobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $verificationCode = $this->Common->random_string(4);
        $this->User_Job_Apply_Model->setData(['isHire'=>'1'],$jobApplyData->id);
        $jobId = $this->User_Job_Model->setData(['isHire'=>'1','verificationCode'=>$verificationCode,'userCardId'=>$apiData['data']['userCardId']],$existJobData->id);
        if (!empty($jobId)) {
            $jobDetailData = $this->User_Job_Detail_Model->get(['jobId'=>$jobId,'status'=>'1','orderby'=>'startTime','orderstate'=>'ASC'],true);
            if(!empty($jobDetailData)){
                // Set notification for accept job request by caregiver
                $notiData = [];
                $notiData['send_from'] = $user->id;
                $notiData['send_to'] = $jobApplyData->userId;
                $notiData['model_id'] = (int)$jobDetailData->id;
                $this->Common_Model->backroundCall('acceptJobRequestByUser', $notiData);
                // ./ Set notification for accept job request by caregiver
            }
            
            // Send Mail and SMS in Authentication code
            $notiData = [];
            $notiData['userId'] = $user->id;
            $notiData['verificationCode'] = $verificationCode;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('sendJobVerificationCodeForUser', $notiData);
            // ./ Send Mail and SMS in Authentication code

            $in48Hours = $this->User_Job_Detail_Model->get(['jobId'=>$jobId,'getDatabefore48HoursOfStartJob'=>true,'userPaymentStatus'=>'0','status'=>1]);
            if(!empty($in48Hours)){
                $this->Background_Model->collectPaymentUseApi($jobId);
            }

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("acceptCaregiverJobRequestSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptCaregiverJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function rejectCaregiverJobRequest_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        $existJobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'userId'=>$user->id,'status'=> '1'],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("postedJobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobApplyData = $this->User_Job_Apply_Model->get(['jobId'=>$apiData['data']['jobId'],'isHire'=>'0','userId'=>$apiData['data']['caregiverId']],true);
        if (empty($jobApplyData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("postedJobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $lastId = $this->User_Job_Apply_Model->setData(['status'=>'2'],$jobApplyData->id);
        if (!empty($lastId)) {
            // Set notification for reject job request by caregiver
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobApplyData->userId;
            $notiData['model_id'] = (int)$existJobData->id;
            $this->Common_Model->backroundCall('rejectJobRequestByUser', $notiData);
            // ./ Set notification for reject job request by caregiver
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("rejectCaregiverJobRequestSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRejectCaregiverJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function findCaregivers_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
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
        $data['role'] = 3;
        $data['profileStatus'] = 8;
        $data['status'] = 1;
        $data['getCaregiverCategory'] = true;
        $data['getCaregiverReview'] = true;
        $data['countTotalJobCompleted'] = true;
        //$data['countTotalJobOngoingWithMe'] = $user->id;
        $data['getInRadius']['lat'] = (isset($apiData['data']['latitude']) && !empty($apiData['data']['latitude']) ? $apiData['data']['latitude'] : $user->latitude);
        $data['getInRadius']['long'] = (isset($apiData['data']['longitude']) && !empty($apiData['data']['longitude']) ? $apiData['data']['longitude'] : $user->longitude);
        $data['getInRadius']['miles'] = (isset($apiData['data']['miles']) && !empty($apiData['data']['miles']) ? $apiData['data']['miles'] : 60);
        if(isset($apiData['data']['startMiles']) && !empty($apiData['data']['startMiles'])){
            $data['getInRadius']['startMiles'] = $apiData['data']['startMiles'];
        }

        if(isset($apiData['data']['endMiles']) && !empty($apiData['data']['endMiles'])){
            $data['getInRadius']['endMiles'] = $apiData['data']['endMiles'];
        }


        if(isset($apiData['data']['search']) && $apiData['data']['search'] != ""){
            $this->User_Search_History_Model->setData(['userId'=>$user->id,'keyword'=>$apiData['data']['search']]);
            $data['search'] = $apiData['data']['search'];
        }

        if(isset($apiData['data']['category']) && $apiData['data']['category'] != ""){            
            $data['category'] = $apiData['data']['category'];
        }
        if(isset($apiData['data']['isFirst']) && $apiData['data']['isFirst'] == '1'){
            $data['isNewestFirst'] = true;
        }elseif(isset($apiData['data']['isFirst']) && $apiData['data']['isFirst'] == '2'){
            $data['isOldestFirst'] = true;
        }
        
        if(isset($apiData['data']['isOnline']) && $apiData['data']['isOnline'] == "1"){            
            $data['isOnline'] = $apiData['data']['isOnline'];
        }
        
        if(isset($apiData['data']['isTopRated']) && $apiData['data']['isTopRated'] == "1"){            
            $data['getIsTopRated'] = $apiData['data']['isTopRated'];
        }
        
        if(isset($apiData['data']['gender']) && in_array($apiData['data']['gender'], array(1,2,3))){
            $data['gender'] = $apiData['data']['gender'];
        }

        if(isset($apiData['data']['startAgeRange']) && !empty($apiData['data']['startAgeRange'])){
            $data['checkStartAgeRange'] = $apiData['data']['startAgeRange'];
        }

        if(isset($apiData['data']['endAgeRange']) && !empty($apiData['data']['endAgeRange'])){
            $data['checkEndAgeRange'] = $apiData['data']['endAgeRange'];
        }

        if(isset($apiData['data']['isVaccinated']) && in_array($apiData['data']['isVaccinated'], array(1,2))){
            $data['familyVaccinated'] = $apiData['data']['isVaccinated'];
        }

        if(isset($apiData['data']['isAvailable']) && in_array($apiData['data']['isAvailable'], array(1,2))){
            
        }

        if(isset($apiData['data']['customDate']) && !empty($apiData['data']['customDate'])){
            
        }

		$totalData = count($this->Users_Model->get($data));
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->Users_Model->get($data);
        
        //echo $this->db->last_query(); die;

        if (!empty( $responseData )) {
            $finalData = array();
            foreach( $responseData as $value ){
                $tmp = array();
                $tmp['id'] = $value->id;
                $tmp['firstName'] = $value->firstName;
                $tmp['lastName'] = $value->lastName;
                $tmp['fullName'] = $value->firstName.' '.$value->lastName;
                $tmp['email'] = $value->email;
                $tmp['profileImageUrl'] = $value->profileImageUrl;
                $tmp['profileImageThumbUrl'] = $value->profileImageThumbUrl;
                $tmp['categoryNames'] = $value->categoryNames;
                $tmp['ratingAverage'] = $value->ratingAverage;
                $tmp['distance'] = $value->distance;
                $tmp['totalJobCompleted'] = $value->totalJobCompleted;
                $tmp['totalJobOngoingWithMe'] = 0;
                $tmp['status'] = $value->status;
                $finalData[] = $tmp;
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getCaregiverResultSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $finalData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "caregiverResultNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function getMyJobRelatedCaregiver_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
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
        $data['role'] = 3;
        $data['profileStatus'] = 8;
        $data['status'] = 1;
        $data['getCaregiverCategory'] = true;
        $data['countTotalJobCompleted'] = true;
        $data['countTotalJobWithMe'] = $user->id;
        if(isset($apiData['data']['search']) && $apiData['data']['search'] != ""){
            $this->User_Search_History_Model->setData(['userId'=>$user->id,'keyword'=>$apiData['data']['search']]);
            $data['search'] = $apiData['data']['search'];
        }
       
        if(isset($apiData['data']['gender']) && in_array($apiData['data']['gender'], array(1,2,3))){
            $data['gender'] = $apiData['data']['gender'];
        }

        if(isset($apiData['data']['startAgeRange']) && !empty($apiData['data']['startAgeRange'])){
            $data['checkStartAgeRange'] = $apiData['data']['startAgeRange'];
        }

        if(isset($apiData['data']['endAgeRange']) && !empty($apiData['data']['endAgeRange'])){
            $data['checkEndAgeRange'] = $apiData['data']['endAgeRange'];
        }

        if(isset($apiData['data']['isVaccinated']) && in_array($apiData['data']['isVaccinated'], array(1,2))){
            $data['familyVaccinated'] = $apiData['data']['isVaccinated'];
        }

        if(isset($apiData['data']['isAvailable']) && in_array($apiData['data']['isAvailable'], array(1,2))){
            
        }

        if(isset($apiData['data']['customDate']) && !empty($apiData['data']['customDate'])){
            
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
                $tmp['fullName'] = $value->firstName.' '.$value->lastName;
                $tmp['email'] = $value->email;
                $tmp['profileImageUrl'] = $value->profileImageUrl;
                $tmp['profileImageThumbUrl'] = $value->profileImageThumbUrl;
                $tmp['categoryNames'] = $value->categoryNames;
                $tmp['totalJobCompleted'] = $value->totalJobCompleted;
                $tmp['totalJobWithMe'] = $value->totalJobWithMe;
                $tmp['status'] = $value->status;
                $finalData[] = $tmp;
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getCaregiverResultSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $finalData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "caregiverResultNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    // List upcoming and completed job
    public function getUserRelatedJobList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['type']) || !in_array($apiData['data']['type'], array('1','2'))) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("typeRequired", $apiData['data']['langType']);
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
        $data['getHiredCaregiverData'] = true;
        $data['isHire'] = 1;
        $data['status'] = [1,3];

        if(isset($apiData['data']['search']) && !empty($apiData['data']['search'])) {
            $data['allsearch'] = $apiData['data']['search'];
        }

        if($apiData['data']['type'] == '1') {
            $data['getJobDetailData'] = 1;
        }elseif($apiData['data']['type'] == '2') {
            $data['getJobReview'] = $user->id;
            $data['getJobDetailData'] = 3;
        }
        
		$totalData = $this->User_Job_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Job_Model->get($data);
		
        if (!empty( $responseData)) {
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach( $responseData as $value ){
                $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($value->starTimestamp);
                $value->startDateTime = $startDateTime->format('d M Y  h:i A');
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

    // Upcoming and completed job detail
    public function getUserRelatedJobDetail_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
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
        $data['userId'] = $user->id;
        $data['getHiredCaregiverData'] = true;
        $data['getHiredCaregiverRatingData'] = true;
        $data['isHire'] = 1;
        $data['status'] = [1,3];
        $data['getJobReview'] = $user->id;
        $data['getCategoryData'] = true;

		$responseData = $this->User_Job_Model->get($data,true);
		
        if (!empty($responseData)) {
            $responseData->userJobDetailId = $jobDetailData->id;
            $responseData->starTimestamp = $jobDetailData->startTime;
            $responseData->endTimestamp = $jobDetailData->endTime;
            $responseData->jobStatus = $jobDetailData->status;
            //0->Not Started, 1->Ongoing, 2->Completed
            $responseData->startJobStatus = $jobDetailData->isJobStatus;
            $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        
            $startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $startDateTime->setTimestamp($responseData->starTimestamp);
            $endTimeTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
            $endTimeTime->setTimezone(new DateTimeZone($myUserTimeZone));
            $endTimeTime->setTimestamp($responseData->endTimestamp);
            $responseData->startDateTime = $startDateTime->format('d M Y  h:i A').' to '.$endTimeTime->format('h:i A');
            $responseData->startTime = $startDateTime->format('h:i A');
            $responseData->endTime = $endTimeTime->format('h:i A');

            $responseData->media = $this->User_Job_Media_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->uploadedMedia = $this->User_Job_Uploaded_Model->get(['apiResponse'=>true,'jobId'=>$responseData->userJobId,'jobDetailId'=>$responseData->userJobDetailId,'orderby'=>'id','orderstate'=>'ASC']);
            $responseData->questions = $this->User_Job_Question_Model->get(['apiResponse'=>true,'getJonQestionAnswer'=>$responseData->caregiverId,'jobId'=>$responseData->userJobId,'orderby'=>'id','orderstate'=>'ASC']);
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

    public function setJobReview_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );
		if (!isset( $apiData['data']['rating']) || empty($apiData['data']['rating'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ratingRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if (!isset( $apiData['data']['feedback'] ) || empty( $apiData['data']['feedback'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "feedbackRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if (!isset( $apiData['data']['jobId'] ) || empty( $apiData['data']['jobId'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "jobIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

        $jobDetailData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'userId'=>$user->id,'getHiredCaregiverData'=>true,'status'=> [3]],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $data = [];
        $data['userIdFrom'] = $user->id;
        $data['userIdTo'] = $jobDetailData->caregiverId;
        $data['jobId'] = $apiData['data']['jobId'];

		$appFeedbackData = $this->User_Review_Model->get($data,true);

        $data['rating'] = $apiData['data']['rating'];
        $data['feedback'] = $apiData['data']['feedback'];
		if ( !empty($appFeedbackData) ) {
			$data['status'] = "1";
			$appFeedbackId = $this->User_Review_Model->setData( $data, $appFeedbackData->id );
		} else {
			$appFeedbackId = $this->User_Review_Model->setData( $data );
		}

		if ( !empty($appFeedbackId) ) {
			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "saveJobReviewSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSaveJobReview", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

    public function getCaregiverProfile_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        /*if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }*/
    
        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data['id'] = $apiData['data']['caregiverId'];
        $data['role'] = 3;
        $data['profileStatus'] = 8;
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

            // Completed job list
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
            $finalData['totalReview'] = $this->User_Review_Model->get(['userIdTo'=>$responseData->id,'getUserData'=>true,'status'=>1],false,true);
            $finalData['reviewData'] = $this->User_Review_Model->get(['apiResponse'=>true,'userIdTo'=>$responseData->id,'getUserData'=>true,'status'=>1,'orderby'=>'createdDate','orderstate'=>'ASC','limit'=>5]);
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
    
    // Caregiver review list
    public function getCaregiverReviewList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );
    
        if (!isset($apiData['data']['caregiverId']) || empty($apiData['data']['caregiverId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("caregiverIdRequired", $apiData['data']['langType']);
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
        $data['userIdTo'] = $apiData['data']['caregiverId'];
        $data['getUserData'] = true;
        $data['status'] = 1;


		$totalData = $this->User_Review_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Review_Model->get($data);
		
        if (!empty( $responseData)) {
         	$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getReviewListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['totalReview'] = $totalData;
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "reviewListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
            $this->apiResponse['totalReview'] = $totalData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function applicantApplyJobQueAnsList_post(){
        $user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userId']) || empty($apiData['data']['userId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $response = $this->User_Job_Question_Answer_Model->get(['jobId' => $apiData['data']['jobId'], 'userId' => $apiData['data']['userId'], 'status' => '1', 'questionData' => true]);
        if(!empty($response)){
            $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getUserQuestionAnsListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data'] = $response;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
        } else {
            $this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "noQuestionAnswer", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
        }
        
    }

    public function requestJobImageVideo_post(){
        $user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['mediaType']) || !in_array($apiData['data']['mediaType'], array(1,2))){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("mediaTypeRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'getJobJobDetail'=>true,'status'=> [1,3]],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if($apiData['data']['mediaType'] == "1"){
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobDetailData->caregiverId;
            $notiData['model_id'] = (int)$jobDetailData->id;
            $notiData['jobName'] = $jobDetailData->jobName;
            $this->Common_Model->backroundCall('sendJobImageRequest', $notiData);
            // ./ Set notification
        }elseif($apiData['data']['mediaType'] == "2"){
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobDetailData->caregiverId;
            $notiData['model_id'] = (int)$jobDetailData->id;
            $notiData['jobName'] = $jobDetailData->jobName;
            $this->Common_Model->backroundCall('sendJobVideoRequest', $notiData);
            // ./ Set notification
        }
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification( "sendJobMediaRequestSuccess", $apiData['data']['langType'] );
        return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
        //$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSendJobMediaRequest", $apiData['data']['langType'] );
    }

    public function setOngoingJobReview_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );
		if (!isset( $apiData['data']['rating']) || empty($apiData['data']['rating'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ratingRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if (!isset( $apiData['data']['feedback'] ) || empty( $apiData['data']['feedback'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "feedbackRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
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
        
        $data = [];
        $data['userId'] = $user->id;
        $data['jobDetailId'] = $apiData['data']['userJobDetailId'];

		$appFeedbackData = $this->User_Ongoing_Job_Review_Model->get($data,true);

        $data['rating'] = $apiData['data']['rating'];
        $data['feedback'] = $apiData['data']['feedback'];
		if ( !empty($appFeedbackData) ) {
			$data['status'] = "1";
			$appFeedbackId = $this->User_Ongoing_Job_Review_Model->setData( $data, $appFeedbackData->id );
		} else {
			$appFeedbackId = $this->User_Ongoing_Job_Review_Model->setData( $data );
		}

		if ( !empty($appFeedbackId) ) {
			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "saveReviewSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSaveReview", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

    public function acceptSubstituteJobRequestByUser_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['substituteRequestId']) || empty($apiData['data']['substituteRequestId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existSubstituteRequestData = $this->User_Job_Substitute_Request_Model->get(['id'=>$apiData['data']['substituteRequestId'],'send_user'=>$user->id,'userStatus'=>'0','status'=>1],true);
        if (empty($existSubstituteRequestData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Model->get(['id'=>$existSubstituteRequestData->jobId,'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if($existSubstituteRequestData->caregiverStatus == "1"){
            $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData(['userStatus'=>1,'status'=>2],$apiData['data']['substituteRequestId']);
            $jobApplyId = $this->User_Job_Apply_Model->setData(['userId'=>$existSubstituteRequestData->send_to],$existSubstituteRequestData->userJobApplyId);
        }else{
            $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData(['userStatus'=>1],$apiData['data']['substituteRequestId']);
        }
        
        if (!empty($jobSubstituteRequestId)) {
            // Set notification for substitute job by user
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existSubstituteRequestData->send_from;
            $notiData['model_id'] = (int)$existSubstituteRequestData->jobId;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestAcceptByUser', $notiData);
            // ./ Set notification for substitute job by user
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobRequestAcceptSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToAcceptSubstituteJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function rejectSubstituteJobRequestByUser_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
    
        if (!isset($apiData['data']['substituteRequestId']) || empty($apiData['data']['substituteRequestId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
   
        $existSubstituteRequestData = $this->User_Job_Substitute_Request_Model->get(['id'=>$apiData['data']['substituteRequestId'],'send_user'=>$user->id,'userStatus'=>'0','status'=>1],true);
        if (empty($existSubstituteRequestData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteRequestDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existJobData = $this->User_Job_Model->get(['id'=>$existSubstituteRequestData->jobId,'isHire'=>1,'status'=>1],true);
        if (empty($existJobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobSubstituteRequestId = $this->User_Job_Substitute_Request_Model->setData(['status'=>2,'userStatus'=>2],$apiData['data']['substituteRequestId']);
        
        if (!empty($jobSubstituteRequestId)) {
            // Set notification for substitute job by user
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $existSubstituteRequestData->send_from;
            $notiData['model_id'] = (int)$existSubstituteRequestData->jobId;
            $notiData['jobName'] = $existJobData->name;
            $this->Common_Model->backroundCall('caregiverSubstituteJobRequestRejectByUser', $notiData);
            // ./ Set notification for substitute job by user
            
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("substituteJobRequestRejectSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRejectSubstituteJobRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getUserSubstituteJobRequestList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
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
        $data['userStatus'] = 0;
        $data['send_user'] = $user->id;
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

    public function sendJobExtraHoursRequest_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
		if (!isset( $apiData['data']['startTime']) || empty($apiData['data']['startTime'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "startTimeRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if (!isset( $apiData['data']['endTime'] ) || empty( $apiData['data']['endTime'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "endTimeRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if (!isset($apiData['data']['userJobDetailId']) || empty($apiData['data']['userJobDetailId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userJobDetailIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $jobDetailData = $this->User_Job_Detail_Model->get(['id'=>$apiData['data']['userJobDetailId'],'getJobJobDetail'=>true,'status'=> [1,3]],true);
        if (empty($jobDetailData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
        
        $enddatetime = new DateTime(null, new DateTimeZone( getenv('SYSTEMTIMEZON') ));
        $enddatetime->setTimezone(new DateTimeZone($myUserTimeZone));
        $enddatetime->setTimestamp($jobDetailData->endTime);

        $requeststartdatetime = new DateTime($enddatetime->format('Y-m-d').' '.$apiData['data']['startTime'], new DateTimeZone( $myUserTimeZone ));
        $requeststartdatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));
        
        $requestenddatetime = new DateTime($enddatetime->format('Y-m-d').' '.$apiData['data']['endTime'], new DateTimeZone( $myUserTimeZone ));
        $requestenddatetime->setTimezone(new DateTimeZone(getenv('SYSTEMTIMEZON')));

        if($enddatetime->format('U') != $requeststartdatetime->format('U')){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobRequestStartTimeAndJobEndTimeNotMatch", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = [];
        $data['requestStartTime'] = $requeststartdatetime->format('U');
        $data['requestEndTime'] = $requestenddatetime->format('U');
        $data['requestTimeStatus'] = 1;

        $requestId = $this->User_Job_Detail_Model->setData($data,$jobDetailData->id);
		if ( !empty($requestId) ) {
            $hours = gmdate("H:i",$requestenddatetime->format('U') - $requeststartdatetime->format('U'));

            // Set notification for extra job time request by user
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $jobDetailData->caregiverId;
            $notiData['model_id'] = (int)$jobDetailData->id;
            $notiData['jobName'] = $jobDetailData->jobName;
            $notiData['hours'] = $hours;
            $this->Common_Model->backroundCall('sendExtraTimeRequestOfCurrentJobByUser', $notiData);
            // ./ Set notification for extra job time request by user

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "extraJobRequestTimeSendSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSendExtraTimeJobRequest", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

    public function awardJobRequest_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset( $apiData['data']['caregiverId'] ) || empty( $apiData['data']['caregiverId'])) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "caregiverIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$jobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'userId'=>$user->id,'status' => '1'],true);
		if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $data = [];
        $data['jobId'] = $apiData['data']['jobId'];
        $data['userId'] = $apiData['data']['caregiverId'];

        $existData = $this->User_Job_Award_Model->get($data,true);
        if(!empty($existData)){
            $requestId = $this->User_Job_Award_Model->setData($data,$existData->id);
        }else{
            $requestId = $this->User_Job_Award_Model->setData($data);
        }
		if ( !empty($requestId) ) {
            // Set notification for award job request by user
            $notiData = [];
            $notiData['send_from'] = $user->id;
            $notiData['send_to'] = $apiData['data']['caregiverId'];
            $notiData['model_id'] = (int)$apiData['data']['jobId'];
            $notiData['jobName'] = $jobData->name;
            $this->Common_Model->backroundCall('sendAwardJobRequestByUser', $notiData);
            // ./ Set notification for award job request by user

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "awardJobRequestSendSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSendAwardJobRequest", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

    public function awardJobSavePaymentData_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if ($user->role != '2') {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youAreNotAUser", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['jobId']) || empty($apiData['data']['jobId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['userCardId']) || empty($apiData['data']['userCardId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userCardIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

		$jobData = $this->User_Job_Model->get(['id'=>$apiData['data']['jobId'],'userId'=>$user->id,'status' => '1'],true);
		if (empty($jobData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $jobId = $this->User_Job_Model->setData(['userCardId'=>$apiData['data']['userCardId']],$apiData['data']['jobId']);
		if ( !empty($jobId) ) {
            $this->Notification_Model->removeData(['send_to'=>$user->id,'model'=>'acceptAwardJobRequestByCaregiver','model_id'=>$apiData['data']['jobId']]);
            $this->User_Job_Award_Model->setData(['status'=>4,'jobIds'=>$apiData['data']['jobId']]);
            $in48Hours = $this->User_Job_Detail_Model->get(['jobId'=>$apiData['data']['jobId'],'getDatabefore48HoursOfStartJob'=>true,'userPaymentStatus'=>'0','status'=>1]);
            if(!empty($in48Hours)){
                $this->Background_Model->collectPaymentUseApi($apiData['data']['jobId']);
            }
           $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "saveAwardJobPaymentDataSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status'] = "0";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "failToSaveAwardJobPaymentData", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}
}
