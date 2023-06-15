<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
            <?php include('viewCaregiverMenu.php');?>
            </div>
            <div class="card-body">
                <div class="toolbar">

                <table id="datatable" class="table table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">License Image</th>
                            <th class="font-weight-bold">License Type</th>
                            <th class="font-weight-bold">License Name</th>
                            <th class="font-weight-bold">License Number</th>
                            <th class="font-weight-bold">Description</th>
                            <th class="font-weight-bold">Issue Date</th>
                            <th class="font-weight-bold">Expire Date</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>License Image</th>
                            <th>License Type</th>
                            <th>License Name</th>
                            <th>License Number</th>
                            <th>Description</th>
                            <th>Issue Date</th>
                            <th>Expire Date</th>
                        </tr>
                    </tfoot>
                    <tbody>
                    </tbody>
                   
                </table>
                </div>
            </div>
        </div>
    </div>   
</div>
<script>
    $(document).ready(function() {
        $('#datatable').DataTable({
            "pagingType": "full_numbers",
            "lengthMenu": [
                [50, 100, 150, 200],
                [50, 100, 150, 200],
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
                url: "<?php  echo current_url();?>",
                type: "post",
                data:{'<?php echo $this->security->get_csrf_token_name(); ?>' : '<?php echo $this->security->get_csrf_hash(); ?>'},
                error: function () {
                    $(".datagrid-error").html("");
                    //$("#datagrid").append('<tbody class="datagrid-error"><tr><th colspan="3">No data found in the server</th></tr></tbody>');
                    $("#datagrid_processing").css("display", "none");
                },
            },
        });
    });
</script>
