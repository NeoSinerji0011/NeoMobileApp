package com.smslisten;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class MySmsReceiver extends BroadcastReceiver {
    private static final String TAG =
            MySmsReceiver.class.getSimpleName();
    public static final String pdu_type = "pdus";
    private Integer TryCount = 0;

    private String[] getSmsTitles() throws Exception {
        // BU Kısım Refactor için deneniyor ve hazır değil.
        /* Gson gson = new Gson();
        HttpClient httpClient = new DefaultHttpClient();
        HttpGet request = new HttpGet("https://sigortadefterimv2api.azurewebsites.net/mobilapi/smstitles");
        HttpResponse response = httpClient.execute(request);
        String data = EntityUtils.toString(response.getEntity());
        Log.d("NEO_LOG", "SMS_TITLES: " + data);
        return gson.fromJson(data, String[].class);*/

        String url = "https://sigortadefterimv2api.azurewebsites.net/mobilapi/smstitles";

        HttpURLConnection httpClient =
                (HttpURLConnection) new URL(url).openConnection();

        // optional default is GET
        httpClient.setRequestMethod("GET");

        //add request header
        httpClient.setRequestProperty("User-Agent", "Mozilla/5.0");

        int responseCode = httpClient.getResponseCode();
        System.out.println("\nSending 'GET' request to URL : " + url);
        System.out.println("Response Code : " + responseCode);

        try (BufferedReader in = new BufferedReader(
                new InputStreamReader(httpClient.getInputStream()))) {

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = in.readLine()) != null) {
                response.append(line);
            }
            Gson gson = new Gson();
            return gson.fromJson(response.toString(), String[].class);
        }
    }

    public void sendSmsToServer(JSONObject message, String user) {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Log.d("NEO_LOG", message + " mesajı için deneme sayısı +" + TryCount);

                    // BU Kısım Refactor için deneniyor ve hazır değil.
                    /*HttpClient httpClient = new DefaultHttpClient();
                    HttpPost httpPost = new HttpPost("https://sigortadefterimv2api.azurewebsites.net/mobilapi/SMSReceiver");
                    httpPost.setEntity(new StringEntity(message));
                    HttpResponse response = httpClient.execute(httpPost);

                    String data = EntityUtils.toString(response.getEntity());
                    Log.d("NEO_LOG:", data);*/

                    URL url = new URL("https://sigortadefterimv2api.azurewebsites.net/mobilapi/SmsReceiver");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
                    conn.setRequestProperty("Accept","application/json");
                    conn.setDoOutput(true);
                    conn.setDoInput(true);

                    Log.i("NEO_LOG", "POST_JSON:" + message);
                    DataOutputStream outputStream= new DataOutputStream(conn.getOutputStream());
                    outputStream.write(message.toString().getBytes(StandardCharsets.UTF_8));
                    outputStream.flush();
                    outputStream.close();

                    Log.i("NEO_LOG", "POST_RESPONSE_STATUS: " + String.valueOf(conn.getResponseCode()));
                    Log.i("NEO_LOG" , "POST_RESPONSE_STATUS: " + conn.getResponseMessage());

                    conn.disconnect();
                } catch (Exception e) {
                    if(e.getMessage().contains("Unable to resolve host") && TryCount >= 2) {
                        TryCount++;
                        Timer timer = new Timer();
                        timer.schedule(new TimerTask() {
                            @Override
                            public void run() {
                                sendSmsToServer(message, user);
                            }
                        }, 5000);
                    }
                    e.printStackTrace();
                }
            }
        });

        thread.start();
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void onReceive(Context context, Intent intent) {
        new Thread(new Runnable(){
            @Override
            public void run() {
                try {
                    Log.d("NEO_LOG ", "SMS CAUGHT");

                    SharedPreferences sharedPref = context.getSharedPreferences("Neo", Context.MODE_PRIVATE);
                    String userInfo = sharedPref.getString("neo_userInfo", "{}");
                    /*if(userInfo.equals("{}")) return;*/
                    String res = sharedPref.getString("neo_smsHistory", "[]");
                    String toPhone = sharedPref.getString("neo_phoneNumber", "");
                    Gson gson = new GsonBuilder().disableHtmlEscaping().create();
                    ArrayList<SmsHistory> data = gson.fromJson(res, new TypeToken<ArrayList<SmsHistory>>(){}.getType());

                    String[] draftMessages = null;
                    draftMessages = getSmsTitles();

                    Log.d("NEO_LOG ", "Draft messages have been taken: " + draftMessages.length);

                    // Get the SMS message.
                    Bundle bundle = intent.getExtras();
                    SmsMessage[] msgs;
                    StringBuilder body = new StringBuilder();
                    String senderPhone = "";
                    String format = bundle.getString("format");
                    // Retrieve the SMS message received.
                    Object[] pdus = (Object[]) bundle.get(pdu_type);
                    if (pdus != null) {
                        // Check the Android version.
                        boolean isVersionM =
                                (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M);
                        // Fill the msgs array.
                        msgs = new SmsMessage[pdus.length];
                        for (int i = 0; i < msgs.length; i++) {
                            // Check Android version and use appropriate createFromPdu.
                            if (isVersionM) {
                                // If Android version M or newer:
                                msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i], format);
                            } else {
                                // If Android version L or older:
                                msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
                            }

                            body.append(msgs[i].getMessageBody());
                            senderPhone = msgs[i].getOriginatingAddress();
                        }
                    }

                    if(body.toString().equals("") || senderPhone.equals(""))
                    {
                        Log.d("NEO_LOG ", "Message: " + body + " ,Phone: " + senderPhone + " empty. Process Killed!");
                        return;
                    }

                    Log.d("NEO_LOG ", "Taken Message Content: " + body);

                    Log.d("NEO_LOG ", "Sender Phone Number: " + senderPhone);

                    final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

                    if(draftMessages != null) {
                        for(int j = 0; j < draftMessages.length; j++){
                            if(body.toString().contains(draftMessages[j])) {
                                Date date = new Date();
                                SmsHistory history = new SmsHistory(senderPhone, body.toString(), sdf.format(date), date.getTime(), toPhone);
                                data.add(0, history);

                                Object[] array = data.toArray();
                                String json = gson.toJson(Arrays.copyOf(array, array.length > 100 ? 100 : array.length));

                                Log.d("NEO_LOG ", "SMS HISTORIES " + json);

                                SharedPreferences.Editor editor = sharedPref.edit();
                                editor.putString("neo_smsHistory", json);
                                editor.apply();

                                Log.d("NEO_LOG ", "Saved To SMS History: " + array.length);

                                JSONObject postObj = new JSONObject();
                                postObj.put("body", history.body);
                                postObj.put("date", history.date);
                                postObj.put("fromPhone", history.fromPhone);
                                postObj.put("toPhone", history.toPhone);

                                sendSmsToServer(postObj, userInfo);
                                Log.d("NEO_LOG ", "SMS Sended To Server");
                            }
                        }
                    }
                    TryCount = 0;
                } catch (Exception e) {
                    if(e.getMessage().contains("Unable to resolve host") && TryCount < 3) {
                        TryCount++;
                        Timer timer = new Timer();
                        timer.schedule(new TimerTask() {
                            @Override
                            public void run() {
                                onReceive(context.getApplicationContext(), intent);
                            }
                        }, 5000);
                    }
                    e.printStackTrace();
                    Log.d("NEO_LOG ", "Error: " + e.toString());
                }
            }
        }).start();
    }
}