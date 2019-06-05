package com.example.gps;
/// create 2019-06-05 by cai


import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;

import java.util.HashMap;
import java.util.Map;

class GpsHandler implements LocationListener {
    private final GpsPlugin gpsPlugin;
    private final LocationManager locationManager;

    GpsHandler(GpsPlugin gpsPlugin, LocationManager locationManager) {
        this.gpsPlugin = gpsPlugin;
        this.locationManager = locationManager;
    }

    void handleGps() {
        Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);//高精度
        criteria.setAltitudeRequired(false);
        criteria.setCostAllowed(true);

//        String bestProvider = locationManager.getBestProvider(criteria, true);

//        locationManager.requestLocationUpdates(bestProvider, 1000L, 10, this);
        locationManager.requestSingleUpdate(criteria, this, Looper.getMainLooper());
    }

    @Override
    public void onLocationChanged(Location location) {
        locationManager.removeUpdates(this);
        Map<String, String> map = new HashMap<>();
        map.put("lat", String.valueOf(location.getLatitude()));
        map.put("lng", String.valueOf(location.getLongitude()));
        gpsPlugin.setResult(map);
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
}
