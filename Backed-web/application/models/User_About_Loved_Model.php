<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_About_Loved_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_about_loved";
        $this->tbl_loved_disabilities_type = "tbl_loved_disabilities_type";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userAboutLovedId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.lovedDisabilitiesTypeId');
                $this->db->select($this->table . '.lovedAboutDesc');
                $this->db->select($this->table . '.lovedOtherCategoryText');
                $this->db->select($this->table . '.lovedBehavioral');
                $this->db->select($this->table . '.lovedVerbal');
                $this->db->select($this->table . '.allergies');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if (isset($data['getLovedDisabilitiesTypeData']) && $data['getLovedDisabilitiesTypeData'] == true) {
            $this->db->select($this->tbl_loved_disabilities_type . '.name as lovedDisabilitiesTypeName');
            $this->db->join($this->tbl_loved_disabilities_type, $this->tbl_loved_disabilities_type.'.id = '.$this->table.'.lovedDisabilitiesTypeId AND '.$this->tbl_loved_disabilities_type.'.status = 1','left');
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }

        if (isset($data['search']) && !empty($data['search'])) {
            $search = trim($data['search']);
            $this->db->group_start();
            $this->db->like($this->table . '.lovedAboutDesc', $search);
            $this->db->like($this->table . '.allergies', $search);
            $this->db->group_end();
        }

        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }

        if (isset($data['lovedDisabilitiesTypeId'])) {
            $this->db->where($this->table . '.lovedDisabilitiesTypeId', $data['lovedDisabilitiesTypeId']);
        }

        if (isset($data['lovedAboutDesc'])) {
            $this->db->where($this->table . '.lovedAboutDesc', $data['lovedAboutDesc']);
        }

        if (isset($data['lovedOtherCategoryText'])) {
            $this->db->where($this->table . '.lovedOtherCategoryText', $data['lovedOtherCategoryText']);
        }

        if (isset($data['lovedBehavioral'])) {
            $this->db->where($this->table . '.lovedBehavioral', $data['lovedBehavioral']);
        }

        if (isset($data['lovedVerbal'])) {
            $this->db->where($this->table . '.lovedVerbal', $data['lovedVerbal']);
        }

        if (isset($data['allergies'])) {
            $this->db->where($this->table . '.allergies', $data['allergies']);
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

        if (isset($data['lovedDisabilitiesTypeId'])) {
            $modelData['lovedDisabilitiesTypeId'] = $data['lovedDisabilitiesTypeId'];
        }

        if (isset($data['lovedAboutDesc'])) {
            $modelData['lovedAboutDesc'] = $data['lovedAboutDesc'];
        }

        if (isset($data['lovedOtherCategoryText'])) {
            $modelData['lovedOtherCategoryText'] = $data['lovedOtherCategoryText'];
        }

        if (isset($data['lovedBehavioral'])) {
            $modelData['lovedBehavioral'] = $data['lovedBehavioral'];
        }

        if (isset($data['lovedVerbal'])) {
            $modelData['lovedVerbal'] = $data['lovedVerbal'];
        }

        if (isset($data['allergies'])) {
            $modelData['allergies'] = $data['allergies'];
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

    public function delete($userId=0){
        $this->db->where('userId', $userId);
        $this->db->delete($this->table);
    }
}
