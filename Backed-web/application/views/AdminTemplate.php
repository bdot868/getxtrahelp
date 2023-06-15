<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <link rel="apple-touch-icon" sizes="76x76" href="<?php echo base_url(); ?>assets/backend/img/apple-icon.png">
  <link rel="icon" href="<?php echo base_url('assets/backend/img/favicon.png'); ?>" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <!-- <title><?php //echo $this->config->item('website_name') . "  " . (isset($pageTitle['title']) ? $pageTitle['title'] : "Admin panel"); 
              ?></title> -->
  <title><?php echo getenv('WEBSITE_NAME') . " : " . (isset($pageTitle['title']) ? $pageTitle['title'] : "Admin panel"); ?></title>
  <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
  <!--     Fonts and icons     -->
  <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700,200" rel="stylesheet" />
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
  <!-- CSS Files -->
  <link href="<?php echo base_url(); ?>assets/backend/css/bootstrap.min.css" rel="stylesheet" />
  <link href="<?php echo base_url(); ?>assets/backend/css/now-ui-dashboard.css?v=1.4.0" rel="stylesheet" />
  <link href="<?php echo base_url(); ?>assets/backend/css/style.css" rel="stylesheet" />

  <?php echo $this->template->stylesheet; ?>
  <!--   Core JS Files   -->
  <script src="<?php echo base_url(); ?>assets/backend/js/core/jquery.min.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/core/popper.min.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/core/bootstrap.min.js"></script>
  <!-- <script src="<?php //echo base_url(); 
                    ?>assets/backend/js/plugins/perfect-scrollbar.jquery.min.js"></script> -->
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/moment.min.js"></script>
  <!--  DataTables.net Plugin, full documentation here: https://datatables.net/    -->
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.dataTables.min.js"></script>
  <!-- Forms Validations Plugin -->
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.validate.min.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/additional-methods.min.js"></script>
  <link href="<?php echo base_url(); ?>assets/backend/css/select2.min.css" rel="stylesheet" />
  <script src="<?php echo base_url(); ?>assets/backend/js/select2.min.js"></script>
  <?php echo $this->template->javascript; ?>

</head>

<body class=" sidebar-mini ">
  <div class="wrapper ">
    <div class="sidebar">
      <!--
        Tip 1: You can change the color of the sidebar using: data-color="blue | green | orange | red | yellow"
    -->
      <div class="logo">
        <a href="<?php echo base_url('admin/dashboard'); ?>" class="simple-text logo-mini">
          XH
        </a>
        <a href="<?php echo base_url('admin/dashboard'); ?>" class="simple-text logo-normal">
          <?php echo strtoupper(getenv('WEBSITE_NAME')) ?>
        </a>
        <div class="navbar-minimize">
          <button id="minimizeSidebar" class="btn btn-simple btn-icon btn-neutral btn-round">
            <i class="now-ui-icons text_align-center visible-on-sidebar-regular"></i>
            <i class="now-ui-icons design_bullet-list-67 visible-on-sidebar-mini"></i>
          </button>
        </div>
      </div>
      <div class="sidebar-wrapper" id="sidebar-wrapper">
        <div class="user">
          <div class="photo">
            <img src="<?php echo base_url() . "assets/uploads/" . $this->session->userdata('appXtrahelpAdminImage'); ?>" alt='image' />
          </div>
          <div class="info">
            <a data-toggle="collapse" href="#collapseExample" class="collapsed">
              <span>
                <?php echo $this->session->userdata('appXtrahelpAdminName'); ?>
                <!-- <b class="caret"></b> -->
              </span>
            </a>
            <div class="clearfix"></div>

          </div>
        </div>
        <ul class="nav">
          <li class="<?php echo $this->uri->segment(2) == 'dashboard' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/dashboard'); ?>">
              <i class="now-ui-icons design_app"></i>
              <p>Dashboard</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'user' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/user'); ?>">
              <i class="now-ui-icons users_circle-08"></i>
              <p>Families</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'caregiver' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/caregiver'); ?>">
              <i class="fas fa-user"></i>
              <p>Caregiver</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'lovedCategory' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/lovedCategory'); ?>">
              <i class="fa fa-object-ungroup"></i>
              <p>Loved One's Category</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'lovedSpecialities' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/lovedSpecialities'); ?>">
              <i class="fas fa-magic"></i>
              <p>Loved One's Specialities</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'licenceType' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/licenceType'); ?>">
              <i class="fas fa-certificate"></i>
              <p>Licence Type</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'jobCategory' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/jobCategory'); ?>">
              <i class="fab fa-servicestack"></i>
              <p>Job Category</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'jobSubCategory' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/jobSubCategory'); ?>">
              <i class="fab fa-usps"></i>
              <p>Job Sub Category</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'workSpeciality' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/workSpeciality'); ?>">
              <i class="fas fa-house-damage"></i>
              <p>Work Speciality</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'transportationMethod' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/transportationMethod'); ?>">
              <i class="fas fa-bus"></i>
              <p>Work Method Of Transportation</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'willingType' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/willingType'); ?>">
              <i class="fas fa-bell-slash"></i>
              <p>Work Disabilities Willing Type</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'insurance' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/insurance'); ?>">
              <i class="fas fa-car-crash"></i>
              <p>Insurance Type</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'lovedDisabilitiesType' ? 'active' : ''; ?>">
            <a href="<?php echo base_url('/admin/lovedDisabilitiesType'); ?>">
              <i class="fas fa-question-circlefas fa-blog"></i>
              <p>Loved Disabilities Type</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'ticket' ? 'active' : '' ?>">
            <a href="<?php echo base_url(); ?>admin/ticket">
              <i class="fas fa-ticket-alt"></i>
              <p>Support Ticket</p>
            </a>
          </li>
          <li class="<?php echo $this->uri->segment(2) == 'appfeedback' ? 'active' : '' ?>">
            <a href="<?php echo base_url(); ?>admin/appfeedback">
              <i class="fas fa-star"></i>
              <p>App FeedBack</p>
            </a>
          </li>
          <li class="<?php echo isset($page['menu']) && $page['menu'] == 'Cms' ? 'active' : '' ?>">
            <a data-toggle="collapse" href="#post3">
              <i class="fas fa-laptop-code"></i>
              <p>Cms Masters<b class="caret"></b></p>
            </a>
            <div class="collapse <?php echo isset($page['menu']) && $page['menu'] == 'Cms' ? 'show' : '' ?>" id="post3">
              <ul class="nav">
                <li class="<?php echo isset($page['submenu']) && $page['submenu'] == 'cms' ? 'active' : '' ?>">
                  <a href="<?php echo base_url(); ?>admin/Cms">
                    <span class="sidebar-mini-icon"><i class="fas fa-laptop-code"></i></span>
                    <span class="sidebar-normal">Cms</span>
                  </a>
                </li>
                <li class="<?php echo isset($page['submenu']) && $page['submenu'] == 'faq' ? 'active' : '' ?>">
                  <a href="<?php echo base_url(); ?>admin/Faq">
                    <span class="sidebar-mini-icon"><i class="fas fa-question-circle"></i></span>
                    <span class="sidebar-normal">Faq</span>
                  </a>
                </li>
                <li class="<?php echo isset($page['submenu']) && $page['submenu'] == 'apiresponse' ? 'active' : '' ?>">
                  <a href="<?php echo base_url(); ?>admin/Apiresponse">
                    <span class="sidebar-mini-icon"><i class="fas fa-users"></i></span>
                    <span class="sidebar-normal">Apiresponse</span>
                  </a>
                </li>
                <li class="<?php echo isset($page['submenu']) && $page['submenu'] == 'Resources' ? 'active' : '' ?>">
                  <a href="<?php echo base_url(); ?>admin/Resources">
                    <span class="sidebar-mini-icon"><i class="fas fa-laptop-code"></i></span>
                    <span class="sidebar-normal">Resources</span>
                  </a>
                </li>
                <li class="<?php echo isset($page['submenu']) && $page['submenu'] == 'Resources_Category' ? 'active' : ''; ?>">
                  <a href="<?php echo base_url(); ?>admin/resourcesCategory">
                    <span class="sidebar-mini-icon"><i class="fas fa-wind"></i></span>
                    <span class="sidebar-normal">Resources category</span>
                  </a>
                </li>
              </ul>
            </div>
          </li>
        </ul>
      </div>
    </div>
    <div class="main-panel" id="main-panel">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-transparent  bg-primary  navbar-absolute">
        <div class="container-fluid">
          <div class="navbar-wrapper">
            <div class="navbar-toggle">
              <button type="button" class="navbar-toggler">
                <span class="navbar-toggler-bar bar1"></span>
                <span class="navbar-toggler-bar bar2"></span>
                <span class="navbar-toggler-bar bar3"></span>
              </button>
            </div>
            <a class="navbar-brand" href="<?= $page['url']; ?>"><?= $page['name']; ?></a>
          </div>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navigation" aria-controls="navigation-index" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-bar navbar-kebab"></span>
            <span class="navbar-toggler-bar navbar-kebab"></span>
            <span class="navbar-toggler-bar navbar-kebab"></span>
          </button>
          <div class="collapse navbar-collapse justify-content-end" id="navigation">
            <ul class="navbar-nav">
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <i class="now-ui-icons users_single-02"></i>
                  <p>
                    <span class="d-lg-none d-md-block">Some Actions</span>
                  </p>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                  <a class="dropdown-item" href="<?php echo  base_url('admin/setting'); ?>">Profile</a>
                  <a class="dropdown-item" href="<?php echo  base_url('admin/logout'); ?>">Logout</a>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </nav>
      <!-- End Navbar -->
      <div class="panel-header panel-header-sm">

      </div>
      <div class="content">
        <?php
        echo $this->template->content;
        ?>
      </div>
      <footer class="footer">
        <div class=" container-fluid ">
          <div class="copyright" id="copyright">
            Copyright
            &copy;
            <script>
              document.getElementById('copyright').appendChild(document.createTextNode(new Date().getFullYear()))
            </script>
            <a href="#"><?php echo getenv('WEBSITE_NAME'); ?></a> All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  </div>
  <!--  Plugin for Switches, full documentation here: http://www.jque.re/plugins/version3/bootstrap.switch/ -->
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/bootstrap-switch.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.bootstrap-wizard.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/bootstrap-selectpicker.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/bootstrap-tagsinput.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/jasny-bootstrap.min.js"></script>
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/fullcalendar.min.js"></script>
  <!--  Notifications Plugin    -->
  <script src="<?php echo base_url(); ?>assets/backend/js/plugins/bootstrap-notify.js"></script>
  <!-- Control Center for Now Ui Dashboard: parallax effects, scripts for the example pages etc -->
  <script src="<?php echo base_url(); ?>assets/backend/js/now-ui-dashboard.js?v=1.4.0" type="text/javascript"></script>
  <!-- Now Ui Dashboard DEMO methods, don't include it in your project! -->
  <?php echo $this->template->javascript; ?>
  <?php if ($this->session->flashdata('error')) : ?>
    <script>
      $(document).ready(function() {
        jQuery.notify({
          message: '<?php echo $this->session->flashdata('error'); ?>',
        }, {
          type: 'danger',
          delay: 5000,
        });
      });
    </script>
  <?php unset($_SESSION['error']);
  endif; ?>

  <?php if ($this->session->flashdata('success')) : ?>
    <script>
      $(document).ready(function() {
        jQuery.notify({
          message: "<?php echo $this->session->flashdata('success'); ?>",
        }, {
          type: 'success',
          delay: 5000,
        });
      });
    </script>
  <?php unset($_SESSION['success']);
  endif; ?>

</body>

</html>