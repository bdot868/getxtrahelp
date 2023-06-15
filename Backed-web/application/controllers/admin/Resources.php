<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Resources extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->load->model('Resources_Model');
        $this->load->model('Resources_Category_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"RESOURCES",'url'=>base_url('admin/resources'),'menu'=>'resources','submenu'=>'Resources'];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'Resources';
        $this->data['data'] = [];
        $this->template->content->view('admin/resources/manage', $this->data);
        $this->template->publish();
    }

    public function getList() {
        $result = [];
        $data = $this->input->post();
        $paggination['offset'] = isset($data['start'])?$data['start']:"0";
        if($data['length'] != '-1') {
            $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
        }
        $query['orderby'] = 'id';
        $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
        $query['status'] = [0,1];
        $resultData =  $this->Resources_Model->get(array_merge($paggination,$query));
        $totalData =  $this->Resources_Model->get($query, false, true);
        $result['data'] = [];
        foreach ($resultData as $key => $value) {
            $status = "";
            if ($value->status == "1") {
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" onclick="return confirm(\'Are you sure?\')" class="btn btn-round btn-warning btn-icon btn-sm"><i class="fas fa-lock-open"></i></a>';
            } else if ($value->status == "0") {
                $status = '<a href="' . current_url() . "/unblock/" . $value->id . '" class="btn btn-round btn-warning btn-icon btn-sm"><i class="fas fa-lock"></i></a>';
            }
            $result['data'][$key][] = "<img class='grid-thumb' src=".$value->thumbImageUrl." width=30%>";         
            $result['data'][$key][] = $value->title;
            $result['data'][$key][] = $value->status==0 ? "Inactive" : "Active";
            $result['data'][$key][] = $value->createdDateFormat;
            $result['data'][$key][] = $status.' <a href="' . current_url() . "/set/" . $value->id . '" class="btn btn-round btn-info btn-icon btn-sm"><i class="fas fa-pencil-alt"></i></a>
            <a href="' . current_url() . "/delete/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-danger" onclick="return confirm(\'Are you sure?\')"><i class="fas fa-trash"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        echo json_encode($result);
        exit();
    }

    public function set($id = null) {
        if ($this->input->server('REQUEST_METHOD') == 'POST') {
            $data = $this->input->post();
            $data['createdDate'] = strtotime($this->input->post('createdDate'));

            //image upload
            $upload_path = getenv('UPLOADPATH');
            $allowed_types = array(".jpg", ".png", ".jpeg",".webp");          
            if (isset($_FILES['image']["name"]) && !empty($_FILES['image']["name"])) {
                $fileExt = strtolower($this->Common_Model->getFileExtension($_FILES['image']["name"]));
                if (in_array($fileExt, $allowed_types)) {
                    $fileName = date('ymdhis') . $this->Common_Model->random_string(6) . $fileExt;
                    $upload_dir = $upload_path . "/" . $fileName;
                    if (move_uploaded_file($_FILES['image']["tmp_name"], $upload_dir)) {
                        $data['image'] = $fileName;
                    }
                }else{
                    $this->session->set_flashdata('error', 'Allowed only image file.');
                    return redirect('admin/resources/' . $data['id']);
                }
            }
            //image upload
            
            if (isset($data['id']) && !empty($data['id'])) {
                $this->Resources_Model->setData($data, $data['id']);
            } else {
                $this->Resources_Model->setData($data);
            }
            $this->session->set_flashdata('success', 'Data Saved');
            return redirect('admin/resources');
        }

        if (!empty($id) && $id != 0) {
            $this->data['data'] = $this->Resources_Model->get(['id' => $id], true);
            $this->data['categoryList'] = $this->Resources_Category_Model->get(['status'=>'1']);

            if(empty($this->data['data'])){
                $this->session->set_flashdata('error', 'Something went wrong!');
                return redirect('admin/resources');
            }
        }    
        $this->data['categoryList'] = $this->Resources_Category_Model->get(['status'=>'1']);

        $this->data['pagename'] = 'Resources'; 
        $this->template->javascript->add(base_url().'assets/ckeditor/ckeditor.js');
        $this->template->content->view('admin/resources/form', $this->data);
        $this->template->publish();
    }
    
    public function delete($id = 0){
        $data['status'] = "2";
        if (!empty($id) && $id != 0) {
            $response = $this->Resources_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data removed');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/resources');
    }

    public function block($id = 0){
        $data['status'] = "0";
        if (!empty($id) && $id != 0) {
            $response = $this->Resources_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data blocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/resources');
    }

    public function unblock($id = 0){
        $data['status'] = "1";
        if (!empty($id) && $id != 0) {
            $response = $this->Resources_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data unblocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/resources');
    }

    public function checkslug($id=0) {
        if ($this->input->server('REQUEST_METHOD') == 'GET') {
            $data = $this->input->get();
            $request = ['slug' => $data['slug'],'status' => [0, 1]];
            
            $exist = $this->Resources_Model->get($request);
            if(!empty($exist)){
                foreach($exist as $val){
                    if($val->id != $id){
                        echo "0";
                    } else {
                        echo "true";die;
                    }
                }
            } else {
                echo "true";
            }
        }
    }
}