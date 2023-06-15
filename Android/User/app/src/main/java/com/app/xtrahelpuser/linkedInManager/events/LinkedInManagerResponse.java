package com.app.xtrahelpuser.linkedInManager.events;


import com.app.xtrahelpuser.linkedInManager.dto.LinkedInAccessToken;
import com.app.xtrahelpuser.linkedInManager.dto.LinkedInEmailAddress;
import com.app.xtrahelpuser.linkedInManager.dto.LinkedInUserProfile;

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
