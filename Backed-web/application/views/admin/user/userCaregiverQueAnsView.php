<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'].'/userJobSingleView/'.$jobId ?>"> Back </a>
            </div>
            <div class="card-body">
                <div class="toolbar">
                    <!--Here you can write extra buttons/actions for the toolbar-->
                </div>
                <table class="table table-striped" cellspacing="0" width="100%">
                    <tbody>

                        <?php
                            if(isset($caregiverQueAnsDb) && !empty($caregiverQueAnsDb)){
                                foreach($caregiverQueAnsDb as $queAns){?>
                                    <tr>
                                        <td width="20%"><b><?=$queAns->question?></b></td>
                                        <td><?=$queAns->answer?></td>
                                    </tr><?php  }}
                        ?>
                   </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
