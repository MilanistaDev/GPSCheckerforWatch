//
//  MapInterfaceController.swift
//  GPSCheckerforWatch
//
//  Created by 麻生 拓弥 on 2016/10/17.
//  Copyright © 2016年 麻生 拓弥. All rights reserved.
//

import WatchKit
import Foundation


class MapInterfaceController: WKInterfaceController {

    // MARK:- Property

    @IBOutlet var mapView: WKInterfaceMap!
    var locationData: [String : Double] = [:]

    // MARK:- Life Cycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let contextData = context else {
            popToRootController()
            return
        }
        self.locationData = contextData as! [String : Double]
        let latValue = locationData["latitude"]
        let lonValue = locationData["longitude"]

        let mapLocation = CLLocationCoordinate2DMake(latValue!, lonValue!)
        let coordinateSpan = MKCoordinateSpanMake(0.02, 0.02)

        self.mapView.addAnnotation(mapLocation, with: WKInterfaceMapPinColor.red)
        self.mapView.setRegion(MKCoordinateRegionMake(mapLocation, coordinateSpan))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
