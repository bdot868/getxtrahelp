<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Ticket_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_ticket";
        $this->tableTicketReply = "tbl_ticketreply";
        $this->tbl_users = "tbl_users";
    }
    public function get($data = [], $single = false, $num_rows = false) {
        // print_r($data);
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            $this->db->select($this->table . '.*');
            $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as name');
            $this->db->select($this->tbl_users . '.email');
            $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDateSimple');

            if (isset($data['formatedData']) && $data['formatedData']) {
                $this->db->select("IF(".$this->table.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS createdDate",false);
                $this->db->select("IF(".$this->table.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS updatedDate",false);
                $this->db->select("IF(".$this->table.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS closedDate",false);
                $this->db->select("IF(".$this->table.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS reopenDate",false);
            }
        }

        $this->db->from($this->table);
        $this->db->join($this->tbl_users, $this->table . ".userId = " . $this->tbl_users . ".id");
        if(isset($data['getRolewiseTicket'])) {
            if(isset($data['role']) && !empty($data['role'])) {
                $this->db->group_start();
                $this->db->where($this->tbl_users . '.role', $data['role']);
                $this->db->group_end();
            }
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

        if (isset($data['title'])) {
            $this->db->where($this->table . '.title', $data['title']);
        }

        if (isset($data['description'])) {
            $this->db->where($this->table . '.description', $data['description']);
        }

        if (isset($data['priority'])) {
            $this->db->where($this->table . '.priority', $data['priority']);
        }

        if (isset($data['closedDate'])) {
            $this->db->where($this->table . '.closedDate', $data['closedDate']);
        }

        if (isset($data['reopenDate'])) {
            $this->db->where($this->table . '.reopenDate', $data['reopenDate']);
        }

        if (isset($data['updatedDate'])) {
            $this->db->where($this->tbl_user_location . '.updatedDate', $data['updatedDate']);
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
        // echo "<pre>";
        // print_r($query->result());
        // die;
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

        if (isset($data['title'])) {
            $modelData['title'] = $data['title'];
        }

        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
        }

        if (isset($data['priority'])) {
            $modelData['priority'] = $data['priority'];
        }

        if (isset($data['closedDate'])) {
            $modelData['closedDate'] = $data['closedDate'];
        }

        if (isset($data['reopenDate'])) {
            $modelData['reopenDate'] = $data['reopenDate'];
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

    public function getTicketReply($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->tableTicketReply . '.id) as totalRecord');
        } else {
            $this->db->select($this->tableTicketReply . '.*');
            $this->db->select('IF('.$this->tableTicketReply.'.replyType=1,'.$this->tableTicketReply.'.description,CONCAT("'. base_url(getenv('UPLOAD_URL')).'",'.$this->tableTicketReply.'.description)) as description');
            if (isset($data['formatedData']) && $data['formatedData']) {
                $this->db->select("IF(".$this->tableTicketReply.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->tableTicketReply . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS createdDate",false);
                $this->db->select("IF(".$this->tableTicketReply.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->tableTicketReply . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%a, %d %M %Y, %H.%i')) AS createdDateMain",false);
                $this->db->select("IF(".$this->tableTicketReply.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->tableTicketReply . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%D %b %Y at %l:%i %p')) AS time",false);
                $this->db->select("IF(".$this->tableTicketReply.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->tableTicketReply . ".createdDate), @@session.time_zone, '" . $data['formatedData'] . "'), '%d/%m/%Y')) AS foramted_date",false);
            }
        }
        $this->db->select('CONCAT('.$this->tbl_users . '.firstName," ",'.$this->tbl_users . '.lastName) as senderName');
        $this->db->select($this->tbl_users . '.isOnline');
        $this->db->select("IF(".$this->tableTicketReply.".forReply=1,(SELECT CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->tbl_users . ".image) FROM " . $this->tbl_users . " WHERE " . $this->tbl_users . ".role=1 limit 1), CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->tbl_users . ".image)) AS profileimage");
        $this->db->select("IF(".$this->tableTicketReply.".forReply=1,(SELECT CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->tbl_users . ".image) FROM " . $this->tbl_users . " WHERE " . $this->tbl_users . ".role=1 limit 1), CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->tbl_users . ".image)) AS thumbprofileimage");
        $this->db->join($this->table, $this->tableTicketReply . ".ticketId =" . $this->table . ".id",'left');
        $this->db->join($this->tbl_users, $this->table . ".userId = " . $this->tbl_users . ".id",'left'); 

        $this->db->from($this->tableTicketReply);

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->tableTicketReply . '.id', $data['id']);
            } else {
                $this->db->where($this->tableTicketReply . '.id', $data['id']);
            }
        }

        if (isset($data['ticketId'])) {
            $this->db->where($this->tableTicketReply . '.ticketId', $data['ticketId']);
        }

        if (isset($data['forReply'])) {
            $this->db->where($this->tableTicketReply . '.forReply', $data['forReply']);
        }

        if (isset($data['replyType'])) {
            $this->db->where($this->tableTicketReply . '.replyType', $data['replyType']);
        }

        if (isset($data['description'])) {
            $this->db->where($this->tableTicketReply . '.description', $data['description']);
        }

        if (isset($data['createdDate'])) {
            $this->db->where($this->tableTicketReply . '.createdDate', $data['createdDate']);
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->tableTicketReply . '.status', $data['status']);
            } else {
                $this->db->where($this->tableTicketReply . '.status', $data['status']);
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
            $this->db->order_by($this->tableTicketReply . '.id', 'DESC');
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

    public function setTicketReplyData($data, $id = 0) {

        if (empty($data)) {
            return false;
        }

        $modelData = array();

        if (isset($data['ticketId'])) {
            $modelData['ticketId'] = $data['ticketId'];
        }

        if (isset($data['description'])) {
            $modelData['description'] = $data['description'];
        }

        if (isset($data['forReply'])) {
            $modelData['forReply'] = $data['forReply'];
        }

        if (isset($data['replyType'])) {
            $modelData['replyType'] = $data['replyType'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        if (empty($modelData)) {
            return false;
        }

        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->tableTicketReply, $modelData);
        } else {
            $this->db->insert($this->tableTicketReply, $modelData);
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
