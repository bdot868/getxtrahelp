<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Appfeedback extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->load->model('App_User_Feedback_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"App Feedback",'url'=>base_url('admin/appfeedback'),'menu'=>'appfeedback','submenu'=>''];
        $this->data['pageTitle'] = ['title' =>'App Feedback', 'icon' => ''];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'App Feedback List';
        $this->data['data'] = [];
    	$this->template->content->view('admin/appfeedback/manage', $this->data);
        $this->template->publish();
    }

    public function getList()
    {
        $result = array();
        $data = $this->input->post();
        // print_r($data);die;
        $paggination['offset'] = isset($data['start'])?$data['start']:"0";
        if($data['length'] != '-1'){
            $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
        }
        $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
        $query['status'] = [0,1];
        $resultData =  $this->App_User_Feedback_Model->get(array_merge($paggination,$query));
        $totalData =  $this->App_User_Feedback_Model->get($query, false, true);
        $result['data']=array();
        foreach ($resultData as $key => $value) {
            $status = "";
            if($value->status == "1"){
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" onclick="return confirm(\'Are you sure?\')" class="btn btn-round btn-icon btn-sm btn-primary"><i class="fas fa-lock-open"></i></a>';
            }elseif($value->status == "0"){
                $status = '<a href="' . current_url() . "/unblock/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-primary"><i class="fas fa-lock"></i></a>';
            }
            $starts = "";
            if($value->rating=="1"){
                $starts = "<img class='emoji' src='".base_url('assets/backend/img/')."emoji1.png'>";
                //$starts = '<i class="fa fa-smile apprateemoji"></i>'; 
            }elseif($value->rating=="2"){
                $starts = "<img class='emoji' src='".base_url('assets/backend/img/')."emoji2.png'>";
                //$starts = '<i class="fa fa-meh apprateemoji"></i>'; 
            }elseif($value->rating=="3"){
                $starts = "<img class='emoji' src='".base_url('assets/backend/img/')."emoji3.png'>";
                //$starts = '<i class="fa fa-frown apprateemoji"></i>';
            }elseif($value->rating=="4"){
                $starts = "<img class='emoji' src='".base_url('assets/backend/img/')."emoji4.png'>";
                //$starts = '<i class="far fa-grin"></i>';
            }elseif($value->rating=="5"){
                $starts = "<img class='emoji' src='".base_url('assets/backend/img/')."emoji5.png'>";
                //$starts = '<i class="far fa-angry"></i>';
            }
            
            $result['data'][$key][] = $value->name;
            $result['data'][$key][] = $starts;
            $result['data'][$key][] = $value->feedback;
            $result['data'][$key][] = $value->status==0 ? "Inactive" : "Active";
            $result['data'][$key][] = $status.' <a href="' . current_url() . "/delete/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-danger" onclick="return confirm(\'Are you sure?\')"><i class="fas fa-trash"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        $result["query"] = $this->db->last_query();
        echo json_encode($result);
        exit();
    }

    public function delete($id = 0){
        $data['status'] = "2";
        if (!empty($id) && $id != 0) {
            $response = $this->App_User_Feedback_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data removed');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/appfeedback');
    }

    public function block($id = 0){
        $data['status'] = "0";
        if (!empty($id) && $id != 0) {
            $response = $this->App_User_Feedback_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data blocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/appfeedback');
    }

    public function unblock($id = 0){
        $data['status'] = "1";
        if (!empty($id) && $id != 0) {
            $response = $this->App_User_Feedback_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data unblocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/appfeedback');
    }
}