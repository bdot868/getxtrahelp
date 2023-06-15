<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Availability_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_user_availability";
    }
    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userAvailabilityId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.startDateTime');
                $this->db->select($this->table . '.endDateTime');
                $this->db->select($this->table . '.timing');
                $this->db->select($this->table . '.isBooked');
            }else{
                $this->db->select($this->table . '.*');
            }
        }

        $this->db->from($this->table);

        if (isset($data['getFutureAvailability']) && $data['getFutureAvailability'] == true) {
            $this->db->where($this->table . '.endDateTime > UNIX_TIMESTAMP()');
        }

        if (isset($data['checkdate']) && !empty($data['checkdate'])) {
            $this->db->where('DATE(FROM_UNIXTIME('.$this->table . '.startDateTime, "%Y-%m-%d")) =', $data['checkdate']['startDate']);
            //$this->db->where('DATE(FROM_UNIXTIME('.$this->table . '.endDateTime, "%Y-%m-%d")) =', $data['checkdate']['endDate']);
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

        if (isset($data['startDateTime'])) {
            $this->db->where($this->table . '.startDateTime', $data['startDateTime']);
        }

        if (isset($data['endDateTime'])) {
            $this->db->where($this->table . '.endDateTime', $data['endDateTime']);
        }

        if (isset($data['timing'])) {
            $this->db->where($this->table . '.timing', $data['timing']);
        }

        if (isset($data['isBooked'])) {
            $this->db->where($this->table . '.isBooked', $data['isBooked']);
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
            $this->db->order_by($this->table . '.'.$data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id', 'ASC');
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

        if (isset($data['startDateTime'])) {
            $modelData['startDateTime'] = $data['startDateTime'];
        }

        if (isset($data['endDateTime'])) {
            $modelData['endDateTime'] = $data['endDateTime'];
        }
        
        if (isset($data['timing'])) {
            $modelData['timing'] = $data['timing'];
        }
        
        if (isset($data['isBooked'])) {
            $modelData['isBooked'] = $data['isBooked'];
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
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->table, $modelData);
        } else {
            if (isset($data['userIds']) && !empty($data['userIds'])) {
                $this->db->where('userId', $data['userIds']);
                if (isset($data['notbooked']) && $data['notbooked'] == true) {
                    $this->db->where('isBooked !=', 1);
                }
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