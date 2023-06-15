<div class="row">
    <div class="col-md-12">
        <div class="card">
            <?php include('userMenu.php');?>
            <!-- <div class="card-header ">
                <h4 class="card-title d-inline-block"><?php  $pagename ?></h4>
                <a class="btn btn-primary pull-right" href="<?php  $page['url'] ?>">Back</a>
            </div> -->
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <form method="post" id="form" enctype="multipart/form-data" action="<?php echo $page['url'] ?>/aboutUserLovedOne">
                            <input type="hidden" name="id" value="<?php echo isset($data->id) ? $data->id : "" ?>">
                            <div class="form-group">
                                <label>Number of recipients needing care</label>
                                <select class="form-control" name="numRecipients" id="numRecipients">
                                    
                                    <?php
                                    $optionHtml = '';
                                    for ($x = 1; $x <= 10; $x++){
                                        $sel_attr = ($numLovedRecipients == $x)?'selected':'';
                                        $optionHtml .= "<option value='$x' $sel_attr>$x</option>";
                                      }
                                      echo $optionHtml;
                                    ?>
                                </select>
                            </div>
                            <div id="aboutLovedContainer">
                            <?php
                            $cnt =0; 
                            if(isset($userAboutLovedList) && !empty($userAboutLovedList)){
                                foreach($userAboutLovedList as $v){?>
                                        <div class='recipientBlock rec_block_separ1'>
                                            <div class="form-group recp_lbl">
                                                Recipients <?= ++$cnt;?>
                                            </div>
                                            <div class="form-group">
                                                <label>What type of disabilities your loved one has?</label>
                                                <select class="form-control" name='typeOfDisabilities[<?=$cnt?>]'> 
                                                    <option value=''>Select</option>
                                                <?php
                                                   if(isset($typeOfDisablities) && !empty($typeOfDisablities)){
                                                        foreach($typeOfDisablities as $value){?>
                                                                <option value="<?php echo $value->id; ?>" <?php echo ($v->lovedDisabilitiesTypeId==$value->id ? "selected" : "") ?> ><?php echo $value->name; ?></option>
                                                        <?php   }
                                                        }
                                                ?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Describe about your loved one</label>
                                                <textarea type="text" class="form-control" name="desc[<?=$cnt?>]"><?= $v->lovedAboutDesc ?></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label>Categories your loved one needs help with</label>
                                                <div class="row ml-2">
                                                <?php
                                                    $lovedCatObj = $this->User_Loved_Category_Model->get(['userAboutLovedId'=>$v->id,'userId'=>$v->userId]);
                                                    $userLovedCategories_arr = [];
                                                    if(isset($lovedCatObj) && !empty($lovedCatObj)){
                                                        
                                                        foreach($lovedCatObj as $catVal){    
                                                            $userLovedCategories_arr[] =  $catVal->lovedCategoryId;   
                                                        }
                                                    }

                                                   if(isset($lovedCategoryList) && !empty($lovedCategoryList)){
                                                        foreach($lovedCategoryList as $value){
                                                            $checkedAttr = ((!empty($userLovedCategories_arr)) && in_array($value->id,$userLovedCategories_arr))?'checked=true':'';
                                                             ?>
                                                        <div class="col-md-6">
                                                            <input type="checkbox" class='form-check-input' id="<?= "userLovedCategory".$cnt.$value->id?>" name="userLovedCategory<?=$cnt?>[]" <?= $checkedAttr; ?> value="<?= $value->id; ?>">
                                                            <label for="<?= "userLovedCategory".$cnt.$value->id?>" class="form-check-label"><?= $value->name; ?></label>
                                                        </div>
                                                    <?php   }
                                                        }
                                                ?>    
                                                </div>
                                            </div>                                
                                            <div class="form-group">
                                                <label>Is your loved one Behavioral or Non-Behavioral?</label>
                                                <div>
                                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedBehavioral[<?=$cnt?>]" id="lovedBehavioral<?=$cnt?>" <?php echo (!empty($v->lovedBehavioral) && $v->lovedBehavioral == '1')?'checked':'' ?> value="1" />
                                        <label class="form-check-label" for="lovedBehavioral<?=$cnt?>">Behavioral</label>
                                                    </div>
                                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedBehavioral[<?=$cnt?>]"  id="lovedNonBehavioral<?=$cnt?>" <?php echo (!empty($v->lovedBehavioral) && $v->lovedBehavioral == '2')?'checked':'' ?>  value="2"/>
                                        <label class="form-check-label" for="lovedNonBehavioral<?=$cnt?>">Non-behavioral</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Is your loved one Verbal or Non-verbal?</label> 
                                                <div>
                                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedVerbal[<?=$cnt?>]" id="lovedVerbal<?=$cnt?>" <?php echo (!empty($v->lovedBehavioral) && $v->lovedBehavioral == '1')?'checked':'' ?> value="1" />
                                        <label class="form-check-label" for="lovedVerbal<?=$cnt?>">Verbal</label>
                                                    </div>
                                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedVerbal[<?=$cnt?>]"  id="lovedNonVerbal<?=$cnt?>" <?php echo (!empty($v->lovedBehavioral) && $v->lovedBehavioral == '2')?'checked':'' ?>  value="2"/>
                                        <label class="form-check-label" for="lovedNonVerbal<?=$cnt?>">Non-verbal</label>
                                                    </div>
                                                </div>
                                            </div>                                            
                                            <div class="form-group">
                                                <label>Allergies</label>
                                                <input type="text" class="form-control" name="allergies[<?=$cnt?>]" value="<?= $v->allergies ?>"> 
                                            </div>
                                            <div class="form-group">
                                                <label>Specialities</label>
                                                <div class="row ml-2">
                                                <?php
                                                $lovedSpeObj = $this->User_Loved_Specialities_Model->get(['userAboutLovedId'=>$v->id,'userId'=>$v->userId]);
                                                $userLovedSpecialities_arr = [];
                                                if(isset($lovedSpeObj) && !empty($lovedSpeObj)){
                                                    
                                                     foreach($lovedSpeObj as $speVal){    
                                                        $userLovedSpecialities_arr[] =  $speVal->lovedSpecialitiesId;   
                                                   }
                                                }

                                                if(isset($lovedSpecialitiesList) && !empty($lovedSpecialitiesList)){
                                                    foreach($lovedSpecialitiesList as $value){
                                                        $checkedAttr = ((!empty($userLovedSpecialities_arr)) && in_array($value->id,$userLovedSpecialities_arr))?'checked=true':'';
                                                         ?>
                                                    <div class="col-md-6">
                                                        <input type="checkbox" class='form-check-input' id="<?= "userLovedSpecialities".$cnt.$value->id?>" name="userLovedSpecialities<?=$cnt?>[]" <?= $checkedAttr; ?> value="<?= $value->id; ?>">
                                                        <label for="<?= "userLovedSpecialities".$cnt.$value->id?>" class="form-check-label"><?= $value->name; ?></label>
                                                    </div>
                                                <?php   }
                                                    }
                                                ?>
                                                </div>
                                            </div>
                                        </div>             
                                <?php }}?>    
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
<link href="<?php echo base_url(); ?>assets/backend/css/jquery-ui.css" rel='stylesheet'>
<script src="<?php echo base_url(); ?>assets/backend/js/jquery-ui.min.js" ></script>
<script>
//$('#soonPlanningHireDate').datepicker({ dateFormat: 'yy-mm-dd' });
$('#soonPlanningHireDate').datepicker();

// $("#phone").mask("(999) 999-9999");

$(document).ready(function() {
    
    $('div.recipientBlock').slice('-1').removeClass('rec_block_separ1');

    var disabilitiesType = <?php echo json_encode($typeOfDisablities) ?>;  
    var lovedCategoryList = <?php echo json_encode($lovedCategoryList) ?>; 
    var lovedSpecialitiesList = <?php echo json_encode($lovedSpecialitiesList) ?>;

    $('#numRecipients').change(function(){

        var oldNumRecipients = $('div.recipientBlock').length;
        var newNumRecipients = $(this).val();
        
        var recipientBlock_str = '';
        if(newNumRecipients > oldNumRecipients){
            
            for(let i = (oldNumRecipients+1); i <= newNumRecipients;i++){
                nextCnt = i;
                recipientBlock_str += `<div class="recipientBlock rec_block_separ2">
                                    <div class="form-group recp_lbl">Recipients `+i+`</div>
                                    <div class="form-group">
                                        <label>What type of disabilities your loved one has?</label>
                                        <select class="form-control" name="typeOfDisabilities[`+nextCnt+`]"> 
                                            <option value="">Select</option>`
                                            $.each(disabilitiesType, function(k1,v1) {
                                                recipientBlock_str += `<option value="`+v1.id+`">`+v1.name+`</option>`;
                                            });
                                            recipientBlock_str += `</select>
                                    </div>
                                    <div class="form-group">
                                        <label>Describe about your loved one</label>
                                        <textarea type="text" class="form-control" name="desc[`+nextCnt+`]"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label>Categories your loved one needs help with</label>
                                        <div class="row ml-2">`
                                        $.each(lovedCategoryList, function(k1,v1) {
                                            recipientBlock_str += `<div class="col-md-6">
                                                                        <input type="checkbox" class='form-check-input' id="userLovedCategory`+nextCnt+v1.id+`" name="userLovedCategory`+nextCnt+`[]"  value="`+v1.id+`">
                                                                        <label for="userLovedCategory`+nextCnt+v1.id+`" class="form-check-label">`+v1.name+`</label>
                                                                    </div>`;
                                        });

                                    recipientBlock_str += `</div>
                                    </div>
                                    <div class="form-group">
                                            <label>Is your loved one Behavioral or Non-Behavioral?</label>
                                            <div>
                                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="lovedBehavioral[`+nextCnt+`]" id="lovedBehavioral`+nextCnt+`" value="1" />
                                    <label class="form-check-label" for="lovedBehavioral`+nextCnt+`">Behavioral</label>
                                                </div>
                                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="lovedBehavioral[`+nextCnt+`]"  id="lovedNonBehavioral`+nextCnt+`" value="2" />
                                    <label class="form-check-label" for="lovedNonBehavioral`+nextCnt+`">Non-behavioral</label>
                                                </div>
                                            </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Is your loved one Verbal or Non-verbal?</label> 
                                        <div>
                                            <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedVerbal[`+nextCnt+`]" id="lovedVerbal`+nextCnt+`" value="1" />
                                        <label class="form-check-label" for="lovedVerbal`+nextCnt+`">Verbal</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="lovedVerbal[`+nextCnt+`]"  id="lovedNonVerbal`+nextCnt+`" value="2"/>
                                        <label class="form-check-label" for="lovedNonVerbal`+nextCnt+`">Non-verbal</label>
                                            </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Allergies</label>
                                        <input type="text" class="form-control" name="allergies[`+nextCnt+`]" value=""> 
                                    </div>
                                    <div class="form-group">
                                                <label>Specialities</label>
                                                <div class="row ml-2">`
                                                $.each(lovedSpecialitiesList, function(k1,v1) {
                                                    recipientBlock_str += `<div class="col-md-6">
                                                        <input type="checkbox" class='form-check-input' id="userLovedSpecialities`+nextCnt+v1.id+`" name="userLovedSpecialities`+nextCnt+`[]"  value="`+v1.id+`">
                                                        <label for="userLovedSpecialities`+nextCnt+v1.id+`" class="form-check-label">`+v1.name+`</label>
                                                    </div>`;
                                                });
                                recipientBlock_str += `</div>
                                     </div>
                            </div>`;        
            }
        }else{
            if(newNumRecipients < oldNumRecipients){
                $('div.recipientBlock').slice(-(oldNumRecipients-newNumRecipients)).remove();
            }
        }
           $("#aboutLovedContainer").append(recipientBlock_str);
           
    });
});
</script>
