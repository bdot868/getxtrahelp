package com.app.xtrahelpuser.linkedInManager.events;

import org.json.JSONObject;

public interface LinkedInProfileDataResponse {
    void onRequestSuccess(JSONObject jsonObject);
    void onRequestFailed();
}
