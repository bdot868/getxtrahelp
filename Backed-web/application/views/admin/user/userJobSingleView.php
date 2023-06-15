<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'].'/userJobsView/'.$data->userId; ?>"> Back </a>
            </div>
            <div class="card-body">
                <div class="toolbar">
                    <!--Here you can write extra buttons/actions for the toolbar-->
                </div>
                <div class="row mb-4">
                    <div class="col-md-12 d-flex">
                        <div class="col-md-8">
                            <div><b class="pr-2">Job Name:</b><?= $data->name; ?></div>
                            <div><b class="pr-2">Category:</b><?= $catname; ?></div>
                            <div><b class="pr-2">Caregiver Preferences:</b><?= $caregiver_preference; ?></div>
                            <div><b class="pr-2">Location:</b><?= $data->location; ?></div>
                        </div>
                        <div class="col-md-4">
                            <div><b class="pr-2">Price:</b><?= '$ '.$data->price; ?></div>
                            <div><b class="pr-2">Status:</b><?= $this->jobStatus[$data->status]; ?></div>
                            <div ><div class="d-inline-block align-top pr-2"><b>Time/Schedule:</b></div><div class="d-inline-block"><?=$time_schedule?><br/><?=$schedule_date?></div></div>
                        </div>
                    </div>
                </div>
                <table class="table" bgcolor="whitesmoke" cellspacing="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="20%"><b>Description</b></td>
                            <td><?= $data->description; ?></td>
                        </tr>
                        <tr>
                            <td width="20%"><b>Questions</b></td>
                            <td>
                            <?php
                            if(isset($user_job_question_db) && !empty($user_job_question_db)){
                                foreach($user_job_question_db as $jobquev){?>
                                         <div><?=$jobquev->question?></div>    
                                <?php } } ?>
                            </td>
                        </tr>
                        <tr>
                            <td width="20%"><b>Photo/Video</b></td>
                            <td><?php
                                if(isset($user_job_media_db) && !empty($user_job_media_db)){?>
                                    <div><?php
                                    foreach($user_job_media_db as $jobv){
                                        if($jobv->isVideo == 1 && $jobv->mediaName != '123'){?>
                                           <div class="align-bottom mt-2 d-inline-block">
                                                <video   width="200" height="200" controls>
                                                    <source src="<?php echo $jobv->mediaNameUrl ?>" type="video/mp4"> 
                                                </video>
                                           </div>  
                                         <?php }else if($jobv->isVideo == 0){?>
                                             <div  class="align-bottom mt-2 d-inline-block" ><img src="<?php echo $jobv->mediaNameThumbUrl ?>" class="chatrplyimg"></div>
                                       <?php }
                                     } ?>
                                    </div>
                               <?php }?>
                            </td>
                        </tr>
                   </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block">List of caregiver who have applied for this job</h4>
            </div>
            <div class="card-body">
                <table id="caregiver_datatable" class="table table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">Name</th>
                            <th class="font-weight-bold">Email</th>
                            <th class="font-weight-bold">Phone</th>
                            <th class="font-weight-bold">Address</th>
                            <th class="font-weight-bold">Age</th>
                            <th class="font-weight-bold">Gender</th>
                            <th class="font-weight-bold">Is Hired</th>
                            <th class="font-weight-bold">Answers</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Is Hired</th>
                            <th>Answers</th>
                        </tr>
                    </tfoot>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>   
</div>

<script type="text/javascript">
    $(document).ready(function() {
       
        $('#caregiver_datatable').DataTable({
            "pagingType": "full_numbers",
            "lengthMenu": [
                [10, 25, 50, -1],
                [10, 25, 50, "All"],
            ],            
            responsive: true,
            language: {
                search: "_INPUT_",
                searchPlaceholder: "Search records",
            },
            "serverSide": true,
            "ordering": false,
            "processing": true,
            "ajax": {
                url: "<?php echo base_url('admin/User/getCaregiversAppliedForJob');?>",
                type: "post",
                data: {
                    '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>',
                    jobId:"<?php echo $data->id; ?>"
                },
                error: function () {
                    $(".datagrid-error").html("");
                    //$("#datagrid").append('<tbody class="datagrid-error"><tr><th colspan="3">No data found in the server</th></tr></tbody>');
                    $("#datagrid_processing").css("display", "none");
                },
            },
        });
    });
</script>        