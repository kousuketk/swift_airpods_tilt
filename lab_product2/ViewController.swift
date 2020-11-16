import UIKit
import AVFoundation
import CoreMotion
import Foundation

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    // setting sound
    let musicPath_sound_quiet = Bundle.main.bundleURL.appendingPathComponent("backgroud_quiet.mp3")
    let musicPath_alert = Bundle.main.bundleURL.appendingPathComponent("alert.mp3")
    
    //
    // ------------------------ 40dB -------------------------------
    //
    var musicPlayer_sound_quiet = AVAudioPlayer()
    var musicPlayer_alert_quiet = AVAudioPlayer()
    // setting flag
    var flag_sound40 = false
    var flag_alert40 = false
    @IBOutlet weak var upper_sound_label: UILabel!
    @IBOutlet weak var upper_alert_label: UILabel!
    // sound func
    @IBAction func sound_quiet(_ sender: Any) {
        do {
            musicPlayer_sound_quiet = try AVAudioPlayer(contentsOf: musicPath_sound_quiet)
            musicPlayer_sound_quiet.numberOfLoops = -1
            if flag_sound40 == false {
                musicPlayer_sound_quiet.play()
                flag_sound40 = true
            } else {
                musicPlayer_sound_quiet.stop()
                flag_sound40 = false
            }
            upper_sound_label.text = String(flag_sound40)
        } catch {
            print("flag_sound40 エラー")
        }
    }
    // alert func
    @IBAction func alert_quiet(_ sender: Any) {
        do {
            musicPlayer_alert_quiet = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert_quiet.numberOfLoops = -1
            if flag_alert40 == false {
                musicPlayer_alert_quiet.play()
                flag_alert40 = true
            } else {
                musicPlayer_alert_quiet.stop()
                flag_alert40 = false
            }
            upper_alert_label.text = String(flag_alert40)
        } catch {
            print("flag_alert40 エラー")
        }
    }
    
    
    //
    // --------------------- 50dB ------------------------------
    //
    
    //
    // --------------------- 60dB ------------------------------
    //
    
    //
    // --------------------- csv ---------------------------------
    //
    var flag_output = false
    let header =  "time" + "," + "head pitch" + "," + "alert status" + "\n"
    var dataList = String()
    var num: Int = 0
    @IBOutlet weak var csv_status: UILabel!
    let csvPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + "0_pre_trial" + ".csv"
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
    // dataListをcsvに出力する
    @IBAction func output_end(_ sender: Any) {
        flag_output = false
        do {
            dataList = header + dataList
            try dataList.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
            print(dataList)
            dataList = String()
        } catch {
            print("dataList.write error")
        }
    }
    
    //
    //---------------------- timer -------------------------------
    //
    var timer: Timer!
    let format = DateFormatter()
    var timeList = String()
    let time = String()
    @IBOutlet weak var time_data: UILabel!
    @objc func update(tm: Timer) {
        // AirPods
        APP.delegate = self
        guard APP.isDeviceMotionAvailable else { return }
        APP.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error in guard let motion = motion, error == nil else { return }
            self?.printData(motion)
        })
    }

    //
    // --------------------- AirPods ----------------------------
    //
    let APP = CMHeadphoneMotionManager()
    @IBOutlet weak var pitch_label: UILabel!
    func printData(_ data: CMDeviceMotion) {
        pitch_label.text = String(data.attitude.pitch)
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        let time = format.string(from: Date())
        time_data.text = time
        if flag_output == true {
            dataList = dataList + time + "," + String(data.attitude.pitch) + "," + String(flag_alert40) + "\n"
        }
    }
    
    //
    // --------------------- viewLoad ------------------------------
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // 40dB
        upper_sound_label.text = String(flag_sound40)
        upper_alert_label.text = String(flag_alert40)
        // under
        // timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
}

