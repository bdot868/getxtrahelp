<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/REST_Controller.php';

class Payment extends REST_Controller {

    function __construct() {
        parent::__construct();
        $this->load->library('upload');
        $this->load->model('Common_Model','Common');
        $this->load->model('Background_Model');
        $this->load->model('Users_Model', 'User');
        $this->load->model('User_Card_Model','User_Card');
        $this->load->model('User_Job_Model');
        $this->load->model('User_Bank_Model');
        $this->load->model('StripeConnect_Model');
        $this->load->model('User_Transaction_Model');
        $this->load->library('stripe');
    }

    public function saveUserCard_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
 
        if (!isset($apiData['data']['holderName']) || empty($apiData['data']['holderName'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("holderNameRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (!isset($apiData['data']['number']) || empty($apiData['data']['number'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardNumberRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (!isset($apiData['data']['expMonth']) || empty($apiData['data']['expMonth'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("expMonthRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (!isset($apiData['data']['expYear']) || empty($apiData['data']['expYear'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("expYearRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if (!isset($apiData['data']['cvv']) || empty($apiData['data']['cvv'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cvvRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if(empty($user->stripeCustomerId)){
            $customer['description'] = '#UserId:'.$user->id.", Name: ".$user->firstName." ".$user->lastName.", Is registred from App";
            $customer['email'] = $user->email;
    
            //Customer data
            $customerData = $this->stripe->addCustomer($customer);
            if (isset($customerData['error']) && !empty($customerData['error'])) {
                $customerData['error']['status'] = '0';
                $this->apiResponse = $customerData['error'];
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
            $stripeCustomerId = $customerData['id'];
            $this->User->setData(['stripeCustomerId' => $stripeCustomerId,'stripeCustomerJson'=>json_encode($customerData)], $user->id);
        }else{
            $stripeCustomerId = $user->stripeCustomerId;
        }

        //REGISTRING CARD IN STRIPE
        $stripeCardData['card']['number'] = str_replace(' ','',$apiData['data']['number']);
        $stripeCardData['card']['exp_month'] = $apiData['data']['expMonth'];
        $stripeCardData['card']['exp_year'] = $apiData['data']['expYear'];
        $stripeCardData['card']['cvc'] = $apiData['data']['cvv'];
        $stripeCardData['card']['name'] = $apiData['data']['holderName'];
        $stripeToken = $this->stripe->createToken($stripeCardData);
        //END OF REGISTRING CARD IN STRIPE

        if(empty($stripeToken)){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToGetStripeCardToken", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif(isset($stripeToken['error'])){ //FAIL TO REGISTER CARD IN STRIPE
            $stripeToken['error']['status'] = '0';
            $this->apiResponse = $stripeToken['error'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif(!isset($stripeToken["id"]) || $stripeToken["id"]==""){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToGetStripeCardToken", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $responseCreateCard = $this->stripe->createCard(['customer_id' => $stripeCustomerId,'source' => $stripeToken['id'],]);

        if(empty($responseCreateCard)){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToCreateCardInStripe", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif(isset($responseCreateCard['error'])){ //FAIL TO REGISTER CARD IN STRIPE
            $responseCreateCard['error']['status'] = '0';
            $this->apiResponse = $responseCreateCard['error'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif(!isset($responseCreateCard["id"]) || $responseCreateCard["id"]==""){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToCreateCardInStripe", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $cardData = array();
        $cardData['userId'] = $user->id;
        $cardData['customerId'] = $responseCreateCard['customer'];
        $cardData['cardId'] = $responseCreateCard['id'];
        $cardData['cardBrand'] = $responseCreateCard['brand'];
        $cardData['last4'] = $responseCreateCard['last4'];
        $cardData['month'] = $responseCreateCard['exp_month'];
        $cardData['year'] = $responseCreateCard['exp_year'];
        $cardData['holderName'] = $apiData['data']['holderName'];
        $cardData['cardJson'] = json_encode($responseCreateCard);
        $cardId = $this->User_Card->setData($cardData);
        
        if (!empty($cardId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("saveCardSuccess", $apiData['data']['langType']);
        }else{
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToSaveCard", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);        
    }

    public function getUserCardList_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        $data = array();
        $data['status'] = 1;
        $data['userId'] = $user->id;
        $data['apiResponse'] = true;
        $response = $this->User_Card->get($data);
        if (!empty($response)) {
            foreach( $response as $value ){
                if(trim($value->cardBrand) == "Visa"){
                    $value->cardImage = base_url('assets/img/creditcard/visa.png');
                }elseif(trim($value->cardBrand) == "MasterCard"){
                    $value->cardImage = base_url('assets/img/creditcard/mastercard.png');
                }elseif(trim($value->cardBrand) == "American Express"){
                    $value->cardImage = base_url('assets/img/creditcard/americanexpress.png');
                }elseif(trim($value->cardBrand) == "Discover"){
                    $value->cardImage = base_url('assets/img/creditcard/discover.png');
                }elseif(trim($value->cardBrand) == "JCB"){
                    $value->cardImage = base_url('assets/img/creditcard/jcb.png');
                }elseif(trim($value->cardBrand) == "Maestro"){
                    $value->cardImage = base_url('assets/img/creditcard/maestro.png');
                }else{
                    $value->cardImage = base_url('assets/img/creditcard/no-name.png');
                }
            }
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getCardListSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardListNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
    
    public function removeUserCard_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
 
        if (!isset($apiData['data']['userCardId']) || empty($apiData['data']['userCardId'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("userCardIdRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $existCardData = $this->User_Card->get(['id'=>$apiData['data']['userCardId'],'userId'=>$user->id,'status'=>1],true);
        if(empty($existCardData)){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("cardNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $totalCard = $this->User_Card->get(['userId'=>$user->id,'status'=>1]);
        if(count($totalCard) <= 1){
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("mustBeAtLeastOneCardNeeded", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
         
        $existJobCardData = $this->User_Job_Model->get(['userCardId'=>$existCardData->id,'status'=> '1'],true);
        if (!empty($existJobCardData)) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("youHaveAttachedThisCardForJobPayment", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        $removeCardResponse = $this->stripe->deleteCard(['customer_id'=> $existCardData->customerId,'card_id'=> $existCardData->cardId]);
        if(empty($removeCardResponse)){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRemoveCardFromStripe", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif(isset($removeCardResponse['error'])){ //FAIL TO REGISTER CARD IN STRIPE
            $removeCardResponse['error']['status'] = '0';
            $this->apiResponse = $removeCardResponse['error'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }elseif((!isset($removeCardResponse['deleted']) || $removeCardResponse['deleted'] != 1)){ //FAIL TO GET CARD TOKEN
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRemoveCardFromStripe", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $cardId = $this->User_Card->setData(['status'=>2],$existCardData->id);
        
        if (!empty($cardId)) {
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("removeCardSuccess", $apiData['data']['langType']);
        }else{
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToRemoveCard", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function connectStripe_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        $getData = $this->StripeConnect_Model->get(['userId' => $user->id],TRUE);
        if(!empty($getData)){
            $connectedAccountId = $getData->accId;
        }else{
            $connectAccount = $this->stripe->createStripeConnect(['email' => $user->email]);
            if(isset($connectAccount->id) && !empty($connectAccount->id)){
                $set = $this->StripeConnect_Model->setData(['userId' => $user->id, 'accId' => $connectAccount->id]);
                $connectedAccountId = $connectAccount->id;
            }
        }
        if(!empty($connectedAccountId)){
            $loginLink = $this->stripe->createStripeConnectOnBoard(['accId' => $connectedAccountId]);
            if (isset($loginLink->url) && !empty($loginLink->url)) {
                $this->apiResponse['status'] = "1";
                $this->apiResponse['message'] = $this->Common_Model->GetNotification("listsuccess", $apiData['data']['langType']);
                $this->apiResponse['accId'] = $connectedAccountId;
                $this->apiResponse['url'] = $loginLink->url;
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }else if(isset($loginLink['error']['message'])
            && !empty($loginLink['error']['message'])){
                $this->apiResponse['status'] = "0";
                $this->apiResponse['message'] = $loginLink['error']['message'];
                return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
            }
        }
        $this->apiResponse['status'] = "0";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("failtoconnect", $apiData['data']['langType']);
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function saveBankDetailInStripe_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        if(!isset($apiData['data']['account_holder_name']) || empty($apiData['data']['account_holder_name'])){
            $this->apiResponse['message'] = $this->Common->GetNotification("account_holder_name_required", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if(!isset($apiData['data']['account_holder_type']) || empty($apiData['data']['account_holder_type'])){
            $this->apiResponse['message'] = $this->Common->GetNotification("account_holder_type_required", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if(!isset($apiData['data']['routing_number']) || empty($apiData['data']['routing_number'])){
            $this->apiResponse['message'] = $this->Common->GetNotification("routing_number_required", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if(!isset($apiData['data']['account_number']) || empty($apiData['data']['account_number'])){
            $this->apiResponse['message'] = $this->Common->GetNotification("account_number_required", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $bankdatas = array();
        $bankdatas['account_holder_name'] = $apiData['data']['account_holder_name'];
        $bankdatas['account_holder_type'] = $apiData['data']['account_holder_type'];
        $bankdatas['routing_number'] = $apiData['data']['routing_number'];
        $bankdatas['account_number'] = $apiData['data']['account_number'];
        $bankdatas['country'] = "US";

        $bankToken = $this->stripe->createBankToken($bankdatas);
        if(isset($bankToken['error']) && !empty($bankToken['error'])){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $bankToken['error']['message'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $connectAccount = $this->StripeConnect_Model->get(['userId' => $user->id],TRUE);
        if(!isset($connectAccount->accId) || empty($connectAccount->accId)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("connectAccountDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        /*if(!isset($connectAccount->status) || $connectAccount->status != 1){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("yourConnectAccountPendingOrRejectedFromTheStripe", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }*/

        $bankData = $this->stripe->createBankAccountOfConnect($connectAccount->accId,$bankToken->id,true);
        if(isset($bankData['error']) && !empty($bankData['error'])){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $bankData['error']['message'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        if(isset($bankData['id']) && !empty($bankData['id'])){
            $bankdatas['userId'] = $user->id;
            $bankdatas['stripeBankId'] = $bankData['id'];
            $bankdatas['bankTokenJson'] = json_encode($bankData);
            $this->User_Bank_Model->setData(["userIds"=>$user->id,"status"=>0]);
            $this->User_Bank_Model->setData($bankdatas);
           
            $this->StripeConnect_Model->setData(['isBankDetail' => 1],$connectAccount->id);
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common->GetNotification("bankAddedSuccessfully", $apiData['data']['langType']);
        }else{
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("failToAddBank", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getBankDetail_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);

        $connectAccount = $this->StripeConnect_Model->get(['userId' => $user->id],TRUE);
        if(!isset($connectAccount->accId) || empty($connectAccount->accId)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("connectAccountDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $bankAccount = $this->User_Bank_Model->get(['userId' => $user->id,"status"=>1],TRUE);
        if(empty($bankAccount)){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("bankAccountDataNotFound", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $bankData = $this->stripe->retriveBankAccountOfConnect($connectAccount->accId,$bankAccount->stripeBankId);
        if(isset($bankData['error']) && !empty($bankData['error'])){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $bankData['error']['message'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        
        if(isset($bankData['id']) && !empty($bankData['id']) && isset($bankData['default_for_currency']) && $bankData['default_for_currency'] == "1"){
            $response = array();
            $response['id'] = $bankData['id'];
            $response['account_holder_name'] = $bankData['account_holder_name'];
            $response['account_holder_type'] = $bankData['account_holder_type'];
            $response['routing_number'] = $bankData['routing_number'];
            $response['country'] = $bankData['country'];
            $response['currency'] = $bankData['currency'];
            $response['account_number'] = $bankAccount->account_number;
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common->GetNotification("getBankAccountDataSuccess", $apiData['data']['langType']);
            $this->apiResponse['data'] = $response;
        }else{
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common->GetNotification("bankAccountDataNotFound", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getWalletAmount_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        $walletData = $this->User_Transaction_Model->get(['userId'=>$user->id,'getWalletBalanceData'=>true, 'status'=>1],true);
        //echo $this->db->last_query(); die;
        //print_r($walletData); die;
        $data = array();
        $data['walletAmountFormat'] = (isset($walletData->totalBalance) && !empty($walletData->totalBalance)  ? "$".number_format($walletData->totalBalance, 2) :"$0.00") ;
        $data['walletAmount'] = (isset($walletData->totalBalance) && !empty($walletData->totalBalance)  ? $walletData->totalBalance :0) ;
        $data['walletAmountInFormat'] = (isset($walletData->amount_in) && !empty($walletData->amount_in)  ? "$".number_format($walletData->amount_in, 2) :"$0.00") ;
        $data['walletAmountOutFormat'] = (isset($walletData->amount_out) && !empty($walletData->amount_out)  ? "$".number_format($walletData->amount_out, 2) :"$0.00") ;
        
        $stripeconnect = $this->StripeConnect_Model->get(['userId' => $user->id],TRUE);
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("getWalletDataSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $data;
        $this->apiResponse['stripe_connect_status'] = isset($stripeconnect->status) && $stripeconnect->status == "1" ? "1" : "0";
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);        
    }

    public function withdrawMoney_post() {
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        if (!isset($apiData['data']['amount']) || empty($apiData['data']['amount'])) {
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("amountRequired", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $stripeconnect = $this->StripeConnect_Model->get(['userId' => $user->id],TRUE);
        if( empty($stripeconnect) ){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("createConnectAccount", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if( isset($stripeconnect->status) && $stripeconnect->status != "1" ){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common->GetNotification("connectAccountNotApproved", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        $walletData = $this->User_Transaction_Model->get(['userId'=>$user->id,'getWalletBalanceData'=>true, 'status'=>1],true);
        $walletAmount = (isset($walletData->totalBalance) && !empty($walletData->totalBalance)  ? $walletData->totalBalance :0);
        if(empty($walletAmount) || $walletAmount < $apiData['data']['amount']){
            $this->apiResponse['message'] = $this->Common->GetNotification("insufficientAmountInYourWallet", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }

        $this->load->library('stripe');
        $connectTransfer = $this->stripe->stripeConnectTransfer($apiData['data']['amount'],$stripeconnect->accId);
        if(isset($connectTransfer['error']) && !empty($connectTransfer['error'])){
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $connectTransfer['error']['message'];
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }
        if(isset($connectTransfer['id']) && !empty($connectTransfer['id'])){
            $transactionData = array();
            $transactionData['userId'] = $user->id;
            $transactionData['stripeTransactionId'] = $connectTransfer['id'];
            $transactionData['stripeTranJson'] = json_encode($connectTransfer);
            $transactionData['amount'] = $apiData['data']['amount'];
            $transactionData['type'] = 2; //Debit amount
            $transactionData['payType'] = 3; //Withdraw amount from wallet
            $transactionData['tranType'] = 2; //Stripe Transaction
            $transactionData['createdDate'] = time();
            $this->User_Transaction_Model->setData($transactionData);

            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common->GetNotification("withdrawRequestSuccess", $apiData['data']['langType']);
            return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
        }else{
            $this->apiResponse['status'] = "0";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("failToWithdrawRequest", $apiData['data']['langType']);
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function caregiverAccountTransaction_post(){
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
        
        $response = $this->User_Transaction_Model->get(['userId'=>$user->id,'status'=>1,'payType'=>[1,2,3],'tranType'=>[1,2],'apiResponse'=>true,'getFormattedAmount'=>true,'userTranDateFormate'=>true,'orderby'=>'createdDate','orderstate'=>'DESC']);
        $totalData = $this->User_Transaction_Model->get(['userId'=>$user->id,'status'=>1,'payType'=>[1,2,3],'tranType'=>[1,2],'limit'=>$limit,'offset'=>$offset],false,true);
        if (!empty($response)) {
            foreach($response as $value){
                $value->jobName = "";
                $value->caregiverName = "";
                if(in_array($value->payType,array(1,2)) && !empty($value->userJobId)){
                    $existJobData = $this->User_Job_Model->get(['id'=>$value->userJobId,'getUserData'=>true],true);
                    if (!empty($existJobData)) {
                        $value->jobName = $existJobData->name;
                        $value->caregiverName = $existJobData->userFullName;
                    }
                }elseif($value->payType == 3){
                    $value->jobName = "Withdraw Amount";
                    $value->caregiverName = "Self";
                }
            }
            $this->apiResponse['status'] = "1";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification("getTransactionListSuccess", $apiData['data']['langType']);
            $this->apiResponse['totalPages'] = ceil($totalData / $limit) . "";
            $this->apiResponse['data'] = $response;
        } else {
            $this->apiResponse['status'] = "6";
            $this->apiResponse['message'] = $this->Common_Model->GetNotification(($offset > 0 ? 'allcatchedUp' : "transactionListNotFound"), $apiData['data']['langType']);
            $this->apiResponse['totalPages'] = ceil($totalData / $limit) . "";
        }
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }

    public function getAccountChartData_post(){
        $user = $this->checkUserRequest();
        $apiData = json_decode(file_get_contents('php://input'), TRUE);
        
        $year = (isset($apiData['data']['year']) && $apiData['data']['year'] != '' ? $apiData['data']['year'] : date('Y'));
        
        $monthList = [1=>'JAN',2=>'FEB',3=>'MAR',4=>'APR',5=>'MAY',6=>'JUN',7=>'JULY',8=>'AUG',9=>'SEPT',10=>'OCT',11=>'NOV',12=>'DEC'];
        $response = array();
        foreach($monthList as $key => $value){
            $date = date('Y-m',strtotime($year.'-'.$key.'-1'));
            $totalAmount = $this->User_Transaction_Model->get(['userId'=>$user->id,'status'=>1,'payType'=>2,'type'=>1,'getMonthYearData'=>$date,'sumAmount'=>true],true);
            $response[] = ['month'=>$value,'amount'=>(isset($totalAmount->totalAmount) ? $totalAmount->totalAmount : 0)];
        }
        
        $this->apiResponse['status'] = "1";
        $this->apiResponse['message'] = $this->Common_Model->GetNotification("getChartDataSuccess", $apiData['data']['langType']);
        $this->apiResponse['data'] = $response;
        return $this->response($this->apiResponse, REST_Controller::HTTP_OK);
    }
}
