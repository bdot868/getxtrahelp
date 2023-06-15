package com.app.xtrahelpcaregiver.linkedInManager.events;


import com.app.xtrahelpcaregiver.linkedInManager.dto.LinkedInAccessToken;
import com.app.xtrahelpcaregiver.linkedInManager.dto.LinkedInEmailAddress;
import com.app.xtrahelpcaregiver.linkedInManager.dto.LinkedInUserProfile;

public interface LinkedInManagerResponse {
    void onGetAccessTokenFailed();

    void onGetAccessTokenSuccess(LinkedInAccessToken linkedInAccessToken);

    void onGetCodeFailed();

    void onGetCodeSuccess(String code);

    void onGetProfileDataFailed();

    void onGetProfileDataSuccess(LinkedInUserProfile linkedInUserProfile);

    void onGetEmailAddressFailed();

    void onGetEmailAddressSuccess(LinkedInEmailAddress linkedInEmailAddress);
}
