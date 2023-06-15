<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Admin extends MY_Controller {

    public function __construct() {        
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"Admin profile",'url'=>'','menu'=>'setting','submenu'=>''];
    }

    public function changePassword(){
        $this->data['pagename'] = 'Change Password';
        $this->data['data'] = [];
        if($this->input->server('REQUEST_METHOD') == 'POST') {
            
            $data = $this->input->post();
            $userData = $this->Users_Model->get(['id'=>$this->session->userdata('appXtrahelpAdminId')],TRUE);
            if($userData->password != $this->Common_Model->convert_to_hash($data['oldpassword'])){
                $this->session->set_flashdata('error', 'Old password is wrong');
                return redirect('admin/setting');
            }
            $setData = [
                'password' => $this->Common_Model->convert_to_hash($data['password'])
            ];
            $set = $this->Users_Model->setData($setData,$this->session->userdata('appXtrahelpAdminId'));
            if($set){
                $this->session->set_flashdata('success', 'Password changed successfully');
                return redirect('admin/setting');
            }else{
                $this->session->set_flashdata('error', 'Fail to change password');
                return redirect('admin/setting');
            }
        }
        $this->template->content->view('admin/setting', $this->data);
        $this->template->publish();
    }

    public function setting(){

        $this->data['pagename'] = 'My Profile';
        
        $this->data['data'] = $this->Users_Model->get(['id'=>$this->session->userdata('appXtrahelpAdminId')],TRUE);
        
        if($this->input->server('REQUEST_METHOD') == 'POST') {
            $data = $this->input->post();
            $mailExist = $this->Users_Model->get(['email' => strtolower($data['email'])], true);
            if (!empty($mailExist)) {
                if (isset($data['id']) && !empty($data['id']) && $data['id'] != $mailExist->id) {
                    $this->session->set_flashdata('error', 'Email already exist');
                    return redirect('admin/setting');
                }
                if(!isset($data['id']) || empty($data['id'])){
                    $this->session->set_flashdata('error', 'Email already exist');
                    return redirect('admin/setting');
                }
            }

            $data['image'] = '';
            $upload_path = getenv('UPLOADPATH');
            $allowed_types = array(".jpg",".JPG",".jpeg",".JPEG",".png",".PNG",".webp");  
            
            if (isset($_FILES['image']["name"]) && !empty($_FILES['image']["name"])) {
                $fileExt = strtolower($this->Common_Model->getFileExtension($_FILES['image']["name"]));
                if (in_array($fileExt, $allowed_types)) {
                    
                    $fileName = date('ymdhis') . $this->Common_Model->random_string(6) . $fileExt;
                    $upload_dir = $upload_path . "/" . $fileName;
                    if (move_uploaded_file($_FILES['image']["tmp_name"], $upload_dir)) {
                        $data['image'] = $fileName;
                    }
                }else{
                    $data['image'] = "default_user.jpg";
                }
            }
            
            $setData['firstName'] = $data['firstName'];
            $setData['lastName'] = $data['lastName'];
            $setData['email'] = $data['email'];
            $setData['phone'] = $data['phone'];
    
            if(isset($data['image']) && !empty($data['image'])){
                $setData['image'] = $data['image'];
            }

            if (isset($data['id']) && !empty($data['id'])) {
                $this->Users_Model->setData($setData, $data['id']);

                $sessionData = array(
                    'appXtrahelpRole' => $this->session->userdata('appXtrahelpRole'),
                    'appXtrahelpAdminId' => $data['id'],
                    'appXtrahelpAdminImage' => isset($data['image']) && !empty($data['image']) ? $data['image'] : $this->data['data']->image,
                    'appXtrahelpAdminName' => $data['firstName'],
                   );
                
                $this->session->set_userdata($sessionData);
                $this->session->set_flashdata('success', 'Profile saved');
                return redirect('admin/setting');
            }else{
                $this->session->set_flashdata('error', 'Fail to save profile');
                return redirect('admin/setting');
            }
        }
    	$this->template->content->view('admin/setting', $this->data);
        $this->template->publish();
    }
}