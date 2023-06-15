<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Common_Model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->load->library('email');
        $this->load->model('Users_Model', 'User');
    }

    // Get Unique No
    public function get_Unique_No() {
        return uniqid();
    }

    // Get Random Number
    public function random_string($length) {
        $key = '';
        $keys = array_merge(range(0, 9));
        for ($i = 0; $i < $length; $i++) {
            $key .= $keys[array_rand($keys)];
            //$key .= '1';
        }
        return $key;
    }

    //for get file extantion
    public function getFileExtension($file_name) {
        return '.' . substr(strrchr($file_name, '.'), 1);
    }

    public function random_alphnum_string($length) {
        $key = '';
        $keys = array_merge(range('a', 'z'), range('A', 'Z'), range('0', '9'));
        for ($i = 0; $i < $length; $i++) {
            $key .= $keys[array_rand($keys)];
        }
        return $key;
    }

    public function crypto_rand_secure($min, $max) {
        $range = $max - $min;
        if ($range < 1)
            return $min; // not so random...
        $log = ceil(log($range, 2));
        $bytes = (int) ($log / 8) + 1; // length in bytes
        $bits = (int) $log + 1; // length in bits
        $filter = (int) (1 << $bits) - 1; // set all lower bits to 1
        do {
            $rnd = hexdec(bin2hex(openssl_random_pseudo_bytes($bytes)));
            $rnd = $rnd & $filter; // discard irrelevant bits
        } while ($rnd > $range);
        return $min + $rnd;
    }

    //for get date format
    public function getDateFormat($date, $time = false, $humanReadable = false) {
        $result = "";
        if ($date != '0000-00-00 00:00:00') {
            if ($humanReadable) {
                $result = date("d M Y", strtotime($date));
            } else {
                if ($time) {
                    $result = date("m-d-Y H:i:s", strtotime($date));
                } else {
                    $result = date("m-d-Y", strtotime($date));
                }
            }
        }
        return $result;
    }

    //for generate token
    public function getToken($length, $config = []) {
        $token = "";
        $codeAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        $codeAlphabet .= isset($config['notSmall']) && $config['notSmall'] ? '' : "abcdefghijklmnopqrstuvwxyz";
        $codeAlphabet .= "0123456789";
        $max = strlen($codeAlphabet); // edited
        for ($i = 0; $i < $length; $i++) {
            $token .= $codeAlphabet[$this->crypto_rand_secure(0, $max - 1)];
        }
        return $token;
    }

    // Convert string(password) into hash
    public function convert_to_hash($password) {
        return hash_hmac('SHA512', $password, 1);
    }

    //Start of getNotification function
    public function GetNotification($key, $lang = '1') {
        $colName = "value_en";
        if ($lang == '1') {
            $colName = "value_en";
        }
        $this->db->select('*');
        $this->db->from('tbl_apiresponse');
        $this->db->where("key", $key);
        $this->db->where("status", "1");
        $result = $this->db->get()->row_array();
        if (empty($result)) {
            return "Message not found";
        }
        return $result[$colName];
    }
    /* for check user login or not in Admin side or Front-end side */

    public function checkUserAuth($type = '2', $isredirect = true) {
        if (empty($this->session->userdata('appXtrahelpRole')) || empty($this->session->userdata('appXtrahelpAdminId'))) {
            return redirect(base_url('admin'));
        }

        if ($type == '1') {
            if (($this->session->userdata('appXtrahelpRole') == 1 || $this->session->userdata('appXtrahelpRole') == 2) && !empty($this->session->userdata('appXtrahelpAdminId'))) {
                return true;
            } else {
                if (!$isredirect) {
                    return false;
                } else {
                    $this->session->set_flashdata('error', 'Your session is expire');
                    redirect(base_url('admin'));
                }
            }
        } else {
            $this->session->set_flashdata('error', 'Your session is expire');
            redirect(base_url('admin'));
        }
    }

    //for send email
    public function mailsend($recipient, $subject, $body, $from = NULL, $file = NULL, $bcc = NULL, $replyTo = NULL, $replyToName = NULL, $icalContent = NULL) {
        try {
            $this->load->library('email');
            $mail['charset'] = "utf-8";
            $mail['newline']  = '\r\n';
            $mail['wordwrap']  = TRUE;
            $mail['mailtype'] = 'html';
            $mail['protocol'] = "smtp";
            $mail['smtp_host'] = getenv('SMTP_HOST');
            $mail['smtp_port'] = getenv('SMTP_PORT');
            $mail['smtp_user'] = getenv('SMTP_USER');
            $mail['smtp_pass'] = getenv('SMTP_PASSWORD');
            $mail['newline'] = "\r\n";
            $this->email->initialize($mail);
            $from = empty($from) ? getenv('FROM_EMAIL') : $from;
            $this->email->from($from, getenv('WEBSITE_NAME'));
            $this->email->subject($subject);
            $this->email->message($body);

            if (!empty($recipient) && is_array($recipient)) {
                foreach ($recipient as $key => $value) {
                    $this->email->to($value);
                }
            } elseif (!empty($recipient)) {
                $this->email->to($recipient);
            }
            if (!empty($file) && is_array($file)) {
                foreach ($file as $key => $value) {
                    $this->email->attach($value);
                }
            } elseif (!empty($file)) {
                $this->email->attach($file);
            }

            $systemBCC = getenv('EMAIL_BCC');
            if (!empty($systemBCC) && is_array($systemBCC)) {
                foreach ($systemBCC as $key => $value) {
                    $this->email->bcc($value);
                }
            } elseif (!empty($systemBCC)) {
                $this->email->bcc($systemBCC);
            }

            if (!empty($bcc) && is_array($bcc)) {
                foreach ($bcc as $key => $value) {
                    $this->email->bcc($value);
                }
            } elseif (!empty($bcc)) {
                $this->email->bcc($bcc);
            }

            if ( !empty($icalContent) ) {
                $this->email->attach($icalContent, 'ical.ics', 'base64', 'text/calendar');
            }

            if(!empty($replyTo)){
                //$this->email->ClearReplyTos();
                $this->email->reply_to($replyTo, $replyToName);
            }
             $this->email->send();
           // var_dump($this->email->print_debugger ( array ('headers','subject') ));
        } catch (Stripe\Error\Card $e) {
            return $e->getJsonBody();
        }
    } 

    public function distance($lat1, $lon1, $lat2, $lon2) {
        $theta = $lon1 - $lon2;
        $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
        $dist = acos($dist);
        $dist = rad2deg($dist);
        $miles = $dist * 60 * 1.1515;
        return round($miles, 1) . "";
    }

    public function is_jsonDecode($json) {
        if (empty($json)) {
            return $json;
        }

        $ob = json_decode($json);
        if ($ob === null) {
            return $json;
        } else {
            return $ob;
        }
    }

    public function get_time_ago($time) {
        $time_difference = time() - $time;
        if ($time_difference < 1) {
            return 'just now';
        }
        $condition = array(12 * 30 * 24 * 60 * 60 => 'year',
            30 * 24 * 60 * 60 => 'month',
            24 * 60 * 60 => 'day',
            60 * 60 => 'hour',
            60 => 'min',
            1 => 'second'
        );
        foreach ($condition as $secs => $str) {
            $d = $time_difference / $secs;
            if ($d >= 1) {
                $t = round($d);
                return str_pad($t,2,"0",STR_PAD_LEFT) . ' ' . $str . ( $t > 1 ? 's' : '' ) . ' ago';
            }
        }
    }

    //Function definition

    public function timeAgo($time_ago) {
        $time_ago = strtotime($time_ago);
        $cur_time = time();
        $time_elapsed = $cur_time - $time_ago;
        $hours = round($time_elapsed / 3600);
        $days = round($time_elapsed / 86400);
        $weeks = round($time_elapsed / 604800);
        $months = round($time_elapsed / 2600640);
        $years = round($time_elapsed / 31207680);

        //Hours
        if ($hours <= 24) {
            return "today";
        }
        //Days
        else if ($days <= 7) {
            if ($days == 1) {
                return "yesterday";
            } else {
                return "$days days ago";
            }
        }
        //Weeks
        else if ($weeks <= 4.3) {
            if ($weeks == 1) {
                return "a week ago";
            } else {
                return "$weeks weeks ago";
            }
        }
        //Months
        else if ($months <= 12) {
            if ($months == 1) {
                return "a month ago";
            } else {
                return "$months months ago";
            }
        }
        //Years
        else {
            if ($years == 1) {
                return "a year ago";
            } else {
                return "$years years ago";
            }
        }
    }

    //Function definition
    public function chatInboxTiming($userTimestamp,$userTimezone) {
        $msgDateTime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        $msgDateTime->setTimezone(new DateTimeZone($userTimezone));
        $msgDateTime->setTimestamp($userTimestamp);

        $currentdatetime = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        $currentdatetime->setTimezone(new DateTimeZone($userTimezone));

        $time_difference = $currentdatetime->format('U') - $msgDateTime->format('U');
        $hours = round($time_difference / 3600);
        $days = round($time_difference / 86400);
        $weeks = round($time_difference / 604800);
        $months = round($time_difference / 2600640);
        $years = round($time_difference / 31207680);

        //Hours
        if ($hours <= 24) {
            if ($time_difference < 1) {
                return 'just now';
            }
            $condition = array(
                60 * 60 => 'hour',
                60 => 'min',
                1 => 'second'
            );
            foreach ($condition as $secs => $str) {
                $d = $time_difference / $secs;
                if ($d >= 1) {
                    $t = round($d);
                    return str_pad($t,2,"0",STR_PAD_LEFT) . ' ' . $str . ( $t > 1 ? 's' : '' ) . ' ago';
                }
            }
        } 
        return $msgDateTime->format('d-M-Y h:i A');
    }

    function getDayAndDateName($timestamp = "",$userTimezone = ""){
        if(empty($timestamp)){
            return "";
        }
        $today_date = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        $today_date->setTimezone(new DateTimeZone($userTimezone));
        
        $tomorrow_date = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        $tomorrow_date->setTimezone(new DateTimeZone($userTimezone));
        $tomorrow_date->add(new DateInterval('P1D'));

        $match_date = new DateTime(null,new DateTimeZone(getenv('SYSTEMTIMEZON')));
        $match_date->setTimezone(new DateTimeZone($userTimezone));
        $match_date->setTimestamp($timestamp);
        $interval = $today_date->diff($match_date);
        
        if ( $today_date->format('y-m-d') == $match_date->format('y-m-d') ) {
            return "Today";
        } elseif ( $tomorrow_date->format('y-m-d') == $match_date->format('y-m-d') ) {
            return "Tomorrow, ".$match_date->format('d M');
        } else {
            return $match_date->format('D, d M');
        }
        /*
        if($interval->days == 0) {
            return "Today";
        } elseif($interval->days == 1 && $interval->invert == 0) {
            return "Tomorrow, ".$match_date->format('d M');
        } else {
            return $match_date->format('D, d M');
        }*/
    }
    
    public function backroundCall($function, $data) {

        /*if (class_exists('GearmanClient')) {
            $this->load->library('lib_gearman');
            $this->lib_gearman->gearman_client();
            $this->lib_gearman->do_job_background('dc_' . $function, serialize($data));
        } else {
            $this->Background_Model->$function($data);
        }*/

        $this->Background_Model->$function($data);
    }
}
