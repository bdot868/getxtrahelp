<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Wmmessanger extends CI_Controller {
    function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model', 'User');
        $this->load->model('Auth_Model');
    }
    public function index() {
        $this->load->library('ratchet_client');
        $this->ratchet_client->set_callback('auth', array($this, '_auth'));
        $this->ratchet_client->run();
    }

    public function _auth($data = null) {
        if(!isset($data->token) || empty($data->token)){
            return false; 
        }
        $userauth = $this->Auth_Model->get(['token' => $data->token], true);
        if(empty($userauth)){
            return false;
        }
        $user = $this->User->get(['id' => $userauth->userId], true);
        if(!empty($user)){
            $user->auth_id = $userauth->id;
            return $user;
        }else{
            return false;
        }
    }

    public function _event($datas = null) {
        // Here you can do everyting you want, each time message is received
        echo 'Hey ! I\'m an EVENT callback' . PHP_EOL;
    }

}
