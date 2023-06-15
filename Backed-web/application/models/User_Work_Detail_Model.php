<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Work_Detail_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_work_detail";
        $this->tbl_work_speciality = "tbl_work_speciality";
        $this->tbl_work_method_of_transportation = "tbl_work_method_of_transportation";
        $this->tbl_work_disabilities_willing_type = "tbl_work_disabilities_willing_type";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userWorkDetailId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.workSpecialityId');
                $this->db->select($this->table . '.maxDistanceTravel');
                $this->db->select($this->table . '.workMethodOfTransportationId');
                $this->db->select($this->table . '.workDisabilitiesWillingTypeId');
                $this->db->select($this->table . '.experienceOfYear');
                $this->db->select($this->table . '.inspiredYouBecome');
                $this->db->select($this->table . '.bio');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if (isset($data['getExtraData']) && $data['getExtraData'] == true) {
            $this->db->select($this->tbl_work_speciality . '.name as workSpecialityName');
            $this->db->join($this->tbl_work_speciality, $this->tbl_work_speciality.'.id = '.$this->table.'.workSpecialityId AND '.$this->tbl_work_speciality.'.status = 1','left');

            $this->db->select($this->tbl_work_method_of_transportation . '.name as workMethodOfTransportationName');
            $this->db->join($this->tbl_work_method_of_transportation, $this->tbl_work_method_of_transportation.'.id = '.$this->table.'.workMethodOfTransportationId AND '.$this->tbl_work_method_of_transportation.'.status = 1','left');

            $this->db->select($this->tbl_work_disabilities_willing_type . '.name as workDisabilitiesWillingTypeName');
            $this->db->join($this->tbl_work_disabilities_willing_type, $this->tbl_work_disabilities_willing_type.'.id = '.$this->table.'.workDisabilitiesWillingTypeId AND '.$this->tbl_work_disabilities_willing_type.'.status = 1','left');
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }

        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }

        if (isset($data['workSpecialityId'])) {
            $this->db->where($this->table . '.workSpecialityId', $data['workSpecialityId']);
        }

        if (isset($data['maxDistanceTravel'])) {
            $this->db->where($this->table . '.maxDistanceTravel', $data['maxDistanceTravel']);
        }

        if (isset($data['workMethodOfTransportationId'])) {
            $this->db->where($this->table . '.workMethodOfTransportationId', $data['workMethodOfTransportationId']);
        }

        if (isset($data['workDisabilitiesWillingTypeId'])) {
            $this->db->where($this->table . '.workDisabilitiesWillingTypeId', $data['workDisabilitiesWillingTypeId']);
        }

        if (isset($data['experienceOfYear'])) {
            $this->db->where($this->table . '.experienceOfYear', $data['experienceOfYear']);
        }

        if (isset($data['inspiredYouBecome'])) {
            $this->db->where($this->table . '.inspiredYouBecome', $data['inspiredYouBecome']);
        }

        if (isset($data['bio'])) {
            $this->db->where($this->table . '.bio', $data['bio']);
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

        if (isset($data['userId'])) {
            $modelData['userId'] = $data['userId'];
        }

        if (isset($data['workSpecialityId'])) {
            $modelData['workSpecialityId'] = $data['workSpecialityId'];
        }

        if (isset($data['maxDistanceTravel'])) {
            $modelData['maxDistanceTravel'] = $data['maxDistanceTravel'];
        }

        if (isset($data['workMethodOfTransportationId'])) {
            $modelData['workMethodOfTransportationId'] = $data['workMethodOfTransportationId'];
        }

        if (isset($data['workDisabilitiesWillingTypeId'])) {
            $modelData['workDisabilitiesWillingTypeId'] = $data['workDisabilitiesWillingTypeId'];
        }

        if (isset($data['experienceOfYear'])) {
            $modelData['experienceOfYear'] = $data['experienceOfYear'];
        }

        if (isset($data['inspiredYouBecome'])) {
            $modelData['inspiredYouBecome'] = $data['inspiredYouBecome'];
        }

        if (isset($data['bio'])) {
            $modelData['bio'] = $data['bio'];
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
