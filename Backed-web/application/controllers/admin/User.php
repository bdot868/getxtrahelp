<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Common_Model');
        $this->load->model('Users_Model');
        $this->load->model('Hear_About_Us_Model'); 
        $this->load->model('User_About_Loved_Model');     
        $this->load->model('Loved_Disabilities_Type_Model');     
        $this->load->model('Loved_Category_Model');   
        $this->load->model('User_Loved_Category_Model');   
        $this->load->model('Loved_Specialities_Model');     
        $this->load->model('User_Loved_Specialities_Model');
        $this->load->model('User_Job_Model');
        $this->load->model('User_Job_Sub_Category_Model');
        $this->load->model('User_Job_Detail_Model');
        $this->load->model('User_Job_Media_Model');
        $this->load->model('User_Job_Question_Model');
        $this->load->model('User_Job_Apply_Model');
        $this->load->model('User_Job_Question_Answer_Model');
        
        $this->Common_Model->checkUserAuth(1);
        $this->template->set_template('AdminTemplate');
        $this->data['page'] = ['name'=>"Users",'url'=>base_url('admin/user'),'menu'=>'user','submenu'=>''];
        $this->data['pageTitle'] = ['title' => 'User', 'icon' => ''];
        $this->jobStatus = [0=>"Inactive",1=>"Active",2=>"Cancelled",3=>"Completed"];
    }

    public function index(){
        if ($this->input->is_ajax_request()) {
            $this->getList();
        }
        $this->data['pagename'] = 'Family List';
        $this->data['data'] = [];
    	$this->template->content->view('admin/user/manage', $this->data);
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
                    return redirect('admin/user/' . $data['id']);
                }
            }
            //image upload
            if (isset($data['id']) && !empty($data['id'])) {
                
                if(!empty($data['soonPlanningHireDate'])){
                   
                    $data['soonPlanningHireDate'] = date('Y-m-d', strtotime($data['soonPlanningHireDate']));
                }else{
                    $data['soonPlanningHireDate'] = '';
                }

                unset($data['email']);
                $this->Users_Model->setData($data, $data['id']);
                $this->session->set_flashdata('success', 'Data Saved');
                return redirect('admin/user');
            }else {
                $this->session->set_flashdata('error', 'Invalid request');
                return redirect('admin/user');
            }
            
            $this->session->set_flashdata('success', 'Data Saved');
            return redirect('admin/user');
        }

        if (!empty($id)) {
            if (!is_numeric($id)) {
                $this->session->set_flashdata('error', 'Invalid request');
                return redirect('admin/user');
            }
            $this->data['data'] = $this->Users_Model->get(['id' => $id], true);
            if(!empty($this->data['data']->soonPlanningHireDate) && $this->data['data']->soonPlanningHireDate != '0000-00-00'){
                $this->data['data']->soonPlanningHireDate = date("m/d/Y",strtotime($this->data['data']->soonPlanningHireDate));
            }
            if (empty($this->data['data'])) {
                $this->session->set_flashdata('error', 'Family does not exists');
                return redirect('admin/user');
            }
        }else{
            $this->session->set_flashdata('error', 'Invalid request');
            return redirect('admin/user');
        }  
        
        $this->data['pagename'] = 'Set family personal information'; 
        $this->data['hearAboutUsList'] = $this->Hear_About_Us_Model->get(['status'=>1, 'orderby'=>'name', 'orderstate'=>'ASC']);

        $this->template->content->view('admin/user/personalInformation', $this->data);
        $this->template->publish();
    }
    
    public function aboutUserLovedOne($id = null) {

        if($this->input->server('REQUEST_METHOD') == 'POST'){
            $data = $this->input->post();

            if (isset($data['id']) && !empty($data['id'])) {

                $this->User_About_Loved_Model->delete($data['id']);
                $this->User_Loved_Category_Model->delete($data['id']);
                $this->User_Loved_Specialities_Model->delete($data['id']);

                foreach($data['typeOfDisabilities'] as $k => $val){

                    $userAboutLoved_ary = array();
                    $userAboutLoved_ary['userId'] = $data['id'];
                    $userAboutLoved_ary['lovedDisabilitiesTypeId'] = $val;
                    $userAboutLoved_ary['lovedAboutDesc'] = $data['desc'][$k];
                    $userAboutLoved_ary['lovedBehavioral'] = $data['lovedBehavioral'][$k];
                    $userAboutLoved_ary['lovedVerbal'] = $data['lovedVerbal'][$k];
                    $userAboutLoved_ary['allergies'] = $data['allergies'][$k];
                    $userAboutLoved_ary['status'] = '1';

                    $userAboutLovedId = $this->User_About_Loved_Model->setData($userAboutLoved_ary);
                    
                    foreach($data['userLovedCategory'.$k] as $lck => $lc_val){
                        
                        $userLovedCat_ary = array();
                        $userLovedCat_ary['userId'] = $data['id'];
                        $userLovedCat_ary['userAboutLovedId'] = $userAboutLovedId;
                        $userLovedCat_ary['lovedCategoryId'] = $lc_val;
                        $userLovedCat_ary['status'] = '1';

                        $this->User_Loved_Category_Model->setData($userLovedCat_ary);
                    }
                    
                    foreach($data['userLovedSpecialities'.$k] as $lsk => $ls_val){
                        
                        $userLovedSpe_ary = array();
                        $userLovedSpe_ary['userId'] = $data['id'];
                        $userLovedSpe_ary['userAboutLovedId'] = $userAboutLovedId;
                        $userLovedSpe_ary['lovedSpecialitiesId'] = $ls_val;
                        $userLovedSpe_ary['status'] = '1';

                        $this->User_Loved_Specialities_Model->setData($userLovedSpe_ary);
                    }
                }

                $this->session->set_flashdata('success', 'Data Saved');
                return redirect('admin/user');

            }else {
                $this->session->set_flashdata('error', 'Invalid request');
                return redirect('admin/user');
            }
            /*print "<pre>";
            print_r($data);
            print "</pre>";*/
            
        }
        
        if(!empty($id) && $id != 0) {
            $this->data['data'] = $this->Users_Model->get(['id' => $id], true);
            
            if(empty($this->data['data'])){
                $this->session->set_flashdata('error', 'Family does not exists!');
                return redirect('admin/user');
            }
        }else{
            $this->session->set_flashdata('error', 'Invalid request');
            return redirect('admin/user');
        }

        $this->data['pagename'] = 'About User Loved One'; 
        $this->data['numLovedRecipients'] = $this->User_About_Loved_Model->get(['status'=>1,'userId'=>$id], false, true);
        $this->data['userAboutLovedList'] = $this->User_About_Loved_Model->get(['status'=>1,'userId'=>$id,'orderby'=>'id','orderstate'=>'ASC']);
        $this->data['typeOfDisablities'] = $this->Loved_Disabilities_Type_Model->get(['status'=>1]);
        $this->data['lovedCategoryList'] = $this->Loved_Category_Model->get(['status'=>1,'orderby'=>'name','orderstate'=>'ASC']);
        $this->data['lovedSpecialitiesList'] = $this->Loved_Specialities_Model->get(['status'=>1,'orderby'=>'name','orderstate'=>'ASC']);

        $this->template->content->view('admin/user/aboutUserLovedOne', $this->data);
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
        $query['role'] = 2;
        
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
            
            $result['data'][$key][] = $value->firstName;
            $result['data'][$key][] = $value->lastName;
            $result['data'][$key][] = $value->email;
            $result['data'][$key][] = $userStatus;
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
            
            $this->data['pagename'] = 'User Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;
            
            if($this->data['data']->hearAboutUsId != ''){
                $this->data['hearAboutUsObj'] = $this->Hear_About_Us_Model->get(['status'=>1, 'id'=>$this->data['data']->hearAboutUsId]);
            }
            $this->template->content->view('admin/user/personalInfoView',$this->data);
            $this->template->publish();
        }else{
            $this->session->set_flashdata('error', 'User Does Not Exist!');
            return redirect('admin/user');
        }
    }

    public function aboutUserLovedOneView($id = 0){
        //$data['status'] = [0,1,2];
        //$data['role'] = [2];

        if(!empty($id)){

            $this->data['data'] = $this->Users_Model->get(['id'=>$id],TRUE);
 
            $this->data['pagename'] = 'User Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;

            $this->data['numLovedRecipients'] = $this->User_About_Loved_Model->get(['status'=>1,'userId'=>$id], false, true);
            
            $this->data['userAboutLovedList'] = $this->User_About_Loved_Model->get(['status'=>1,'userId'=>$id,'orderby'=>'id','orderstate'=>'ASC']);
        }else{
            $this->session->set_flashdata('error', 'Invalid Request!');
            return redirect('admin/user'); 
        }
        $this->template->content->view('admin/user/aboutUserLovedOneView',$this->data);
        $this->template->publish();
    }
    
    public function userJobsView($id = 0){
        //$data['status'] = [0,1,2];
        //$data['role'] = [2];
        
        if(!empty($id)){

            if($this->input->is_ajax_request()){
                $this->getUserJobList();
            }

            $this->data['data'] = $this->Users_Model->get(['id'=>$id],TRUE);
            $this->data['pagename'] = 'User Detail : '.$this->data['data']->firstName." ".$this->data['data']->lastName;
                  
            $this->template->content->view('admin/user/userJobsView', $this->data);
            $this->template->publish();           

        }else{
            $this->session->set_flashdata('error', 'Invalid Request!');
            return redirect('admin/user'); 
        }
    }
    
    public function userJobSingleView($jobId){

        if(!empty($jobId)){

            $data['id'] = $jobId;
            $data['status'] = [0,1,2,3];
            $data['getCategoryData'] = true;
            
            $this->data['data'] = $this->User_Job_Model->get($data, true); 
            
            if($this->data['data'] != ""){
                
                $userJobSubCatList_Db = $this->User_Job_Sub_Category_Model->get(['jobId'=>$jobId,'status'=>'1','getSubCategoryName'=>true]);
                $workJobSubCatAry = [];
                if(isset($userJobSubCatList_Db) && !empty($userJobSubCatList_Db)){
                    foreach($userJobSubCatList_Db as $subcat_v){
                        $workJobSubCatAry[] = $subcat_v->SubCategoryName;
                    }
                }
                
                $this->data['catname'] = (!empty($workJobSubCatAry))?$this->data['data']->CategoryName.' - '.implode(', ',$workJobSubCatAry):$this->data['data']->CategoryName;

                $caregiver_preference_ary = [];
                if(!empty($this->data['data']->ownTransportation)){
                    $caregiver_preference_ary[] = 'Has own transportation'; 
                }
                if(!empty($this->data['data']->nonSmoker)){
                    $caregiver_preference_ary[] = 'Non-Smoker'; 
                }
                if(!empty($this->data['data']->minExperience)){
                    $caregiver_preference_ary[] = $this->data['data']->yearExperience.' year experience';  
                }
                if(!empty($this->data['data']->currentEmployment)){
                    $caregiver_preference_ary[] = 'Has current employment'; 
                }
                if(!empty($caregiver_preference_ary)){
                    $this->data['caregiver_preference'] = implode(', ',$caregiver_preference_ary);
                }else{
                    $this->data['caregiver_preference'] = '';
                }
                $this->data['time_schedule'] = ($this->data['data']->isJob == '1')?'One Time':'Recurring';
                $user_job_detail_db = $this->User_Job_Detail_Model->get(['jobId'=>$this->data['data']->id,'status'=>[0,1,2,3],'orderby'=>'id','orderstate'=>'ASC']);  
                if(isset($user_job_detail_db) && !empty($user_job_detail_db)){
                    if($this->data['data']->isJob == '2'){
                        $this->data['schedule_date'] = date("d-m-Y H:i", $user_job_detail_db[0]->startTime)." : ".date("d-m-Y H:i",$user_job_detail_db[1]->endTime);
                    }else{
                        $this->data['schedule_date'] = date("d-m-Y H:i", $user_job_detail_db[0]->startTime)." : ".date("d-m-Y H:i",$user_job_detail_db[0]->endTime);
                    }
                }

                $user_job_detail_db = $this->User_Job_Detail_Model->get(['jobId'=>$this->data['data']->id,'status'=>[0,1,2,3],'orderby'=>'id','orderstate'=>'ASC']);  
                $this->data['user_job_media_db'] = $this->User_Job_Media_Model->get(['jobId'=>$this->data['data']->id,'status'=>[0,1]]);   
                $this->data['user_job_question_db'] = $this->User_Job_Question_Model->get(['jobId'=>$this->data['data']->id,'status'=>[0,1]]);
                $this->data['jobId'] = $jobId;
                $this->data['pagename'] = 'User Job Single View';
                $this->template->content->view('admin/user/userJobSingleView', $this->data);
                $this->template->publish();   
            }else{
                $this->session->set_flashdata('error', 'Job Does Not Exist!');
                return redirect('admin/user');
            }
        }else{
            $this->session->set_flashdata('error', 'Invalid Request!');
            return redirect('admin/user'); 
        }
    }

    public function getUserJobList(){
        $result = array();
        $data = $this->input->post();
        $paggination['offset'] = isset($data['start'])?$data['start']:"0";
        if($data['length'] != '-1'){
            $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
        }
        $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
        $query['status'] = [0,1,2,3];
        $query['userId'] = $data['userId'];
        $query['getCategoryData'] = true;
        $query['getHiredCaregiver'] = true;
        
        $resultData =  $this->User_Job_Model->get(array_merge($paggination,$query));
        $totalData = $this->User_Job_Model->get($query, false, true);
        $result['data']=array();
        foreach($resultData as $key => $value){
           
            $result['data'][$key][] = $value->name;
            $result['data'][$key][] = $value->CategoryName;
            $result['data'][$key][] = $value->caregiverName;
            $result['data'][$key][] = $value->createdDate;
            $result['data'][$key][] = $this->jobStatus[$value->status];
            $result['data'][$key][] = '<a href="'.base_url('admin/user/userJobSingleView/').$value->id.'" class="btn btn-round btn-primary btn-icon btn-sm"><i class="fas fa-eye"></i></a>';            
        }
        $result["draw"] =  intval($this->input->post("draw"));
        $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
        $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
        
        echo json_encode($result);
        exit();
    }

    public function getCaregiversAppliedForJob(){
        if($this->input->is_ajax_request()){
            $result = array();
            $data = $this->input->post();

            $paggination['offset'] = isset($data['start'])?$data['start']:"0";
            if($data['length'] != '-1'){
                $paggination['limit'] =  isset($data['length']) ? $data['length'] : "10";
            }
            $query['search'] = (isset($data['search']['value']) ? $data['search']['value'] : "");
            $query['jobId'] = $data['jobId'];
            $query['status'] = 1;
            $query['getCaregiverDetails'] = true;
            $resultData =  $this->User_Job_Apply_Model->get(array_merge($paggination,$query));
            $totalData =  $this->User_Job_Apply_Model->get($query, false, true);
            $result['data'] = array();
            foreach($resultData as $key => $value){
                
                if($value->gender == 1){
                    $gender = 'Male';
                }else if($value->gender == 2){
                    $gender = 'Female';
                }else{
                    $gender = 'Other';
                }

                $result['data'][$key][] = $value->caregiverFullName; 
                $result['data'][$key][] = $value->email;
                $result['data'][$key][] = $value->phone;
                $result['data'][$key][] = $value->address;
                $result['data'][$key][] = $value->age;
                $result['data'][$key][] = $gender;
                $result['data'][$key][] = ($value->isHire)?'Yes':'No';
                $result['data'][$key][] = "<a href='".base_url('admin/user/caregiverQueAns/').$data['jobId'].'-'.$value->id."' class='btn btn-round btn-primary btn-icon btn-sm'><i class='fas fa-eye'></i></a>";
            }

            $result["draw"] =  intval($this->input->post("draw"));
            $result["recordsTotal"] = !empty($totalData) ? $totalData : 0;
            $result["recordsFiltered"] = !empty($totalData) ? $totalData : 0;
            echo json_encode($result);
            exit();
        }
    }

    public function caregiverQueAns($id){

        if(!empty($id)){
            
            $id_ary = explode("-",$id);

            $this->data['caregiverQueAnsDb'] = $this->User_Job_Question_Model->get(['jobId'=>$id_ary[0],'userJobApplyId'=>$id_ary[1],'getCaregiverQueAns'=>true]);
            $this->data['pagename'] = 'User Job - Caregiver Answers'; 
            $this->data['jobId'] = $id_ary[0]; 
            $this->template->content->view('admin/user/userCaregiverQueAnsView', $this->data);
            $this->template->publish();           

        }else{
            $this->session->set_flashdata('error', 'Invalid Request!');
            return redirect('admin/user'); 
        }
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
        return redirect('admin/user');
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
        return redirect('admin/user');
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
        return redirect('admin/user');
    }

}
