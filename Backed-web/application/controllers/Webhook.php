<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Webhook extends MY_Controller {
    
    public function __construct() {
        parent::__construct();
        // $this->template->set_template('FrontTemplate');
        $this->load->model('Background_Model');
        $this->load->model('Users_Model');
    }
    
    public function index() {
        
    }

    public function stripe_log() {
        $this->load->library('stripe');
        $fileData = file_get_contents('php://input');
        if(!isset($_SERVER['HTTP_STRIPE_SIGNATURE']) || empty($_SERVER['HTTP_STRIPE_SIGNATURE'])){
            $failauth = "\n\n--------------------------------------------------------------------------------------------------------\n";
            $failauth .= "Header Not found :".date("Y-m-d H:i:s")." \n";
            $failauth .= json_encode(json_decode(file_get_contents('php://input'), TRUE));
            $failauth .= "\n--------------------------------------------------------------------------------------------------------\n\n\n\n";
            file_put_contents(FCPATH.'worker/payment/failed_hook'.date('d_m_Y').'.txt',$failauth,FILE_APPEND);
            return false;
        }
        $fileData =  $this->stripe->validateWebhook($fileData,$_SERVER['HTTP_STRIPE_SIGNATURE']);
        if(empty($fileData)){
            $failauth = "\n\n--------------------------------------------------------------------------------------------------------\n";
            $failauth .= "Header authentication failed :".date("Y-m-d H:i:s")." \n";
            $failauth .= json_encode(json_decode(file_get_contents('php://input'), TRUE));
            $failauth .= "\n--------------------------------------------------------------------------------------------------------\n\n\n\n";
            file_put_contents(FCPATH.'worker/payment/failed_hook'.date('d_m_Y').'.txt',$failauth,FILE_APPEND);
            return false;
        }
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $data = "--------------------------------------------".date('d-m-Y H:i')."--------------------------------------------\n\n";
        $data .= json_encode($apiData);
        $data .= "\n--------------------------------------------------------------------------------------------------------\n\n\n\n";
        file_put_contents(FCPATH.'worker/payment/stripe_log_'.date('d_m_Y').'.txt',$data,FILE_APPEND);
        if(isset($apiData['type'])){
            switch ($apiData['type']) {
                case 'account.updated':
                    $object = [];
                    if(isset($apiData['data']['object'])
                    && !empty($apiData['data']['object'])){
                        $object = $apiData['data']['object'];
                    }
                    if(!empty($object)){
                        $this->load->model('StripeConnect_Model');
                        $getData = $this->StripeConnect_Model->get(['accId'=>$object['id']],TRUE);
                        if(!empty($getData)){
                            if(isset($object['capabilities']['card_payments']) && isset($object['capabilities']['transfers']) && 
                            $object['capabilities']['card_payments'] == 'active' && $object['capabilities']['transfers'] == 'active'){
                                $this->StripeConnect_Model->setData(['status'=>'1'],$getData->id);
                            }else if(isset($object['capabilities']['card_payments']) && isset($object['capabilities']['card_payments']) && 
                            $object['capabilities']['card_payments'] == 'pending' && $object['capabilities']['transfers'] == 'pending'){
                                $this->StripeConnect_Model->setData(['status'=>'2'],$getData->id);
                            }else{
                                $this->StripeConnect_Model->setData(['status'=>'0'],$getData->id);
                            }

                            if(isset($object['charges_enabled']) && $object['charges_enabled'] == true){
                                $this->StripeConnect_Model->setData(['isPayment'=>'1'],$getData->id);
                            }
                            if(isset($object['payouts_enabled']) && $object['payouts_enabled'] == true){
                                $this->StripeConnect_Model->setData(['isPayout'=>'1','isBankDetail'=>1],$getData->id);
                            }
                        }
                    }
                    break;
                default:
                    echo 'Received unknown event type ' . $apiData['type'];
            }
        }
    }
    
}
