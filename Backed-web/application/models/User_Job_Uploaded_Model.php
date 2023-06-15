<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Uploaded_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job_uploaded_media";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobMediaId');
                $this->db->select($this->table . '.jobId');
                $this->db->select($this->table . '.jobDetailId');
                $this->db->select($this->table . '.isVideo');
                $this->db->select($this->table . '.mediaName');
                $this->db->select($this->table . '.videoImage');
                $this->db->select("CONCAT('".base_url(getenv('UPLOAD_URL'))."', ".$this->table.".mediaName) as mediaNameUrl", FALSE);
                $this->db->select("CONCAT('".base_url(getenv('THUMBURL'))."', mediaName) as mediaNameThumbUrl", FALSE);
                $this->db->select("IF(".$this->table.".videoImage !='', CONCAT('".base_url(getenv('UPLOAD_URL'))."', ".$this->table.".videoImage), '') as videoImageUrl", FALSE);
                $this->db->select("IF(".$this->table.".videoImage !='', CONCAT('".base_url(getenv('THUMBURL'))."', videoImage), '') as videoImageThumbUrl", FALSE);
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
                $this->db->select("CONCAT('".base_url(getenv('UPLOAD_URL'))."', ".$this->table.".mediaName) as mediaNameUrl", FALSE);
                $this->db->select("CONCAT('".base_url(getenv('THUMBURL'))."', mediaName) as mediaNameThumbUrl", FALSE);
            }    
        }

        $this->db->from($this->table);

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

        if (isset($data['jobDetailId'])) {
            $this->db->where($this->table . '.jobDetailId', $data['jobDetailId']);
        }

        if (isset($data['mediaName'])) {
            $this->db->where($this->table . '.mediaName', $data['mediaName']);
        }
		
        if (isset($data['videoImage'])) {
            $this->db->where($this->table . '.videoImage', $data['videoImage']);
        }
		
        if (isset($data['isVideo'])) {
            $this->db->where($this->table . '.isVideo', $data['isVideo']);
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

        if (isset($data['jobDetailId'])) {
            $modelData['jobDetailId'] = $data['jobDetailId'];
        }

        if (isset($data['mediaName'])) {
            $modelData['mediaName'] = $data['mediaName'];
        }
        
        if (isset($data['videoImage'])) {
            $modelData['videoImage'] = $data['videoImage'];
        }
        
        if (isset($data['isVideo'])) {
            $modelData['isVideo'] = $data['isVideo'];
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
