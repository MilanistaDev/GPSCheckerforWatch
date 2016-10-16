//
//  LocationManager.swift
//  FLATWCForiPhone
//
//  Created by 麻生 拓弥 on 2016/02/12.
//  Copyright © 2016年 麻生 拓弥. All rights reserved.
//

import UIKit
import CoreLocation

let LMLocationUpdateNotification: String = "LMLocationUpdateNotification"
let LMLocationInfoKey: String = "LMLocationInfoKey"


class LocationManager: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation!
    
    // Singleton
    struct Singleton {
        static let sharedInstance = LocationManager()
    }
    
    // MARK:- Initialized
    override init() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        super.init()
        
        locationManager.delegate = self

        // Check Authorization(iOS8 and Later)
        // 位置情報認証状態をチェックしてまだ決まってなければアラート出す
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined) {
            // Always
//            if (self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
//                self.locationManager.requestAlwaysAuthorization()
//            }
            // When Is Use
            if (self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        // if App uses background mode(iOS9 and later)
        // 位置情報をバックグラウンドで取得する際に必要
        // バックグラウンドのトグル入れる
        if #available(iOS 9.0, *) {
            //locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    // MARK: - CLLocationManagerDelegate Method
    /**
       位置情報取得を開始
       Start updating location data
     */
    func startUpdatingLocation()
    {
        self.locationManager.startUpdatingLocation()
    }
    
    /**
       位置情報取得失敗時に呼ばれる
       Call when iOS device failed to get location data.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print("Error: \(error.localizedDescription)")
        // Implement Alert
    }

    /**
       位置情報取得成功したときに呼ばれる
       Call when iOS device succeeded to get location data.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let locationData = locations.last as CLLocation!
        self.currentLocation = locationData
        let locationDataDic = [LMLocationInfoKey : self.currentLocation]
        
        // Notice and send location data. | 通知して位置情報を送信
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: LMLocationUpdateNotification), object: self, userInfo: locationDataDic)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /**
       位置情報の認証ステータスの変更時に呼ばれる
       Call when Authorization status changed.
     */
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status:CLAuthorizationStatus) {
        if (status == .notDetermined) {
            // Always
//            if (self.locationManager.responds(to:#selector(CLLocationManager.requestAlwaysAuthorization))) {
//                self.locationManager.requestAlwaysAuthorization()
//            }
            // When Is Use
            if (self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
}
