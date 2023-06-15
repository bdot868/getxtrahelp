package com.app.xtrahelpcaregiver.Utils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;

public class JsonUtils {
    private static final Gson GSON = new Gson();

    private JsonUtils() {
        throw new AssertionError("No Instance");
    }

    public static String toJson(Object object) {
        return GSON.toJson(object);
    }

    public static <T> T fromJson(String json, Class<T> type) {
        try {
            return GSON.fromJson(json, type);
        } catch (Exception e) {
            return null;
        }
    }

    public static <T> T fromJson(String json, TypeToken<T> typeToken) {
        try {
            return GSON.fromJson(json, typeToken.getType());
        } catch (Exception e) {
            return null;
        }
    }

    public static Object fromJson(String jsonString, Type type) {
        return new Gson().fromJson(jsonString, type);
    }
}
