<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class StripeConnect_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_stripe_connect";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            $this->db->select($this->table . '.*');
            $this->db->select('FROM_UNIXTIME('.$this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
        }

        $this->db->from($this->table);

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
        
        if (isset($data['accId'])) {
            $this->db->where($this->table . '.accId', $data['accId']);
        }

        if (isset($data['loginLink'])) {
            $this->db->where($this->table . '.loginLink', $data['loginLink']);
        }

        if (isset($data['loginId'])) {
            $this->db->where($this->table . '.loginId', $data['loginId']);
        }

        if (isset($data['isPayment'])) {
            $this->db->where($this->table . '.isPayment', $data['isPayment']);
        }

        if (isset($data['isPayout'])) {
            $this->db->where($this->table . '.isPayout', $data['isPayout']);
        }

        if (isset($data['isBankDetail'])) {
            $this->db->where($this->table . '.isBankDetail', $data['isBankDetail']);
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
            $this->db->order_by($data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id', 'DESC');
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return $row->totalRecord;
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
        
        if (isset($data['accId'])) {
            $modelData['accId'] = $data['accId'];
        }

        if (isset($data['loginLink'])) {
            $modelData['loginLink'] = $data['loginLink'];
        }

        if (isset($data['loginId'])) {
            $modelData['loginId'] = $data['loginId'];
        }
        

        if (isset($data['isPayment'])) {
            $modelData['isPayment'] = $data['isPayment'];
        }
        

        if (isset($data['isPayout'])) {
            $modelData['isPayout'] = $data['isPayout'];
        }
        

        if (isset($data['isBankDetail'])) {
            $modelData['isBankDetail'] = $data['isBankDetail'];
        }
        
        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($modelData)) {
            return false;
        }
        
        if (empty($id) && (!isset($data['userIds']) && empty($data['userIds']))) {
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        
        $this->db->flush_cache();

        if (!empty($id)) {
            $this->db->trans_begin();
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
        if (!empty($id)) {
            $this->db->trans_commit();
        }
        
        return $id;
    }
}
