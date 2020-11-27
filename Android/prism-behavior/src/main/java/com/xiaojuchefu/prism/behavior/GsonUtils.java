package com.xiaojuchefu.prism.behavior;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

import java.util.ArrayList;
import java.util.List;

public class GsonUtils {

    private static Gson sGson = new Gson();

    public static <T> T fromJson(String json, Class<T> classOfT) {
        return sGson.fromJson(json, classOfT);
    }

    public static <T> List<T> fromJsonArray(String json, Class<T> classOfT) {
        JsonArray array = new JsonParser().parse(json).getAsJsonArray();
        ArrayList<T> mList = new ArrayList<T>(array.size());
        for (JsonElement elem : array) {
            mList.add(sGson.fromJson(elem, classOfT));
        }
        return mList;
    }

    public static String toJson(Object src) {
        return sGson.toJson(src);
    }

}
