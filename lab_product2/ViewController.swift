import UIKit
import AVFoundation
import CoreMotion
import Foundation

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    //
    // ------------------------ upper -------------------------------
    //
    // setting sound
    let musicPath_sound_quiet = Bundle.main.bundleURL.appendingPathComponent("backgroud_quiet.mp3")
    let musicPath_alert = Bundle.main.bundleURL.appendingPathComponent("alert.mp3")
    var musicPlayer_sound_quiet = AVAudioPlayer()
    var musicPlayer_alert_quiet = AVAudioPlayer()
    // setting flag
    var flag_sound_quiet = false
    var flag_alert_quiet = false
    // setting label
    @IBOutlet weak var upper_sound_label: UILabel!
    @IBOutlet weak var upper_alert_label: UILabel!
    // sound func
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
            upper_sound_label.text = String(flag_sound_quiet)
        } catch {
            print("エラー")
        }
    }
    // alert func
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
            upper_alert_label.text = String(flag_alert_quiet)
        } catch {
            print("エラー")
        }
    }
    
    
    //
    // --------------------- under ------------------------------
    //
    
    //
    //---------------------- timer -------------------------------
    //
    // setting time
    var timer: Timer!
    let format = DateFormatter()
    // setting label
    @IBOutlet weak var time_data: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //
    // --------------------- csv ---------------------------------
    //
    // setting
    var flag_output = false
    let header =  "time" + "," + "head pitch" + "," + "alert status" + "\n"
    var dataList = String()
    // flag操作だけ
    var num: Int = 0
    @IBOutlet weak var csv_status: UILabel!
    let csvPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + "0_pre_trial" + ".csv"
//    var csvPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/サンプル/" + "事前試行" + ".csv"
    @IBAction func output_start(_ sender: Any) {
        flag_output = true
        num += 1
        do {
            try FileManager.default.removeItem(atPath: csvPath)
            csv_status.text = "成功" + String(num)
        } catch {
            csv_status.text = "失敗" + String(num)
        }
    }
    @IBAction func output_end(_ sender: Any) {
        flag_output = false
        do {
            try dataList.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
            print(dataList)
            dataList = String()
        } catch {
            print("dataList.write error")
        }
    }
    
    
    //
    // --------------------- AirPods ----------------------------
    //
    // setting
    let APP = CMHeadphoneMotionManager()
    // setting label
    @IBOutlet weak var pitch_label: UILabel!
    @IBOutlet weak var roll_label: UILabel!
    @IBOutlet weak var yaw_label: UILabel!
    // label func
    func printData(_ data: CMDeviceMotion) {
        pitch_label.text = String(data.attitude.pitch)
        
        let time = String(Date().timeIntervalSince1970)
        if flag_output == true {
            dataList = dataList + time + "," + String(data.attitude.pitch) + "," + String(flag_alert_quiet) + "\n"
        }
    }
    
    //
    // --------------------- 初期化 ------------------------------
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // upper
        upper_sound_label.text = String(flag_sound_quiet)
        upper_alert_label.text = String(flag_alert_quiet)
        // under
        // AirPods
        APP.delegate = self
        guard APP.isDeviceMotionAvailable else { return }
        APP.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error in guard let motion = motion, error == nil else { return }
            self?.printData(motion)
        })
    }
}

