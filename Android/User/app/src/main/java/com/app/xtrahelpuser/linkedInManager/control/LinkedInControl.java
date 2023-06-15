package com.app.xtrahelpuser.linkedInManager.control;


import static com.app.xtrahelpuser.linkedInManager.common.CommonInfo.MODE_ACCESS_TOKEN_REQUEST;
import static com.app.xtrahelpuser.linkedInManager.common.CommonInfo.MODE_EMAIL_ADDRESS_REQUEST;
import static com.app.xtrahelpuser.linkedInManager.common.CommonInfo.MODE_PROFILE_DATA_REQUEST;

import com.app.xtrahelpuser.linkedInManager.deamon.LinkedInAsyncTask;
import com.app.xtrahelpuser.linkedInManager.events.LinkedInAccessTokenResponse;
import com.app.xtrahelpuser.linkedInManager.events.LinkedInEmailAddressResponse;
import com.app.xtrahelpuser.linkedInManager.events.LinkedInProfileDataResponse;

public class LinkedInControl {
    private static final String TAG = "LinkedInControl";

    public void getAccessToken(String url, LinkedInAccessTokenResponse linkedInAccessTokenResponse) {
        new LinkedInAsyncTask(url, MODE_ACCESS_TOKEN_REQUEST, linkedInAccessTokenResponse).execute();
    }

    public void getProfileData(String url, LinkedInProfileDataResponse linkedInProfileDataResponse) {
        new LinkedInAsyncTask(url, MODE_PROFILE_DATA_REQUEST, linkedInProfileDataResponse).execute();
    }

    public void getEmailAddress(String url, LinkedInEmailAddressResponse linkedInEmailAddressResponse) {
        new LinkedInAsyncTask(url, MODE_EMAIL_ADDRESS_REQUEST, linkedInEmailAddressResponse).execute();
    }
}
