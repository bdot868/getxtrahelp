package com.app.xtrahelpcaregiver.linkedInManager.events;

import org.json.JSONObject;

public interface LinkedInAccessTokenResponse {
    void onAuthenticationSuccess(JSONObject jsonObject);
    void onAuthenticationFailed();
}
