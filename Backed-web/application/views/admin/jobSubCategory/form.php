<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header ">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'] ?>"> Back </a>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <form method="post" id="form" action="<?php echo $page['url'] ?>/set" >
                            <input type="hidden" name="id" id="id" value="<?php echo isset($data->id) ? $data->id : "" ?>">
                            <div class="form-group">
                                <label>Job Category</label>
                                <select class="form-control" id="jobCategoryId" name="jobCategoryId">
                                    <option value="">Select</option>
                                    <?php
                                        if(isset($jobCatList) && !empty($jobCatList)){
                                            foreach($jobCatList as $value){?>
                                                    <option value="<?php echo $value->id; ?>" <?= (isset($data->jobCategoryId) && $data->jobCategoryId == $value->id)?'selected':'' ?> ><?php echo $value->name; ?></option>
                                            <?php }
                                        }
                                    ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Name</label>
                                <input type="text" class="form-control" name="name" id="name" value="<?php echo isset($data->name) ? $data->name : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <select class="form-control" name="status">
                                    <option value="1" <?php echo isset($data->status) && $data->status == '1' ? 'selected' : '' ?>>Active</option>
                                    <option value="0" <?php echo isset($data->status) && $data->status == '0' ? 'selected' : '' ?>>Inactive</option>
                                </select>
                            </div>
                            <?php
                            $csrf = array(
                                'name' => $this->security->get_csrf_token_name(),
                                'hash' => $this->security->get_csrf_hash()
                            );
                            ?>
                            <input type="hidden" name="<?= $csrf['name']; ?>" value="<?= $csrf['hash']; ?>" />
                            <button type="submit" class="btn btn-fill btn-primary">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $("#form").validate({
        rules: {
            jobCategoryId: {
                required: true,
            },
            name: {
                required: true,
                normalizer: function(value) {
                    return $.trim(value);
                },
                remote: {
                    url: "<?php echo $page['url'] ?>/checkJobSubCat",
                    type: "post",
                    data: {
                        '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>',
                        id: function(){
                            return $('#id').val();
                        },
                        jobCategoryId: function(){
                            return $('#jobCategoryId').val();
                        },
                        name: function(){
                            return $('#name').val();
                        },
                    },
                }
            },
        },
        messages:{
            jobCategoryId:{
                required: "Please select Category"
            },
            name: {
                required: "Please enter name",
                remote: "Job Sub Category already exist"
            },
        },
    });
</script>