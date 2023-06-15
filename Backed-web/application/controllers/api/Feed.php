<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Feed extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('User_Feed_Model');
        $this->load->model('User_Feed_Media_Model');
        $this->load->model('User_Feed_Like_Model');
        $this->load->model('User_Feed_Report');
        $this->load->model('User_Feed_Comment_Model');
        $this->load->model('User_Feed_Comment_Report');
    }

    public function saveUserFeed_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['description']) || empty($apiData['data']['description'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedDescriptionRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $data = array();
        $data['userId'] = $user->id;
        $data['description'] = $apiData['data']['description'];
        if (isset($apiData['data']['userFeedId']) && !empty($apiData['data']['userFeedId'])) {
            $feedId = $this->User_Feed_Model->setData($data,$apiData['data']['userFeedId']);    
        }else{
            $feedId = $this->User_Feed_Model->setData($data);
        }
        
        if (!empty($feedId)) {
            // Save Media
            $this->User_Feed_Media_Model->setData(['userFeedIds' => $feedId, 'status' => 2]);
            if (isset($apiData['data']['media']) && !empty($apiData['data']['media'])) {
                $imgExtn = array('jpeg', 'gif', 'png', 'jpg', 'JPG', 'PNG', 'GIF', 'JPEG');
                foreach ($apiData['data']['media'] as $key => $media) {
                    if (!isset($media['mediaName']) && empty($media['mediaName'])) {
                        continue;
                    }
                    $tmp = [];
                    $existMedialData = $this->User_Feed_Media_Model->get(['mediaName' => $media['mediaName'], 'userFeedId' => $feedId], true);
                    if (!empty($existMedialData)) {
                        $tmp['userFeedId'] = $feedId;
                        $tmp['status'] = 1;
                        $this->User_Feed_Media_Model->setData($tmp, $existMedialData->id);
                    } else {
                        $tmp['userFeedId'] = $feedId;
                        $tmp['mediaName'] = $media['mediaName'];
                        $extention = pathinfo($media['mediaName'], PATHINFO_EXTENSION);
                        if (!in_array($extention, $imgExtn)) {
                            $tmp['isVideo'] = 1;
                            $tmp['videoImage'] = (isset($media['videoImage']) ? $media['videoImage'] : "");
                        }
                        $this->User_Feed_Media_Model->setData($tmp);
                    }
                }
            }
            // ./ Save Media
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveFeedDataSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveFeedData", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getUserFeedList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

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
        $data['getLikeCount'] = true;
        $data['checkIsLikeOrNot'] = $user->id;
        $data['getCommentCount'] = true;
        $data['status'] = "1";
        $data['orderby'] = "createdDate";
        $data['orderstate'] = "DESC";
		$totalData = $this->User_Feed_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Feed_Model->get($data);
		
        if (!empty( $responseData)) {
            //$myUserTimeZone = (!empty($user->timezone) ? $user->timezone : getenv('SYSTEMTIMEZON'));
            foreach( $responseData as $value ){
                /*$startDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
                $startDateTime->setTimezone(new DateTimeZone($myUserTimeZone));
                $startDateTime->setTimestamp($value->starTimestamp);
                $value->startDateTime = $startDateTime->format('d M Y  h:i A');*/
                $value->createdTime = $this->Common_Model->get_time_ago($value->createdDate);
                $value->media = $this->User_Feed_Media_Model->get(['apiResponse'=>true,'userFeedId'=>$value->userFeedId,'orderby'=>'id','status'=>1,'orderstate'=>'ASC']);
            }

			$this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getUserFeedSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "userFeedNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function likeUnlikeFeed_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (!isset($apiData['data']['userFeedId']) || empty($apiData['data']['userFeedId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $feedExistData = $this->User_Feed_Like_Model->get(['userId'=>$user->id,'userFeedId'=>$apiData['data']['userFeedId']],true);
        if(!empty($feedExistData)){
            if($feedExistData->status == 1){
                $set = $this->User_Feed_Like_Model->setData(['status'=>2],$feedExistData->id);
                $successMsg = "feedUnlikeSuccess";
                $failMsg = "failToUnlikeFeed";
            }else{
                $set = $this->User_Feed_Like_Model->setData(['status'=>1],$feedExistData->id);
                $successMsg = "feedLikeSuccess";
                $failMsg = "failToLikeFeed";
            }
        }else{
            $set = $this->User_Feed_Like_Model->setData(['userId'=>$user->id,'userFeedId'=>$apiData['data']['userFeedId']]);
            $successMsg = "feedLikeSuccess";
            $failMsg = "failToLikeFeed";
        }

        if (!empty($set)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification($successMsg, $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification($failMsg, $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function feedReport_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (!isset($apiData['data']['userFeedId']) || empty($apiData['data']['userFeedId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['message']) || empty($apiData['data']['message'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedMessageRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $feedData = $this->User_Feed_Model->get(['id'=>$apiData['data']['userFeedId'],'status'=> 1],true);
        if (empty($feedData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data['userId'] = $user->id;
        $data['userFeedId'] = $apiData['data']['userFeedId'];
        $data['message'] = $apiData['data']['message'];
        $feedReportId = $this->User_Feed_Report->setData($data);
        
        if (!empty($feedReportId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("sendFeedReportSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSendFeedReport", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function feedCommentReport_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (!isset($apiData['data']['feedCommentId']) || empty($apiData['data']['feedCommentId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedCommentIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if (!isset($apiData['data']['message']) || empty($apiData['data']['message'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedMessageRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $feedCommentData = $this->User_Feed_Comment_Model->get(['id'=>$apiData['data']['feedCommentId'],'status'=> 1],true);
        if (empty($feedCommentData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedCommentNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $feedData = $this->User_Feed_Model->get(['id'=>$feedCommentData->userFeedId,'status'=> 1],true);
        if (empty($feedData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedDetailNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $data = array();
        $data['userId'] = $user->id;
        $data['userFeedId'] = $feedData->id;
        $data['userFeedCommentId'] = $apiData['data']['feedCommentId'];
        $data['message'] = $apiData['data']['message'];
        $feedCommentReportId = $this->User_Feed_Comment_Report->setData($data);
        
        if (!empty($feedCommentReportId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("sendFeedCommentReportSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSendFeedCommentReport", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getFeedLikeUserList_post() {
		$user = $this->checkUserRequest();
		$apiData = json_decode( file_get_contents( 'php://input' ), TRUE );

        if (!isset($apiData['data']['userFeedId']) || empty($apiData['data']['userFeedId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedIdRequired", $apiData['data']['langType']);
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
        $data['userFeedId'] = $apiData['data']['userFeedId'];
        $data['feedToId'] = true;
        $data['orderby'] = "createdDate";
        $data['orderstate'] = "DESC";
		$totalData = $this->User_Feed_Like_Model->get($data, false, true);
        $data['limit'] = $limit;
        $data['offset'] = $offset;
		$responseData = $this->User_Feed_Like_Model->get($data);
		
        if (!empty( $responseData)) {
            $this->apiResponse['status'] = "1";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( "getFeedUserLikeListSuccess", $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			$this->apiResponse['data'] = $responseData;
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		} else {
			$this->apiResponse['status'] = "6";
			$this->apiResponse['message'] = $this->Common_Model->GetNotification( ($offset > 0 ? "allcatchedUp" : "feedUserLikeListNotFound" ), $apiData['data']['langType'] );
			$this->apiResponse['totalPages'] = ceil( $totalData / $limit ) . "";
			return $this->response( $this->apiResponse, REST_Controller::HTTP_OK );
		}
	}

    public function feedComment_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (!isset($apiData['data']['userFeedId']) || empty($apiData['data']['userFeedId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedFeedIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if (!isset($apiData['data']['comment']) || empty($apiData['data']['comment'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedCommentRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $getFeedData = $this->User_Feed_Model->get(['id' => $apiData['data']['userFeedId'], 'status' => '1'], true);
        if(empty($getFeedData)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("somthingWantsWrong", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $data = array();
        $data['userId'] = $user->id;
        $data['userFeedId'] = $apiData['data']['userFeedId'];
        $data['comment'] = $apiData['data']['comment'];
        $data['status'] = '1';
        // print_r($data);die;
        $feedCommentId = $this->User_Feed_Comment_Model->setData($data);
        
        if (!empty($feedCommentId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("sendFeedCommentSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSendFeedComment", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getFeedCommentList_post() {
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
        
        if (!isset($apiData['data']['userFeedId']) || empty($apiData['data']['userFeedId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedFeedIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $data['userFeedId'] = $apiData['data']['userFeedId'];
        $data['status'] = '1';
        $data['limit'] = $limit;
        $data['timeFormate'] = true;
        $data['getUserData'] = true;
        $data['orderby'] = 'id';
        $data['orderstate'] = 'ASC';
        $response = $this->User_Feed_Comment_Model->get($data);
        $totalData = $this->User_Feed_Comment_Model->get(['userFeedId' => $apiData['data']['userFeedId'],'status'=>'1','limit'=>$limit,'offset'=>$offset],false,true);
        
        if (!empty($response)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("sendFeedCommentSuccess", $apiData['data']['langType']);
            $this->apiResponse['totalPages'] = ceil($totalData / $limit) . "";
            $this->apiResponse['data'] = $response;

        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("noSendFeedComment", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function deleteFeedComment_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        if (!isset($apiData['data']['commentId']) || empty($apiData['data']['commentId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("feedCommentIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $getComment = $this->User_Feed_Comment_Model->get(['id' => $apiData['data']['commentId'], 'status' => '1'], true);
        if(empty($getComment)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("somthingWantsWrong", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $setData = $this->User_Feed_Comment_Model->setData(['status'=> '2'], $apiData['data']['commentId']);

        if (!empty($setData)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("deleteCommentSuccess", $apiData['data']['langType']);
        } else {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("somthingWantsWrong", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function deleteFeed_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if (!isset($apiData['data']['feedId']) || empty($apiData['data']['feedId'])) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("deleteFeedIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $getData = $this->User_Feed_Model->get(['userId'=>$user->id, 'id'=>$apiData['data']['feedId'], 'status'=>1], TRUE);
        if (empty($getData)) {
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("feedNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $this->User_Feed_Model->setData(['status'=>2], $getData->id);

        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common->GetNotification("deleteFeedSuccess", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
}
