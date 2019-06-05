package com.example.gps;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static androidx.core.content.PermissionChecker.PERMISSION_GRANTED;

/**
 * GpsPlugin
 */
public class GpsPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private Registrar registrar;

    private Result result;

    private static final int REQ_CODE = 293032;

    private static final String[] permissions = new String[]{
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
    };

    private GpsPlugin(Registrar registrar) {
        this.registrar = registrar;
        this.registrar.addRequestPermissionsResultListener(this);
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "top.kikt/gps");
        channel.setMethodCallHandler(new GpsPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("gps")) {
            this.result = result;
            checkPermission();
        } else {
            result.notImplemented();
        }
    }

    private void checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            for (String permission : permissions) {
                int i = ContextCompat.checkSelfPermission(getActivity(), permission);
                if (i != PERMISSION_GRANTED) {
                    requestPermission();
                    return;
                }
            }
            requestCurrentGps();
        } else {
            requestCurrentGps();
        }
    }

    private void requestPermission() {
        ActivityCompat.requestPermissions(getActivity(), permissions, REQ_CODE);
    }

    private void requestCurrentGps() {
        LocationManager locationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);
        GpsHandler gpsHandler = new GpsHandler(this, locationManager);
        gpsHandler.handleGps();
    }

    private Activity getActivity() {
        return this.registrar.activity();
    }

    public void setResult(Object obj) {
        Result result = this.result;
        this.result = null;
        result.success(obj);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
        if (requestCode == REQ_CODE) {
            for (int result : grantResults) {
                if (result == PackageManager.PERMISSION_DENIED) {
                    setResult(null);
                    return true;
                }
            }
            requestCurrentGps();
            return true;
        }
        return false;
    }
}
