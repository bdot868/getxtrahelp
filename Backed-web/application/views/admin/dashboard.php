<div class="row">
  <div class="col-md-12">
    <div class="card card-stats">
      <div class="card-body">
        <div class="row">
          <div class="col-md-3">
            <div class="statistics">
              <div class="info">
                <div class="icon icon-info">
                  <i class="now-ui-icons users_single-02"></i>
                </div>
                <h3 class="info-title"><?= $totalUser ?></h3>
                <h6 class="stats-title"><a href="<?php echo base_url('/admin/user'); ?>">Total Families</a></h6>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="statistics">
              <div class="info">
                <div class="icon icon-info">
                  <i class="now-ui-icons users_single-02"></i>
                </div>
                <h3 class="info-title"><?= $totalCargiver ?></h3>
                <h6 class="stats-title"><a href="<?php echo base_url('/admin/caregiver'); ?>">Total Caregivers</a></h6>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>