<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Common extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model');
        $this->load->model('Hear_About_Us_Model');
        $this->load->model('Licence_Type_Model');
        $this->load->model('Job_Category_Model');
		$this->load->model('Job_Sub_Category_Model');
        $this->load->model('Insurance_Type_Model');
        $this->load->model('Work_Speciality_Model');
        $this->load->model('Work_Method_Of_Transportation_Model');
        $this->load->model('Work_Disabilities_Willing_Type_Model');
        $this->load->model('Loved_Disabilities_Type_Model');
        $this->load->model('Loved_Category_Model');
        $this->load->model('Loved_Specialities_Model');
        $this->load->model('Cms_Model');
        $this->load->model('Faq_Model');
        $this->load->model('App_User_Feedback_Model');
        $this->load->model('Ticket_Model');
        $this->load->model('Background_Model');
        $this->load->model('Notification_Model');
        $this->load->model('Chat_Model');
    }

    public function mediaUpload_post() {
        $this->checkGuestUserRequest();
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
            $image_type = $this->input->post('imageType');
            $upload_path = getenv('UPLOADPATH');
            $allowed_types = array(".jpg", ".gif", ".png", ".jpeg", ".mp4", ".m4a", ".MOV", ".MPEG-4", ".mpeg-4", ".mov", ".pdf", ".doc", ".docx", ".txt", ".PDF", ".DOC", ".DOCX", ".TXT");
            foreach ($_FILES as $key => $file) {
                if (is_array($_FILES[$key]["name"])) {
                    foreach ($_FILES[$key]["name"] as $_key => $value) {
                        $_FILES['file']['name'] = $_FILES[$key]['name'][$_key];
                        $_FILES['file']['type'] = $_FILES[$key]['type'][$_key];
                        $_FILES['file']['tmp_name'] = $_FILES[$key]['tmp_name'][$_key];
                        $_FILES['file']['error'] = $_FILES[$key]['error'][$_key];
                        $_FILES['file']['size'] = $_FILES[$key]['size'][$_key];

                        $fileExt = $this->Common_Model->getFileExtension($_FILES[$key]["name"][$_key]);
                        if (in_array(strtolower($fileExt), $allowed_types)) {
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
                    if (in_array(strtolower($fileExt), $allowed_types)) {
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
            $this->apiResponse['status'] = "1";
            $this->apiResponse['data'] = $finalData;
            $this->apiResponse['base_url'] = base_url(getenv('UPLOAD_URL'));
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("mediaUploaded", 1);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failtoUploadMedia", 1);
        }
        $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getCommonData_post() {
        $user = $this->checkGuestUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $data = array();
        $data['hearAboutUs'] = $this->Hear_About_Us_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['licenceType'] = $this->Licence_Type_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['insuranceType'] = $this->Insurance_Type_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['workSpeciality'] = $this->Work_Speciality_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['workMethodOfTransportation'] = $this->Work_Method_Of_Transportation_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['workDisabilitiesWillingType'] = $this->Work_Disabilities_Willing_Type_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['lovedDisabilitiesType'] = $this->Loved_Disabilities_Type_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['lovedCategory'] = $this->Loved_Category_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $data['lovedSpecialities'] = $this->Loved_Specialities_Model->get(['apiResponse'=>true,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("getCommonDataSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $data;
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getJobCategoryList_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        $search = (isset($apiData['data']['search']) && !empty($apiData['data']['search']) ? $apiData['data']['search'] : "");
        $data = $this->Job_Category_Model->get(['apiResponse'=>true,'search'=>$search,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
        if (!empty($data)) {
			foreach( $data as $value ){
				$value->subCategory = $this->Job_Sub_Category_Model->get(['apiResponse'=>true,'jobCategoryId'=>$value->jobCategoryId,'status'=>1,'orderby'=>'id','orderstate'=>'ASC']);
			}
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getJobCategoryListSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $data;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("jobCategoryDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function faq_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		if ( !isset( $apiData['data']['type'] ) || empty( $apiData['data']['type'] )) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "typeRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit		 = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}

		$search = (isset( $apiData['data']['search'] ) ? $apiData['data']['search'] : "");
		$getData = $this->Faq_Model->get( [ 'type' =>[3, $apiData['data']['type']], 'search' => $search, 'status' => '1', 'limit' => $limit, 'offset' => $offset ] );		
		
		$totalData	 = $this->Faq_Model->get( [ 'type' => [3, $apiData['data']['type']], 'search' => $search, 'status' => '1' ], false, true );
		if ( !empty( $getData ) ) {
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "faqlistSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['activeSupportTicketCount'] = $this->Ticket_Model->get(['userId'=>$user->id,'status'=>1],false,true);
			$this->apiResponse['data']		 = $getData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( ($offset > 0 ? 'allcatchedUp' : "faqDataNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['activeSupportTicketCount'] = $this->Ticket_Model->get(['userId'=>$user->id,'status'=>1],false,true);
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

	public function faqDetails_post() {
		$user	 = $this->checkGuestUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		if ( ! isset( $apiData['data']['faqId'] ) || empty( $apiData['data']['faqId'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "faqIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$getData = $this->Faq_Model->get( [ 'status' => '1', 'id' => $apiData['data']['faqId'] ], TRUE );
		if ( ! empty( $getData ) ) {
			/* if (isset($getData->description)) {
			  $getData->description = "<style>*,p{font-size:15px !important;}</style>" . $getData->description;
			  } */
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "getFaqDetailSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data']		 = $getData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "faqDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

	public function setAppFeedback_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );
		if ( ! isset( $apiData['data']['rating'] ) || empty( $apiData['data']['rating'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ratingRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if ( ! isset( $apiData['data']['feedback'] ) || empty( $apiData['data']['feedback'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "feedbackRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
		$data				 = [];
		$data['userId']		 = $user->id;
		$data['rating']		 = $apiData['data']['rating'];
		$data['feedback']	 = $apiData['data']['feedback'];

		$appFeedbackId	 = "";
		$appFeedbackData = $this->App_User_Feedback_Model->get( [ 'userId' => $user->id ], true );
		if ( ! empty( $appFeedbackData ) ) {
			$data['status']	 = "1";
			$appFeedbackId	 = $this->App_User_Feedback_Model->setData( $data, $appFeedbackData->id );
		} else {
			$appFeedbackId = $this->App_User_Feedback_Model->setData( $data );
		}

		if ( ! empty( $appFeedbackId ) ) {
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "saveAppFeedbackSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status']	 = "0";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "failToSaveAppFeedback", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function getMyAppFeedback_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		$appFeedbackData = $this->App_User_Feedback_Model->get( [ 'userId' => $user->id, 'status' => 1 ], true );

		if ( ! empty( $appFeedbackData ) ) {
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "getMyAppFeedbackSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data']		 = $appFeedbackData;
		} else {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "myAppFeedbackNotFound", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function getCMS_post() {
		$user	 = $this->checkGuestUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );
		if ( ! isset( $apiData['data']['pageId'] ) || empty( $apiData['data']['pageId'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "pageIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$cms = $this->Cms_Model->get( [ 'status' => 1, 'key' => $apiData['data']['pageId'] ], TRUE );
		if ( ! empty( $cms ) ) {
			/* if (isset($cms->description)) {
			  $cms->description = "<style>*,p{font-size:15px !important;}</style>" . $cms->description;
			  } */
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "pageGetSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data']		 = $cms;
		} else {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "pageDataNotFound", $apiData['data']['langType'] );
		}
		return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function setTicket_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		if ( ! isset( $apiData['data']['title'] ) || empty( $apiData['data']['title'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ticketTitleRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		if ( ! isset( $apiData['data']['description'] ) || empty( $apiData['data']['description'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ticketDescRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$titcketData				 = array();
		$titcketData['userId']		 = $user->id;
		$titcketData['title']		 = $apiData['data']['title'];
		$titcketData['description']	 = $apiData['data']['description'];
		$titcketData['priority']	 = "0";

		$titcketId = $this->Ticket_Model->setData( $titcketData );

		if ( ! empty( $titcketId ) ) {
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketSavedSuccess", $apiData['data']['langType'] );
		} else {
			$this->apiResponse['status']	 = "0";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketSaveFail", $apiData['data']['langType'] );
		}

		$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function getTicket_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		$page_number = (isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : 1;
		$limit		 = (isset( $apiData['data']['limit'] ) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
		if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] == 1 ) {
			$offset = 0;
		} else {
			if ( isset( $apiData['data']['page'] ) && $apiData['data']['page'] != '1' ) {
				$offset = ($page_number * $limit) - $limit;
			} else {
				$offset = 0;
			}
		}

		$titcketData = array();
		$titcketData = $this->Ticket_Model->get( [ 'userId' => $user->id, 'status' => [ 0, 1 ], "formatedData" => $user->timezone, 'limit' => $limit, 'offset' => $offset ] );
		$totalData	 = $this->Ticket_Model->get( [ 'userId' => $user->id, 'status' => [ 0, 1 ] ], false, true );

		if ( ! empty( $titcketData ) ) {
			foreach ( $titcketData as $value ) {
				$value->lastReplay	 = "";
				$value->lastMsgTime	 = "";
				$lastreplay			 = $this->Ticket_Model->getTicketReply( [ 'ticketId' => $value->id, 'status' => 1 ], true );
				if ( ! empty( $lastreplay ) ) {
					if ( $lastreplay->replyType != 1 ) {
						$value->lastReplay = "Image";
					} else {
						$value->lastReplay = $lastreplay->description;
					}
					$value->lastMsgTime = $this->Common_Model->get_time_ago( $lastreplay->createdDate );
				}
			}
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "getTicketDataSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data']		 = $titcketData;
		} else {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( ($offset > 0 ? 'allcatchedUp' : "ticketDataNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
		}

		$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function getTicketDetail_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		if ( ! isset( $apiData['data']['ticketId'] ) || empty( $apiData['data']['ticketId'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ticketIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$titcketData = $this->Ticket_Model->get( [ 'userId' => $user->id, 'id' => $apiData['data']['ticketId'], "formatedData" => $user->timezone, 'status' => [ 0, 1 ] ], TRUE );
		if ( empty( $titcketData ) ) {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$this->apiResponse['status']	 = "1";
		$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "getTicketDetailSuccess", $apiData['data']['langType'] );
		$this->apiResponse['data']		 = $titcketData;

		$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}

	public function reopenTicket_post() {
		$user	 = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

		if ( ! isset( $apiData['data']['ticketId'] ) || empty( $apiData['data']['ticketId'] ) ) {
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "ticketIdRequired", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$titcketData = $this->Ticket_Model->get( [ 'userId' => $user->id, 'id' => $apiData['data']['ticketId'], 'status' => 0 ], TRUE );
		if ( empty( $titcketData ) ) {
			$this->apiResponse['status']	 = "6";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketDetailNotFound", $apiData['data']['langType'] );
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}

		$titcketId = $this->Ticket_Model->setData( [ 'status' => 1, 'reopenDate' => time() ], $apiData['data']['ticketId'] );

		if ( ! empty( $titcketId ) ) {
			$titcketData = $this->Ticket_Model->get( [ 'userId' => $user->id, 'id' => $apiData['data']['ticketId'], 'status' => [ 0, 1 ] ], TRUE );

			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketReopenSuccess", $apiData['data']['langType'] );
			$this->apiResponse['data']		 = $titcketData;
		} else {
			$this->apiResponse['status']	 = "0";
			$this->apiResponse['message']	 = $this->Common_Model->GetNotification( "ticketReopenFail", $apiData['data']['langType'] );
		}
		$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}
	
    public function getNotificationsList_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $page_number = (isset($apiData['data']['page']) && $apiData['data']['page'] != '') ? $apiData['data']['page'] : '';
        $limit = (isset($apiData['data']['limit']) && $apiData['data']['limit'] != '') ? $apiData['data']['limit'] : 10;
        if (isset($apiData['data']['page']) && $apiData['data']['page'] == 1) {
            $offset = 0;
        } else {
            if (isset($apiData['data']['page']) && $apiData['data']['page'] != '1') {
                $offset = ($page_number * $limit) - $limit;
            } else {
                $offset = 0;
            }
        }

        $notiData = $this->Notification_Model->get(['userData'=>true,'send_to'=>$user->id,'status'=>[0,1],'limit'=> $limit,'offset'=>$offset]);
        $totalData = $this->Notification_Model->get(['userData'=>true,'send_to'=>$user->id,'status'=>[0,1]],false,true);
        $responseData = array();
        if(!empty($notiData)){
            foreach($notiData as $value){
                if($value->status == 1){
                    $this->Notification_Model->setData(['status'=>0],$value->id);
                }
                $value->time = $this->Common_Model->get_time_ago($value->createdDate);
                $responseData[] = $value;
            }
        }
        if(!empty($responseData)){
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getNotificationListSuccess", $apiData['data']['langType']);
            $this->apiResponse['total_page'] = ceil($totalData/$limit)."";
            $this->apiResponse['data'] = $responseData;
        }else{
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification(($offset > 0 ? 'allcatchedUp' : "notificationListNotFound"), $apiData['data']['langType']);
            $this->apiResponse['total_page'] = ceil($totalData/$limit)."";
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getUnreadNotificationsCount_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        $this->apiResponse['status'] = "1";
        $this->apiResponse['notificationCount'] = $this->Notification_Model->get(['send_to'=>$user->id,'status'=>1],false,true);
        $this->apiResponse['chatCount'] = $this->Chat_Model->getMessageStatus(['userId'=>$user->id,'status'=>[1,2]],false,true);
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("getUnreadNotificationCount", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

	public function testNotification_post() {
		$this->checkGuestUserRequest();
		$apiData		 = json_decode( file_get_contents( 'php://input' ), TRUE );
		$notification	 = array(
			"title"	 => "THIS IS TITLE",
			"body"	 => "THIS IS NOTIFICATION BODY",
			"badge"	 => intval( 0 ),
			"sound"	 => "default"
		);
		if ( isset( $apiData['data']['title'] ) && ! empty( $apiData['data']['title'] ) ) {
			$notification["title"] = $apiData['data']['title'];
		}
		if ( isset( $apiData['data']['body'] ) && ! empty( $apiData['data']['body'] ) ) {
			$notification["body"] = $apiData['data']['body'];
		}
		if ( isset( $apiData['data']['deviceToken'] ) && ! empty( $apiData['data']['deviceToken'] ) ) {
			$extraData						 = array(
				"category"		 => "transactionSuccessForJobPayment",
				"messageData"	 => array( 'send_from' => '8', 'send_to' => '8', 'model_id' => '183', 'amount' => '$125.00', 'jobName' => '16-02-2022 Job', 'model' => 'transactionSuccessForJobPayment', 'title' => 'Job Payment', 'desc' => '$125.00 has been deducted successfully for 16-02-2022 Job job payment' ),
				"unread"		 => (string) 0
			);
			$result							 = $this->Background_Model->testpushNotification( $apiData['data']['deviceToken'], $notification, $extraData, 0 );
			$this->apiResponse['status']	 = "1";
			$this->apiResponse['message']	 = $extraData;
			$this->apiResponse['data']		 = json_decode( $result );
			$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
		$this->apiResponse['status']	 = "0";
		$this->apiResponse['message']	 = "Fail to call";
		$this->response( $this->apiResponse, REST_Controller::HTTP_OK );
	}
}
