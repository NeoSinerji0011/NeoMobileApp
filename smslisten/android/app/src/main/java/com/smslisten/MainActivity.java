package com.smslisten;

import android.content.Intent;
import android.os.Bundle;
import android.os.StrictMode;

import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.reactnativecommunity.asyncstorage.AsyncStorageModule;

public class MainActivity extends ReactActivity {

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "smslisten";
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    if (android.os.Build.VERSION.SDK_INT > 9) {
      StrictMode.ThreadPolicy policy =
              new StrictMode.ThreadPolicy.Builder().permitAll().build();
      StrictMode.setThreadPolicy(policy);
    }

    Intent service = new Intent(this, MySmsReceiver.class);
    this.startService(service);
  }
}
