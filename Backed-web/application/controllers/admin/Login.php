<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Login extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Users_Model');
        $this->load->model('Common_Model');
        $this->load->model('Auth_Model');
    }

    public function index() {
        if ($this->session->userdata('appXtrahelpRole') == 1 && !empty($this->session->userdata('appXtrahelpAdminId'))) {
            return redirect('admin/dashboard');
        }
        
        $this->data = [];
        $this->data['pageTitle'] = ['title' => 'Admin Login', 'icon' => ''];

        if ($this->input->server('REQUEST_METHOD') == 'POST') {
            
            $this->load->library('form_validation');
            $config = array(
                array(
                    'field' => 'username',
                    'label' => 'Username',
                    'rules' => 'required'
                ),
                array(
                    'field' => 'password',
                    'label' => 'Password',
                    'rules' => 'required'
                ),
            );
            $this->form_validation->set_rules($config);
            if ($this->form_validation->run() == FALSE) {
                $this->form_validation->set_error_delimiters('<p class="error">', '</p>');
            }

            if (!empty($this->input->post('email')) && !empty($this->input->post('password'))) {

                $user = $this->Users->get(['email' => $this->input->post('email'), 'password' => $this->Common->convert_to_hash($this->input->post('password')), 'role' => 1], true);
                if (empty($user)) {
                    $this->session->set_flashdata('error', 'Invalid email or password');
                    return redirect('admin');
                }
				
                if ($user->status != 1) {
                    $this->session->set_flashdata('error', 'Your account is blocked by Admin');
                    return redirect('admin');
                }
                
                $sessionData = array(
                    'appXtrahelpRole' => $user->role,
                    'appXtrahelpAdminId' => $user->id,
                    'appXtrahelpAdminImage' => $user->image,
                    'appXtrahelpAdminName' => $user->firstName,
                );
                $this->session->set_userdata($sessionData);

                $authData = array();
                $authData['userId'] = $user->id;
                $authData['token'] = $this->Common_Model->getToken(120);

                $getAuth = $this->Auth_Model->get(['userId' => $user->id], TRUE);
                if(!empty($getAuth)) {
                    $authid = $this->Auth_Model->setData($authData, $getAuth->id);
                } else {
                    $authid = $this->Auth_Model->setData($authData);
                }

                $cookie= array(
                    'name'   => 'xhAdminSessionCookie',
                    'value'  => $authData['token'],
                    'expire' => '86400',
                );
                $this->input->set_cookie($cookie);
                
                return redirect('admin/dashboard');
            }
        }
        $this->load->view('admin/login', $this->data);
    }

    public function logout() {
        delete_cookie('xhAdminSessionCookie');
        $this->session->sess_destroy();
        redirect(base_url('admin'));
    }
}
