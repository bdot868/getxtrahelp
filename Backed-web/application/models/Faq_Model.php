<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Faq_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_faq";      
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


        if (isset($data['search']) && !empty($data['search'])) {
            $this->db->like($this->table . '.name', trim($data['search']));
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }
		
		if(isset($data['like']) && isset($data['value'])) {
            $this->db->like($this->table . '.'.$data['like'], $data['value']);
        }

        if (isset($data['type'])) {
           
            if (is_array($data['type'])) {
                $this->db->where_in($this->table . '.type', $data['type']);
            } else {
                $this->db->where($this->table . '.type', $data['type']);
            }
        }
              
        
        if (isset($data['name'])) {
            $this->db->where($this->table . '.name', $data['name']);
        }

        if (isset($data['description'])) {
            $this->db->where($this->table . '.description', $data['description']);
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

        if (isset($data['type'])) {
            $modelData['type'] = $data['type'];
        }

        if (isset($data['name'])) {
            $modelData['name'] = $data['name'];
        }
        
        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($modelData)) {
            return false;
        }
        
        if(empty($id)){
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
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

   

 
}
