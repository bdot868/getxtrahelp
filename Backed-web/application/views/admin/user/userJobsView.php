<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <?php include('viewUserMenu.php');?>
            </div>
            <div class="card-body">
                <div class="toolbar">
                </div>
                <table id="datatable" class="table table-bordered" cellspacing="0" width="100%" userId="<?=$data->id;?>">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">Job Name</th>
                            <th class="font-weight-bold">Category</th>
                            <th class="font-weight-bold">Hired Caregiver</th>
                            <th class="font-weight-bold">Created Date</th>
                            <th class="font-weight-bold">Status</th>
                            <th class="disabled-sorting font-weight-bold">Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Job Name</th>
                            <th>Category</th>
                            <th>Hired Caregiver</th>
                            <th>Created Date</th>
                            <th>Status</th>
                            <th class="disabled-sorting">Actions</th>
                        </tr>
                    </tfoot>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <!-- end content-->
        </div>
         <!--  end card  -->
    </div>  
    <!-- end col-md-12 -->
</div>
<script>
    $(document).ready(function() {
        $('#datatable').DataTable({
            "pagingType": "full_numbers",
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50,"All"]],
            responsive: true,
            language: {
                search: "_INPUT_",
                searchPlaceholder: "Search records",
            },
            "serverSide": true,
            "ordering": false,
		    "processing": true,
            "ajax": {
                url: "<?php echo current_url();?>",
                type: "post",
                data: {
                    '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>',
                    'userId':$('#datatable').attr('userId')
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