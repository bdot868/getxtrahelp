<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Chat_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->table = "tbl_chat_message";
        $this->chat_group = "tbl_chat_group";
        $this->tbl_chat_group_members = "tbl_chat_group_members";
        $this->chat_message_status = "tbl_chat_message_status";
        $this->users = "tbl_users";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            $this->db->select($this->table . '.*');
            $this->db->select($this->chat_message_status . '.status as readStatus');
            $this->db->select('CONCAT('.$this->users . '.firstName," ",'.$this->users . '.lastName) as senderName');
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->users . ".image) as senderImage", FALSE);

            $this->db->select('FROM_UNIXTIME('.$this->table . '.createdDate, "%d-%m-%Y") as date');
            $this->db->select('FROM_UNIXTIME('.$this->table . '.createdDate, "%H.%i") as time',false);

            if (isset($data['getFormatedDate']) && !empty($data['getFormatedDate'])) {
                $this->db->select("IF(".$this->table.".createdDate < 1,0,DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['getFormatedDate']) ? $data['getFormatedDate'] : getenv('SYSTEMTIMEZON')) . "'), '%a, %d %M %Y, %H.%i')) AS createdDateMain",false);
            }
        }

        $this->db->from($this->table);
        $this->db->join($this->users, $this->users . '.id = ' . $this->table . '.sender');
        $this->db->join($this->chat_message_status, $this->chat_message_status . ".messageId = " . $this->table . ".id AND " . $this->chat_message_status . ".userId = " . $this->users . ".id", "left");

        if (isset($data['totalMessage']) && !empty($data['totalMessage'])) {
            $this->db->join($this->tbl_chat_group_members, $this->tbl_chat_group_members . '.groupId = ' . $this->table . '.groupId');
            $this->db->where($this->tbl_chat_group_members . '.userId', $data['totalMessage']);
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }

        if (isset($data['message'])) {
            $this->db->where($this->table . '.message', $data['message']);
        }

        if (isset($data['type'])) {
            $this->db->where($this->table . '.type', $data['type']);
        }

        if (isset($data['groupId']) && !empty($data['groupId'])) {
            $this->db->where($this->table . '.groupId', $data['groupId']);
        }

        if (isset($data['sender']) && !empty($data['sender'])) {
            $this->db->where($this->table . '.sender', $data['sender']);
        }

        if (isset($data['attachmentRealName']) && !empty($data['attachmentRealName'])) {
            $this->db->where($this->table . '.attachmentRealName', $data['attachmentRealName']);
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
            return empty($row) ? 0 : $row->totalRecord;
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

        if (isset($data['message']) && !empty($data['message'])) {
            $modelData['message'] = $data['message'];
        }

        if (isset($data['type']) && !empty($data['type'])) {
            $modelData['type'] = $data['type'];
        }

        if (isset($data['groupId']) && !empty($data['groupId'])) {
            $modelData['groupId'] = $data['groupId'];
        }

        if (isset($data['sender']) && !empty($data['sender'])) {
            $modelData['sender'] = $data['sender'];
        }

        if (isset($data['attachmentRealName']) && !empty($data['attachmentRealName'])) {
            $modelData['attachmentRealName'] = $data['attachmentRealName'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($modelData)) {
            return false;
        }
        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
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

    public function getGroups($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->chat_group . '.id) as totalRecord');
        } else {
            $this->db->select($this->chat_group . '.*');
            //$this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->chat_group . ".image) as image", FALSE);
            //$this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->chat_group . ".image) as image", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->chat_group . ".image) as thumbImage", FALSE);
            if (!isset($data['chatInbox']) && empty($data['chatInbox'])) {
                $this->db->select("COUNT(" . $this->tbl_chat_group_members . ".id) as totalMembers", FALSE);
            }
            if (isset($data['chatInbox']) && !empty($data['chatInbox'])) {
                $this->db->select($this->table . '.message, max(' . $this->table . '.createdDate) as messageDate, max(' . $this->table . '.id) as messageId');
            }
        }

        if (isset($data['withFormatedDate']) && !empty($data['withFormatedDate'])) {
            $this->db->select("DATE_FORMAT(CONVERT_TZ(from_unixtime(" . $this->chat_group . ".createdDate), @@session.time_zone, '".$data['withFormatedDate']."'), '%D %b %Y at %l %p') as createdDate", FALSE);
        }

        $this->db->from($this->chat_group);
        $this->db->join($this->tbl_chat_group_members, $this->tbl_chat_group_members . '.groupId = ' . $this->chat_group . '.id');

        if (isset($data['chatInbox']) && !empty($data['chatInbox'])) {
            $this->db->join($this->table, $this->table . '.groupId = ' . $this->chat_group . '.id', 'LEFT');
        }

        if (isset($data['userId']) && !empty($data['userId'])) {
            if (is_array($data['userId'])) {
                $this->db->where_in($this->tbl_chat_group_members . '.userId', $data['userId']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.userId', $data['userId']);
            }
        } elseif (isset($data['userAdmin']) && !empty($data['userAdmin'])) {
            $this->db->where($this->tbl_chat_group_members . '.userId', $data['userAdmin']);
            $this->db->where($this->tbl_chat_group_members . '.isAdmin', 1);
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->chat_group . '.id', $data['id']);
            } else {
                $this->db->where($this->chat_group . '.id', $data['id']);
            }
        }

        if (isset($data['name']) && !empty($data['name'])) {
            $this->db->where($this->chat_group . '.name', $data['name']);
        }

        if (isset($data['nameLike']) && !empty($data['nameLike'])) {
            $this->db->like($this->chat_group . '.name', $data['nameLike']);
        }

        if (isset($data['type'])) {
            if (is_array($data['type'])) {
                $this->db->where_in($this->chat_group . '.type', $data['type']);
            } else {
                $this->db->where($this->chat_group . '.type', $data['type']);
            }
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->chat_group . '.status', $data['status']);
            } else {
                $this->db->where($this->chat_group . '.status', $data['status']);
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
            $this->db->group_by($this->chat_group . ".id");
        }

        if (isset($data['orderby']) && !empty($data['orderby'])) {
            $this->db->order_by($data['orderby'], (isset($data['orderstate']) && !empty($data['orderstate']) ? $data['orderstate'] : 'DESC'));
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return empty($row) ? 0 : $row->totalRecord;
        }

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }

    public function setGroupData($data, $id = 0) {
        if (empty($data)) {
            return false;
        }
        $modelData = array();

        if (isset($data['name'])) {
            $modelData['name'] = $data['name'];
        }

        if (isset($data['image'])) {
            $modelData['image'] = $data['image'];
        }

        if (isset($data['type'])) {
            $modelData['type'] = $data['type'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($modelData)) {
            return false;
        }
        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->chat_group, $modelData);
        } else {
            $this->db->insert($this->chat_group, $modelData);
            $id = $this->db->insert_id();
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return $id;
    }

    public function getGroupMembers($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->tbl_chat_group_members . '.id) as totalRecord');
        } else {
            $this->db->select($this->tbl_chat_group_members . '.*');
            $this->db->select('CONCAT('.$this->users . '.firstName," ",'.$this->users . '.lastName) as name');
            $this->db->select("CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->users . ".image) as image", FALSE);
            $this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->users . ".image) as thumbImage", FALSE);
        }
        $this->db->from($this->tbl_chat_group_members);
        $this->db->join($this->users, $this->users . '.id = ' . $this->tbl_chat_group_members . '.userId');
        $this->db->join($this->chat_group, $this->chat_group . '.id = ' . $this->tbl_chat_group_members . '.groupId');

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->tbl_chat_group_members . '.id', $data['id']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.id', $data['id']);
            }
        }

        if (isset($data['groupId']) && !empty($data['groupId'])) {
            if (is_array($data['groupId'])) {
                $this->db->where_in($this->tbl_chat_group_members . '.groupId', $data['groupId']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.groupId', $data['groupId']);
            }
        }

        if (isset($data['userId']) && !empty($data['userId'])) {
            if (is_array($data['userId'])) {
                $this->db->where_in($this->tbl_chat_group_members . '.userId', $data['userId']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.userId', $data['userId']);
            }
        }

        if (isset($data['userNotin']) && !empty($data['userNotin'])) {
            if (is_array($data['userNotin'])) {
                $this->db->where_not_in($this->tbl_chat_group_members . '.userId', $data['userNotin']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.userId !=', $data['userNotin']);
            }
        }

        if (isset($data['isAdmin'])) {
            $this->db->where($this->tbl_chat_group_members . '.isAdmin', $data['isAdmin']);
        }

        if (isset($data['nameLike']) && !empty($data['nameLike'])) {
            $this->db->group_start();
            $this->db->or_like($this->users . '.firstName', $data['nameLike']);
            $this->db->or_like($this->users . '.lastName', $data['nameLike']);
            $this->db->group_end();
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->tbl_chat_group_members . '.status', $data['status']);
            } else {
                $this->db->where($this->tbl_chat_group_members . '.status', $data['status']);
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
            $this->db->order_by('name', 'ASC');
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return empty($row) ? 0 : $row->totalRecord;
        }

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }

    public function setGroupMember($data, $id = 0) {
        if (empty($data)) {
            return false;
        }
        $modelData = array();

        if (isset($data['groupId'])) {
            $modelData['groupId'] = $data['groupId'];
        }

        if (isset($data['userId'])) {
            $modelData['userId'] = $data['userId'];
        }

        if (isset($data['isAdmin'])) {
            $modelData['isAdmin'] = $data['isAdmin'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }

        if (empty($modelData)) {
            return false;
        }
        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->tbl_chat_group_members, $modelData);
        } else {
            $this->db->insert($this->tbl_chat_group_members, $modelData);
            $id = $this->db->insert_id();
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return $id;
    }

    public function deleteNotInMember($group, $members) {
        if (!is_array($members) || empty($members)) {
            return false;
        }
        $this->db->reset_query();
        $this->db->flush_cache();
        $this->db->where('groupId', $group);
        $this->db->where_not_in('userId', $members);
        $this->db->update($this->tbl_chat_group_members, ['status' => 0]);
        $this->db->reset_query();
    }

    public function getMessageStatus($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->chat_message_status . '.id) as totalRecord');
        } else {
            $this->db->select($this->chat_message_status . '.*');
        }

        $this->db->from($this->chat_message_status);

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->chat_message_status . '.id', $data['id']);
            } else {
                $this->db->where($this->chat_message_status . '.id', $data['id']);
            }
        }

        if (isset($data['messageId']) && !empty($data['messageId'])) {
            if (is_array($data['messageId'])) {
                $this->db->where_in($this->chat_message_status . '.messageId', $data['messageId']);
            } else {
                $this->db->where($this->chat_message_status . '.messageId', $data['messageId']);
            }
        }

        if (isset($data['userId']) && !empty($data['userId'])) {
            if (is_array($data['userId'])) {
                $this->db->where_in($this->chat_message_status . '.userId', $data['userId']);
            } else {
                $this->db->where($this->chat_message_status . '.userId', $data['userId']);
            }
        }

        if (isset($data['createdDate'])) {
            $this->db->where($this->chat_message_status . '.createdDate', $data['createdDate']);
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->chat_message_status . '.status', $data['status']);
            } else {
                $this->db->where($this->chat_message_status . '.status', $data['status']);
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
            $this->db->order_by($this->chat_message_status . '.id', 'DESC');
        }

        $query = $this->db->get();

        if ($num_rows) {
            $row = $query->row();
            return empty($row) ? 0 : $row->totalRecord;
        }

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }

    public function setMessageStatus($data, $id = 0) {
        if (empty($data)) {
            return false;
        }
        $modelData = array();

        if (isset($data['messageId']) && !empty($data['messageId'])) {
            $modelData['messageId'] = $data['messageId'];
        }

        if (isset($data['userId']) && !empty($data['userId'])) {
            $modelData['userId'] = $data['userId'];
        }

        if (isset($data['status'])) {
            $modelData['status'] = $data['status'];
        }
        
        if (isset($data['groupId'])) {
            $modelData['groupId'] = $data['groupId'];
        }

        if (empty($modelData)) {
            return false;
        }

        if (isset($data['updatedDate'])) {
            $modelData['updatedDate'] = $data['updatedDate'];
        } elseif (!empty($id)) {
            $modelData['updatedDate'] = time();
        }

        if (empty($id)) {
            $modelData['createdDate'] = !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->chat_message_status, $modelData);
        } else {
            $this->db->insert($this->chat_message_status, $modelData);
            $id = $this->db->insert_id();
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            return false;
        }

        $this->db->trans_commit();
        return $id;
    }
    
    /*
    public function chatInbox($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        $this->db->reset_query();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->chat_group . '.id) as totalRecord');
        } else {
            $this->db->select($this->chat_group . '.id');
            $this->db->select("IF(". $this->chat_group .".type = 1, ".$this->users . ".name, ". $this->chat_group .".name) as name", false);
            $this->db->select("CONCAT('".base_url(getenv('THUMBURL'))."', IF(". $this->chat_group .".type = 1, ". $this->users .".image, ". $this->chat_group .".image)) as image", false);
            $this->db->select("CONCAT('".base_url(getenv('THUMBURL'))."', IF(". $this->chat_group .".type = 1, ". $this->users .".image, ". $this->chat_group .".image)) as thumbImage", false);
            $this->db->select("IF(". $this->chat_group .".type = 1, ". $this->users .".location, '') as address", false);
            if(isset($data['userId']) && !empty($data['userId'])){
                $this->db->select("unreadMessages", false);
                $this->db->select("IF(" . $this->table . ".type = 1, " . $this->table . ".message, IF(" . $this->table . ".type = 2, 'Image', IF(" . $this->table . ".type = 3, 'Video', ''))) as message", false);
                $this->db->select($this->table . ".type");
                $this->db->select($this->table . ".id as messageId");
                $this->db->select($this->table . ".sender");
                $this->db->select("IF(".$this->table . ".createdDate IS NULL, ".$this->chat_group . ".createdDate,".$this->table . ".createdDate) as messageDate", FALSE);
                if (isset($data['withFormatedDate']) && !empty($data['withFormatedDate'])) {
                    $this->db->select("DATE_FORMAT(CONVERT_TZ(from_unixtime(IF(".$this->table . ".createdDate IS NULL, ".$this->chat_group . ".createdDate,".$this->table . ".createdDate)), @@session.time_zone, '" . $data['withFormatedDate'] . "'), '%D %b %Y at %l %p') as createdDate", FALSE);
                }
            }
        }
        
        $this->db->from($this->chat_group);
        $this->db->join($this->tbl_chat_group_members, $this->tbl_chat_group_members . '.groupId = ' . $this->chat_group . '.id AND '.$this->tbl_chat_group_members . '.status = 1', 'LEFT');
        $this->db->join($this->tbl_chat_group_members ." as allMembers", 'allMembers.groupId = ' . $this->chat_group . '.id AND allMembers.status = 1', 'LEFT');
        $this->db->join($this->users, "IF(". $this->chat_group .".type = 1, (allMembers.userId = ".$this->users.".id AND ".$this->users.".id != ".$data['userId']."), 0)", "LEFT", FALSE);
        if(isset($data['userId']) && !empty($data['userId'])){
            $this->db->join("(SELECT count(" . $this->chat_message_status . ".id) as unreadMessages, " . $this->chat_message_status . ".groupId FROM " . $this->chat_message_status . " WHERE " . $this->chat_message_status . ".status < 3 AND " . $this->chat_message_status . ".userId = " . $data['userId'] . " GROUP BY " . $this->chat_message_status . ".groupId ) as " . $this->chat_message_status, $this->chat_group . ".id = " . $this->chat_message_status . ".groupId ", 'LEFT', FALSE);
            $this->db->join($this->table, $this->table . '.groupId = ' . $this->chat_group . '.id', 'LEFT');
            $this->db->join($this->table . " as tempMessage", "(" . $this->table . ".groupId = tempMessage.groupId AND " . $this->table . ".id < tempMessage.id) ", 'LEFT', FALSE);
            $this->db->where('tempMessage.id IS NULL');
            $this->db->where($this->tbl_chat_group_members . '.userId', $data['userId']);
        }
        
        if (isset($data['name']) && !empty($data['name'])) {
            $this->db->where($this->chat_group . '.name', $data['name']);
        }

        if (isset($data['nameLike']) && !empty($data['nameLike'])) {
            $this->db->like($this->chat_group . '.name', $data['nameLike']);
        }
        
        if (isset($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->chat_group . '.id', $data['id']);
            } else {
                $this->db->where($this->chat_group . '.id', $data['id']);
            }
        }
        
        if (isset($data['type'])) {
            if (is_array($data['type'])) {
                $this->db->where_in($this->chat_group . '.type', $data['type']);
            } else {
                $this->db->where($this->chat_group . '.type', $data['type']);
            }
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->chat_group . '.status', $data['status']);
            } else {
                $this->db->where($this->chat_group . '.status', $data['status']);
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
            $this->db->group_by($this->chat_group . ".id");
        }

       
        $this->db->order_by($this->table .".createdDate", 'DESC');

        $query = $this->db->get();
        $this->db->reset_query();
        $this->db->flush_cache();
        if ($num_rows) {
            $row = $query->row();
            return empty($row) ? 0 : $row->totalRecord;
        }

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }
        
        return $query->result();
    }
    */
    
   public function chatInbox($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        $this->db->reset_query();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->chat_group . '.id) as totalRecord');
        } else {
            $this->db->select($this->chat_group . '.id');
            $this->db->select($this->chat_group . '.type as groupType');

            $this->db->select("IF(" . $this->chat_group . ".type = 1, " . $this->users . ".id, 0) as friendUserId", false);
            $this->db->select("IF(" . $this->chat_group . ".type = 1, CONCAT(" . $this->users . ".firstName ,' '," . $this->users . ".lastName) , " . $this->chat_group . ".name) as name", false);
            $this->db->select("IF(" . $this->chat_group . ".type = 1, " . $this->users . ".isOnline, 0) as isOnline", false);
            //$this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', IF(" . $this->chat_group . ".type = 1, " . $this->users . ".image, " . $this->chat_group . ".image)) as image", false);
            //$this->db->select("CONCAT('" . base_url(getenv('THUMBURL')) . "', IF(" . $this->chat_group . ".type = 1, " . $this->users . ".image, " . $this->chat_group . ".image)) as thumbImage", false);
            $this->db->select("IF(" . $this->chat_group . ".type = 1, CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->users . ".image), substring_index(group_concat( CONCAT('" . base_url(getenv('UPLOAD_URL')) . "', " . $this->users . ".image) SEPARATOR ','), ',', 3)) as image", false);
            $this->db->select("IF(" . $this->chat_group . ".type = 1, CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->users . ".image), substring_index(group_concat( CONCAT('" . base_url(getenv('THUMBURL')) . "', " . $this->users . ".image) SEPARATOR ','), ',', 3)) as thumbImage", false);
            if (isset($data['userId']) && !empty($data['userId'])) {
                $this->db->select("unreadMessages", false);
                $this->db->select("IF(" . $this->table . ".type = 1, " . $this->table . ".message, IF(" . $this->table . ".type = 2, 'Image', IF(" . $this->table . ".type = 3, 'Video', IF(" . $this->table . ".type = 4, 'Suggested a caregiver', IF(" . $this->table . ".type = 5, 'Attachment File', ''))))) as message", false);
                $this->db->select($this->table . ".type");
                $this->db->select($this->table . ".id as messageId");
                $this->db->select($this->table . ".sender");
                $this->db->select($this->table . ".status as messageStatus");
                $this->db->select("IF(" . $this->table . ".createdDate IS NULL, " . $this->chat_group . ".createdDate," . $this->table . ".createdDate) as messageDate", FALSE);
                if (isset($data['withFormatedDate']) && !empty($data['withFormatedDate'])) {
                    //$this->db->select("DATE_FORMAT(CONVERT_TZ(from_unixtime(IF(" . $this->table . ".createdDate IS NULL, " . $this->chat_group . ".createdDate," . $this->table . ".createdDate)), @@session.time_zone, '" . $data['withFormatedDate'] . "'), '%D %b %Y at %l %p') as createdDateFormat", FALSE);
                    $this->db->select("DATE_FORMAT(CONVERT_TZ(from_unixtime(IF(" . $this->table . ".createdDate IS NULL, " . $this->chat_group . ".createdDate," . $this->table . ".createdDate)), @@session.time_zone, '" . $data['withFormatedDate'] . "'), '%H.%i') as time", FALSE);
                    //$this->db->select("CONCAT(IF(DATE_FORMAT(CONVERT_TZ(current_date, '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), '%Y-%m-%d') = DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), '%Y-%m-%d'), 'Today at', IF(subdate(DATE_FORMAT(CONVERT_TZ(current_date, '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), '%Y-%m-%d'), 1) = DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), '%Y-%m-%d'), 'Yesterday at', DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), '%b %d, %Y'))), DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(" . $this->table . ".createdDate), '" . getenv('SYSTEMTIMEZON') . "', '" . (!empty($data['withDateFormate']) ? $data['withDateFormate'] : getenv('SYSTEMTIMEZON')) . "'), ' %l:%i %p')) as formatedDate", FALSE);
                }
            }
            if (isset($data['search']) && !empty($data['search'])) {
                $this->db->group_start();
                    $this->db->or_like("IF(" . $this->chat_group . ".type = 1," . $this->users . ".firstName , " . $this->chat_group . ".name)", $data['search']);
                    $this->db->or_like("IF(" . $this->chat_group . ".type = 1," . $this->users . ".lastName , " . $this->chat_group . ".name)", $data['search']);
                $this->db->group_end();
            }
        }

        $this->db->from($this->chat_group);
        $this->db->join($this->tbl_chat_group_members, $this->tbl_chat_group_members . '.groupId = ' . $this->chat_group . '.id AND ' . $this->tbl_chat_group_members . '.status = 1', 'LEFT');
        $this->db->join($this->tbl_chat_group_members . " as allMembers", 'allMembers.groupId = ' . $this->chat_group . '.id AND allMembers.status = 1', 'LEFT');
        $this->db->join($this->users, "IF(" . $this->chat_group . ".type = 1, (allMembers.userId = " . $this->users . ".id AND " . $this->users . ".id != " . $data['userId'] . "), (allMembers.userId = " . $this->users . ".id))", "LEFT", FALSE);

        if (isset($data['userId']) && !empty($data['userId'])) {
            $this->db->join("(SELECT count(" . $this->chat_message_status . ".id) as unreadMessages, " . $this->chat_message_status . ".groupId FROM " . $this->chat_message_status . " WHERE " . $this->chat_message_status . ".status < 3 AND " . $this->chat_message_status . ".userId = " . $data['userId'] . " GROUP BY " . $this->chat_message_status . ".groupId ) as " . $this->chat_message_status, $this->chat_group . ".id = " . $this->chat_message_status . ".groupId ", 'LEFT', FALSE);
            $this->db->join($this->table, $this->table . '.groupId = ' . $this->chat_group . '.id', 'LEFT');
            //This for get data 1 or more message avaialble in group
            if (isset($data['getNotEmptyGroup']) && $data['getNotEmptyGroup'] == true) {
                $this->db->where($this->table . '.status', 1);
            }
            // ./ This for get data 1 or more message avaialble in group
            $this->db->join($this->table . " as tempMessage", "(" . $this->table . ".groupId = tempMessage.groupId AND " . $this->table . ".id < tempMessage.id) ", 'LEFT', FALSE);
            $this->db->where('tempMessage.id IS NULL');
            $this->db->where($this->tbl_chat_group_members . '.userId', $data['userId']);
        }

        if (isset($data['name']) && !empty($data['name'])) {
            //$this->db->where($this->chat_group . '.name', $data['name']);
            $this->db->where("(IF(" . $this->chat_group . ".type = 1, CONCAT(" . $this->users . ".firstName ,' '," . $this->users . ".lastName), " . $this->chat_group . ".name) = '" . $data['name'] . "' )", null, false);
        }

        if (isset($data['nameLike']) && !empty($data['nameLike'])) {
            //$this->db->like($this->chat_group . '.name', $data['nameLike']);
            $this->db->where("(IF(" . $this->chat_group . ".type = 1, CONCAT(" . $this->users . ".firstName ,' '," . $this->users . ".lastName), " . $this->chat_group . ".name) LIKE '%" . $data['nameLike'] . "%'  ESCAPE '!' )", null, false);
        }

        if (isset($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->chat_group . '.id', $data['id']);
            } else {
                $this->db->where($this->chat_group . '.id', $data['id']);
            }
        }

        if (isset($data['type'])) {
            if (is_array($data['type'])) {
                $this->db->where_in($this->chat_group . '.type', $data['type']);
            } else {
                $this->db->where($this->chat_group . '.type', $data['type']);
            }
        }

        if (isset($data['status'])) {
            if (is_array($data['status'])) {
                $this->db->where_in($this->chat_group . '.status', $data['status']);
            } else {
                $this->db->where($this->chat_group . '.status', $data['status']);
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
            $this->db->group_by($this->chat_group . ".id");
        }

        $this->db->order_by($this->table . ".createdDate", 'DESC');

        $query = $this->db->get();
        $this->db->reset_query();
        $this->db->flush_cache();
        if ($num_rows) {
            $row = $query->row();
            return empty($row) ? 0 : $row->totalRecord;
        }

        if ($single) {
            return $query->row();
        } elseif (isset($data['id']) && !empty($data['id']) && !is_array($data['id'])) {
            return $query->row();
        }

        return $query->result();
    }

    public function checkCreateGroupFromUser($data) {
        if (!isset($data['users']) || empty($data['users']) || !is_array($data['users'])) {
            return false;
        }
        $this->db->flush_cache();
        $this->db->reset_query();

        $this->db->select($this->chat_group . '.*');
        $this->db->from($this->chat_group);
        foreach ($data['users'] as $key => $value) {
            $this->db->join($this->tbl_chat_group_members . " as members{$key}", "members{$key}.groupId = " . $this->chat_group . ".id AND members{$key}.userId = {$value}");
        }
        $this->db->where('type', 1);
        $query = $this->db->get();
        $group = $query->row();
        $this->db->reset_query();

        if (!empty($group)) {
            if (!$group->status && isset($data['setActive']) && !empty($data['setActive'])) {
                $this->setGroupData(["status" => 1], $group->id);
            }
            return $group->id;
        }

        $group = $this->setGroupData(["name" => "P2P", "type" => 1, "status" => 1]);
        foreach ($data['users'] as $key => $value) {
            $this->setGroupMember(["groupId" => $group, "userId" => $value, "isAdmin" => (empty($key) ? 1 : 0), "status" => 1]);
        }
        return $group;
    }

    public function setMessageRead($data) {
        if (!isset($data['groupId']) || empty($data['groupId']) || !isset($data['userId']) || empty($data['userId']) || !isset($data['messageId']) || empty($data['messageId'])) {
            return false;
        }
        $this->db->flush_cache();
        $this->db->reset_query();
        $query = $this->db->query("UPDATE " . $this->chat_message_status . " JOIN " . $this->table . " ON " . $this->table . ".id = " . $this->chat_message_status . ".messageId SET " . $this->chat_message_status . ".status = 3 WHERE " . $this->table . ".groupId = '" . $data['groupId'] . "' AND " . $this->chat_message_status . ".userId = '" . $data['userId'] . "' AND " . $this->chat_message_status . ".messageId >= '" . $data['messageId'] . "' AND " . $this->chat_message_status . ".status != 3");
        $this->db->reset_query();
        return $query;
    }
    
    public function removeChatData($groupId = ""){
        if(empty($groupId)){
            return false;
        }

        $this->db->reset_query();
        $this->db->flush_cache();
        $this->db->where('groupId', $groupId);
        $this->db->update($this->table, ['status' => 0]);
        $this->db->reset_query();
        
        $this->db->reset_query();
        $this->db->flush_cache();
        $this->db->where('groupId', $groupId);
        $this->db->update($this->chat_message_status, ['status' => 4]);
        $this->db->reset_query();
    }
}
