<div class="row mainrow">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'] ?>/set"> Add </a>
            </div>
            <div class="card-body">
                <div class="toolbar">
                    <!--Here you can write extra buttons/actions for the toolbar-->
                </div>
                <table id="datatable" class="table table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">Name</th>
                            <th class="font-weight-bold">Key</th>
                            <th class="font-weight-bold">Status</th>
                            <th class="disabled-sorting font-weight-bold">Actions</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Name</th>
                            <th>Key</th>
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
    var mainTable;
    $(document).ready(function() {
        mainTable = $('#datatable').DataTable({
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
                data:{'<?php echo $this->security->get_csrf_token_name(); ?>':'<?php echo $this->security->get_csrf_hash(); ?>'},
                error: function () {
                    $(".datagrid-error").html("");
                    //$("#datagrid").append('<tbody class="datagrid-error"><tr><th colspan="3">No data found in the server</th></tr></tbody>');
                    $("#datagrid_processing").css("display", "none");
                },
            },
        });
    });
</script>