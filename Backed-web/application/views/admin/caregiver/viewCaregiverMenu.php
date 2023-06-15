<div class="card-header ">
	<h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
	<a class="btn btn-primary pull-right" href="<?php echo /* isset($_SERVER['HTTP_REFERER'] ) && !empty($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : */ $page['url']; ?>"> Back </a>
	<?php
	if(isset($data) && !empty($data)){
		if($data->profileStatus	== 7 && $data->status == 1){
			?>
			<a class="btn btn-primary pull-right" href="<?= base_url('admin/caregiver/acceptCarGiver/').$data->id ?>" onclick="return confirm('Are you sure?')">Accept</a>
			<?php
		}
	}
	?>
</div>
<?php $keyword = $this->uri->segment(3);?>
<div class="card-body">
	<div class="row">
		<div class="col-md-12">
			<ul class="nav nav-pills box-color">
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'personalInfoView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/personalInfoView/<?php echo $data->id ?>">Personal information</a></li>
                <li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'workDetailsView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/workDetailsView/<?php echo $data->id ?>">Work Details View</a></li>
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'certificationsLicensesView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/certificationsLicensesView/<?php echo $data->id ?>">Certifications/Licenses</a></li>
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'insuranceView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/insuranceView/<?php echo $data->id ?>">Insurance</a></li>
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'appliedJobView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/appliedJobView/<?php echo $data->id ?>">Applied Job</a></li>
			</ul>
		</div>
    </div>
</div>        
		