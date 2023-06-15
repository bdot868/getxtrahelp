<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class User_Job_Detail_Model extends CI_Model {

    public function __construct() {
        parent::__construct(); 
        $this->table = "tbl_user_job_detail";
        $this->tbl_user_job = "tbl_user_job";
        $this->tbl_user_job_apply = "tbl_user_job_apply";
    }

    public function get($data = [], $single = false, $num_rows = false) {
        $this->db->flush_cache();
        if ($num_rows) {
            $this->db->select('COUNT(' . $this->table . '.id) as totalRecord');
        } else {
            if(isset($data['apiResponse'])){
                $this->db->select($this->table . '.id as userJobDetailId');
                $this->db->select($this->table . '.jobId');
                $this->db->select($this->table . '.startTime');
                $this->db->select($this->table . '.endTime');
                $this->db->select($this->table . '.caregiverStartingTime');
                $this->db->select($this->table . '.requestStartTime ');
                $this->db->select($this->table . '.requestEndTime');
            }else{
                $this->db->select($this->table . '.*');
                $this->db->select('FROM_UNIXTIME(' . $this->table . '.createdDate, "%d-%m-%Y %H:%i") as createdDate');
            }    
        }

        $this->db->from($this->table);
        if (isset($data['getDatabefore48HoursOfStartJob']) && $data['getDatabefore48HoursOfStartJob'] == true) {
            $this->db->select($this->tbl_user_job.'.userId');
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select($this->tbl_user_job.'.userCardId');
            $this->db->select($this->tbl_user_job.'.price');
            $this->db->select($this->tbl_user_job_apply.'.userId as caregiverId');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status = 1','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
            // Advance hours of 48 hours
            $this->db->where($this->table . '.startTime < UNIX_TIMESTAMP()+172800');
        }

        if (isset($data['getDatabefore30MintsOfStartJob']) && $data['getDatabefore30MintsOfStartJob'] == true) {
            $this->db->select($this->tbl_user_job.'.userId');
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select($this->tbl_user_job_apply.'.userId as caregiverId');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status = 1','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
            
            // Advance job of 30 to 35 minutes
            $this->db->where($this->table . '.startTime >= UNIX_TIMESTAMP()+1800');
            $this->db->where($this->table . '.startTime <= UNIX_TIMESTAMP()+2100');
        }

        if (isset($data['getJobCompletedTimingData']) && !empty($data['getJobCompletedTimingData'])) {
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status IN(1,3)','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.userId = '.$data['getJobCompletedTimingData'].' AND '.$this->tbl_user_job_apply.'.status = 1','inner');

            $this->db->select('TIME_FORMAT(SEC_TO_TIME(SUM('.$this->table . '.endTime - '.$this->table . '.startTime)),"%H hrs %i mins") as totalWorkTime');
            $this->db->group_by($this->tbl_user_job_apply . '.userId');
        }

        if (isset($data['getFeatureData']) && $data['getFeatureData'] == true) {
            $this->db->where($this->table . '.startTime > UNIX_TIMESTAMP()');
        }

        if (isset($data['getJobJobDetail']) && $data['getJobJobDetail'] == true) {
            $this->db->select($this->tbl_user_job.'.userId');
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select($this->tbl_user_job_apply.'.userId as caregiverId');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status IN(1,3)','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
        }

        if (isset($data['getDataMaxTimingOfOngoingJob']) && $data['getDataMaxTimingOfOngoingJob'] == true) {
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status = 1','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
            
            $this->db->select('('.$this->table . '.endTime - '.$this->table . '.startTime)  as totalSeconds');
            //$this->db->where('UNIX_TIMESTAMP() BETWEEN '.$this->table . '.startTime AND '.$this->table. '.endTime');
            $this->db->order_by('totalSeconds', 'DESC');
        }

        if (isset($data['getDataOfOngoingJobEvery30Mint']) && !empty($data['getDataOfOngoingJobEvery30Mint'])) {
            $this->db->select($this->tbl_user_job.'.userId');
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select($this->tbl_user_job_apply.'.userId as caregiverId');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status = 1','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
           
            // Ongoing job of 30 minutes
            $this->db->group_start();
                foreach($data['getDataOfOngoingJobEvery30Mint'] as $value){
                    $this->db->or_where('(FROM_UNIXTIME('.$this->table.'.startTime +'.$value.', "%Y-%m-%d %H:%i") = DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i"))');
                }
            $this->db->group_end();
            $this->db->where('UNIX_TIMESTAMP() BETWEEN '.$this->table . '.startTime AND '.$this->table. '.endTime');
        }

        if (isset($data['getDataOfOngoingJobStarting30Mint']) && $data['getDataOfOngoingJobStarting30Mint'] == true) {
            $this->db->select($this->tbl_user_job.'.userId');
            $this->db->select($this->tbl_user_job.'.name as jobName');
            $this->db->select($this->tbl_user_job_apply.'.userId as caregiverId');
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status = 1','inner');
            $this->db->join($this->tbl_user_job_apply, $this->tbl_user_job_apply.'.jobId = '.$this->table.'.jobId AND '.$this->tbl_user_job_apply.'.isHire = 1 AND '.$this->tbl_user_job_apply.'.status = 1','inner');
           
            // Ongoing job of 30 minutes
            $this->db->where('FROM_UNIXTIME('.$this->table.'.startTime + 1800, "%Y-%m-%d %H:%i") = DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i")');
            $this->db->where('UNIX_TIMESTAMP() BETWEEN '.$this->table . '.startTime AND '.$this->table. '.endTime');
        }

        if((isset($data['checkBookedSlot']['startDateTime']) && !empty($data['checkBookedSlot']['startDateTime'])) && (isset($data['checkBookedSlot']['endDateTime']) && !empty($data['checkBookedSlot']['endDateTime']))){
            
            $this->db->join($this->tbl_user_job, $this->tbl_user_job.'.id = '.$this->table.'.jobId AND '.$this->tbl_user_job.'.userId = '.$data['checkBookedSlot']['userId'].' AND '.$this->tbl_user_job.'.isHire = 1 AND '.$this->tbl_user_job.'.status=1','inner');
            
            $this->db->group_start();
                $this->db->group_start();
                    $this->db->where($this->table . '.startTime > '.$data['checkBookedSlot']['startDateTime']);
                    $this->db->where($this->table . '.startTime < '.$data['checkBookedSlot']['endDateTime']);
                $this->db->group_end();

                $this->db->or_group_start();
                    $this->db->where($this->table . '.endTime > '.$data['checkBookedSlot']['startDateTime']);
                    $this->db->where($this->table . '.endTime < '.$data['checkBookedSlot']['endDateTime']);
                $this->db->group_end();
                
                $this->db->group_start();
                    $this->db->where($this->table . '.startTime < '.$data['checkBookedSlot']['startDateTime']);
                    $this->db->where($this->table . '.endTime > '.$data['checkBookedSlot']['startDateTime']);
                $this->db->group_end();
            
                $this->db->or_group_start();
                    $this->db->where($this->table . '.startTime < '.$data['checkBookedSlot']['endDateTime']);
                    $this->db->where($this->table . '.endTime > '.$data['checkBookedSlot']['endDateTime']);
                $this->db->group_end();

                $this->db->or_group_start();
                    $this->db->where($this->table . '.startTime = '.$data['checkBookedSlot']['startDateTime']);
                    $this->db->where($this->table . '.endTime = '.$data['checkBookedSlot']['endDateTime']);
                $this->db->group_end();
            $this->db->group_end();
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

        if (isset($data['jobId'])) {
            $this->db->where($this->table . '.jobId', $data['jobId']);
        }

        if (isset($data['startTime'])) {
            $this->db->where($this->table . '.startTime', $data['startTime']);
        }

        if (isset($data['endTime'])) {
            $this->db->where($this->table . '.endTime', $data['endTime']);
        }

        if (isset($data['caregiverStartingTime'])) {
            $this->db->where($this->table . '.caregiverStartingTime', $data['caregiverStartingTime']);
        }

        if (isset($data['userPaymentStatus'])) {
            $this->db->where($this->table . '.userPaymentStatus', $data['userPaymentStatus']);
        }

        if (isset($data['caregiverPaymentStatus'])) {
            $this->db->where($this->table . '.caregiverPaymentStatus', $data['caregiverPaymentStatus']);
        }

        if (isset($data['requestStartTime'])) {
            $this->db->where($this->table . '.requestStartTime', $data['requestStartTime']);
        }

        if (isset($data['requestEndTime'])) {
            $this->db->where($this->table . '.requestEndTime', $data['requestEndTime']);
        }

        if (isset($data['requestTimeStatus'])) {
            $this->db->where($this->table . '.requestTimeStatus', $data['requestTimeStatus']);
        }

        if (isset($data['requestTimeUserPaymentStatus'])) {
            $this->db->where($this->table . '.requestTimeUserPaymentStatus', $data['requestTimeUserPaymentStatus']);
        }

        if (isset($data['isJobStatus'])) {
            $this->db->where($this->table . '.isJobStatus', $data['isJobStatus']);
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

        if (isset($data['startTime'])) {
            $modelData['startTime'] = $data['startTime'];
        }

        if (isset($data['endTime'])) {
            $modelData['endTime'] = $data['endTime'];
        }

        if (isset($data['caregiverStartingTime'])) {
            $modelData['caregiverStartingTime'] = $data['caregiverStartingTime'];
        }

        if (isset($data['userPaymentStatus'])) {
            $modelData['userPaymentStatus'] = $data['userPaymentStatus'];
        }

        if (isset($data['caregiverPaymentStatus'])) {
            $modelData['caregiverPaymentStatus'] = $data['caregiverPaymentStatus'];
        }

        if (isset($data['requestStartTime'])) {
            $modelData['requestStartTime'] = $data['requestStartTime'];
        }

        if (isset($data['requestEndTime'])) {
            $modelData['requestEndTime'] = $data['requestEndTime'];
        }

        if (isset($data['requestTimeStatus'])) {
            $modelData['requestTimeStatus'] = $data['requestTimeStatus'];
        }

        if (isset($data['requestTimeUserPaymentStatus'])) {
            $modelData['requestTimeUserPaymentStatus'] = $data['requestTimeUserPaymentStatus'];
        }

        if (isset($data['isJobStatus'])) {
            $modelData['isJobStatus'] = $data['isJobStatus'];
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
