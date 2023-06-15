<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Question_Answer_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job_question_answer";
        $this->tbl_user_job_question = "tbl_user_job_question";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobQuestionAnswerId');
                $this->db->select($this->table . '.userId');
                $this->db->select($this->table . '.jobId');
                $this->db->select($this->table . '.userJobQuestionId');
                $this->db->select($this->table . '.userJobApplyId');
                $this->db->select($this->table . '.answer');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);

        if(isset($data['questionData']) && $data['questionData'] == true){
            $this->db->select($this->tbl_user_job_question . '.question');

            $this->db->join($this->tbl_user_job_question, $this->table.'.userJobQuestionId = '.$this->tbl_user_job_question.'.id AND '.$this->tbl_user_job_question.'.status = 1','left');
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

        if (isset($data['jobId'])) {
            $this->db->where($this->table . '.jobId', $data['jobId']);
        }

        if (isset($data['userJobQuestionId'])) {
            $this->db->where($this->table . '.userJobQuestionId', $data['userJobQuestionId']);
        }

        if (isset($data['userJobApplyId'])) {
            $this->db->where($this->table . '.userJobApplyId', $data['userJobApplyId']);
        }

        if (isset($data['answer'])) {
            $this->db->where($this->table . '.answer', $data['answer']);
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

        if (isset($data['jobId'])) {
            $modelData['jobId'] = $data['jobId'];
        }

        if (isset($data['userJobQuestionId'])) {
            $modelData['userJobQuestionId'] = $data['userJobQuestionId'];
        }

        if (isset($data['userJobApplyId'])) {
            $modelData['userJobApplyId'] = $data['userJobApplyId'];
        }

        if (isset($data['answer'])) {
            $modelData['answer'] = $data['answer'];
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
