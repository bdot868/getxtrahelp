package com.app.xtrahelpuser.linkedInManager.events;

import org.json.JSONObject;

public interface LinkedInEmailAddressResponse {
    void onSuccessResponse(JSONObject jsonObject);
    void onFailedResponse();
}
