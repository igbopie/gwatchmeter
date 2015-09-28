//
//  InterfaceController.swift
//  GWatchMeter WatchKit Extension
//
//  Created by Ignacio Bona Piedrabuena on 9/27/15.
//  Copyright © 2015 Ignacio Bona Piedrabuena. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var xForceLabel: WKInterfaceLabel!
    @IBOutlet var yForceLabel: WKInterfaceLabel!
    @IBOutlet var zForceLabel: WKInterfaceLabel!
    @IBOutlet var totalForceLabel: WKInterfaceLabel!
    @IBOutlet var minForceLabel: WKInterfaceLabel!
    @IBOutlet var maxForceLabel: WKInterfaceLabel!
    lazy var motionManager = CMMotionManager()
    var minG: Double = 1;
    var maxG: Double = 1;
    
    override func awakeWithContext(context: AnyObject?) {
        print("awakeWithContext")
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        motionManager.accelerometerUpdateInterval = 0.1
    }

    override func willActivate() {
        print("willActivate")
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        minG = 1;
        maxG = 1;
        
        if (motionManager.accelerometerAvailable) {
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                    
                    //print("X = \(data.acceleration.x)")
                    //print("Y = \(data.acceleration.y)")
                    //print("Z = \(data.acceleration.z)")
                    
                    self.xForceLabel.setText("X: \(data.acceleration.x)");
                    self.yForceLabel.setText("Y: \(data.acceleration.y)");
                    self.zForceLabel.setText("Z: \(data.acceleration.z)");
                    
                    let vectorModule = sqrt(pow(abs(data.acceleration.x),2) +
                        pow(abs(data.acceleration.y),2) +
                        pow(abs(data.acceleration.z),2));
                    
                    if (vectorModule < self.minG) {
                        self.minG = vectorModule;
                    }
                    
                    if (vectorModule > self.maxG) {
                        self.maxG = vectorModule;
                    }
                    
                    self.totalForceLabel.setText("Total: \(vectorModule)");
                    
                    self.minForceLabel.setText("Min: \(self.minG)");
                    self.maxForceLabel.setText("Max: \(self.maxG)");
                }
            )
        }
        else {
            print("Accelerometer is not available")
        }
    }

    override func didDeactivate() {
        print("didDeactivate")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        motionManager.stopAccelerometerUpdates();
    }

}
