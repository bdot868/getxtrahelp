<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Dashboard extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"Dashboard",'url'=>base_url('admin/dashboard')];
        $this->data['pageTitle'] = ['title' => 'Dashboard', 'icon' => ''];
    }

    public function index(){
        
        $this->data['pageTitle'] = ['title' => 'Dashboard', 'icon' => ''];
        $this->data['totalUser'] = $this->Users_Model->get(['role'=>'2','status'=>[0,1,2]],false, true);
        $this->data['totalCargiver'] = $this->Users_Model->get(['role'=>'3','status'=>[0,1,2]],false, true);
       
        $this->template->content->view('admin/dashboard', $this->data);
        $this->template->publish();
    }
}