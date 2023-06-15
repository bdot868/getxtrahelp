<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Card_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_user_card";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userCardId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.customerId');
                $this->db->select($this->table . '.cardId');
                $this->db->select($this->table . '.cardBrand');
                $this->db->select($this->table . '.holderName');
                $this->db->select($this->table . '.last4');
                $this->db->select($this->table . '.month');
                $this->db->select($this->table . '.year');
            }else{
                $this->db->select($this->table . '.*');
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
		
        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }
        
        if (isset($data['customerId'])) {
            $this->db->where($this->table . '.customerId', $data['customerId']);
        }
        
        if (isset($data['cardId'])) {
            $this->db->where($this->table . '.cardId', $data['cardId']);
        }
        
        if (isset($data['cardBrand'])) {
            $this->db->where($this->table . '.cardBrand', $data['cardBrand']);
        }
        
        if (isset($data['holderName'])) {
            $this->db->where($this->table . '.holderName', $data['holderName']);
        }
        
        if (isset($data['last4'])) {
            $this->db->where($this->table . '.last4', $data['last4']);
        }
        
        if (isset($data['month'])) {
            $this->db->where($this->table . '.month', $data['month']);
        }
        
        if (isset($data['year'])) {
            $this->db->where($this->table . '.year', $data['year']);
        }
        
        if (isset($data['cardJson'])) {
            $this->db->where($this->table . '.cardJson', $data['cardJson']);
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
		
        if (isset($data['orderby']) && !empty($data['orderby'])) {
            $this->db->order_by($data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id', 'DESC');
        }
		
        $query = $this->db->get();
		
        if ($num_rows) {
            $row = $query->row();
            return (isset($row->totalRecord) ? $row->totalRecord : 0);
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
		
        if (isset($data['customerId'])) {
            $modelData['customerId'] = $data['customerId'];
        }
		
        if (isset($data['cardId'])) {
            $modelData['cardId'] = $data['cardId'];
        }
		
        if (isset($data['cardBrand'])) {
            $modelData['cardBrand'] = $data['cardBrand'];
        }
		
        if (isset($data['holderName'])) {
            $modelData['holderName'] = $data['holderName'];
        }
		
        if (isset($data['last4'])) {
            $modelData['last4'] = $data['last4'];
        }
		
        if (isset($data['month'])) {
            $modelData['month'] = $data['month'];
        }
		
        if (isset($data['year'])) {
            $modelData['year'] = $data['year'];
        }
		
        if (isset($data['cardJson'])) {
            $modelData['cardJson'] = $data['cardJson'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }
        
        if (isset($data['updatedDate'])) {
            $modelData['updatedDate'] = $data['updatedDate'];
        } elseif (!empty($id)) {
            $modelData['updatedDate'] = time();
        }

        if (empty($id) && (!isset($data['userIds']) && empty($data['userIds']))) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }

        if(empty($modelData)){
            return false;
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
            }else{
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
