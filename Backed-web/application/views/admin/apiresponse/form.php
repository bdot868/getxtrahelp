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
                        <form method="post" id="form" action="<?php echo $page['url'] ?>/set">
                            <input type="hidden" name="id" value="<?php echo isset($data->id)?$data->id:"" ?>">
                            <div class="form-group">
                                <label>Key</label>
                                <input type="text" class="form-control" value="<?php echo isset($data->key)?$data->key:"" ?>"readonly>
                            </div>
                            <div class="form-group">
                                <label>Value_en</label>
                                <input type="text" class="form-control" name="value_en" value="<?php echo isset($data->value_en)?$data->value_en:"" ?>">
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
                            <input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />
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
        errorPlacement: function(error, element) {
            //console.log(element.attr("type"));
            if (element.attr("type") == "checkbox" ){
                error.insertAfter(".group-extra-err");	
            }else{
                error.insertAfter(element);	
            }  
        },
		rules: {
			key: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
			value_en: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
		},
		messages: {
            key: {
				required: "Please enter key",
			},
            value_en: {
				required: "Please enter value_en",
			},
		},
    });
</script>