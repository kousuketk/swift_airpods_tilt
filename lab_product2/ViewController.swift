//
//  ViewController.swift
//  lab_product2
//
//  Created by Takahashi on 2020/09/28.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {
    
    let musicPath_sound_quiet = Bundle.main.bundleURL.appendingPathComponent("backgroud_quiet.mp3")
    let musicPath_alert = Bundle.main.bundleURL.appendingPathComponent("alert.mp3")
    var musicPlayer_sound_quiet = AVAudioPlayer()
    var musicPlayer_alert_quiet = AVAudioPlayer()
    var flag_sound_quiet = false
    var flag_alert_quiet = false

    @IBAction func sound_quiet(_ sender: Any) {
        do {
            musicPlayer_sound_quiet = try AVAudioPlayer(contentsOf: musicPath_sound_quiet)
            musicPlayer_sound_quiet.numberOfLoops = -1
            if flag_sound_quiet == false {
                musicPlayer_sound_quiet.play()
                flag_sound_quiet = true
            } else {
                musicPlayer_sound_quiet.stop()
                flag_sound_quiet = false
            }
        } catch {
            print("エラー")
        }
    }
    
    @IBAction func alert_quiet(_ sender: Any) {
        do {
            musicPlayer_alert_quiet = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert_quiet.numberOfLoops = -1
            if flag_alert_quiet == false {
                musicPlayer_alert_quiet.play()
                flag_alert_quiet = true
            } else {
                musicPlayer_alert_quiet.stop()
                flag_alert_quiet = false
            }
        } catch {
            print("エラー")
        }
    }
    // labelの定義
    @IBOutlet weak var time_data: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    // その他定義
    var timer: Timer!
    let format = DateFormatter()
    
    // AirPods Pro => APP :)
//    let APP = CMHeadphoneMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // AirPods
//        guard APP.isDeviceMotionAvailable else { return }
        //3秒ごとに繰り返す、repeat every 3 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
//    func printData() {
//        guard APP.isDeviceMotionActive else { return }
//        print("test")
////        let data = APP.deviceMotion!
////
////        textView.text = """
////           Quaternion:
////               x: \(data.attitude.quaternion.x)
////               y: \(data.attitude.quaternion.y)
////               z: \(data.attitude.quaternion.z)
////               w: \(data.attitude.quaternion.w)
////           Attitude:
////               pitch: \(data.attitude.pitch)
////               roll: \(data.attitude.roll)
////               yaw: \(data.attitude.yaw)
////           Gravitational Acceleration:
////               x: \(data.gravity.x)
////               y: \(data.gravity.y)
////               z: \(data.gravity.z)
////           Rotation Rate:
////               x: \(data.rotationRate.x)
////               y: \(data.rotationRate.y)
////               z: \(data.rotationRate.z)
////           Acceleration:
////               x: \(data.userAcceleration.x)
////               y: \(data.userAcceleration.y)
////               z: \(data.userAcceleration.z)
////           Magnetic Field:
////               field: \(data.magneticField.field)
////               accuracy: \(data.magneticField.accuracy)
////           Heading:
////               \(data.heading)
////           """
//    }
    
    @objc func update(tm: Timer) {
        //この関数を繰り返す、repeat this function
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        time_data.text = format.string(from: Date())
        // AirPods
//        APP.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] _,error  in
//            guard error == nil else { return }
//            self?.printData()
//        })
    }
}

