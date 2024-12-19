package com.smslisten;

import java.util.Date;

public class SmsHistory {
    public final String fromPhone;
    public final String body;
    public final String date;
    public final Long id;
    public final String toPhone;

    public SmsHistory(String fromPhone, String body, String date, Long id, String toPhone) {
        this.fromPhone = fromPhone;
        this.toPhone = toPhone;
        this.body = body;
        this.date = date;
        this.id = id;
    }
}
