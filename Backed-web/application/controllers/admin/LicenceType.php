<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class LicenceType extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Licence_Type_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"Licence Type",'url'=>base_url('admin/licenceType'),'menu'=>'LicenceType','submenu'=>''];
        $this->data['pageTitle'] = ['title' => 'Licence Type', 'icon' => ''];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'Licence Type';
        $this->data['data'] = []; 
    	$this->template->content->view('admin/licenceType/manage', $this->data);
        $this->template->publish();
    }

    public function getList()
    {
        $result = array();
        $data = $this->input->post();
        $paggination['offset'] = isset($data['start'])?$data['start']:"0";
        if($data['length'] != '-1'){
            $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
        }
        $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
        $query['status'] = [0,1];
        $resultData =  $this->Licence_Type_Model->get(array_merge($paggination,$query));
        $totalData =  $this->Licence_Type_Model->get($query, false, true);
        $result['data']=array();
        foreach ($resultData as $key => $value) {
            $status = "";
            if($value->status == "1"){
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" onclick="return confirm(\'Are you sure?\')" class="btn btn-round btn-primary btn-icon btn-sm"><i class="fas fa-lock-open"></i></a>';
            }elseif($value->status == "0"){
                $status = '<a href="' . current_url() . "/unblock/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-primary"><i class="fas fa-lock"></i></a>';
            }
            $result['data'][$key][] = $value->name;
            $result['data'][$key][] = $value->status==0 ? "Inactive" : "Active";
            $result['data'][$key][] = $status.' <a href="' . current_url() . "/set/" . $value->id . '" class="btn btn-round btn-info btn-icon btn-sm btn-primary"><i class="fas fa-pencil-alt"></i></a>
            <a href="' . current_url() . "/delete/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-danger" onclick="return confirm(\'Are you sure?\')"><i class="fas fa-trash"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        echo json_encode($result);
        exit();
    }

    public function set($id = null)
    {
        if ($this->input->server('REQUEST_METHOD') == 'POST') {

            $data = $this->input->post();
            if(isset($data['id']) && !empty($data['id'])){
                    $this->Licence_Type_Model->setData($data, $data['id']);
            }else{
                    $this->Licence_Type_Model->setData($data);
            }
            $this->session->set_flashdata('success', 'Data Saved');
            return redirect('admin/licenceType');
        }

        if (!empty($id) && $id != 0) {
            $this->data['data'] = $this->Licence_Type_Model->get(['id' => $id], true);
            if(empty($this->data['data'])){
                $this->session->set_flashdata('error', 'Something went wrong!');
                return redirect('admin/licenceType');
            }
        }          
        
        $this->data['pagename'] = 'Set Licence Type'; 
        $this->template->content->view('admin/licenceType/form', $this->data);
        $this->template->publish();
    }

    public function delete($id = 0){
        $data['status'] = "2";
        if (!empty($id) && $id != 0) {
            $response = $this->Licence_Type_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data removed');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/licenceType');
    }

    public function block($id = 0){
        $data['status'] = "0";
        if (!empty($id) && $id != 0) {
            $response = $this->Licence_Type_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data blocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/licenceType');
    }

    public function unblock($id = 0){
        $data['status'] = "1";
        if(!empty($id) && $id != 0){
            $response = $this->Licence_Type_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data unblocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/licenceType');
    }
    
    public function checkLicenceType(){
        if ($this->input->server('REQUEST_METHOD') == 'POST') {
            $data = $this->input->post();
            $request = ['name' => $data['name'],'status' => [0, 1]];
            
            $licencetype_obj = $this->Licence_Type_Model->get($request, true);

            if(isset($data['lictypeid']) && !empty($data['lictypeid'])){
                    
                    if(!empty($licencetype_obj) && ($data['name'] != $data['licence_type_name'])){
                        echo 'false';
                    }else{
                        echo 'true';
                    }
            }else{
                    echo (!empty($licencetype_obj))?'false':'true';    
            }
            exit;
        }
    }    
}