//
//  ViewController.swift
//  testAccelerometerData
//
//  Created by teppei.kikuchi on 4/28/20.
//  Copyright © 2020 teppei.kikuchi. All rights reserved.
//

import UIKit
import CoreMotion
 
class ViewController: UIViewController {
 
    // MotionManager
    let motionManager = CMMotionManager()
 
    // 3 axes
    @IBOutlet var accelerometerX: UILabel!
    @IBOutlet var accelerometerY: UILabel!
    @IBOutlet var accelerometerZ: UILabel!
 
    @IBOutlet weak var historyTable: UITableView!
    
    fileprivate var histories = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTable.delegate = self
        historyTable.dataSource = self
 
        if motionManager.isAccelerometerAvailable {
            // set interval [sec]
            motionManager.accelerometerUpdateInterval = 0.2
 
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
 
        }
    }
 
    func outputAccelData(acceleration: CMAcceleration){
        // 加速度センサー [G]
        accelerometerX.text = String(format: "%06f", acceleration.x)
        accelerometerY.text = String(format: "%06f", acceleration.y)
        accelerometerZ.text = String(format: "%06f", acceleration.z)
        
        let conbinedText = "X=\(accelerometerX.text!), Y=\(accelerometerY.text!), Z=\(accelerometerZ.text!)"
        histories.insert(History(time: Date().description, acceleration: conbinedText), at: 0)
        
        historyTable.reloadData()
    }
 
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = histories[indexPath.row].time
        cell.detailTextLabel?.text = histories[indexPath.row].acceleration
        return cell
    }
    
    
}

class History {
    var time = ""
    var acceleration = ""
    
    init(time: String, acceleration: String) {
        self.time = time
        self.acceleration = acceleration
    }
}
