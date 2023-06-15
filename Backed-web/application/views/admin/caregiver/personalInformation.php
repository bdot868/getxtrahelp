<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header ">
                <h4 class="card-title d-inline-block"><?php echo $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php echo $page['url'] ?>">Back</a>
            </div> 
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <form method="post" id="form" enctype="multipart/form-data" action="<?php echo $page['url'] ?>/personalInformation">
                            <input type="hidden" name="id" value="<?php echo isset($data->id) ? $data->id : "" ?>">
                            <div class="form-group">
                                <label>Image</label>
                                <div class="row">
                                    <div class="col-md-6"><input type="file" class="form-control" name="image" id="image" ></div>
                                    <?php  if(isset($data->profileImageThumbUrl)) { ?> 
                                        <div class="col-md-6">
                                            <a href="<?php echo isset($data->profileImageUrl)?$data->profileImageUrl:"" ?>" target="_blank">
                                                <img id="imagePreview" src="<?php echo isset($data->profileImageThumbUrl)?$data->profileImageThumbUrl:"" ?>" width="100px"/>
                                            </a>
                                        </div> 
                                    <?php } else {
                                        ?>
                                            <div class="col-md-6">
                                                    <img class="d-none" id="imagePreview" src="<?php echo isset($data->profileImageThumbUrl)?$data->profileImageThumbUrl:"" ?>" width="100px" />
                                            </div>
                                        <?php
                                    } ?>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>First Name</label>
                                <input type="text" class="form-control" name="firstName" value="<?php echo isset($data->firstName) ? $data->firstName : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Last Name</label>
                                <input type="text" class="form-control" name="lastName" value="<?php echo isset($data->lastName) ? $data->lastName : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email" value="<?php echo isset($data->email) ? $data->email : "" ?>" readonly>
                            </div>
                            <div class="form-group">
                                <label>Age</label>
                                <input type="text" class="form-control" name="age" value="<?php echo isset($data->age) ? $data->age : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Gender</label>
                                <select class="form-control" name="gender">
                                    <option value="">Select Gender</option>
                                    <option value="1" <?php echo isset($data->gender) && $data->gender == '1' ? 'selected' : '' ?>>Male</option>
                                    <option value="2" <?php echo isset($data->gender) && $data->gender == '2' ? 'selected' : '' ?>>Female</option>
                                    <option value="3" <?php echo isset($data->gender) && $data->gender == '3' ? 'selected' : '' ?>>Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" class="form-control" id="phone" name="phone" value="<?php echo isset($data->phone) ? $data->phone : "" ?>">
                            </div>
                            <div class="form-group">
                <label>Is your family Vaccinated(Covid-19)?</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" value="1" id='yes' class="form-check-input" name="familyVaccinated" <?php echo isset($data->familyVaccinated) && $data->familyVaccinated == '1' ? 'checked' : '' ?>><label for='yes'>Yes</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" value="2" id='no' class="form-check-input" name="familyVaccinated" <?php echo isset($data->familyVaccinated) && $data->familyVaccinated == '2' ? 'checked' : '' ?>><label for='no'>No</label>
                            </div>
                            <div class="form-group">
                                <label>How did you hear about us?</label>
                                <select class="form-control" name="hearAboutUsId">
                                <option value="">Select</option>
                                    <?php
                                        if(isset($hearAboutUsList) && !empty($hearAboutUsList)){
                                            foreach($hearAboutUsList as $value){?>
                                                    <option value="<?php echo $value->id; ?>" <?php echo ( isset($data) && $data->hearAboutUsId==$value->id ? "selected" : "") ?> ><?php echo $value->name; ?></option>
                                             <?php   }
                                            }
                                    ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Location</label>
                                <input type="text" class="form-control" id="address" name="address" value="<?php echo isset($data->address) ? $data->address : "" ?>">
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <select class="form-control" name="status" <?php echo isset($data->status) && $data->status == '0' ? 'disabled' : '' ?>>
                                    <option value="1" <?php echo isset($data->status) && $data->status == '1' ? 'selected' : '' ?>>Active</option>
                                    <option value="" <?php echo isset($data->status) && $data->status == '0' ? 'selected' : '' ?> disabled>Inactive</option>
                                    <option value="2" <?php echo isset($data->status) && $data->status == '2' ? 'selected' : '' ?>>Admin Block</option>
                                </select>
                            </div>
                            <?php 
                                $csrf = array(
                                    'name' => $this->security->get_csrf_token_name(),
                                    'hash' => $this->security->get_csrf_hash()
                                );						
                            ?>
						  <input type="hidden" name="<?=$csrf['name'];?>" value="<?=$csrf['hash'];?>" />
                          <input type="hidden" id="latitude" name="latitude" value="<?php echo isset($data->latitude) ? $data->latitude : "" ?>" />
                            <input type="hidden" id="longitude" name="longitude" value="<?php echo isset($data->longitude) ? $data->longitude : "" ?>" />
                            <button type="submit" class="btn btn-fill btn-primary">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=<?php echo $_ENV['GOOGLEMAPKEY']; ?>&libraries=places&callback=initAutocomplete" async defer></script>

<script>
    /* address */
    var placeSearch, autocomplete;
    var city = "";
    var province = "";
    var componentForm = {
        latitude: 'latitude',
        longitude: 'longitude'
    };

    function initAutocomplete() {
        autocomplete = new google.maps.places.Autocomplete(
            (document.getElementById('address'))
        );
        autocomplete.addListener('place_changed', fillInAddress);
    }

    function fillInAddress() {

        var place = autocomplete.getPlace();

        lat = place.geometry.location.lat();
        lng = place.geometry.location.lng();
     
        $('#latitude').val(lat);
        $('#longitude').val(lng);
}

// $("#phone").mask("(999) 999-9999");

$("#form").validate({
    rules: {
        image:{ 
            required: false,
            extension: "jpg,JPG,jpeg,JPEG,png,PNG,webp"
        },
        firstName: {
            required: true,
            normalizer: function(value) {
                return $.trim(value);
            },
        },
        lastName: {
            required: true,
            normalizer: function(value) {
                return $.trim(value);
            },
        },
        phone: {
            required: true,            
            normalizer: function(value) {
                return $.trim(value);
            },
        },
        gender: {
            required: true
        }
    },
    messages: {
        image: {
            required: "Please choose image",
            extension: "You're only allowed to upload jpg or png or webp images."
        },
        firstName: {
            required: "Please enter first name",
        },
        lastName: {
            required: "Please enter last name",
        },
        phone: {
            required: "Please enter phone",
        },
        gender:{
            required: "Please select gender",
        },
    },
});
</script>
