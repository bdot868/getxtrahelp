<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Transaction_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_user_transaction";
        $this->tbl_users = "tbl_users";
    }
    
    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userTransactionId');
                $this->db->select($this->table . '.userJobId');
                $this->db->select($this->table . '.type');
                $this->db->select($this->table . '.payType');
                $this->db->select($this->table . '.tranType');
                $this->db->select($this->table . '.amount');
                if(isset($data['userTranDateFormate']) && $data['userTranDateFormate'] == true){
                    $this->db->select('FROM_UNIXTIME('.$this->table . '.createdDate, "%h:%i %p") as userTransactionTime');
                }
            }else{
                $this->db->select($this->table . '.*');
            }
        }
        
        if(isset($data['sumAmount']) && $data['sumAmount'] == true){
            $this->db->select('SUM('.$this->table . '.amount) as totalAmount');
        }
   
        if(isset($data['getMonthYearData']) && !empty($data['getMonthYearData'])){
            $this->db->where('FROM_UNIXTIME('.$this->table . '.createdDate, "%Y-%m") =', $data['getMonthYearData']);
        }

        if(isset($data['getFormattedAmount']) && $data['getFormattedAmount'] == true){
            //$this->db->select('ABS(FORMAT('.$this->table . '.amount,2)) as amountFormatted');
            $this->db->select('CONCAT("$",FORMAT('.$this->table . '.amount,2)) as amountFormatted');
        }
        
        if(isset($data['getWalletBalanceData']) && $data['getWalletBalanceData'] == true){
            $this->db->select(' SUM(IF(' . $this->table . '.payType = 2 AND ' . $this->table . '.type = 1 AND ' . $this->table . '.tranType = 1, ' . $this->table . '.amount, 0)) as amount_in');
            $this->db->select(' SUM(IF(' . $this->table . '.payType = 3 AND ' . $this->table . '.type = 2 AND ' . $this->table . '.tranType = 2, ' . $this->table . '.amount, 0)) as amount_out');
            $this->db->select('(SUM(IF(' . $this->table . '.payType = 2 AND ' . $this->table . '.type = 1 AND ' . $this->table . '.tranType = 1, ' . $this->table . '.amount, 0)) - SUM(IF(' . $this->table .'.payType = 3 AND ' . $this->table . '.type = 2 AND ' . $this->table . '.tranType = 2, ' . $this->table . '.amount, 0))) as totalBalance');
            $this->db->group_by($this->table . '.userId');
        }

        $this->db->from($this->table);

        if (isset($data['search']) && !empty($data['search'])) {
            $search = trim($data['search']);
            $this->db->group_start();
                $this->db->like($this->table . '.id', $search);
                $this->db->or_like($this->table . '.amount', $search);
            $this->db->group_end();
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }
		
        if (isset($data['userId']) && !empty($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }
		
        if (isset($data['userIdTo'])) {
            $this->db->where($this->table . '.userIdTo', $data['userIdTo']);
        }
		
        if (isset($data['cardId'])) {
            $this->db->where($this->table . '.cardId', $data['cardId']);
        }
		
        if (isset($data['userJobId'])) {
            $this->db->where($this->table . '.userJobId', $data['userJobId']);
        }
		
        if (isset($data['userJobDetailId'])) {
            $this->db->where($this->table . '.userJobDetailId', $data['userJobDetailId']);
        }
		
        if (isset($data['stripeTransactionId'])) {
            $this->db->where($this->table . '.stripeTransactionId', $data['stripeTransactionId']);
        }
		
        if (isset($data['stripeTranJson'])) {
            $this->db->where($this->table . '.stripeTranJson', $data['stripeTranJson']);
        }
		
        if (isset($data['amount'])) {
            $this->db->where($this->table . '.amount', $data['amount']);
        }
		
        if (isset($data['refundAmount'])) {
            $this->db->where($this->table . '.refundAmount', $data['refundAmount']);
        }
		
        if (isset($data['type']) && !empty($data['type'])) {
            if (is_array($data['type'])) {
                $this->db->where_in($this->table . '.type', $data['type']);
            } else {
                $this->db->where($this->table . '.type', $data['type']);
            }
        }
		
        if (isset($data['payType']) && !empty($data['payType'])) {
            if (is_array($data['payType'])) {
                $this->db->where_in($this->table . '.payType', $data['payType']);
            } else {
                $this->db->where($this->table . '.payType', $data['payType']);
            }
        }
		
        if (isset($data['tranType']) && !empty($data['tranType'])) {
            if (is_array($data['tranType'])) {
                $this->db->where_in($this->table . '.tranType', $data['tranType']);
            } else {
                $this->db->where($this->table . '.tranType', $data['tranType']);
            }
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
        
        if (isset($data['userIdTo'])) {
            $modelData['userIdTo'] = $data['userIdTo'];
        }
        
        if (isset($data['cardId'])) {
            $modelData['cardId'] = $data['cardId'];
        }
        
        if (isset($data['userJobId'])) {
            $modelData['userJobId'] = $data['userJobId'];
        }
        
        if (isset($data['userJobDetailId'])) {
            $modelData['userJobDetailId'] = $data['userJobDetailId'];
        }
        
        if (isset($data['stripeTransactionId'])) {
            $modelData['stripeTransactionId'] = $data['stripeTransactionId'];
        }

        if (isset($data['stripeTranJson'])) {
            $modelData['stripeTranJson'] = $data['stripeTranJson'];
        }
        
        if (isset($data['amount'])) {
            $modelData['amount'] = $data['amount'];
        }
        
        if (isset($data['refundAmount'])) {
            $modelData['refundAmount'] = $data['refundAmount'];
        }
        
        if (isset($data['type'])) {
            $modelData['type'] = $data['type'];
        }
        
        if (isset($data['payType'])) {
            $modelData['payType'] = $data['payType'];
        }
        
        if (isset($data['tranType'])) {
            $modelData['tranType'] = $data['tranType'];
        }
        
        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (isset($data['updatedDate'])) {
            $modelData['updatedDate'] = $data['updatedDate'];
        } elseif (!empty($id)) {
            $modelData['updatedDate'] = time();
        }
        
        if (isset($data['createdDate']) && $data['createdDate'] == true) {
            $modelData['createdDate'] = time();
        }

        if (empty($id) && (!isset($data['userIds']) && empty($data['userIds']))) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        if (empty($modelData)) {
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
