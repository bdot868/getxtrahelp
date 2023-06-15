<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
            <?php include('viewUserMenu.php');?>
            </div>
            <div class="card-body">
                <div class="toolbar">
                </div>
            </div>
        </div>
    </div>   
</div>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body recp_lbl">
                Number of Receipients: <?=$numLovedRecipients;?>
            </div>
        </div>
    </div>   
</div>
<?php
$cnt = 0;
if(isset($userAboutLovedList) && !empty($userAboutLovedList)){
    foreach($userAboutLovedList as $value){?>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header recp_lbl">
                Receipients <?=++$cnt;?> 
            </div>
            <div class="card-body">
                <div class="toolbar">
                </div>
                <table class="table table-striped" cellspacing="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="20%">What type of disabilities your loved one has?</td>
                            <td><?php
                                if(!empty($value->lovedDisabilitiesTypeId)){
                                    $disabilityTypeObj = $this->Loved_Disabilities_Type_Model->get(['status'=>1,'id'=>$value->lovedDisabilitiesTypeId]);
                                    echo $disabilityTypeObj->name;
                                }else{
                                    echo "";
                                }
                             ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Describe about your loved one</td>
                            <td><?= (isset($value->lovedAboutDesc))?$value->lovedAboutDesc:'' ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Categories your loved one needs help with</td>
                            <td><?php
                                   $lovedCatObj = $this->User_Loved_Category_Model->get(['userId'=>$value->userId,'userAboutLovedId'=>$value->id,'getLovedCategoryData'=>true]);
                                   $cat_ary = array();
                                   if(isset($lovedCatObj) && !empty($lovedCatObj)){
                                        foreach($lovedCatObj as $cat_v){
                                            $cat_ary[] = $cat_v->lovedCategoryName;
                                        }
                                        echo implode(", ",$cat_ary);
                                   }else{
                                        echo (!empty($value->lovedOtherCategoryText)?$value->lovedOtherCategoryText:'');
                                   }
                            ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Is your loved one Behavioral or Non-Behavioral?</td>
                            <td><?= (isset($value->lovedBehavioral) && $value->lovedBehavioral == '1')?'Behavioral':'Non-Behavioral' ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Is your loved one Verbal or Non-verbal?</td>
                            <td><?= (isset($value->lovedVerbal) && $value->lovedVerbal == '1')?'Verbal':'Non-Verbal' ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Allergies</td>
                            <td><?= (isset($value->allergies))?$value->allergies:'' ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Specialities</td>
                            <td><?php
                             $lovedSpeObj = $this->User_Loved_Specialities_Model->get(['userId'=>$value->userId,'userAboutLovedId'=>$value->id,'getLovedSpecialitiesData'=>true]);
                             $spe_ary = array();
                            if(isset($lovedSpeObj) && !empty($lovedSpeObj)){
                                foreach($lovedSpeObj as $spe_v){
                                    $spe_ary[] = $spe_v->lovedSpecialitiesName;
                                }
                                echo implode(", ",$spe_ary);
                            }
                            ?></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>   
</div>    
    <?php }} ?>    
