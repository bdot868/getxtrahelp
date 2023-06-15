<?php

defined('BASEPATH') OR exit('No direct script access allowed');
/*
set_error_handler('exceptions_error_handler');

function exceptions_error_handler($severity, $message, $filename, $lineno) {
    $CI = &get_instance();
    $CI->load->model('SystemErrorLog_Model');
    $CI->SystemErrorLog_Model->addSystemErrorLog(['message' => $message, 'file' => $filename, 'line' => $lineno]);

    if (error_reporting() == 0) {
        return;
    }
    if (error_reporting() & $severity) {
        throw new ErrorException($message, 0, $severity, $filename, $lineno);
    }
}
*/
class Background extends CI_Controller {

    public function index() {
        
    }

    public function worker() {
        $CI = &get_instance();
        $CI->load->library('lib_gearman');
        $CI->load->model('Background_Model');
        $CI->load->model('Common_Model');

        $worker = $this->lib_gearman->gearman_worker();
        $this->lib_gearman->add_worker_function('transactionSuccessForJobPayment', 'Background::transactionSuccessForJobPayment');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobByCaregiver', 'Background::caregiverSubstituteJobByCaregiver');
        $this->lib_gearman->add_worker_function('cancelUpcomingJobByCaregiver', 'Background::cancelUpcomingJobByCaregiver');
        $this->lib_gearman->add_worker_function('addMoneyInYourWalletForUserJobPayment', 'Background::addMoneyInYourWalletForUserJobPayment');
        $this->lib_gearman->add_worker_function('acceptJobRequestByUser', 'Background::acceptJobRequestByUser');
        $this->lib_gearman->add_worker_function('sendJobVerificationCodeForUser', 'Background::sendJobVerificationCodeForUser');
        $this->lib_gearman->add_worker_function('rejectJobRequestByUser', 'Background::rejectJobRequestByUser');
        $this->lib_gearman->add_worker_function('applyUserJobByCaregiver', 'Background::applyUserJobByCaregiver');
        $this->lib_gearman->add_worker_function('alertCaregiverMessageBeforeStartjobOf30Mint', 'Background::alertCaregiverMessageBeforeStartjobOf30Mint');
        $this->lib_gearman->add_worker_function('alertUserMessageBeforeStartjobOf30Mint', 'Background::alertUserMessageBeforeStartjobOf30Mint');
        $this->lib_gearman->add_worker_function('sendJobImageRequest', 'Background::sendJobImageRequest');
        $this->lib_gearman->add_worker_function('sendJobVideoRequest', 'Background::sendJobVideoRequest');
        $this->lib_gearman->add_worker_function('ongoingJobMediaRequestOfCaregiver', 'Background::ongoingJobMediaRequestOfCaregiver');
        $this->lib_gearman->add_worker_function('ongoingJobReviewRequestCaregiver', 'Background::ongoingJobReviewRequestCaregiver');
        $this->lib_gearman->add_worker_function('ongoingJobReviewRequestUser', 'Background::ongoingJobReviewRequestUser');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestByCaregiver', 'Background::caregiverSubstituteJobRequestByCaregiver');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestAcceptByCaregiver', 'Background::caregiverSubstituteJobRequestAcceptByCaregiver');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestRejectByCaregiver', 'Background::caregiverSubstituteJobRequestRejectByCaregiver');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestByCaregiverToUser', 'Background::caregiverSubstituteJobRequestByCaregiverToUser');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestAcceptByUser', 'Background::caregiverSubstituteJobRequestAcceptByUser');
        $this->lib_gearman->add_worker_function('caregiverSubstituteJobRequestRejectByUser', 'Background::caregiverSubstituteJobRequestRejectByUser');
        $this->lib_gearman->add_worker_function('sendExtraTimeRequestOfCurrentJobByUser', 'Background::sendExtraTimeRequestOfCurrentJobByUser');
        $this->lib_gearman->add_worker_function('declineExtraTimeRequestOfCurrentJobByCaregiver', 'Background::declineExtraTimeRequestOfCurrentJobByCaregiver');
        $this->lib_gearman->add_worker_function('acceptExtraTimeRequestOfCurrentJobByCaregiver', 'Background::acceptExtraTimeRequestOfCurrentJobByCaregiver');
        $this->lib_gearman->add_worker_function('transactionSuccessForAdditionaHoursJobPayment', 'Background::transactionSuccessForAdditionaHoursJobPayment');
        $this->lib_gearman->add_worker_function('transactionFailForJobPayment', 'Background::transactionFailForJobPayment');
        $this->lib_gearman->add_worker_function('cancelUpcomingJobByAutoSystemForUser', 'Background::cancelUpcomingJobByAutoSystemForUser');
        $this->lib_gearman->add_worker_function('cancelUpcomingJobByAutoSystemForCaregiver', 'Background::cancelUpcomingJobByAutoSystemForCaregiver');
        $this->lib_gearman->add_worker_function('sendAwardJobRequestByUser', 'Background::sendAwardJobRequestByUser');
        $this->lib_gearman->add_worker_function('declineAwardJobRequestByCaregiver', 'Background::declineAwardJobRequestByCaregiver');
        $this->lib_gearman->add_worker_function('acceptAwardJobRequestByCaregiver', 'Background::acceptAwardJobRequestByCaregiver');
        $this->lib_gearman->add_worker_function('sendChatNotification', 'Background::sendChatNotification');

        while ($this->lib_gearman->work()) {
            if (!$worker->returnCode()) {
                echo "\n----------- " . date('c') . " worker done successfully---------\n";
            }
            if ($worker->returnCode() != GEARMAN_SUCCESS) {

                echo "return_code: " . $this->lib_gearman->current('worker')->returnCode() . "\n";
                break;
            }
        }
    }

    public static function transactionSuccessForJobPayment($job = null) {
        echo "\n---------- " . date('c') . "Start send transactionSuccessForJobPayment notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->transactionSuccessForJobPayment($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send transactionSuccessForJobPayment notification -----------------\n";
    }

    public static function caregiverSubstituteJobByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobByCaregiver notification -----------------\n";
    }

    public static function cancelUpcomingJobByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send cancelUpcomingJobByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->cancelUpcomingJobByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send cancelUpcomingJobByCaregiver notification -----------------\n";
    }

    public static function addMoneyInYourWalletForUserJobPayment($job = null) {
        echo "\n---------- " . date('c') . "Start send addMoneyInYourWalletForUserJobPayment notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->addMoneyInYourWalletForUserJobPayment($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send addMoneyInYourWalletForUserJobPayment notification -----------------\n";
    }

    public static function acceptJobRequestByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send acceptJobRequestByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->acceptJobRequestByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send acceptJobRequestByUser notification -----------------\n";
    }

    public static function sendJobVerificationCodeForUser($job = null) {
        echo "\n---------- " . date('c') . "Start send sendJobVerificationCodeForUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendJobVerificationCodeForUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendJobVerificationCodeForUser notification -----------------\n";
    }

    public static function rejectJobRequestByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send rejectJobRequestByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->rejectJobRequestByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send rejectJobRequestByUser notification -----------------\n";
    }

    public static function applyUserJobByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send applyUserJobByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->applyUserJobByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send applyUserJobByCaregiver notification -----------------\n";
    }

    public static function alertCaregiverMessageBeforeStartjobOf30Mint($job = null) {
        echo "\n---------- " . date('c') . "Start send alertCaregiverMessageBeforeStartjobOf30Mint notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->alertCaregiverMessageBeforeStartjobOf30Mint($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send alertCaregiverMessageBeforeStartjobOf30Mint notification -----------------\n";
    }

    public static function alertUserMessageBeforeStartjobOf30Mint($job = null) {
        echo "\n---------- " . date('c') . "Start send alertUserMessageBeforeStartjobOf30Mint notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->alertUserMessageBeforeStartjobOf30Mint($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send alertUserMessageBeforeStartjobOf30Mint notification -----------------\n";
    }

    public static function sendJobImageRequest($job = null) {
        echo "\n---------- " . date('c') . "Start send sendJobImageRequest notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendJobImageRequest($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendJobImageRequest notification -----------------\n";
    }

    public static function sendJobVideoRequest($job = null) {
        echo "\n---------- " . date('c') . "Start send sendJobVideoRequest notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendJobVideoRequest($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendJobVideoRequest notification -----------------\n";
    }

    public static function ongoingJobMediaRequestOfCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send ongoingJobMediaRequestOfCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->ongoingJobMediaRequestOfCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send ongoingJobMediaRequestOfCaregiver notification -----------------\n";
    }

    public static function ongoingJobReviewRequestCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send ongoingJobReviewRequestCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->ongoingJobReviewRequestCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send ongoingJobReviewRequestCaregiver notification -----------------\n";
    }

    public static function ongoingJobReviewRequestUser($job = null) {
        echo "\n---------- " . date('c') . "Start send ongoingJobReviewRequestUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->ongoingJobReviewRequestUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send ongoingJobReviewRequestUser notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestByCaregiver notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestAcceptByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestAcceptByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestAcceptByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestAcceptByCaregiver notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestRejectByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestRejectByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestRejectByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestRejectByCaregiver notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestByCaregiverToUser($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestByCaregiverToUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestByCaregiverToUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestByCaregiverToUser notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestAcceptByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestAcceptByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestAcceptByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestAcceptByUser notification -----------------\n";
    }

    public static function caregiverSubstituteJobRequestRejectByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send caregiverSubstituteJobRequestRejectByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->caregiverSubstituteJobRequestRejectByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send caregiverSubstituteJobRequestRejectByUser notification -----------------\n";
    }

    public static function sendExtraTimeRequestOfCurrentJobByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send sendExtraTimeRequestOfCurrentJobByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendExtraTimeRequestOfCurrentJobByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendExtraTimeRequestOfCurrentJobByUser notification -----------------\n";
    }

    public static function declineExtraTimeRequestOfCurrentJobByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send declineExtraTimeRequestOfCurrentJobByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->declineExtraTimeRequestOfCurrentJobByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send declineExtraTimeRequestOfCurrentJobByCaregiver notification -----------------\n";
    }

    public static function acceptExtraTimeRequestOfCurrentJobByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send acceptExtraTimeRequestOfCurrentJobByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->acceptExtraTimeRequestOfCurrentJobByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send acceptExtraTimeRequestOfCurrentJobByCaregiver notification -----------------\n";
    }

    public static function transactionSuccessForAdditionaHoursJobPayment($job = null) {
        echo "\n---------- " . date('c') . "Start send transactionSuccessForAdditionaHoursJobPayment notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->transactionSuccessForAdditionaHoursJobPayment($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send transactionSuccessForAdditionaHoursJobPayment notification -----------------\n";
    }

    public static function transactionFailForJobPayment($job = null) {
        echo "\n---------- " . date('c') . "Start send transactionFailForJobPayment notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->transactionFailForJobPayment($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send transactionFailForJobPayment notification -----------------\n";
    }

    public static function cancelUpcomingJobByAutoSystemForUser($job = null) {
        echo "\n---------- " . date('c') . "Start send cancelUpcomingJobByAutoSystemForUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->cancelUpcomingJobByAutoSystemForUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send cancelUpcomingJobByAutoSystemForUser notification -----------------\n";
    }

    public static function cancelUpcomingJobByAutoSystemForCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send cancelUpcomingJobByAutoSystemForCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->cancelUpcomingJobByAutoSystemForCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send cancelUpcomingJobByAutoSystemForCaregiver notification -----------------\n";
    }

    public static function sendAwardJobRequestByUser($job = null) {
        echo "\n---------- " . date('c') . "Start send sendAwardJobRequestByUser notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendAwardJobRequestByUser($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendAwardJobRequestByUser notification -----------------\n";
    }

    public static function declineAwardJobRequestByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send declineAwardJobRequestByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->declineAwardJobRequestByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send declineAwardJobRequestByCaregiver notification -----------------\n";
    }

    public static function acceptAwardJobRequestByCaregiver($job = null) {
        echo "\n---------- " . date('c') . "Start send acceptAwardJobRequestByCaregiver notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->acceptAwardJobRequestByCaregiver($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send acceptAwardJobRequestByCaregiver notification -----------------\n";
    }

    public static function sendChatNotification($job = null) {
        echo "\n---------- " . date('c') . "Start send sendChatNotification notification -----------------\n";
        $data = unserialize($job->workload());
        $CI = &get_instance();

        try {
            if (empty($data)) {
                echo "\n Inavlida Data " . json_encode($data) . "  \n";
                return false;
            }
            $CI->db->reconnect();
            $CI->Background_Model->sendChatNotification($data);
        } catch (Exception $e) {
            echo '\n error : ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
            //$CI->load->model('SystemErrorLog_Model');
            //$CI->SystemErrorLog_Model>addSystemErrorLog(['error' => json_encode($e, true)]);
        }

        echo "\n---------- " . date('c') . " End send sendChatNotification notification -----------------\n";
    }

}
