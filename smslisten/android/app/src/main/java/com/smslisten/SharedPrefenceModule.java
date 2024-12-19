package com.smslisten;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class SharedPrefenceModule extends ReactContextBaseJavaModule {
    ReactApplicationContext context;

    SharedPrefenceModule(ReactApplicationContext context) {
        super(context);

        this.context = context;
    }

    @NonNull
    @org.jetbrains.annotations.NotNull
    @Override
    public String getName() {
        return "SharedPrefenceModule";
    }

    @ReactMethod
    public void set(String name, String value, Promise promise) {
        try {
            Log.d("set name", name);
            Log.d("set value", value);
            SharedPreferences sharedPref = context.getSharedPreferences("Neo", Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = sharedPref.edit();
            editor.putString(name, value);
            editor.apply();
            promise.resolve(true);
        } catch(Exception e) {
            promise.reject("Error", e);
        }
    }

    @ReactMethod
    public void get(String name, Promise promise) {
        try{
            Log.d("get name", name);
            SharedPreferences sharedPref = context.getSharedPreferences("Neo", Context.MODE_PRIVATE);
            String res = sharedPref.getString(name, "");
            promise.resolve(res);
        } catch (Exception e) {
            promise.reject("Error", e);
        }
    }
}