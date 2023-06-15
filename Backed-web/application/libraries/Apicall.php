<?php

require_once FCPATH . "vendor/autoload.php";

class Apicall {

    private $_ci;
    private $apiURL = "";

    public function __construct() {
        $this->_ci = & get_instance();
        $this->apiUrl = base_url('api');
        $this->client = new \GuzzleHttp\Client();
        $this->token = '';
        $this->_ci->load->library('session');
        if($this->_ci->session->userdata('user_session')){
            $this->user_data = $this->_ci->session->userdata('user_session');
            $this->token = $this->user_data->token;
        }
    }

    public function post($url,$req=[],$json='true') {
        $apiUrl = $this->apiUrl."".$url;
        $req['langType'] = "1";
        $req['deviceType'] = "3";
        $req['token'] = $this->token;
        $request['data'] = $req;
        try {
            $curl = curl_init();
            curl_setopt_array($curl, array(
            CURLOPT_URL => $apiUrl,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS =>json_encode($request),
            CURLOPT_HTTPHEADER => array(
                "Content-Type: application/json",
                "Cookie: ci_session_steps=er9qs1luk1dbv2f3tuila6m86mfnt3i8"
            ),
			));
			
			$response = curl_exec($curl);
			//var_dump($apiUrl);var_dump($req);exit();
            curl_close($curl);
          
            $response_array = json_decode($response,true);
            //var_dump($response_array);exit();
            if(is_array($response_array)){
                if($response_array['status'] == 2) {
                    $this->_ci->session->sess_destroy();
                    return redirect(base_url());
                }
				if($json == 'true'){
					return $response;
				}
				else{
					return json_decode($response);
				}
            }else{
				if($json == 'true'){
					return json_encode(["status" => '0','message'=>'Something went wrong from server']);
				}
				else {
					return array(["status" => '0','message'=>'Something went wrong from server']);
				}
			}
			
        }catch (Exception $e) {
            return json_encode(["status" => '0','message'=>'Something went wrong from server']);
        }
    }
}
