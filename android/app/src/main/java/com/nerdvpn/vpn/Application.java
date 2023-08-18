package com.nerdvpn.vpn;

import android.content.Context;

import androidx.multidex.MultiDex;

import io.flutter.app.FlutterApplication;

public class Application extends FlutterApplication {
    @Override
    protected void attachBaseContext(Context base) {
        MultiDex.install(this);
        super.attachBaseContext(base);
    }
}
