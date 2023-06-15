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
                        <form method="post" id="form" enctype="multipart/form-data" action="<?php echo $page['url'] ?>/set" >
                            <input type="hidden" name="id" id="id" value="<?php echo isset($data->id) ? $data->id : "" ?>">
                            <input type="hidden" name="jobcat_name" id="jobcat_name" value="<?php echo isset($data->name) ? $data->name : "" ?>">
                            <div class="form-group">
                                <label>Name</label>
                                <input type="text" class="form-control" name="name" id="name" value="<?php echo isset($data->name) ? $data->name : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control" name="description" id="description"><?php echo isset($data->description) ? $data->description : "" ?></textarea>
                            </div>
                            <div class="form-group">
                                <label>Image</label>
                                <div class="row">
                                    <div class="col-md-6"><input type="file" class="form-control" name="image" id="image"></div>
                                    <?php if(isset($data->imageThumbUrl)) {?>
                                    <div class="col-md-6">
                                        <a href="<?php echo isset($data->imageUrl) ? $data->imageUrl : "" ; ?>" target="_blank">
                                            <img src="<?php echo isset($data->imageThumbUrl) ? $data->imageThumbUrl : "" ?>" width="100px" alt="image">
                                        </a>
                                    </div>
                                   <?php } else {?>
                                   <div class="col-md-6">
                                        <img class="d-none" id="imagePreview" alt="image" src="<?php echo isset($data->imageThumbUrl) ? $data->imageThumbUrl : "" ;?>" width="100px">
                                   </div>
                                   <?php } ?>
                                </div>
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

     function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            if (!input.files[0].type.match('image.*')) {return true; }
            
            else{                            
                    reader.onload = function(e) {
                        $('#imagePreview').removeClass("d-none");
                        $('#imagePreview').attr("src", e.target.result );
                
                }
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#image").change(function() {
        
        readURL(this);
    }); 

    $("#form").validate({
        rules: {
            name: {
                required: true,
                normalizer: function(value) {
                    return $.trim(value);
                },
                remote: {
                    url: "<?php echo $page['url'] ?>/checkJobCat",
                    type: "post",
                    data: {
                        '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>',
                        jobcatid: function(){
                            return $('#id').val();
                        },
                        name: function(){
                            return $('#name').val();
                        },
                        jobcat_name: function() {
                            return $('#jobcat_name').val();
                        }
                    },
                }
            },
            image:{ 
                required: <?php echo isset($data) ? "false" : 'true'; ?>,
                extension: "jpg,JPG,jpeg,JPEG,png,PNG,webp",
            },
        },
        messages: {
            name: {
                required: "Please enter name",
                remote: "Job Category already exist"
            },
            image: {
                required: "Please select image",
				extension: "Allowed only image file",
			},
        },
    });
</script>