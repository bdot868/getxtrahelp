<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <div class="form-group col-md-3">
                    <label>Group By</label>
                    <select class="form-control" name="group" id="group">
                        <option value="">All</option>
                        <option value="2">User</option>
                        <option value="3">Caregiver</option>
                    </select>
                </div>
            </div>
            <div class="card-body">
                <div class="toolbar">
                    <!--Here you can write extra buttons/actions for the toolbar-->
                </div>
                <table id="datatable" class="table table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">User Name</th>
                            <th class="font-weight-bold">Email</th>
                            <th class="font-weight-bold">Title</th>
                            <th class="font-weight-bold">Status</th>
                            <th class="disabled-sorting font-weight-bold">Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>User Name</th>
                            <th>Email</th>
                            <th>Title</th>
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
    // $(document).ready(function() {
    //     $('#datatable').DataTable({
    //         "pagingType": "full_numbers",
    //         "lengthMenu": [
    //             [10, 25, 50, -1],
    //             [10, 25, 50, -1],
    //         ],
    //         responsive: true,
    //         language: {
    //             search: "_INPUT_",
    //             searchPlaceholder: "Search records",
    //         },
    //         "serverSide": true,
    //         "ordering": false,
	// 	    "processing": true,
    //         "ajax": {
    //             url: "<?php  echo current_url();?>",
    //             type: "post",
    //             error: function () {
    //                 $(".datagrid-error").html("");
    //                 //$("#datagrid").append('<tbody class="datagrid-error"><tr><th colspan="3">No data found in the server</th></tr></tbody>');
    //                 $("#datagrid_processing").css("display", "none");
    //             },
    //         },
    //     });
        
    // });

    $(document).ready(function() {
        var table = $('#datatable').DataTable({
            
            "pagingType": "full_numbers",
            "pageLength": 50,
            "lengthMenu": [[ 50,100, 150, 200], [ 50,100, 150, 200]],
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
                "data": function (d) {
					d.group = $('#group').val();
                    d.<?php echo $this->security->get_csrf_token_name(); ?> = '<?php echo $this->security->get_csrf_hash(); ?>';
				},
                error: function () {
                    $(".datagrid-error").html("");
                    //$("#datagrid").append('<tbody class="datagrid-error"><tr><th colspan="3">No data found in the server</th></tr></tbody>');
                    $("#datagrid_processing").css("display", "none");
                },
            },
        });
        $("#group").change(function(){
        	table.ajax.reload();	
        });
        
    });

</script>