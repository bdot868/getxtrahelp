<div class="row">
    <div class="col-md-12">
        <div class="card">
			<div class="card-header mb-0">
                <h4 class="card-title d-inline-block inner-page-title">Profile Settings</h4>
            </div>
            <div class="card-body">
				<section id="tabs" class="project-tab">
					<div class="container ml-0 px-0">
						<div class="row">
							<div class="col-md-12">
								<nav>
									<div class="nav nav-tabs nav-fill pl-0" id="nav-tab" role="tablist">
										<a class="nav-link active mr-2" id="nav-prof-tab" data-toggle="tab" href="#nav-prof" role="tab" aria-controls="nav-prof" aria-selected="true">My Profile</a>
										<a class="nav-link mr-2" id="nav-cngpass-tab" data-toggle="tab" href="#nav-cngpass" role="tab" aria-controls="nav-cngpass" aria-selected="false">Change Password</a>
										<!--<a class="nav-item nav-link" id="nav-contact-tab" data-toggle="tab" href="#nav-contact" role="tab" aria-controls="nav-contact" aria-selected="false">Project Tab 3</a>-->
									</div>
								</nav>
								<div class="tab-content" id="nav-tabContent">
									<div class="tab-pane fade show active mt-4" id="nav-prof" role="tabpanel" aria-labelledby="nav-prof-tab">
										<form method="post" id="form" action="<?php echo base_url("admin/setting") ?>" enctype="multipart/form-data">
											<div class="row">
												<div class="col-md-8">
													<div class="row">
														
														<div class="col-sm-6">
															<div class="form__group">
																<label class="form__label" for="firstName">First Name*</label>
																<input class="form__field" type="text"  id="firstName"  name="firstName" placeholder=""  value="<?php echo isset($data->firstName)?$data->firstName:"" ?>" >
															</div>
														</div>
														<div class="col-sm-6">
															<div class="form__group">
                                                                <label class="form__label" for="lastName">Last Name</label>
																<input class="form__field" type="text"  id="lastName"  name="lastName" placeholder=""  value="<?php echo isset($data->lastName)?$data->lastName:"" ?>" >
															</div>
														</div>
														<div class="col-sm-6">
															<div class="form__group">
                                                                <label class="form__label" for="email">Email Address*</label>
																<input class="form__field" type="email"  id="email"  name="email" placeholder=""  value="<?php echo isset($data->email)?$data->email:"" ?>" >
															</div>
														</div>
														<div class="col-sm-6">
															<div class="form__group">
                                                                <label class="form__label" for="phone">Mobile Number*</label>
																<input class="form__field" type="text"  id="phone"  name="phone" placeholder=""  value="<?php echo isset($data->phone)?$data->phone:"" ?>" >
															</div>
														</div>
													</div>
												</div>
												<div class="col-md-4 d-flex justify-content-center">
														<input type="hidden" id="id" name="id" value="<?php echo isset($data->id)?$data->id:"" ?>">
														<div class="position-relative fileinput  <?= isset($data->image) && !empty($data->image) ? "fileinput-exists" : "fileinput-new"; ?> text-center" data-provides="fileinput">
															<div class="fileinput-new thumbnail">
																<img src="<?php echo base_url(); ?>assets/uploads/default_user.jpg" alt="...">
															</div>
															<div class="fileinput-preview fileinput-exists thumbnail position-relative text-center">
																<?php if(isset($data->image) && !empty($data->image)){
																	?>
																		<img src="<?php echo base_url()."assets/uploads/".$data->image; ?>" alt="...">
																	<?php
																}?>
																
															</div>
															<div>
																<span class="btn btn-rose btn-round btn-file upload-icon setting_arrow">
																	<span class="fileinput-exists"><i class="fa fa-arrow-up"></i></span>
																	<input type="file" name="image" />
																</span>
															</div>
														</div>
												
												</div>
												<?php 
													$csrf = array(
														'name' => $this->security->get_csrf_token_name(),
														'hash' => $this->security->get_csrf_hash()
													);						
												?>
						  						<input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />
												<button type="submit" class="btn btn-grad ml-3">Save</button>
											</div>
										</form> 
									</div>
									<div class="tab-pane fade mt-4" id="nav-cngpass" role="tabpanel" aria-labelledby="nav-cngpass-tab">
										<form method="post" id="cp-form" action="<?php echo base_url("admin/changePassword") ?>" enctype="multipart/form-data">
											<div class="col-md-4">
												<div class="form__group">
													<input class="form__field" type="password"  id="oldpassword"  name="oldpassword" placeholder="Old Password*" >
													<label class="form__label" for="oldpassword">Old Password*</label>
												</div>
											</div>
											<div class="col-md-4">
												<div class="form__group">
													<input class="form__field" type="password"  id="password"  name="password" placeholder="New Password*" >
													<label class="form__label" for="password">New Password*</label>
												</div>
											</div>
											<div class="col-md-4">
												<div class="form__group">
													<input class="form__field" type="password"  id="confirmpassword"  name="confirmpassword" placeholder="Confirm Password*" >
													<label class="form__label" for="confirmpassword">Confirm Password*</label>
												</div>
											</div>
											<?php 
													$csrf = array(
														'name' => $this->security->get_csrf_token_name(),
														'hash' => $this->security->get_csrf_hash()
													);						
												?>
						  						<input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />
											<button type="submit" class="btn mt-4">Change Password</button>
										</form>
									</div>
																	
								</div>
							</div>
						</div>
					</div>
				</section>
				               
            </div>
        </div>
    </div>
</div>
<script src="<?php echo base_url(); ?>assets/backend/js/plugins/jquery.maskedinput.min.js"></script>
<script>
	$("#form").validate({
		rules: {
			firstName: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			email: {
                email:true,
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			phone: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			
		},
		messages: {
            firstName: {
				required: "Please enter first name",
			},
			email: {
                email: "Please enter valid email address",
				required: "Please enter email address",
			},
			phone: {
				required: "Please enter mobile number",
			},
		},
    });
	$("#cp-form").validate({
		rules: {
			oldpassword: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			password: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			confirmpassword: {
				required: true,
				equalTo: '#password',
				normalizer: function(value) {
					return $.trim(value);
				},
			},
		},
		messages: {
            oldpassword: {
				required: "Please enter old password",
			},
			password: {
				required: "Please enter new Password",
			},
			confirmpassword: {
                required: "Please enter confirm password",
				equalTo: "Password not match",
			},
		},
    });
	$("#phone").mask("(999) 999-9999");
</script>