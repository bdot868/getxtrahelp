<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Users_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_users";
        $this->tbl_user_review = "tbl_user_review";
        $this->tbl_user_work_job_category = "tbl_user_work_job_category";
        $this->tbl_job_category = "tbl_job_category";
        $this->tbl_user_job_detail = "tbl_user_job_detail";
        $this->tbl_user_job_apply = "tbl_user_job_apply";
        $this->tbl_user_job = "tbl_user_job";
        $this->tbl_user_work_detail = "tbl_user_work_detail";
        $this->tbl_hear_about_us = "tbl_hear_about_us";
        $this->tbl_stripe_connect = "tbl_stripe_connect";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            $this->db->select($this->table . '.*');
            $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            $this->db->select('FROM_UNIXTIME(' . $this->table . '.updatedDate, "%d-%m-%Y %H:%i") as updatedDate');
            $this->db->select($this->table . '.image as profileImageName');
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->table . ".image) as profileImageUrl", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->table . ".image) as profileImageThumbUrl", FALSE);
        }

        $this->db->from($this->table);

        if (isset($data['getStripeConnectedAccountData']) && $data['getStripeConnectedAccountData'] == true) {
            $this->db->select('IF('.$this->tbl_stripe_connect .'.id > 0,1,0) as isStripeConnect');
            $this->db->select($this->tbl_stripe_connect .'.isPayment');
            $this->db->select($this->tbl_stripe_connect .'.isPayout');
            $this->db->select($this->tbl_stripe_connect .'.isBankDetail');
            $this->db->join($this->tbl_stripe_connect, $this->table.'.id = '.$this->tbl_stripe_connect.'.userId AND '.$this->tbl_stripe_connect.'.status IN (1,2)','left');
        }

        if (isset($data['getHearAboutUsDetail']) && $data['getHearAboutUsDetail'] == true) {
            $this->db->select($this->tbl_hear_about_us.".name as hearAboutUsName");
            $this->db->join($this->tbl_hear_about_us, $this->table.'.hearAboutUsId = '.$this->tbl_hear_about_us.'.id AND '.$this->tbl_hear_about_us.'.status = 1','left');
        }

        if (isset($data['getCaregiverWorkDetail']) && $data['getCaregiverWorkDetail'] == true) {
            $this->db->select($this->tbl_user_work_detail.".bio as caregiverBio");
            $this->db->join($this->tbl_user_work_detail, $this->table.'.id = '.$this->tbl_user_work_detail.'.userId AND '.$this->tbl_user_work_detail.'.status = 1','left');
        }

        if (isset($data['getCaregiverCategory']) && $data['getCaregiverCategory'] == true) {
            $this->db->select("(SELECT 
                GROUP_CONCAT(".$this->tbl_job_category.".name SEPARATOR', ') 
                FROM ".$this->tbl_user_work_job_category." 
                INNER JOIN ".$this->tbl_job_category." ON ".$this->tbl_job_category.".id = ".$this->tbl_user_work_job_category.".jobCategoryId AND ".$this->tbl_job_category.".status = 1 
                WHERE ".$this->tbl_user_work_job_category.".userId = ".$this->table.".id 
                AND ".$this->tbl_user_work_job_category.".status = 1) as categoryNames");
                
        }
        if(isset($data['category'] ) && !empty($data['category'])){
            $this->db->join($this->tbl_user_work_job_category, $this->table.'.id = '.$this->tbl_user_work_job_category.'.userId AND '.$this->tbl_user_work_job_category.'.status = 1 AND '.$this->tbl_user_work_job_category.'.jobCategoryId IN ('.implode(",",$data['category']).')','RIGHT');            
            $this->db->group_by($this->table.".id");
        }
        if (isset($data['getIsTopRated']) && $data['getIsTopRated'] == true) {
            $this->db->select("(SELECT 
                    IF(".$this->tbl_user_review.".id > 0,ROUND(SUM(".$this->tbl_user_review.".rating) / COUNT(".$this->tbl_user_review.".id),2), 0)
                    FROM ".$this->tbl_user_review." 
                    WHERE ".$this->tbl_user_review.".userIdTo = ".$this->table.".id 
                    AND ".$this->tbl_user_review.".status = 1) as ratingAverage");
            
            $this->db->order_by('ratingAverage DESC');
        }
        if (isset($data['getCaregiverReview']) && $data['getCaregiverReview'] == true) {
            $this->db->select("(SELECT 
                    IF(".$this->tbl_user_review.".id > 0,ROUND(SUM(".$this->tbl_user_review.".rating) / COUNT(".$this->tbl_user_review.".id),2), 0)
                    FROM ".$this->tbl_user_review." 
                    WHERE ".$this->tbl_user_review.".userIdTo = ".$this->table.".id 
                    AND ".$this->tbl_user_review.".status = 1) as ratingAverage");
        }

        if (isset($data['countTotalJobCompleted']) && $data['countTotalJobCompleted'] == true) {
            $this->db->select("(SELECT 
                    COUNT(".$this->tbl_user_job_apply.".id)
                    FROM ".$this->tbl_user_job_apply." 
                    INNER JOIN ".$this->tbl_user_job_detail." ON ".$this->tbl_user_job_detail.".jobId = ".$this->tbl_user_job_apply.".jobId AND ".$this->tbl_user_job_detail.".status = 3
                    WHERE ".$this->tbl_user_job_apply.".userId = ".$this->table.".id 
                    AND ".$this->tbl_user_job_apply.".isHire = 1
                    AND ".$this->tbl_user_job_apply.".status = 1) as totalJobCompleted");
        }

        if (isset($data['countTotalJobOngoingWithMe']) && !empty($data['countTotalJobOngoingWithMe'])) {
            $this->db->select("(SELECT 
                    COUNT(".$this->tbl_user_job_apply.".id)
                    FROM ".$this->tbl_user_job_apply." 
                    INNER JOIN ".$this->tbl_user_job_detail." ON ".$this->tbl_user_job_detail.".jobId = ".$this->tbl_user_job_apply.".jobId AND ".$this->tbl_user_job_detail.".status = 1
                    INNER JOIN ".$this->tbl_user_job." ON ".$this->tbl_user_job.".id = ".$this->tbl_user_job_detail.".jobId AND ".$this->tbl_user_job.".status = 1
                    WHERE ".$this->tbl_user_job_apply.".userId = ".$this->table.".id 
                    AND ".$this->tbl_user_job_apply.".isHire = 1
                    AND ".$this->tbl_user_job.".userId = ".$data['countTotalJobOngoingWithMe']."
                    AND ".$this->tbl_user_job_apply.".status = 1) as totalJobOngoingWithMe");
        }

        if (isset($data['countTotalJobWithMe']) && !empty($data['countTotalJobWithMe'])) {
            $this->db->select("(SELECT 
                    COUNT(DISTINCT(".$this->tbl_user_job_apply.".id))
                    FROM ".$this->tbl_user_job_apply." 
                    INNER JOIN ".$this->tbl_user_job_detail." ON ".$this->tbl_user_job_detail.".jobId = ".$this->tbl_user_job_apply.".jobId AND ".$this->tbl_user_job_detail.".status IN (1,3)
                    INNER JOIN ".$this->tbl_user_job." ON ".$this->tbl_user_job.".id = ".$this->tbl_user_job_detail.".jobId AND ".$this->tbl_user_job.".status IN (1,3)
                    WHERE ".$this->tbl_user_job_apply.".userId = ".$this->table.".id 
                    AND ".$this->tbl_user_job_apply.".isHire = 1
                    AND ".$this->tbl_user_job.".userId = ".$data['countTotalJobWithMe']."
                    AND ".$this->tbl_user_job_apply.".status = 1) as totalJobWithMe");
            
            $this->db->having('totalJobWithMe > 0');
        }

        if (isset($data['getInRadius']) && !empty($data['getInRadius'])) {
            $lat = $data['getInRadius']['lat'];
            $lng = $data['getInRadius']['long'];
            $this->db->select("( 3959 * acos( cos( radians($lat) ) * cos( radians( ".$this->table.".latitude ) ) * cos( radians( ".$this->table.".longitude ) - radians($lng) ) + sin( radians($lat) ) * sin( radians( ".$this->table.".latitude ) ) ) ) AS distance");
           
            if(isset($data['getInRadius']['startMiles']) && !empty($data['getInRadius']['startMiles']) && isset($data['getInRadius']['endMiles']) && !empty($data['getInRadius']['endMiles'])){
                $this->db->having('distance BETWEEN '.$data['getInRadius']['startMiles'].' AND '.$data['getInRadius']['endMiles']);
            }elseif(isset($data['getInRadius']['miles']) && !empty($data['getInRadius']['miles'])){
                $this->db->having('distance <= ' . $data['getInRadius']['miles'] );
            }
        }

        if(isset($data['checkStartAgeRange']) && !empty($data['checkStartAgeRange']) && isset($data['checkEndAgeRange']) && !empty($data['checkEndAgeRange'])){
            $this->db->having($this->table . '.age BETWEEN '.$data['checkStartAgeRange'].' AND '.$data['checkEndAgeRange']);
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }elseif(isset($data['idNotInclude']) && !empty($data['idNotInclude'])) {
            if (is_array($data['idNotInclude'])) {
                $this->db->where_not_in($this->table . '.id', $data['idNotInclude']);
            } else {
                $this->db->where($this->table . '.id !=', $data['idNotInclude']);
            }
        }

        if (isset($data['search']) && !empty($data['search'])) {
            $search = trim($data['search']);
            $this->db->group_start();
            $this->db->like($this->table . '.firstName', $search);
            $this->db->or_like($this->table . '.lastName', $search);
            $this->db->or_like($this->table . '.email', $search);
            $this->db->or_like($this->table . '.phone', $search);
            $this->db->group_end();
        }
      
        
        if (isset($data['like']) && isset($data['value'])) {
            $this->db->like($this->table . '.' . $data['like'], $data['value']);
        }

        if (isset($data['firstName'])) {
            $this->db->where($this->table . '.firstName', $data['firstName']);
        }

        if (isset($data['lastName'])) {
            $this->db->where($this->table . '.lastName', $data['lastName']);
        }

        if (isset($data['username'])) {
            $this->db->where($this->table . '.username', $data['username']);
        }

        if (isset($data['email']) && !empty($data['email'])) {
            $this->db->where($this->table . '.email', $data['email']);
        }

        if (isset($data['phone'])) {
            $this->db->where($this->table . '.phone', preg_replace("/[^0-9]/", "", $data['phone']));
        }

        if (isset($data['phoneLike']) && !empty($data['phoneLike'])) {
            $this->db->where($this->table . ".phone LIKE '+%" . preg_replace("/[^0-9]/", "", $data['phoneLike']) . "'", NULL);
        }

        if (isset($data['password']) && !empty($data['password'])) {
            $this->db->where($this->table . '.password', $data['password']);
        }

        if (isset($data['role']) && !empty($data['role'])) {
            if (is_array($data['role'])) {
                $this->db->where_in($this->table . '.role', $data['role']);
            } else {
                $this->db->where($this->table . '.role', $data['role']);
            }
        }

        if (isset($data['image']) && !empty($data['image'])) {
            $this->db->where($this->table . '.image', $data['image']);
        }

        if (isset($data['verificationCode']) && !empty($data['verificationCode'])) {
            $this->db->where($this->table . '.verificationCode', $data['verificationCode']);
        }

        if (isset($data['forgotCode']) && !empty($data['forgotCode'])) {
            $this->db->where($this->table . '.forgotCode', $data['forgotCode']);
        }
    
        if (isset($data['timezone']) && !empty($data['timezone'])) {
            $this->db->where($this->table . '.timezone', $data['timezone']);
        }
    
        if (isset($data['latitude']) && !empty($data['latitude'])) {
            $this->db->where($this->table . '.latitude', $data['latitude']);
        }

        if (isset($data['longitude']) && !empty($data['longitude'])) {
            $this->db->where($this->table . '.longitude', $data['longitude']);
        }

        if (isset($data['address']) && !empty($data['address'])) {
            $this->db->where($this->table . '.address', $data['address']);
        }
       
        if (isset($data['age'])) {
            $this->db->where($this->table . '.age', $data['age']);
        }
       
        if (isset($data['gender'])) {
            $this->db->where($this->table . '.gender', $data['gender']);
        }
       
        if (isset($data['familyVaccinated'])) {
            $this->db->where($this->table . '.familyVaccinated', $data['familyVaccinated']);
        }
       
        if (isset($data['hearAboutUsId'])) {
            $this->db->where($this->table . '.hearAboutUsId', $data['hearAboutUsId']);
        }
       
        if (isset($data['soonPlanningHireDate'])) {
            $this->db->where($this->table . '.soonPlanningHireDate', $data['soonPlanningHireDate']);
        }

        if (isset($data['stripeCustomerId'])) {
            $this->db->where($this->table . '.stripeCustomerId', $data['stripeCustomerId']);
        }

        if (isset($data['stripeCustomerJson'])) {
            $this->db->where($this->table . '.stripeCustomerJson', $data['stripeCustomerJson']);
        }
       
        if (isset($data['profileStatus'])) {
            $this->db->where($this->table . '.profileStatus', $data['profileStatus']);
        }

        if (isset($data['isOnline'])) {
            $this->db->where($this->table . '.isOnline', $data['isOnline']);
        }

        if (isset($data['inboxMsgText'])) {
            $this->db->where($this->table . '.inboxMsgText', $data['inboxMsgText']);
        }

        if (isset($data['inboxMsgMail'])) {
            $this->db->where($this->table . '.inboxMsgMail', $data['inboxMsgMail']);
        }

        if (isset($data['jobMsgText'])) {
            $this->db->where($this->table . '.jobMsgText', $data['jobMsgText']);
        }

        if (isset($data['jobMsgMail'])) {
            $this->db->where($this->table . '.jobMsgMail', $data['jobMsgMail']);
        }

        if (isset($data['caregiverUpdateText'])) {
            $this->db->where($this->table . '.caregiverUpdateText', $data['caregiverUpdateText']);
        }

        if (isset($data['caregiverUpdateMail'])) {
            $this->db->where($this->table . '.caregiverUpdateMail', $data['caregiverUpdateMail']);
        }

        if (isset($data['createdDate'])) {
            $this->db->where($this->table . '.createdDate', $data['createdDate']);
        }

        if (isset($data['updatedDate'])) {
            $this->db->where($this->table . '.updatedDate', $data['updatedDate']);
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->table . '.status', $data['status']);
            } else {
                $this->db->where($this->table . '.status', $data['status']);
            }
        }

        if (!$num_rows) {
            if (isset($data['limit']) && isset($data['offset'])) {
                $this->db->limit($data['limit'], $data['offset']);
            } elseif (isset($data['limit']) && !empty($data['limit'])) {
                $this->db->limit($data['limit']);
            } else {
                //$this->db->limit(10);
            }
        }

        if (isset($data['isNewestFirst']) && $data['isNewestFirst'] == true) {
            $this->db->order_by($this->table . '.id', 'ASC');
        }elseif (isset($data['isOldestFirst']) && $data['isOldestFirst'] == true) {
            $this->db->order_by($this->table . '.id', 'DESC');
        }

        if (isset($data['orderby']) && !empty($data['orderby'])) {
            $this->db->order_by($data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id', 'DESC');
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return (isset($row->totalRecord) && !empty($row->totalRecord) ? $row->totalRecord : 0);
        }


        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }

    public function setData($data, $id = 0) {
        if (empty($data)) {
            return false;
        }
        $modelData = array();

        if (isset($data['firstName'])) {
            $modelData['firstName'] = ucwords($data['firstName']);
        }

        if (isset($data['lastName'])) {
            $modelData['lastName'] = ucwords($data['lastName']);
        }

        if (isset($data['username'])) {
            $modelData['username'] = $data['username'];
        }

        if (isset($data['email'])) {
            $modelData['email'] = $data['email'];
        }

        if (isset($data['phone'])) {
            $modelData['phone'] =  preg_replace("/[^0-9]/", "", $data['phone']);
        }

        if (isset($data['password'])) {
            $modelData['password'] = $data['password'];
        }

        if (isset($data['role'])) {
            $modelData['role'] = $data['role'];
        }

        if (isset($data['image']) && !empty($data['image'])) {
            $modelData['image'] = $data['image'];
        }

        if (isset($data['verificationCode'])) {
            $modelData['verificationCode'] = $data['verificationCode'];
        }

        if (isset($data['forgotCode'])) {
            $modelData['forgotCode'] = $data['forgotCode'];
        }

        if (isset($data['timezone']) && !empty($data['timezone'])) {
            $modelData['timezone'] = $data['timezone'];
        }
        
        if (isset($data['latitude'])) {
            $modelData['latitude'] = $data['latitude'];
        }

        if (isset($data['longitude'])) {
            $modelData['longitude'] = $data['longitude'];
        }

        if (isset($data['address'])) {
            $modelData['address'] = $data['address'];
        }

        if (isset($data['age'])) {
            $modelData['age'] = $data['age'];
        }

        if (isset($data['gender'])) {
            $modelData['gender'] = $data['gender'];
        }

        if (isset($data['familyVaccinated'])) {
            $modelData['familyVaccinated'] = $data['familyVaccinated'];
        }

        if (isset($data['hearAboutUsId'])) {
            $modelData['hearAboutUsId'] = $data['hearAboutUsId'];
        }

        if (isset($data['soonPlanningHireDate'])) {
            $modelData['soonPlanningHireDate'] = $data['soonPlanningHireDate'];
        }

        if (isset($data['stripeCustomerId'])) {
            $modelData['stripeCustomerId'] = $data['stripeCustomerId'];
        }

        if (isset($data['stripeCustomerJson'])) {
            $modelData['stripeCustomerJson'] = $data['stripeCustomerJson'];
        }

        if (isset($data['profileStatus'])) {
            $modelData['profileStatus'] = $data['profileStatus'];
        }

        if (isset($data['isOnline'])) {
            $modelData['isOnline'] = $data['isOnline'];
        }

        if (isset($data['inboxMsgText'])) {
            $modelData['inboxMsgText'] = $data['inboxMsgText'];
        }

        if (isset($data['inboxMsgMail'])) {
            $modelData['inboxMsgMail'] = $data['inboxMsgMail'];
        }

        if (isset($data['jobMsgText'])) {
            $modelData['jobMsgText'] = $data['jobMsgText'];
        }

        if (isset($data['jobMsgMail'])) {
            $modelData['jobMsgMail'] = $data['jobMsgMail'];
        }

        if (isset($data['caregiverUpdateText'])) {
            $modelData['caregiverUpdateText'] = $data['caregiverUpdateText'];
        }

        if (isset($data['caregiverUpdateMail'])) {
            $modelData['caregiverUpdateMail'] = $data['caregiverUpdateMail'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (isset($data['updatedDate'])) {
            $modelData['updatedDate'] = $data['updatedDate'];
        } elseif (!empty($id)) {
            $modelData['updatedDate'] = time();
        }

        if (empty($modelData)) {
            return false;
        }
        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->table, $modelData);
        } else {
            $this->db->insert($this->table, $modelData);
            $id = $this->db->insert_id();
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return $id;
    }
   
    public function userData($id, $secure = FALSE,$authId = "") {
        if (empty($id)) {
            return false;
        }
        $user = $this->get(['id' => $id,'getStripeConnectedAccountData'=>TRUE]);

        if (empty($user)) {
            return false;
        }

        if (empty($user->password)) {
            $user->fillpassword = "0";
        } else {
            $user->fillpassword = "1";
        }

        if (empty($user)) {
            return false;
        }

        $user->password = "";
        $user->forgotCode = "";
        $user->verificationCode = "";

        if(!empty($authId)){
            $this->load->model('Auth_Model');
            $getAuthData = $this->Auth_Model->get(['id'=>$authId],TRUE);
            if(!empty($getAuthData)){
                $user->token = $getAuthData->token;
            }
        }
        if ($secure == FALSE) {
            $user->token = "";
        }
        return $user;
    }
}
