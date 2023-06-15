<?php

class MY_Controller extends CI_Controller {
    /* --------------------------------------------------------------
     * VARIABLES
     * ------------------------------------------------------------ */

    /**
     * The current request's view. Automatically guessed
     * from the name of the controller and action
     */
    protected $view = '';

    /**
     * An array of variables to be passed through to the
     * view, layout and any asides
     */
    protected $data = array();

    /**
     * The name of the layout to wrap around the view.
     */
    protected $layout;

    /**
     * An arbitrary list of asides/partials to be loaded into
     * the layout. The key is the declared name, the value the file
     */
    protected $asides = array();

    /**
     * A list of models to be autoloaded
     */
    protected $models = array('Users', 'Common');

    /**
     * A formatting string for the model autoloading feature.
     * The percent symbol (%) will be replaced with the model name.
     */
    protected $model_string = '%_Model';

    /**
     * A list of helpers to be autoloaded
     */
    protected $helpers = array();

    /* --------------------------------------------------------------
     * GENERIC METHODS
     * ------------------------------------------------------------ */

    /**
     * Initialise the controller, tie into the CodeIgniter superobject
     * and try to autoload the models and helpers
     */
    public function __construct() {
        parent::__construct();
        $this->_load_models();
        $this->_load_helpers();
        if($this->session->userdata('user_session')){			
            $this->data['user_data'] = $this->Users->get(['id' => $this->session->userdata('user_session')->id, 'status' => 1]);
        }
    }

    /* --------------------------------------------------------------
     * MODEL LOADING
     * ------------------------------------------------------------ */

    /**
     * Load models based on the $this->models array
     */
    private function _load_models() {
        foreach ($this->models as $model) {
            $this->load->model($this->_model_name($model), $model);
        }
    }

    /**
     * Returns the loadable model name based on
     * the model formatting string
     */
    protected function _model_name($model) {
        return str_replace('%', $model, $this->model_string);
    }

    /* --------------------------------------------------------------
     * HELPER LOADING
     * ------------------------------------------------------------ */

    /**
     * Load helpers based on the $this->helpers array
     */
    private function _load_helpers() {
        foreach ($this->helpers as $helper) {
            $this->load->helper($helper);
        }
    }

}
