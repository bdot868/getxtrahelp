<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <?php include('viewCaregiverMenu.php');?>
            </div>
            <div class="card-body">
                <div class="toolbar">
                </div>
                <table class="table table-striped" cellspacing="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="20%">Profile Photo</td>
                            <td class="imageradius">
                                <img src="<?php echo $data->profileImageThumbUrl ?>" >
                            </td>
                        </tr>
                        <tr>
                            <td width="20%">FirstName</td>
                            <td><?= $data->firstName ?></td>
                        </tr>
                        <tr>
                            <td width="20%">LastName</td>
                            <td><?= $data->lastName ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Email</td>
                            <td><?= $data->email ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Age</td>
                            <td><?= $data->age ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Gender</td>
                            <td>
                                <?php
                                  if($data->gender == '1'){
                                        echo "Male";
                                  }elseif($data->gender == '2'){
                                        echo "Female";
                                  }elseif($data->gender == '3'){
                                        echo "Other";
                                  }
                                ?>
                            </td>
                        </tr>
                        <tr>
                            <td width="20%">Phone</td>
                            <td><?= $data->phone ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Is your family Vaccinated(Covid-19)?</td>
                            <td><?php
                                 if(isset($data->familyVaccinated) && $data->familyVaccinated == '1'){
                                     echo "Yes";
                                 }else if(isset($data->familyVaccinated) && $data->familyVaccinated == '2'){
                                     echo "No";
                                 }else{
                                     echo "";
                                 }
                           ?></td>
                        </tr>
                        <tr>
                            <td width="20%">How did you hear about us?</td>
                            <td><?= (!empty($data->hearAboutUsId))?$hearAboutUsObj->name:'' ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Location</td>
                            <td><?= $data->address ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Status</td>
                            <td>
                                <?php if($data->status==0){echo "Need to Verify";}elseif($data->status==1){echo "Active";}elseif($data->status==2){echo "Admin Blocked";}?>
                            </td>
                        </tr>
                        <tr>
                            <td width="20%">Created Date</td>
                            <td><?= $data->createdDate ?></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>   
</div>
