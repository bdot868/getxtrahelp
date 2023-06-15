package com.app.xtrahelpcaregiver.linkedInManager.control;


import static com.app.xtrahelpcaregiver.linkedInManager.common.CommonInfo.MODE_ACCESS_TOKEN_REQUEST;
import static com.app.xtrahelpcaregiver.linkedInManager.common.CommonInfo.MODE_EMAIL_ADDRESS_REQUEST;
import static com.app.xtrahelpcaregiver.linkedInManager.common.CommonInfo.MODE_PROFILE_DATA_REQUEST;

import com.app.xtrahelpcaregiver.linkedInManager.deamon.LinkedInAsyncTask;
import com.app.xtrahelpcaregiver.linkedInManager.events.LinkedInAccessTokenResponse;
import com.app.xtrahelpcaregiver.linkedInManager.events.LinkedInEmailAddressResponse;
import com.app.xtrahelpcaregiver.linkedInManager.events.LinkedInProfileDataResponse;

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
