<!-- <style></style> -->
<div class="card-header ">
	<h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
	<a class="btn btn-primary pull-right" href="<?php echo /* isset($_SERVER['HTTP_REFERER'] ) && !empty($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : */ $page['url']; ?>"> Back </a>
</div>
<?php $keyword = $this->uri->segment(3);?>
<div class="card-body">
	<div class="row">
		<div class="col-md-12">
			<ul class="nav nav-pills box-color">
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'personalInfoView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/personalInfoView/<?php echo $data->id ?>">Personal information</a></li>
                <li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'aboutUserLovedOneView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/aboutUserLovedOneView/<?php echo $data->id ?>">About User Loved One</a></li>
				<li class="nav-item"><a class="nav-link <?php echo isset($keyword) && $keyword == 'userJobsView' ? 'active' : '' ?>" href="<?php echo $page['url']?>/userJobsView/<?php echo $data->id ?>">User Jobs</a></li>
			</ul>
		</div>
    </div>
</div>        
		