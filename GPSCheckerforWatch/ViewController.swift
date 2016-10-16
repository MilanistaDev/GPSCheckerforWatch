//
//  ViewController.swift
//  GPSCheckerforWatch
//
//  Created by 麻生 拓弥 on 2016/10/17.
//  Copyright © 2016年 麻生 拓弥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK:- Property

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Access Location Service
        LocationManager.Singleton.sharedInstance.startUpdatingLocation()

        // Set NSNotificationCenter
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector:#selector(displayData(notification:)),
                           name:NSNotification.Name(rawValue: LMLocationUpdateNotification),
                           object:nil)
    }

    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }

    // MARK:- Private Method
    /**
     位置情報を取得
     get Location data
     - parameter notification:通知
     */
    func displayData(notification:Notification) {
        let infoDic: Dictionary = notification.userInfo as Dictionary!
        let location: CLLocation? = infoDic[LMLocationInfoKey] as? CLLocation
        let coordinate = location!.coordinate

        self.latLabel.text = (coordinate.latitude).description
        self.lonLabel.text = (coordinate.longitude).description
    }

    // MARK:- Memory warning

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

