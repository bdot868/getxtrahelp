<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Apply_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job_apply";
        $this->tbl_users = "tbl_users";
        $this->tbl_user_work_job_category = "tbl_user_work_job_category";
        $this->tbl_job_category = "tbl_job_category";
        $this->tbl_user_review = "tbl_user_review";
        $this->tbl_user_job = "tbl_user_job";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobApplyId');
                $this->db->select($this->table . '.jobId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.isHire');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if (isset($data['getUserJobStatusWise']) && !empty($data['getUserJobStatusWise'])) {
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId','inner');
            if (is_array($data['getUserJobStatusWise'])) {
                $this->db->where_in($this->tbl_user_job . '.status', $data['getUserJobStatusWise']);
            } else {
                $this->db->where($this->tbl_user_job . '.status', $data['getUserJobStatusWise']);
            }
        }

        if (isset($data['getUserData']) && $data['getUserData'] == true) {
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as userFullName');
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->tbl_users.".image) as profileImageUrl", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->tbl_users.".image) as profileImageThumbUrl", FALSE);
            $this->db->join($this->tbl_users, $this->tbl_users.'.id = '.$this->table.'.userId AND '.$this->tbl_users.'.status = 1','inner');
       
            $this->db->select("(SELECT 
                GROUP_CONCAT(".$this->tbl_job_category.".name SEPARATOR', ') 
                FROM ".$this->tbl_user_work_job_category." 
                INNER JOIN ".$this->tbl_job_category." ON ".$this->tbl_job_category.".id = ".$this->tbl_user_work_job_category.".jobCategoryId AND ".$this->tbl_job_category.".status = 1 
                WHERE ".$this->tbl_user_work_job_category.".userId = ".$this->table.".userId 
                AND ".$this->tbl_user_work_job_category.".status = 1) as categoryNames");

            $this->db->select("(SELECT 
                IF(".$this->tbl_user_review.".id > 0,ROUND(SUM(".$this->tbl_user_review.".rating) / COUNT(".$this->tbl_user_review.".id),2), 0)
                FROM ".$this->tbl_user_review." 
                WHERE ".$this->tbl_user_review.".userIdTo = ".$this->table.".userId 
                AND ".$this->tbl_user_review.".status = 1) as caregiverRatingAverage");
        }

        if(isset($data['getJobData']) && $data['getJobData'] == true){
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as userFullName');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId','inner');
            $this->db->join($this->tbl_users, $this->tbl_users.'.id = '.$this->tbl_user_job.'.userId AND '.$this->tbl_users.'.status = 1','inner');   
        }

        if(isset($data['getCaregiverDetails'])){
            
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as caregiverFullName');
            $this->db->select($this->tbl_users.'.email');
            $this->db->select($this->tbl_users.'.phone');
            $this->db->select($this->tbl_users.'.address');
            $this->db->select( $this->tbl_users.'.age');
            $this->db->select( $this->tbl_users.'.gender');
            $this->db->join($this->tbl_users, $this->table.'.userId = '.$this->tbl_users.'.id and '.$this->tbl_users.'.status = 1','inner');
        }
 
        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }
        
        if (isset($data['jobId'])) {
            $this->db->where($this->table . '.jobId', $data['jobId']);
        }

        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }

        if (isset($data['isHire'])) {
            $this->db->where($this->table . '.isHire', $data['isHire']);
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

        if (isset($data['jobId'])) {
            $modelData['jobId'] = $data['jobId'];
        }

        if (isset($data['userId'])) {
            $modelData['userId'] = $data['userId'];
        }

        if (isset($data['isHire'])) {
            $modelData['isHire'] = $data['isHire'];
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
        
        if (empty($id) && (!isset($data['jobIds']) && empty($data['jobIds']))) {
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->table, $modelData);
        } else {
            if (isset($data['jobIds']) && !empty($data['jobIds'])) {
                $this->db->where('jobId', $data['jobIds']);
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
