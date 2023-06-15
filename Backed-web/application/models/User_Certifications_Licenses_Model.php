<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Certifications_Licenses_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_certifications_licenses";
        $this->tbl_licence_type = "tbl_licence_type";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userCertificationsLicensesId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.licenceTypeId');
                $this->db->select($this->table . '.licenceName');
                $this->db->select($this->table . '.licenceNumber');
                $this->db->select($this->table . '.issueDate');
                $this->db->select($this->table . '.expireDate');
                $this->db->select($this->table . '.description');
                $this->db->select($this->table . '.licenceImage as licenceImageName');
                $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->table . ".licenceImage) as licenceImageUrl", FALSE);
                $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->table . ".licenceImage) as licenceImageThumbUrl", FALSE);
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select($this->table . '.licenceImage as licenceImageName');
                $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->table . ".licenceImage) as licenceImageUrl", FALSE);
                $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->table . ".licenceImage) as licenceImageThumbUrl", FALSE);
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if (isset($data['getLicenceTypeData']) && $data['getLicenceTypeData'] == true) {
            $this->db->select($this->tbl_licence_type . '.name as licenceTypeName');
            $this->db->join($this->tbl_licence_type, $this->tbl_licence_type.'.id = '.$this->table.'.licenceTypeId AND '.$this->tbl_licence_type.'.status = 1','left');
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
            $this->db->like($this->table . '.licenceName', $search);
            $this->db->group_end();
        }

        if (isset($data['userId'])) {
            $this->db->where($this->table . '.userId', $data['userId']);
        }

        if (isset($data['licenceTypeId'])) {
            $this->db->where($this->table . '.licenceTypeId', $data['licenceTypeId']);
        }

        if (isset($data['licenceName'])) {
            $this->db->where($this->table . '.licenceName', $data['licenceName']);
        }

        if (isset($data['licenceNumber'])) {
            $this->db->where($this->table . '.licenceNumber', $data['licenceNumber']);
        }

        if (isset($data['issueDate'])) {
            $this->db->where($this->table . '.issueDate', $data['issueDate']);
        }

        if (isset($data['expireDate'])) {
            $this->db->where($this->table . '.expireDate', $data['expireDate']);
        }

        if (isset($data['licenceImage'])) {
            $this->db->where($this->table . '.licenceImage', $data['licenceImage']);
        }

        if (isset($data['description'])) {
            $this->db->where($this->table . '.description', $data['description']);
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

        if (isset($data['licenceTypeId'])) {
            $modelData['licenceTypeId'] = $data['licenceTypeId'];
        }

        if (isset($data['licenceName'])) {
            $modelData['licenceName'] = $data['licenceName'];
        }

        if (isset($data['licenceNumber'])) {
            $modelData['licenceNumber'] = $data['licenceNumber'];
        }

        if (isset($data['issueDate'])) {
            $modelData['issueDate'] = $data['issueDate'];
        }

        if (isset($data['expireDate'])) {
            $modelData['expireDate'] = $data['expireDate'];
        }

        if (isset($data['licenceImage'])) {
            $modelData['licenceImage'] = $data['licenceImage'];
        }

        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
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
