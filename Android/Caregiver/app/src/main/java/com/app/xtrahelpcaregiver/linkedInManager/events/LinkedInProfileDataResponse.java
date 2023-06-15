package com.app.xtrahelpcaregiver.linkedInManager.events;

import org.json.JSONObject;

public interface LinkedInProfileDataResponse {
    void onRequestSuccess(JSONObject jsonObject);
    void onRequestFailed();
}
