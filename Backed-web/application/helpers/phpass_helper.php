<?php if (! defined('BASEPATH')) {
    exit('No direct script access allowed');
}

if (!function_exists('getRequest')) {
    function getRequest()
    {
       
        $request = json_decode(file_get_contents('php://input'));
        if (is_null($request) || empty($request)) {
            return show_error('Data not found!', 404);
        }
        putenv("BBB_SECURITY_SALT=$request->security_salt");
        putenv("BBB_SERVER_BASE_URL=$request->server_base_url");
        return $request;
    }
}
