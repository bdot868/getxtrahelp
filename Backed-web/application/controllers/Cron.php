<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Cron extends MY_Controller {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('Background_Model');
        $this->load->model('Cms_Model');
        $this->load->model('Users_Model');
        $this->load->model('User_Job_Detail_Model');
        $this->load->model('User_Card_Model');
        $this->load->model('User_Transaction_Model');
    }
    
    public function index() {
        
    }

    /**
     * C001
     * Xtrahelpp – Take Job Payment
     * Xtrahelpp – User job take payment before 48 hours of start job.
     * Cron Timing - every 1 Hour
     */
    public function C001_1hour_take_job_advance_payment_from_user($jobId  = "") {
        $this->load->library('stripe');
        if(!empty($jobId)){
            $pendingPaymentData = $this->User_Job_Detail_Model->get(['jobId'=>$jobId,'getDatabefore48HoursOfStartJob'=>true,'userPaymentStatus'=>'0','status'=>1]);
        }else{
            $pendingPaymentData = $this->User_Job_Detail_Model->get(['getDatabefore48HoursOfStartJob'=>true,'userPaymentStatus'=>'0','status'=>1]);
        }
        //print_r($pendingPaymentData); die;
        if(!empty($pendingPaymentData)){
            foreach($pendingPaymentData as $value){
                if(!empty($value->userCardId)){
                    $startingHour = ($value->startTime - time())/3600;
                    $isCancel = 0;
                    if($startingHour < 24){
                        $isCancel = 1;
                    }

                    $minutes = floor(($value->endTime - $value->startTime) / 60);
                    $amount = ($value->price / 60);
                    $amount = round($amount * $minutes,2);
                    
                    $userCardData = $this->User_Card_Model->get(['userId'=>$value->userId,'id'=>$value->userCardId,'status'=>1],true);
                    if(empty($userCardData)){
                        if($isCancel == 1){
                            $this->User_Job_Detail_Model->setData(['status'=>'2'],$value->id);
                            // Send notification for cancel upcoming job
                            // Set notification
                            $notiData = [];
                            $notiData['send_from'] = $value->userId;
                            $notiData['send_to'] = $value->userId;
                            $notiData['model_id'] = (int)$value->id;
                            $notiData['jobName'] = $value->jobName;
                            $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForUser', $notiData);
                            // ./ Set notification

                            // Send notification for cancel upcoming job
                            // Set notification
                            $notiData = [];
                            $notiData['send_from'] = $value->userId;
                            $notiData['send_to'] = $value->caregiverId;
                            $notiData['model_id'] = (int)$value->id;
                            $notiData['jobName'] = $value->jobName;
                            $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForCaregiver', $notiData);
                            // ./ Set notification
                        }else{
                            // Send notification for transaction fail
                            // Set notification
                            $notiData = [];
                            $notiData['send_from'] = $value->userId;
                            $notiData['send_to'] = $value->userId;
                            $notiData['model_id'] = (int)$value->id;
                            $notiData['amount'] = '$'.number_format($amount,2);
                            $notiData['errorMsg'] = "Payment card not found which are you have added";
                            $this->Common_Model->backroundCall('transactionFailForJobPayment', $notiData);
                            // ./ Set notification
                        }
                        continue;
                    }
                    
                    $stripeChargeData['customer'] = $userCardData->customerId;
                    $stripeChargeData['source'] = $userCardData->cardId;
                    $stripeChargeData['amount'] = $amount * 100;
                    $stripeChargeData['description'] ="Job Payment, userId: #".$value->userId.", caregiverId: #".$value->caregiverId.", userCardId: #".$userCardData->id." , jobId: #".$value->jobId.", jobDetailId: ".$value->id;
                    $response = $this->stripe->addCharge($stripeChargeData);
                    error_log("\n\n -------------------------------------" . date('c'). " \n Request => ".json_encode($stripeChargeData) . " \n Response => ".json_encode($response,true), 3, FCPATH.'worker/jobPayment-'.date('d-m-Y').'.txt');
                    if(!empty($response)){
                        if(isset($response['error'])){ 
                            if($isCancel == 1){
                                $this->User_Job_Detail_Model->setData(['status'=>'2'],$value->id);
                                // Send notification for cancel upcoming job
                                // Set notification
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->userId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['jobName'] = $value->jobName;
                                $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForUser', $notiData);
                                // ./ Set notification
    
                                // Send notification for cancel upcoming job
                                // Set notification
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->caregiverId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['jobName'] = $value->jobName;
                                $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForCaregiver', $notiData);
                                // ./ Set notification
                            }else{
                                // Send notification for transaction fail
                                // Set notification 
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->userId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['amount'] = '$'.number_format($amount,2);
                                $notiData['errorMsg'] = $response['error'];
                                $this->Common_Model->backroundCall('transactionFailForJobPayment', $notiData);
                                // ./ Set notification
                            }
                            continue;
                        }elseif(!isset($response['id']) || $response['id']==""){ 
                            if($isCancel == 1){
                                $this->User_Job_Detail_Model->setData(['status'=>'2'],$value->id);
                                // Send notification for cancel upcoming job
                                // Set notification
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->userId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['jobName'] = $value->jobName;
                                $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForUser', $notiData);
                                // ./ Set notification
    
                                // Send notification for cancel upcoming job
                                // Set notification
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->caregiverId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['jobName'] = $value->jobName;
                                $this->Common_Model->backroundCall('cancelUpcomingJobByAutoSystemForCaregiver', $notiData);
                                // ./ Set notification
                            }else{
                                // Send notification for transaction fail
                                // Set notification 
                                $notiData = [];
                                $notiData['send_from'] = $value->userId;
                                $notiData['send_to'] = $value->userId;
                                $notiData['model_id'] = (int)$value->id;
                                $notiData['amount'] = '$'.number_format($amount,2);
                                $notiData['errorMsg'] = "Something went wrong on payment transactions";
                                $this->Common_Model->backroundCall('transactionFailForJobPayment', $notiData);
                                // ./ Set notification
                            }
                            continue;
                        }else{
                            $this->User_Job_Detail_Model->setData(['userPaymentStatus'=>'1'],$value->id);
                            // For user transaction record
                            $transactionData = array();
                            $transactionData['userId'] = $value->userId;
                            $transactionData['userIdTo'] = $value->caregiverId;
                            $transactionData['cardId'] = $userCardData->id;
                            $transactionData['userJobId'] = $value->jobId;
                            $transactionData['userJobDetailId'] = $value->id;
                            $transactionData['stripeTransactionId'] = $response['id'];
                            $transactionData['stripeTranJson'] = json_encode($response);
                            $transactionData['amount'] = $amount;
                            $transactionData['type'] = 2; // Debit amount
                            $transactionData['payType'] = 1; // Payment Pay For Job 
                            $transactionData['tranType'] = 2; //Stripe Transaction
                            $transactionData['status'] = 1; 
                            $transactionData['createdDate'] = $response['created'];
                            $this->User_Transaction_Model->setData($transactionData);
                            // // ./ Set notification
                         
                            // Send notification for transaction success
                            // Set notification 
                            $notiData = [];
                            $notiData['send_from'] = $value->userId;
                            $notiData['send_to'] = $value->userId;
                            $notiData['model_id'] = (int)$value->id;
                            $notiData['amount'] = '$'.number_format($amount,2);
                            $notiData['jobName'] = $value->jobName;
                            $this->Common_Model->backroundCall('transactionSuccessForJobPayment', $notiData);
                            // ./ Set notification
                        }
                    }
                }
            }
        }
    }

    
    /**
     * C002
     * Xtrahelpp – Alert Before 30min of start job
     * Xtrahelpp – Give a push notification alert before start job of 30mint in caregiver and user
     * Cron Timing - every 5 Mint
     */
    public function C002_5mint_alert_before_start_job_caregiver_and_user() {
        $futureJobData = $this->User_Job_Detail_Model->get(['getDatabefore30MintsOfStartJob'=>true,'status'=>1]);
        
        foreach($futureJobData as $value){
            // Send caregiver  notification for start job alert
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $value->userId;
            $notiData['send_to'] = $value->caregiverId;
            $notiData['model_id'] = (int)$value->id;
            $notiData['jobName'] = $value->jobName;
            $this->Common_Model->backroundCall('alertCaregiverMessageBeforeStartjobOf30Mint', $notiData);
            // ./ Set notification

            // Send user  notification for start job alert
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $value->caregiverId;
            $notiData['send_to'] = $value->userId;
            $notiData['model_id'] = (int)$value->id;
            $notiData['jobName'] = $value->jobName;
            $this->Common_Model->backroundCall('alertUserMessageBeforeStartjobOf30Mint', $notiData);
            // ./ Set notification
        }
    }

    /**
     * C003
     * Xtrahelpp – Ongoing job media request of every 30 minutes
     * Xtrahelpp – Send a media request of a caregiver for her ongoing job
     * Cron Timing - every 1 Mint
     */
    public function C003_1mint_ongoing_job_media_request_of_caregiver() {
        $countTiming = $this->User_Job_Detail_Model->get(['getDataMaxTimingOfOngoingJob'=>true,'status'=>1],true);
        if(empty($countTiming)){
            return false;
        }
        
        $timeSlot = array();
        for( $i = 1800; $i <= $countTiming->totalSeconds; $i+1800 ) {
            $timeSlot[] = $i;
            $i = $i+1800;
        }
        //print_r($timeSlot); die;
        $ongoingJobData = $this->User_Job_Detail_Model->get(['getDataOfOngoingJobEvery30Mint'=>$timeSlot,'status'=>1]);
        //echo $this->db->last_query(); die;
        //print_r($ongoingJobData); die;
        foreach($ongoingJobData as $value){
            // Send caregiver ongoing job media request
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $value->userId;
            $notiData['send_to'] = $value->caregiverId;
            $notiData['model_id'] = (int)$value->id;
            $notiData['jobName'] = $value->jobName;
            $this->Common_Model->backroundCall('ongoingJobMediaRequestOfCaregiver', $notiData);
            // ./ Set notification
        }
    }

    /**
     * C004
     * Xtrahelpp – Ongoing job review request job of starting 30 minutes
     * Xtrahelpp – Send a job review request for ongoing job a caregiver and user for her ongoing job
     * Cron Timing - every 1 Mint
     */
    public function C004_1mint_ongoing_job_review_request() {
      
        $ongoingJobData = $this->User_Job_Detail_Model->get(['getDataOfOngoingJobStarting30Mint'=>true,'status'=>1]);
        //echo $this->db->last_query(); die;
        //print_r($ongoingJobData); die;
        foreach($ongoingJobData as $value){
            // Send caregiver ongoing job review request in caregiver
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $value->userId;
            $notiData['send_to'] = $value->caregiverId;
            $notiData['model_id'] = (int)$value->id;
            $notiData['jobName'] = $value->jobName;
            $this->Common_Model->backroundCall('ongoingJobReviewRequestCaregiver', $notiData);
            // ./ Set notification

            // Send caregiver ongoing job review request in user
            // Set notification 
            $notiData = [];
            $notiData['send_from'] = $value->caregiverId;
            $notiData['send_to'] = $value->userId;
            $notiData['model_id'] = (int)$value->id;
            $notiData['jobName'] = $value->jobName;
            $this->Common_Model->backroundCall('ongoingJobReviewRequestUser', $notiData);
            // ./ Set notification
        }
    }
}
