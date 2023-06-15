<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <?php include('viewCaregiverMenu.php'); ?>
            </div>
            <div class="card-body">
                <div class="toolbar">
                </div>
                <table class="table table-striped" cellspacing="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="20%">Job Category:</td>
                            <td><?php echo ($userWorkJobCatNames != '') ? $userWorkJobCatNames : '-'; ?>
                            </td>
                        </tr>
                        <tr>
                            <td width="20%">Speciality:</td>
                            <td><?php (isset($userWorkDetails->workSpecialityName) ? $userWorkDetails->workSpecialityName : "-"); ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Maximum distance you are willing to travel:</td>
                            <td><?php (isset($userWorkDetails->maxDistanceTravel) ? $userWorkDetails->maxDistanceTravel : "-"); ?></td>
                        </tr>
                        <tr>
                            <td width="20%">What is your method of transportation:</td>
                            <td><?php (isset($userWorkDetails->workMethodOfTransportationName) ? $userWorkDetails->workMethodOfTransportationName : "-"); ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Types of disabilities caregiver is willing to work with:</td>
                            <td><?php (isset($userWorkDetails->workDisabilitiesWillingTypeName) ? $userWorkDetails->workDisabilitiesWillingTypeName : "-"); ?></td>
                        </tr>
                        <tr>
                            <td width="20%">How many years of experience do you have?:</td>
                            <td><?php (isset($userWorkDetails->experienceOfYear) ? $userWorkDetails->experienceOfYear : "-"); ?></td>
                        </tr>

                        <tr>
                            <td width="20%">What inspired you to become a caregiver?:</td>
                            <td><?php (isset($userWorkDetails->inspiredYouBecome) ? $userWorkDetails->inspiredYouBecome : "-"); ?></td>
                        </tr>
                        <tr>
                            <td width="20%">Caregiver Bio:</td>
                            <td><?php (isset($userWorkDetails->bio) ? $userWorkDetails->bio : "-"); ?></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title d-inline-block">Work Details</h4>
            </div>
            <div class="card-body">
                <table id="datatable" class="table table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th class="font-weight-bold">Work Place</th>
                            <th class="font-weight-bold">Start Date</th>
                            <th class="font-weight-bold">End Date</th>
                            <th class="font-weight-bold">Reason for leaving</th>
                            <th class="font-weight-bold">Description about work</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (isset($userWorkExperienceList) && !empty($userWorkExperienceList)) {
                            foreach ($userWorkExperienceList as $value) {
                        ?>
                                <tr>
                                    <td><?= $value->workPlace ?></th>
                                    <td><?= $value->startDate ?></th>
                                    <td><?= $value->endDate ?></th>
                                    <td><?= $value->leavingReason ?></th>
                                    <td><?= $value->description ?></th>
                                </tr>
                            <?php }
                        } else { ?>
                            <tr>
                                <td colspan="5">No work details found</td>
                            </tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>