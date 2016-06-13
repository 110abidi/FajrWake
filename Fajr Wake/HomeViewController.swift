//
//  HomeViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var prayerTimes: [String] = []
    var manager: OneShotLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPrayerTimes()
        
        //displayPrayerTimesSegue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayPrayerTimesSegue"
        {
            if  let navController = segue.destinationViewController as? UINavigationController,
                let displayPrayerVC = navController.topViewController as? DisplayPrayersViewController {
                displayPrayerVC.prayTimesArray = prayerTimes
            }
        }
    }
    
    // gets location and calls updatePrayerTimes function
    func setupPrayerTimes() {
        // FIX: put updating status animation thingy... LOL
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                // got the location!
                print("location: \(loc)")
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                self.updatePrayerTimes(lat, lon: lon, gmt: LocalGMT.getLocalGMT())
            } else if let err = error {
                // default to Qom's time if error in getting location
                self.updatePrayerTimes(34.61, lon: 50.84, gmt: +4.5) // Default location: Qom
                print(err.localizedDescription)
            }
            self.manager = nil
        }
    }
    
    func updatePrayerTimes(lat: Double, lon: Double, gmt: Double) {
        
        // default settings
        let myPrayTimes = PrayerTimes(caculationmethod: .Tehran, asrJuristic: .Shafii, adjustHighLats: .None, timeFormat: .Time12)
        
        self.prayerTimes = myPrayTimes.getPrayerTimes(NSCalendar.currentCalendar(), latitude: lat, longitude: lon, tZone: gmt)
        
    }
}
