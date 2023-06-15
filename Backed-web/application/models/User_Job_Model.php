<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job";
        $this->tbl_user_job_apply = "tbl_user_job_apply";
        $this->tbl_job_category = "tbl_job_category";
        $this->tbl_users = "tbl_users";
        $this->tbl_user_about_loved = "tbl_user_about_loved";
        $this->tbl_user_review = "tbl_user_review";
        $this->tbl_user_job_detail = "tbl_user_job_detail";
        $this->tbl_user_loved_specialities = "tbl_user_loved_specialities";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.categoryId');
                $this->db->select($this->table . '.name');
                $this->db->select($this->table . '.userCardId');
                $this->db->select($this->table . '.price');
                $this->db->select('CONCAT("$",FORMAT('.$this->table . '.price,2)) as formatedPrice');
                $this->db->select($this->table . '.ownTransportation');
                $this->db->select($this->table . '.nonSmoker');
                $this->db->select($this->table . '.currentEmployment');
                $this->db->select($this->table . '.minExperience');
                $this->db->select($this->table . '.yearExperience');
                $this->db->select($this->table . '.location');
                $this->db->select($this->table . '.latitude');
                $this->db->select($this->table . '.longitude');
                $this->db->select($this->table . '.description');
                $this->db->select($this->table . '.isJob');
                $this->db->select($this->table . '.isHire');
                $this->db->select($this->table . '.verificationCode');
                $this->db->select($this->table . '.createdDate');
                $this->db->select($this->table . '.status');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDateFormat');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if (isset($data['getApplicationsCount']) && $data['getApplicationsCount'] == true) {
            $this->db->select("(SELECT 
                COUNT(".$this->tbl_user_job_apply.".id)
                FROM ".$this->tbl_user_job_apply." 
                WHERE ".$this->table.".id = ".$this->tbl_user_job_apply.".jobId
                AND ".$this->tbl_user_job_apply.".status = 1 LIMIT 1) as totalApplication");
        }

        if (isset($data['getCategoryData']) && $data['getCategoryData'] == true) {
            $this->db->select($this->tbl_job_category . '.name as CategoryName');
            $this->db->join($this->tbl_job_category, $this->tbl_job_category.'.id = '.$this->table.'.categoryId AND '.$this->tbl_job_category.'.status = 1','left');
        }

        /*if (isset($data['getBehavioralRelatedData']) && !empty($data['getBehavioralRelatedData'])) {
            $this->db->join($this->tbl_user_about_loved.' as behavioralRelated', 'behavioralRelated.userId = '.$this->table.'.userId AND behavioralRelated.lovedBehavioral = '.$data['getBehavioralRelatedData'].' AND behavioralRelated.status = 1','inner');
            $this->db->group_by($this->table.".id");
        }

        if (isset($data['getVerbalRelatedData']) && !empty($data['getVerbalRelatedData'])) {
            $this->db->join($this->tbl_user_about_loved.' as verbalRelated', 'verbalRelated.userId = '.$this->table.'.userId AND verbalRelated.lovedVerbal = '.$data['getVerbalRelatedData'].' AND verbalRelated.status = 1','inner');
            $this->db->group_by($this->table.".id");
        }*/

        if (isset($data['getJobAboutLovedFilterData']) && $data['getJobAboutLovedFilterData'] == true) {
            $this->db->join($this->tbl_user_about_loved, $this->tbl_user_about_loved.'.userId = '.$this->table.'.userId AND '.$this->tbl_user_about_loved.'.status = 1','inner');
            if (isset($data['getBehavioralRelatedData']) && !empty($data['getBehavioralRelatedData'])) {
                //$this->db->join($this->tbl_user_about_loved.' as behavioralRelated', 'behavioralRelated.userId = '.$this->table.'.userId AND behavioralRelated.lovedBehavioral = '.$data['getBehavioralRelatedData'].' AND behavioralRelated.status = 1','inner');
                $this->db->where($this->tbl_user_about_loved . '.lovedBehavioral', $data['getBehavioralRelatedData']);
            }
    
            if (isset($data['getVerbalRelatedData']) && !empty($data['getVerbalRelatedData'])) {
                //$this->db->join($this->tbl_user_about_loved.' as verbalRelated', 'verbalRelated.userId = '.$this->table.'.userId AND verbalRelated.lovedVerbal = '.$data['getVerbalRelatedData'].' AND verbalRelated.status = 1','inner');
                $this->db->where($this->tbl_user_about_loved . '.lovedVerbal', $data['getVerbalRelatedData']);
            }
            
            if (isset($data['getAllergiesRelatedData']) && !empty($data['getAllergiesRelatedData'])) {
                $this->db->like($this->tbl_user_about_loved . '.allergies', $data['getAllergiesRelatedData']);
            }
            $this->db->group_by($this->table.".id");
        }

        if (isset($data['getLovedSpecialities']) &&  !empty($data['getLovedSpecialities'])) {
            $this->db->join($this->tbl_user_loved_specialities, $this->tbl_user_loved_specialities.'.userId = '.$this->table.'.userId AND '.$this->tbl_user_loved_specialities.'.status = 1','inner');
            if (is_array($data['getLovedSpecialities'])) {
                $this->db->where_in($this->tbl_user_loved_specialities . '.lovedSpecialitiesId', $data['getLovedSpecialities']);
            } else {
                $this->db->where($this->tbl_user_loved_specialities . '.lovedSpecialitiesId', $data['getLovedSpecialities']);
            }
            $this->db->group_by($this->table.".id");
        }

        if (isset($data['getUserData']) && $data['getUserData'] == true) {
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as userFullName');
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->tbl_users.".image) as profileImageUrl", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->tbl_users.".image) as profileImageThumbUrl", FALSE);
            $this->db->select($this->tbl_users.".phone as userPhone");
            $this->db->join($this->tbl_users, $this->tbl_users.'.id = '.$this->table.'.userId AND '.$this->tbl_users.'.status = 1','inner');

            if (isset($data['checkIsFamilyVaccinated']) &&  !empty($data['checkIsFamilyVaccinated'])) {
                $this->db->where($this->tbl_users . '.familyVaccinated', $data['checkIsFamilyVaccinated']);
            }
        }

        if (isset($data['checkIsApply']) && !empty($data['checkIsApply'])) {
            $this->db->select('IF('.$this->tbl_user_job_apply .'.id > 0,1,0) as isJobApply');
            $this->db->join($this->tbl_user_job_apply, $this->table.'.id = '.$this->tbl_user_job_apply.'.jobId  AND '.$this->tbl_user_job_apply.'.userId = '.$data['checkIsApply'].' AND '.$this->tbl_user_job_apply.'.status = 1','left');
        }

        if (isset($data['getOnlyJobApply']) && !empty($data['getOnlyJobApply'])) {
            $this->db->select($this->tbl_user_job_apply.".id as userJobApplyId");
            $this->db->select($this->tbl_user_job_apply.".isHire as userJobIsHire");
            $this->db->join($this->tbl_user_job_apply, $this->table.'.id = '.$this->tbl_user_job_apply.'.jobId  AND '.$this->tbl_user_job_apply.'.userId = '.$data['getOnlyJobApply'].' AND '.$this->tbl_user_job_apply.'.status = 1','inner');
            
            if (isset($data['jobHireStatus']) && in_array($data['jobHireStatus'], array(0,1))) {
                $this->db->where($this->tbl_user_job_apply . '.isHire', $data['jobHireStatus']);
            }
        }

        if (isset($data['getHiredCaregiverData']) && !empty($data['getHiredCaregiverData'])) {
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as userFullName');
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->tbl_users.".image) as profileImageUrl", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->tbl_users.".image) as profileImageThumbUrl", FALSE);
            
            $this->db->select($this->tbl_user_job_apply.".userId as caregiverId");
            $this->db->select($this->tbl_users.".phone as caregiverPhone");
            $this->db->select($this->tbl_user_job_apply.".id as userJobApplyId");
            $this->db->select($this->tbl_user_job_apply.".isHire as userJobIsHire");
            $this->db->join($this->tbl_user_job_apply, $this->table.'.id = '.$this->tbl_user_job_apply.'.jobId  AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
            $this->db->join($this->tbl_users, $this->tbl_users.'.id = '.$this->tbl_user_job_apply.'.userId AND '.$this->tbl_users.'.status = 1','inner');
            
            if (isset($data['getHiredCaregiverRatingData']) && $data['getHiredCaregiverRatingData'] == true) {
                $this->db->select("(SELECT 
                    IF(".$this->tbl_user_review.".id > 0,ROUND(SUM(".$this->tbl_user_review.".rating) / COUNT(".$this->tbl_user_review.".id),2), 0)
                    FROM ".$this->tbl_user_review." 
                    WHERE ".$this->tbl_user_review.".userIdTo = ".$this->tbl_user_job_apply.".userId 
                    AND ".$this->tbl_user_review.".status = 1) as caregiverRatingAverage");
            }
        }

        if (isset($data['getJobDetailData']) && !empty($data['getJobDetailData'])) {
            $this->db->select($this->tbl_user_job_detail.".id as userJobDetailId");
            $this->db->select($this->tbl_user_job_detail.".startTime as starTimestamp");
            $this->db->select($this->tbl_user_job_detail.".endTime  as endTimestamp");
            $this->db->select($this->tbl_user_job_detail.".status  as jobStatus");
            $this->db->join($this->tbl_user_job_detail, $this->table.'.id = '.$this->tbl_user_job_detail.'.jobId','inner');
            if (is_array($data['getJobDetailData'])) {
                $this->db->where_in($this->tbl_user_job_detail . '.status', $data['getJobDetailData']);
            } else {
                $this->db->where($this->tbl_user_job_detail . '.status', $data['getJobDetailData']);
            }
        }

        if (isset($data['getOngoingJobDetailData']) && $data['getOngoingJobDetailData'] == true) {
            $this->db->select($this->tbl_user_job_detail.".id as userJobDetailId");
            $this->db->select($this->tbl_user_job_detail.".startTime as starTimestamp");
            $this->db->select($this->tbl_user_job_detail.".endTime  as endTimestamp");
            $this->db->select($this->tbl_user_job_detail.".status  as jobStatus");
            $this->db->join($this->tbl_user_job_detail, $this->table.'.id = '.$this->tbl_user_job_detail.'.jobId','inner');
            $this->db->where($this->tbl_user_job_detail . '.status', 1);
            $this->db->group_start();
                $this->db->where($this->tbl_user_job_detail.'.startTime <= UNIX_TIMESTAMP()');
                $this->db->where($this->tbl_user_job_detail.'.endTime >= UNIX_TIMESTAMP()');
            $this->db->group_end();
        }
        
        if (isset($data['getJobReview']) && !empty($data['getJobReview'])) {
            $this->db->select('IF('.$this->tbl_user_review .'.rating > 0,'.$this->tbl_user_review .'.rating,0) as jobRating');
            $this->db->select($this->tbl_user_review.".feedback as jobFeedback");
            $this->db->join($this->tbl_user_review, $this->table.'.id = '.$this->tbl_user_review.'.jobId AND '.$this->tbl_user_review.'.userIdFrom = '.$data['getJobReview'].' AND '.$this->tbl_user_review.'.status = 1','left');
        }
        
        if (isset($data['getCaregiverJobReview']) && !empty($data['getCaregiverJobReview'])) {
            $this->db->select('IF('.$this->tbl_user_review .'.rating > 0,'.$this->tbl_user_review .'.rating,0) as jobRating');
            $this->db->select($this->tbl_user_review.".feedback as jobFeedback");
            $this->db->join($this->tbl_user_review, $this->table.'.id = '.$this->tbl_user_review.'.jobId AND '.$this->tbl_user_review.'.userIdTo = '.$data['getCaregiverJobReview'].' AND '.$this->tbl_user_review.'.status = 1','left');
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
        
        if(isset($data['getHiredCaregiver']) && !empty($data['getHiredCaregiver'])){    
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as caregiverName');
            $this->db->join($this->tbl_user_job_apply, $this->table.'.id = '.$this->tbl_user_job_apply.'.jobId and '.$this->tbl_user_job_apply.'.isHire = 1', 'left');
            $this->db->join($this->tbl_users, $this->tbl_user_job_apply.'.userId = '.$this->tbl_users.'.id and '.$this->tbl_users.'.status = 1','left');
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }

        if (isset($data['allsearch']) && !empty($data['allsearch'])) {
            $allsearch = trim($data['allsearch']);
            $this->db->group_start();
                $this->db->like($this->table . '.name', $allsearch);
            $this->db->group_end();
        }

        if (isset($data['search']) && !empty($data['search'])) {
            $search = trim($data['search']);
            $this->db->group_start();
            $this->db->like($this->table . '.name', $search);
            $this->db->like($this->table . '.description', $search);
            $this->db->group_end();
        }

        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }

        if (isset($data['categoryId']) && !empty($data['categoryId'])) {
            if (is_array($data['categoryId'])) {
                $this->db->where_in($this->table . '.categoryId', $data['categoryId']);
            } else {
                $this->db->where($this->table . '.categoryId', $data['categoryId']);
            }
        }

        if (isset($data['userCardId'])) {
            $this->db->where($this->table . '.userCardId', $data['userCardId']);
        }

        if (isset($data['name'])) {
            $this->db->where($this->table . '.name', $data['name']);
        }

        if (isset($data['price'])) {
            $this->db->where($this->table . '.price', $data['price']);
        }

        if (isset($data['ownTransportation'])) {
            $this->db->where($this->table . '.ownTransportation', $data['ownTransportation']);
        }

        if (isset($data['nonSmoker'])) {
            $this->db->where($this->table . '.nonSmoker', $data['nonSmoker']);
        }

        if (isset($data['currentEmployment'])) {
            $this->db->where($this->table . '.currentEmployment', $data['currentEmployment']);
        }

        if (isset($data['minExperience'])) {
            $this->db->where($this->table . '.minExperience', $data['minExperience']);
        }

        if (isset($data['yearExperience'])) {
            $this->db->where($this->table . '.yearExperience', $data['yearExperience']);
        }

        if (isset($data['location'])) {
            $this->db->where($this->table . '.location', $data['location']);
        }

        if (isset($data['latitude'])) {
            $this->db->where($this->table . '.latitude', $data['latitude']);
        }

        if (isset($data['longitude'])) {
            $this->db->where($this->table . '.longitude', $data['longitude']);
        }
        
        if (isset($data['description'])) {
            $this->db->where($this->table . '.description', $data['description']);
        }
        
        if (isset($data['isJob'])) {
            $this->db->where($this->table . '.isJob', $data['isJob']);
        }
        
        if (isset($data['isHire'])) {
            $this->db->where($this->table . '.isHire', $data['isHire']);
        }
        
        if (isset($data['verificationCode'])) {
            $this->db->where($this->table . '.verificationCode', $data['verificationCode']);
        }

        if (isset($data['updatedDate'])) {
            $this->db->where($this->table . '.updatedDate', $data['updatedDate']);
        }

        if (isset($data['createdDate'])) {
            $this->db->where($this->table . '.createdDate', $data['createdDate']);
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
            $this->db->order_by($this->table . '.id', 'DESC');
        }elseif (isset($data['isOldestFirst']) && $data['isOldestFirst'] == true) {
            $this->db->order_by($this->table . '.id', 'ASC');
        }

        if (isset($data['getInRadius']) && !empty($data['getInRadius'])) {
            $this->db->order_by(" distance ASC");
        }

        if (isset($data['latestFirst']) && $data['latestFirst'] == true) {
            $this->db->order_by($this->table . '.createdDate', 'DESC');
        }
        
        if (isset($data['orderby']) && !empty($data['orderby'])) {
            $this->db->order_by($this->table . '.'.$data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id', 'DESC');
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return (isset($row->totalRecord) && !empty($row->totalRecord) ? $row->totalRecord : "0");
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

        if (isset($data['userId'])) {
            $modelData['userId'] = $data['userId'];
        }

        if (isset($data['categoryId'])) {
            $modelData['categoryId'] = $data['categoryId'];
        }

        if (isset($data['userCardId'])) {
            $modelData['userCardId'] = $data['userCardId'];
        }

        if (isset($data['name'])) {
            $modelData['name'] = $data['name'];
        }

        if (isset($data['price'])) {
            $modelData['price'] = $data['price'];
        }

        if (isset($data['ownTransportation'])) {
            $modelData['ownTransportation'] = $data['ownTransportation'];
        }

        if (isset($data['nonSmoker'])) {
            $modelData['nonSmoker'] = $data['nonSmoker'];
        }

        if (isset($data['currentEmployment'])) {
            $modelData['currentEmployment'] = $data['currentEmployment'];
        }

        if (isset($data['minExperience'])) {
            $modelData['minExperience'] = $data['minExperience'];
        }

        if (isset($data['yearExperience'])) {
            $modelData['yearExperience'] = $data['yearExperience'];
        }

        if (isset($data['location'])) {
            $modelData['location'] = $data['location'];
        }

        if (isset($data['latitude'])) {
            $modelData['latitude'] = $data['latitude'];
        }

        if (isset($data['longitude'])) {
            $modelData['longitude'] = $data['longitude'];
        }

        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
        }

        if (isset($data['isJob'])) {
            $modelData['isJob'] = $data['isJob'];
        }

        if (isset($data['isHire'])) {
            $modelData['isHire'] = $data['isHire'];
        }

        if (isset($data['verificationCode'])) {
            $modelData['verificationCode'] = $data['verificationCode'];
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
        
        if (empty($id) && (!isset($data['userIds']) && empty($data['userIds']))) {
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->table, $modelData);
        } else {
            if (isset($data['userIds']) && !empty($data['userIds'])) {
                $this->db->where('userId', $data['userIds']);
                $this->db->update($this->table, $modelData);
            } else {
                $this->db->insert($this->table, $modelData);
                $id = $this->db->insert_id();
            }
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return $id;
    }
}
