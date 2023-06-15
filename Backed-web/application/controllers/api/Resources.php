<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Resources extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('Users_Model', 'User');
        $this->load->model('Resources_Model','Resources');
        $this->load->model('Resources_Category_Model','Resources_Category');
    }

    public function getResource_post() {
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

        $search = (isset($apiData['data']['search']) ? $apiData['data']['search'] : "");
        $categoryId = (isset($apiData['data']['categoryId']) ? $apiData['data']['categoryId'] : "");
        $response = $this->Resources->get(['apiResponse'=>true,'search'=>$search,'categoryId'=>$categoryId,'status'=>'1','limit'=>$limit,'offset'=>$offset]);
        $totalData = $this->Resources->get(['status'=>'1','categoryId'=>$categoryId,'search'=>$search], false, true);
        if (!empty($response)) {
            foreach($response as $value){
                $value->timing = $this->Common_Model->get_time_ago($value->createdDate);
            }
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getBlogSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
            $this->apiResponse['totalPages'] = ceil($totalData / $limit) . "";
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification(($offset > 0 ? 'allcatchedUp' : "blogNotFound"), $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getResourceDetail_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        if (!isset($apiData['data']['blogId']) || empty($apiData['data']['blogId'])) {
            $this->apiResponse['message'] = $this->Common->GetNotification("blogIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $response = $this->Resources->get(['apiResponse'=>true,'status'=>'1','id'=>$apiData['data']['blogId']],true);
        if (!empty($response)) {
            $response->timing = $this->Common_Model->get_time_ago($response->createdDate);
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getBlogDetailSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("blogDetailNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
}
