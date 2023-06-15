<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Resources_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_resources";
        $this->tbl_resources_category = "tbl_resources_category";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as resourceId');
                $this->db->select($this->table . '.categoryId');
                $this->db->select($this->table . '.title');
                $this->db->select($this->table . '.description');
                $this->db->select($this->tbl_resources_category . '.name as categoryName');
                $this->db->select($this->table . '.createdDate');
            }else{
                $this->db->select($this->table . '.*');
            }
            //$this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, \'%m %b %Y\') as createdDateFormat');
            $this->db->select('FROM_UNIXTIME(' . $this->table . ".createdDate, '%d-%b-%Y') as createdDateFormat");
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->table . ".image) as imageUrl", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', ".$this->table.".image) as thumbImageUrl", FALSE);
        }
        
        $this->db->join($this->tbl_resources_category, $this->tbl_resources_category.'.id = '.$this->table.'.categoryId AND '.$this->tbl_resources_category.'.status = 1','left');

        $this->db->from($this->table);

        if (isset($data['search']) && !empty($data['search'])) {
            $search = trim($data['search']);
            $this->db->group_start();
            $this->db->like($this->table . '.title', $search);
            $this->db->or_like($this->tbl_resources_category . '.name', $search);
            $this->db->group_end();
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }

        if (isset($data['notid']) && !empty($data['notid'])) {
            $this->db->where($this->table . '.id !=', $data['notid']);
        }
        
        if (isset($data['categoryId']) && !empty($data['categoryId'])) {
            $this->db->where($this->table . '.categoryId', $data['categoryId']);
        }
        
        if (isset($data['title'])) {
            $this->db->where($this->table . '.title', $data['title']);
        }

        if (isset($data['slug'])) {
            $this->db->where($this->table . '.slug', $data['slug']);
        }

        if (isset($data['description'])) {
            $this->db->where($this->table . '.description', $data['description']);
        }

        if (isset($data['metatitle'])) {
            $this->db->where($this->table . '.metatitle', $data['metatitle']);
        }
        if (isset($data['metakeyword'])) {
            $this->db->where($this->table . '.metakeyword', $data['metakeyword']);
        }
        if (isset($data['metadescription'])) {
            $this->db->where($this->table . '.metadescription', $data['metadescription']);
        }
        
        if (isset($data['image'])) {
            $this->db->where($this->table . '.image', $data['image']);
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
            $this->db->order_by($this->table .'.'.$data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        } else {
            $this->db->order_by($this->table . '.id','DESC');
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

        if (isset($data['categoryId'])) {
            $modelData['categoryId'] = ucwords($data['categoryId']);
        }

        if (isset($data['title'])) {
            $modelData['title'] = ucwords($data['title']);
        }
        
        if (isset($data['slug'])) {
            $modelData['slug'] = $data['slug'];
        }

        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
        }

        if (isset($data['metatitle'])) {
            $modelData['metatitle'] = $data['metatitle'];
        }
        
        if (isset($data['metakeyword'])) {
            $modelData['metakeyword'] = $data['metakeyword'];
        }

        if (isset($data['metadescription'])) {
            $modelData['metadescription'] = $data['metadescription'];
        }

        if (isset($data['image'])) {
            $modelData['image'] = ucwords($data['image']);
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (isset($data['updatedDate'])) {
            $modelData['updatedDate'] = $data['updatedDate'];
        } elseif (!empty($id)) {
            $modelData['updatedDate'] = time();
        }
        
        if(empty($id)){
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
        }else{
            if (isset($data['createdDate']) && !empty($data['createdDate'])) {
                $modelData['createdDate'] = $data['createdDate'];
            }
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

    public function checkSlug($data = [], $single = false) {

        $this->db->flush_cache();
    
        $this->db->select($this->table . '.*');
        $this->db->select('FROM_UNIXTIME('.$this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
        $this->db->select("CONCAT('".base_url(UPLOAD_URL)."', ".$this->table.".image) as fullimage", FALSE);
        $this->db->select("CONCAT('".base_url($this->config->item('thumbUrl'))."', image) as thumbImage", FALSE);
    

        $this->db->from($this->table);

        if (isset($data['id']) && !empty($data['id'])) {            
                $this->db->where($this->table . '.id!=', $data['id']);
        }

        if (isset($data['slug'])) {
            $this->db->where($this->table . '.slug', $data['slug']);
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->table . '.status', $data['status']);
            } else {
                $this->db->where($this->table . '.status', $data['status']);
            }
        }

        $query = $this->db->get();

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }
}
