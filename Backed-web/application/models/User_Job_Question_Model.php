<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Question_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job_question";
        $this->tbl_user_job_question_answer = "tbl_user_job_question_answer";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {

            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobQuestionId');
                $this->db->select($this->table . '.jobId');
                $this->db->select($this->table . '.question');
            }else{

                if(isset($data['getCaregiverQueAns']) && !empty($data['getCaregiverQueAns'])){
                    $this->db->select($this->tbl_user_job_question_answer.'.answer');
                    $this->db->from($this->tbl_user_job_question_answer);
                    $this->db->where($this->tbl_user_job_question_answer.'.jobId = "'.$data['jobId'].'"');
                    $this->db->where($this->tbl_user_job_question_answer.'.userJobApplyId = "'.$data['userJobApplyId'].'"');
                    $this->db->where($this->tbl_user_job_question_answer.'.userJobQuestionId = '.$this->table.'.id');
                    $sub_query = $this->db->get_compiled_select();                 
                }
                
                $this->db->select($this->table . '.*');

                if(isset($data['getCaregiverQueAns']) && !empty($data['getCaregiverQueAns'])){
                    $this->db->select("($sub_query) as answer");
                }
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);
        
        if (isset($data['getJonQestionAnswer']) && !empty($data['getJonQestionAnswer'])) {
            $this->db->select($this->tbl_user_job_question_answer . '.answer');
            $this->db->join($this->tbl_user_job_question_answer, $this->table.'.id = '.$this->tbl_user_job_question_answer.'.userJobQuestionId AND '.$this->table.'.jobId = '.$this->tbl_user_job_question_answer.'.jobId AND '.$this->tbl_user_job_question_answer.'.userId = '.$data['getJonQestionAnswer'].' AND '.$this->tbl_user_job_question_answer.'.status = 1','left');
        }

        if (isset($data['id']) && !empty($data['id'])) {
            if (is_array($data['id'])) {
                $this->db->where_in($this->table . '.id', $data['id']);
            } else {
                $this->db->where($this->table . '.id', $data['id']);
            }
        }
        
        if (isset($data['jobId'])) {
            $this->db->where($this->table . '.jobId', $data['jobId']);
        }

        if (isset($data['question'])) {
            $this->db->where($this->table . '.question', $data['question']);
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

        if (isset($data['jobId'])) {
            $modelData['jobId'] = $data['jobId'];
        }

        if (isset($data['question'])) {
            $modelData['question'] = $data['question'];
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
        
        if (empty($id) && (!isset($data['jobIds']) && empty($data['jobIds']))) {
            $modelData['createdDate'] = isset($data['createdDate']) && !empty($data['createdDate']) ? $data['createdDate'] : time();
        }
        
        $this->db->flush_cache();
        $this->db->trans_begin();

        if (!empty($id)) {
            $this->db->where('id', $id);
            $this->db->update($this->table, $modelData);
        } else {
            if (isset($data['jobIds']) && !empty($data['jobIds'])) {
                $this->db->where('jobId', $data['jobIds']);
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
