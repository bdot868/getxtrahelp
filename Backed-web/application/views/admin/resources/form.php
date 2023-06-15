<script>
    function convertToSlug( str ) {	
        
        //replace all special characters | symbols with a space
        str = str.replace(/[`~!@#$%^&*()_\-+=\[\]{};:'"\\|\/,.<>?\s]/g, ' ').toLowerCase();
        
        // trim spaces at start and end of string
        str = str.replace(/^\s+|\s+$/gm,'');
        
        // replace space with dash/hyphen
        str = str.replace(/\s+/g, '-');	
        document.getElementById("slug").value= str;
        $("#slug").trigger("blur");
        //return str;
    }
</script>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'] ?>"> Back </a>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <form method="post" id="form" action="<?php echo $page['url'] ?>/set" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<?php echo isset($data->id)?$data->id:"" ?>">
                            
                            <div class="form-group">
                                <label>Select Category*</label>  
                                                            
                                <select class="form-control gp-select select2category" name="categoryId" >
                                    <option value="">Category</option>
                                    <?php
                                
                                    if(isset($categoryList) && !empty($categoryList)){
                                        foreach($categoryList as $category)
                                        {
                                            ?>
                                                <option value="<?php echo $category->id; ?>" <?php echo ( isset($data) && $data->categoryId==$category->id ? "selected" : "") ?> ><?php echo $category->name; ?></option>
                                            <?php
                                        }
                                    }
                                    ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Title*</label>
                                <input type="text" onkeyup="convertToSlug(this.value)" class="form-control" name="title"  value="<?php echo isset($data->title)?$data->title:"" ?>">
                            </div>
                            
                            <div class="form-group">
                                <label>Slug*</label>
                                <input type="text" class="form-control" onkeyup="convertToSlug(this.value)" name="slug" id="slug" value="<?php echo isset($data->slug)?$data->slug:"" ?>">
                            </div>

                            <div class="form-group">
                                <label>Description*</label>
                                <textarea class="form-control" name="description" id="editor"><?php echo isset($data->description)?$data->description:"" ?></textarea>
                            </div>

                            <div class="form-group">
                                <label>Metatitle</label>
                                <input type="text" class="form-control" name="metatitle"  value="<?php echo isset($data->metatitle)?$data->metatitle:"" ?>">
                            </div>
                            <div class="form-group">
                                <label>Metakeyword</label>
                                <input type="text" class="form-control" name="metakeyword"  value="<?php echo isset($data->metakeyword)?$data->metakeyword:"" ?>">
                            </div>
                            <div class="form-group">
                                <label>Metadescription</label>
                                <input type="text" class="form-control" name="metadescription"  value="<?php echo isset($data->metadescription)?$data->metadescription:"" ?>">
                            </div>
                            <div class="form-group">
                                <label>Created date</label>
                                <input type="date" class="form-control" name="createdDate" value="<?php echo isset($data->createdDate)? date('Y-m-d',$data->createdDate) :"" ?>">
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <select class="form-control" name="status">
                                    <option value="1" <?php echo isset($data->status) && $data->status == '1' ? 'selected' : '' ?>>Active</option>
                                    <option value="0" <?php echo isset($data->status) && $data->status == '0' ? 'selected' : '' ?>>Inactive</option>
                                </select>
                            </div>

                            <div class="form-group ">
                                <label>Image</label>
                                <div class="row">
                                    <div class="col-md-6"><input type="file" class="form-control" name="image" id="image" ><br></div>
                                    <?php  if(isset($data->thumbImageUrl)) { ?> 
                                        <div class="col-md-6">
                                            <a href="<?php echo isset($data->imageUrl)?$data->imageUrl:"" ?>" target="_blank">
                                                <img id="imagePreview" src="<?php echo isset($data->thumbImageUrl)?$data->thumbImageUrl:"" ?>" width="100px"/>
                                            </a>
                                        </div> 
                                    <?php } else {
                                        ?>
                                            <div class="col-md-6">
                                                <img class="d-none" id="imagePreview" src="<?php echo isset($data->thumbImageUrl)?$data->thumbImageUrl:"" ?>" width="100px" />
                                            </div>
                                        <?php
                                    } ?>
                               </div>
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
    $('.select2category').select2({
        selectOnClose: true
    });
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
            categoryId: {
                required: true,
                normalizer: function(value) {
					return $.trim(value);
				},
            },
			title: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
            slug: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
				remote: '<?php echo  base_url('admin/resources/checkslug').(isset($data->id) ? "/".$data->id : "" ) ?>',
          
			},
			description: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
            },
            metatitle: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
            },
            metakeyword: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
            },
            metadescription: {
				required: true,
				normalizer: function(value) {
					return $.trim(value);
				},
			},
            image:{ 
                required: <?php echo isset($data) ? "false" : 'true'; ?>,
                extension: "jpg|png|jpeg|webp"
            }
		},
		messages: {
            categoryId:{
                required: "Please select category",
            },
            title: {
				required: "Please enter name",
			},
            slug: {
				required: "Please enter slug",              
				    remote: "Slug already Exist please try with diffirent slug",
			},
            description: {
				required: "Please enter description",
            },
            metatitle: {
				required: "Please enter metatitle",
            },
            metakeyword: {
				required: "Please enter metakeyword",
            },
            metadescription: {
				required: "Please enter metadescription",
			},
            image: {
                required: "Please select image",
				extension: "Allowed only image file",
			}
		},
    });
    
    CKEDITOR.replace('editor');
</script>