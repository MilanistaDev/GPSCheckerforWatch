//
//  InterfaceController.swift
//  GPSCfW Extension
//
//  Created by 麻生 拓弥 on 2016/10/17.
//  Copyright © 2016年 麻生 拓弥. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController {

    // MARK:- Property

    @IBOutlet var latLabel: WKInterfaceLabel!
    @IBOutlet var lonLabel: WKInterfaceLabel!
    var latValue:Double = 100.0 // Impossible value(-90 to 90)
    var lonValue:Double = 200.0 // Impossible value(-180 to 180)

    // MARK:- Life Cycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()

        // Access Location Service
        LocationManager.Singleton.sharedInstance.startUpdatingLocation()

        // Set NSNotification
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector:#selector(displayData(notification:)),
                           name:NSNotification.Name(rawValue: LMLocationUpdateNotification),
                           object:nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }

    // MARK:- Private Method

    /**
     取得した位置情報から緯度経度をAppleWatchのLabelに表示
     Acquired latitude and longitude values are displayed on the Apple Watch's labels.
     - parameter notification:通知
     */
    func displayData(notification:Notification) {
        let infoDic: Dictionary = notification.userInfo as Dictionary!
        let location: CLLocation? = infoDic[LMLocationInfoKey] as? CLLocation
        let coordinate = location!.coordinate

        self.latValue = coordinate.latitude
        self.lonValue = coordinate.longitude

        self.latLabel.setText((coordinate.latitude).description)
        self.lonLabel.setText((coordinate.longitude).description)
    }

    /**
     緯度と経度を遷移先のマップ画面に渡す
     Pass the latitude and longitude values to the next map screen(VC).
     - parameter segueIdentifier: SegueのIdentifier名
     - returns Any
     */
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {

        guard self.latValue != 100.0 && self.lonValue != 200.0 else {
            return nil
        }
        guard segueIdentifier == "displayMapSegue" else {
            return nil
        }
        let locationData: [String : Double] = ["latitude": self.latValue, "longitude" : self.lonValue]
        return locationData
    }
}
