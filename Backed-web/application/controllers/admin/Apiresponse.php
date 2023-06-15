<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Apiresponse extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->load->model('ApiResponse_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"API Response",'url'=>base_url('admin/apiresponse'),'menu'=>'apiresponse','submenu'=>'apiresponse'];
        $this->data['pageTitle'] = ['title' => 'API Response', 'icon' => ''];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'API Response Lists';
        $this->data['data'] = [];
    	$this->template->content->view('admin/apiresponse/manage', $this->data);
        $this->template->publish();
    }

    public function getList() {
        $result = [];
        $data = $this->input->post();
        $paggination['offset'] = isset($data['start'])?$data['start']:"0";
        if($data['length'] != '-1'){
            $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
        }
        $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
        $query['status'] = [0,1];
        $query['categoryDetail'] = true;
        
        $resultData =  $this->ApiResponse_Model->get(array_merge($paggination,$query));
        $totalData =  $this->ApiResponse_Model->get($query, false, true);     
        $result['data'] = [];
        foreach ($resultData as $key => $value) {
            $status = "";
            if($value->status == "1"){
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" onclick="return confirm(\'Are you sure?\')" class="btn btn-round btn-icon btn-sm btn-primary"><i class="fas fa-lock-open"></i></a>';
            } else if ($value->status == "0") {
                $status = '<a href="' . current_url() . "/unblock/" . $value->id . '" class="btn btn-round btn-info btn-icon btn-sm btn-primary"><i class="fas fa-lock"></i></a>';
            }
            $result['data'][$key][] = $value->key;            
            $result['data'][$key][] = $value->value_en;            
            $result['data'][$key][] = $value->status==0 ? "Inactive" : "Active";
            // $result['data'][$key][] = date('d-m-Y',strtotime($value->createdDate));
            $result['data'][$key][] = $status.' <a title="Edit" href="' . current_url() . "/set/" . $value->id . '" class="btn btn-round btn-info btn-icon btn-sm btn-danger"><i class="fas fa-pencil-alt"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        echo json_encode($result);
        exit();
    }

    public function set($id = null){
        if ($this->input->server('REQUEST_METHOD') == 'POST') {
            $data = $this->input->post();
            if (isset($data['id']) && !empty($data['id'])) {
                $this->ApiResponse_Model->setData($data, $data['id']);
            } 
            $this->session->set_flashdata('success', 'Data saved successfully.');
            return redirect('admin/apiresponse');
        }

        if (!empty($id) && $id != 0) {
            $this->data['data'] = $this->ApiResponse_Model->get(['id' => $id], true);
            if (empty($this->data['data'])) {
                $this->session->set_flashdata('error', 'Invalid attempt');
                return redirect('admin/apiresponse');
            }
        }
        else{
            $this->session->set_flashdata('error', 'Apiresponse does not exists');
            return redirect('admin/apiresponse');
        }
        $this->data['pagename'] = 'Update Time Label'; 
        $this->template->content->view('admin/apiresponse/form', $this->data);
        $this->template->publish();
    }

    public function delete($id = 0){
        $data['status'] = "2";
        if (!empty($id) && $id != 0) {
            $response = $this->ApiResponse_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data removed');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/apiresponse');
    }

    public function block($id = 0){
        $data['status'] = "0";
        if (!empty($id) && $id != 0) {
            $response = $this->ApiResponse_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data blocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/apiresponse');
    }

    public function unblock($id = 0){
        $data['status'] = "1";
        if (!empty($id) && $id != 0) {
            $response = $this->ApiResponse_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data unblocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/apiresponse');
    }
    
}