<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <link rel="apple-touch-icon" sizes="76x76" href="<?php echo base_url(); ?>assets/backend/img/apple-icon.png">
    <link rel="icon" type="image/png" href="<?php echo base_url(); ?>assets/backend/img/favicon.png">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>
        <?php echo $_ENV['WEBSITE_NAME'].' - Admin Login'; ?>
    </title>
    <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
    <!--     Fonts and icons     -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700,200" rel="stylesheet" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
    <!-- CSS Files -->
    <link href="<?php echo base_url(); ?>assets/backend/css/bootstrap.min.css" rel="stylesheet" />
    <link href="<?php echo base_url(); ?>assets/backend/css/now-ui-dashboard.css?v=1.4.0" rel="stylesheet" />
    <!-- CSS Just for demo purpose, don't include it in your project -->
    <link href="<?php echo base_url(); ?>assets/backend/css/style.css" rel="stylesheet" />
</head>

<body class="login-page sidebar-mini ">
    <div class="wrapper wrapper-full-page ">
        <div class="full-page login-page section-image background_set" filter-color="black">
        <!--   you can change the color of the filter page using: data-color="blue | purple | green | orange | red | rose " -->
        <div class="content">
            <div class="container">
                <div class="col-md-4 ml-auto mr-auto login_box">
                    <form class="form" id="admin_login" method="post">
                        <div class="card card-login card-plain">
                            <div class="card-header ">
                                <?php 
                                if ($this->session->flashdata('error')) { ?>
                                    <div class="alert alert-danger d-flex justify-content-between align-items-center ">
                                        <strong><?php echo $this->session->flashdata('error'); ?></strong> 
                                        <a href="#" class="close" data-dismiss="alert">&times;</a>
                                    </div>
                                <?php } ?>
                                <div class="logo-container">
                                    <img src="<?php echo base_url(); ?>assets/img/logo.png" alt="image">
                                </div>
                            </div>
                            <div class="card-body ">
                                <div class="input-group no-border form-control-lg">
                                    <span class="input-group-prepend">
                                    <div class="input-group-text">
                                        <i class="fas fa-user-circle"></i>
                                    </div>
                                    </span>
                                    <input type="email" name="email" class="form-control"placeholder="Email address">
                                </div>
                                <div class="input-group no-border form-control-lg">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </div>
                                    </div>
                                    <input type="password" name="password" class="form-control" placeholder="Password">
                                </div>
                            </div>
                            <?php 
                            $csrf = array(
								'name' => $this->security->get_csrf_token_name(),
								'hash' => $this->security->get_csrf_hash()
							);						
						  ?>
						  <input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />
                            <div class="card-footer ">
                                <button type="submit" class="btn btn-primary btn-round btn-lg btn-block mb-3">Signin</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <footer class="footer">
            <div class=" container-fluid ">
                <div class="copyright" id="copyright">
                    Copyright
                    &copy;
                    <script>
                    document.getElementById('copyright').appendChild(document.createTextNode(new Date().getFullYear()))
                    </script> 
                    <a href="#"><?php echo $this->config->item('website_name'); ?></a> All rights reserved.
                </div>
            </div>
        </footer>
        </div>
    </div>
    <!--   Core JS Files   -->
    <script src="<?php echo base_url(); ?>assets/backend/js/core/jquery.min.js"></script>
    <script src="<?php echo base_url(); ?>assets/backend/js/core/popper.min.js"></script>
    <script src="<?php echo base_url(); ?>assets/backend/js/core/bootstrap.min.js"></script>
    <script src="<?php echo base_url(); ?>assets/backend/js/plugins/moment.min.js"></script>
    <!-- Forms Validations Plugin -->
    <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.validate.min.js"></script>
    <!--  DataTables.net Plugin, full documentation here: https://datatables.net/    -->
    <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.dataTables.min.js"></script>


    <script>
	    $("#admin_login").validate({
            errorClass: 'error text-left',
            errorElement: 'div',
            errorPlacement: function (error, element) {
                error.insertAfter($(element).parent('div'));
            },
            rules:{
                email: {
                    required: true,
                },
                password: {
                    required: true,
                },
            },
            messages:{
                email:{
                    required: "Please enter email",
                    email: "Enter valid email"
                },
                password:{
                    required: "Please enter password"
                },
            },
        });
    </script>
</body>

</html>
