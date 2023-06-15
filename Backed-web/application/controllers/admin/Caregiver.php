<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Caregiver extends MY_Controller{

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->load->model('Hear_About_Us_Model');
        $this->load->model('User_Work_Detail_Model'); 
        $this->load->model('User_Work_Job_Category_Model'); 
        $this->load->model('User_Work_Experience_Model');
        $this->load->model('User_Certifications_Licenses_Model');
        $this->load->model('User_Insurance_Model');   
        $this->load->model('Background_Model');  
        $this->load->model('User_Job_Apply_Model');   
        
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"Caregiver",'url'=>base_url('admin/caregiver'),'menu'=>'caregiver','submenu'=>''];
        $this->data['pageTitle'] = ['title' => 'Caregiver', 'icon' => ''];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'Caregiver List';
        $this->data['data'] = [];
    	$this->template->content->view('admin/caregiver/manage', $this->data);
        $this->template->publish();
    }

    public function personalInformation($id = null) {
        if ($this->input->server('REQUEST_METHOD') == 'POST'){
            
            $data = $this->input->post();
            //image upload
            $upload_path = getenv('UPLOADPATH');
            $allowed_types = array(".jpg",".JPG",".jpeg",".JPEG",".png",".PNG",".webp");         
            if (isset($_FILES['image']["name"]) && !empty($_FILES['image']["name"])){
                $fileExt = strtolower($this->Common_Model->getFileExtension($_FILES['image']["name"]));
                if (in_array($fileExt, $allowed_types)) {
                    $fileName = date('ymdhis') . $this->Common_Model->random_string(6) . $fileExt;
                    $upload_dir = $upload_path . "/" . $fileName;
                    if (move_uploaded_file($_FILES['image']["tmp_name"], $upload_dir)) {
                        $data['image'] = $fileName;
                    }
                }else{
                    $this->session->set_flashdata('error', 'Allowed only image file.');
                    return redirect('admin/caregiver' . $data['id']);
                }
            }
            //image upload
            if (isset($data['id']) && !empty($data['id'])){

                unset($data['email']);
                $this->Users_Model->setData($data, $data['id']);
                $this->session->set_flashdata('success', 'Data Saved');
                return redirect('admin/caregiver');
            }else {
                $this->session->set_flashdata('error', 'Invalid request');
                return redirect('admin/caregiver');
            }
            
            $this->session->set_flashdata('success', 'Data Saved');
            return redirect('admin/caregiver');
        }

        if (!empty($id)) {
            if (!is_numeric($id)) {
                $this->session->set_flashdata('error', 'Invalid request');
                return redirect('admin/caregiver');
            }
            $this->data['data'] = $this->Users_Model->get(['id' => $id], true);
            if(!empty($this->data['data']->soonPlanningHireDate) && $this->data['data']->soonPlanningHireDate != '0000-00-00'){
                $this->data['data']->soonPlanningHireDate = date("m/d/Y",strtotime($this->data['data']->soonPlanningHireDate));
            }
            if (empty($this->data['data'])) {
                $this->session->set_flashdata('error', 'User does not exists');
                return redirect('admin/caregiver');
            }
        }else{
            $this->session->set_flashdata('error', 'Invalid request');
            return redirect('admin/caregiver');
        }  
        
        $this->data['pagename'] = 'Set Caregiver Personal Information'; 
        $this->data['hearAboutUsList'] = $this->Hear_About_Us_Model->get(['status'=>1, 'orderby'=>'name', 'orderstate'=>'ASC']);

        $this->template->content->view('admin/caregiver/personalInformation', $this->data);
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
        $query['status'] = [0,1,2];
        $query['role'] = [3];

        $resultData =  $this->Users_Model->get(array_merge($paggination,$query));
        $totalData = $this->Users_Model->get($query, false, true);
        $result['data']=array();
        foreach ($resultData as $key => $value) {
            $status = "";
            if($value->status == "1"){
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" onclick="return confirm(\'Are you sure?\')" class="btn btn-round btn-primary btn-icon btn-sm"><i class="fas fa-lock-open"></i></a>';
            }elseif($value->status == "2"){
                $status = '<a href="' . current_url() . "/unblock/" . $value->id . '" class="btn btn-round btn-primary btn-icon btn-sm"><i class="fas fa-lock"></i></a>';
            }else{
                $status = '<a href="' . current_url() . "/block/" . $value->id . '" class="btn btn-round btn-primary btn-icon btn-sm" disabled><i class="fas fa-lock-open"></i></a>';
            }
            $userStatus = "";
            if($value->status==0){$userStatus = "Need to Verify";}elseif($value->status==1){$userStatus = "Active";}elseif($value->status==2){$userStatus = "Admin Blocked";};
            
            $profileStatus = '';
            if($value->profileStatus <= 6) {
                $profileStatus = "Profie Pending";
            }elseif($value->profileStatus==7){
                $profileStatus = "Profie Under review";
            }elseif($value->profileStatus==8){
                $profileStatus = "Profie Approved";
            }
            
            $profileReviewLink = '';
            if($value->profileStatus==7){
                $profileReviewLink = "<a href='".current_url()."/personalInfoView/".$value->id."' class='btn btn-sm'>Profile Review</a>"; 
            }
            $result['data'][$key][] = $value->firstName;
            $result['data'][$key][] = $value->lastName;
            $result['data'][$key][] = $value->email;
            $result['data'][$key][] = $userStatus;
            $result['data'][$key][] = $profileStatus;
            $result['data'][$key][] = $profileReviewLink;
            $result['data'][$key][] = $value->createdDate;
            $result['data'][$key][] = $status.' <a href="' . current_url() . "/personalInformation/" . $value->id . '" class="btn btn-round btn-primary btn-info btn-icon btn-sm"><i class="fas fa-pencil-alt"></i></a>
            <a href="' . current_url() . "/personalInfoView/" . $value->id . '" class="btn btn-round btn-primary btn-icon btn-sm"><i class="fas fa-eye"></i></a>
            <a href="' . current_url() . "/delete/" . $value->id . '" class="btn btn-round btn-icon btn-sm btn-danger" onclick="return confirm(\'Are you sure?\')"><i class="fas fa-trash"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        
        echo json_encode($result);
        exit();
    }

    public function personalInfoView($id = 0){     
        //$data['status'] = [0,1,2];
        //$data['role'] = [2];
        $data['id'] = $id;
        if (!empty($id) && $id != 0) {
            $this->data['data'] = $this->Users_Model->get($data,TRUE);
        } 
        if ($this->data['data'] != ""){
            
            $this->data['pagename'] = 'Caregiver Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;
            
            if($this->data['data']->hearAboutUsId != ''){
                $this->data['hearAboutUsObj'] = $this->Hear_About_Us_Model->get(['status'=>1, 'id'=>$this->data['data']->hearAboutUsId]);
            }
            $this->template->content->view('admin/caregiver/personalInfoView',$this->data);
            $this->template->publish();
        }else{
            $this->session->set_flashdata('error', 'User Does Not Exist!');
            return redirect('admin/caregiver');
        }
    }
    
    public function workDetailsView($id = 0){     
        //$data['status'] = [0,1,2];
        //$data['role'] = [2];
        $data['id'] = $id;
        if (!empty($id) && $id != 0) {
            $this->data['data'] = $this->Users_Model->get($data,TRUE);
        } 
        if($this->data['data'] != ""){
           
            $this->data['pagename'] = 'Caregiver Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;
            $this->data['userWorkDetails'] = $this->User_Work_Detail_Model->get(['status'=>1,'userId'=>$id,'getExtraData'=>true],TRUE);
            
            $workJobCatDbAry = $this->User_Work_Job_Category_Model->get(['userId'=>$id,'status'=>'1','getJobCategoryData'=>true]);
            
            $workJobCatAry = [];
            if(isset($workJobCatDbAry) && !empty($workJobCatDbAry)){
                foreach($workJobCatDbAry as $cat_v){
                    $workJobCatAry[] = $cat_v->name;
                }
            }
            $this->data['userWorkJobCatNames'] = (!empty($workJobCatAry))?implode(', ',$workJobCatAry):'';
            
            $this->data['userWorkExperienceList'] = $this->User_Work_Experience_Model->get(['userId'=>$id,'status'=>'1']);
           
            $this->template->content->view('admin/caregiver/workDetailsView',$this->data);
            $this->template->publish();
        }else{
            $this->session->set_flashdata('error', 'User Does Not Exist!');
            return redirect('admin/caregiver');
        }
    }

    public function certificationsLicensesView($id = 0){
        if(!empty($id)){
            $data_user['id'] = $id;
            $this->data['data'] = $this->Users_Model->get($data_user,TRUE);
            $this->data['pagename'] = 'Cargiver Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;

            if ($this->input->is_ajax_request()) {
                // $response = $this->User_Insurance_Model->get();
                $result = array();
                $data = $this->input->post();
                $paggination['offset'] = isset($data['start'])?$data['start']:"0";
                if($data['length'] != '-1'){
                    $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
                }
                $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
                $query['status'] = '1';
                $query['userId'] = $id;
                $query['getLicenceTypeData'] = true;
                // echo "<pre>";print_r($this->data);die;
                $resultData =  $this->User_Certifications_Licenses_Model->get(array_merge($paggination,$query));
                $totalData = $this->User_Certifications_Licenses_Model->get($query, false, true);
                // echo "<pre>";print_r($resultData);die;
                $result['data']=array();
                foreach ($resultData as $key => $value) {
                    $result['data'][$key][] = '<img src="'.$value->licenceImageThumbUrl.'" class="licenceImgradius">';
                    $result['data'][$key][] = $value->licenceTypeName;
                    $result['data'][$key][] = $value->licenceName;
                    $result['data'][$key][] = $value->licenceNumber;
                    $result['data'][$key][] = $value->description;
                    $result['data'][$key][] = $value->issueDate == '0000-00-00' ? '0000-00-00' : $value->issueDate;
                    $result['data'][$key][] = $value->expireDate == '0000-00-00' ? '0000-00-00' : $value->expireDate;
                }
                $result["draw"] =  intval($this->input->post("draw"));
                $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
                $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
                
                echo json_encode($result);
                exit();
            }
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
            return redirect('admin/caregiver');
        }
        $this->template->content->view('admin/caregiver/certificationsLicensesView',$this->data);
        $this->template->publish();
    }

    public function appliedJobView($id = 0){
        
        if(!empty($id)){
            $data_user['id'] = $id;
            $this->data['data'] = $this->Users_Model->get($data_user,TRUE);
            $this->data['pagename'] = 'Cargiver Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;

            if ($this->input->is_ajax_request()) {
                
                $result = array();
                $data = $this->input->post();
                $paggination['offset'] = isset($data['start'])?$data['start']:"0";
                if($data['length'] != '-1'){
                    $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
                }
                $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
                $query['status'] = [0,1];
                $query['userId'] = $id;
                $query['getJobData'] = true;

                $resultData =  $this->User_Job_Apply_Model->get(array_merge($paggination,$query));
                $totalData = $this->User_Job_Apply_Model->get($query, false, true);
                // echo "<pre>";print_r($resultData);die;
                $result['data']=array();
                foreach($resultData as $key => $value){

                    $result['data'][$key][] = "<a href='".base_url('admin/user/userJobSingleView/'.$value->jobId)."' target='_blank'>".$value->jobName."</a>";
                    $result['data'][$key][] = $value->userFullName;
                    $result['data'][$key][] = ($value->isHire == 0)?'No':'Yes';
                    $result['data'][$key][] = $value->createdDate;
                    $result['data'][$key][] = ($value->status== 0)?'Inactive':'Active';
                }
                $result["draw"] =  intval($this->input->post("draw"));
                $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
                $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
                
                echo json_encode($result);
                exit();
            }
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
            return redirect('admin/caregiver');
        }
        $this->template->content->view('admin/caregiver/appliedJobView',$this->data);
        $this->template->publish();       
    }

    public function delete($id = 0){
        $data['status'] = "3";
        if (!empty($id) && $id != 0) {
            $response = $this->Users_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->load->model('Auth_Model');
            $this->load->model('Notification_Model');
            $this->load->model('StripeConnect_Model');
            $this->load->model('Ticket_Model');
            $this->load->model('User_About_Loved_Model');
            $this->load->model('User_Availability_Model');
            $this->load->model('User_Availability_Offtime_Model');
            $this->load->model('User_Availability_Setting_Model');
            $this->load->model('User_Availability_Setting_New_Model');
            $this->load->model('User_Bank_Model');
            $this->load->model('User_Card_Model');
            $this->load->model('User_Certifications_Licenses_Model');
            $this->load->model('User_Feed_Model');
            $this->load->model('User_Feed_Comment_Report');
            $this->load->model('User_Insurance_Model');
            $this->load->model('User_Job_Model');
            $this->load->model('User_Job_Apply_Model');
            $this->load->model('User_Job_Question_Answer_Model');
            $this->load->model('User_Loved_Category_Model');
            $this->load->model('User_Loved_Specialities_Model');
            $this->load->model('User_Search_History_Model');
            $this->load->model('User_Transaction_Model');
            $this->load->model('User_Work_Detail_Model');
            $this->load->model('User_Work_Disabilities_Willing_Type_Model');
            $this->load->model('User_Work_Experience_Model');
            $this->load->model('User_Work_Job_Category_Model');
            $this->load->model('Usersocialauth_Model');
            
            $this->Auth_Model->removeTokenByUser($id);
            $this->Notification_Model->removeData(['send_from'=>$id]);
            $this->Notification_Model->removeData(['send_to'=>$id]);
            $this->StripeConnect_Model->setData(['status'=>3,'userIds'=>$id]);
            $this->Ticket_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_About_Loved_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Availability_Model->setData(['notbooked'=>true,'status'=>2,'userIds'=>$id]);
            $this->User_Availability_Offtime_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Availability_Setting_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Availability_Setting_New_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Bank_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Card_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Certifications_Licenses_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Feed_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Feed_Comment_Report->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Insurance_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Job_Model->setData(['status'=>4,'userIds'=>$id]);
            $this->User_Job_Apply_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Job_Question_Answer_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Loved_Category_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Loved_Specialities_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Search_History_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Transaction_Model->setData(['status'=>3,'userIds'=>$id]);
            $this->User_Work_Detail_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Work_Disabilities_Willing_Type_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Work_Experience_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->User_Work_Job_Category_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->Usersocialauth_Model->setData(['status'=>2,'userIds'=>$id]);
            $this->session->set_flashdata('success', 'Data removed');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/caregiver');
    }

    public function block($id = 0){
        $data['status'] = "2";
        if (!empty($id) && $id != 0) {
            $response = $this->Users_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data blocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/caregiver');
    }

    public function unblock($id = 0){
        $data['status'] = "1";
        if (!empty($id) && $id != 0) {
            $response = $this->Users_Model->setData($data, $id);
        } 
        if ($response != "") {
            $this->session->set_flashdata('success', 'Data unblocked');
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
        }
        return redirect('admin/caregiver');
    }

    public function insuranceView($id=0){
        
        if(!empty($id)){
            $data_user['id'] = $id;
            $this->data['data'] = $this->Users_Model->get($data_user,TRUE);
            $this->data['pagename'] = 'Cargiver Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;

            if ($this->input->is_ajax_request()) {
                // $response = $this->User_Insurance_Model->get();
                $result = array();
                $data = $this->input->post();
                $paggination['offset'] = isset($data['start'])?$data['start']:"0";
                if($data['length'] != '-1'){
                    $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
                }
                $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
                $query['status'] = '1';
                $query['userId'] = $id;
                $query['getInsuranceTypeData'] = true;
                // echo "<pre>";print_r($this->data);die;
                $resultData =  $this->User_Insurance_Model->get(array_merge($paggination,$query));
                $totalData = $this->User_Insurance_Model->get($query, false, true);
                // echo "<pre>";print_r($resultData);die;
                $result['data']=array();
                foreach ($resultData as $key => $value) {
                    $result['data'][$key][] = '<img src="'.$value->insuranceImageThumbUrl.'"  class="licenceImgradius">';
                    $result['data'][$key][] = $value->insuranceTypeName;
                    $result['data'][$key][] = $value->insuranceName;
                    $result['data'][$key][] = $value->insuranceNumber;
                    $result['data'][$key][] = $value->expireDate;
                }
                $result["draw"] =  intval($this->input->post("draw"));
                $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
                $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
                
                echo json_encode($result);
                exit();
            }
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
            return redirect('admin/caregiver');
        }
        $this->template->content->view('admin/caregiver/insuranceView',$this->data);
        $this->template->publish();
    }
    
    public function acceptCarGiver($id=''){
        // print_r($id);die;
        if(!empty($id)){
            $user = $this->Users_Model->get(['id'=>$id, 'profileStatus'=>'7', 'status'=>'1', 'role' => '3'], TRUE);
            if(!empty($user)){
                $data_user['profileStatus'] = '8';
                $response = $this->Users_Model->setData($data_user,$id);
                if(!empty($response)){
                    $ok = $this->Background_Model->acceptRequestCarGiver(['id' => $response]);
                    $this->session->set_flashdata('success', 'Caregiver account approve sucessfully');
                    redirect($_SERVER['HTTP_REFERER']);
                } else {
                    $this->session->set_flashdata('error', 'Something went wrong!');
                    redirect($_SERVER['HTTP_REFERER']);
                }
            } else {
                $this->session->set_flashdata('error', 'Something went wrong!');
                redirect($_SERVER['HTTP_REFERER']);
            }
        } else {
            $this->session->set_flashdata('error', 'Something went wrong!');
            return redirect('admin/caregiver');
        }
    }
}
