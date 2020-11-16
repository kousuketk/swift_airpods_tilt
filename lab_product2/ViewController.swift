import UIKit
import AVFoundation
import CoreMotion
import Foundation

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    
    // setting sound
    let musicPath_sound_quiet = Bundle.main.bundleURL.appendingPathComponent("sound_quiet.mp3")
    let musicPath_sound_noisy = Bundle.main.bundleURL.appendingPathComponent("sound_noisy.mp3")
    let musicPath_alert = Bundle.main.bundleURL.appendingPathComponent("alert.mp3")
    
    //
    // ------------------------ 40dB -------------------------------
    //
    var musicPlayer_sound40 = AVAudioPlayer()
    var musicPlayer_alert40 = AVAudioPlayer()
    // setting flag
    var flag_sound40 = false
    var flag_alert40 = false
    @IBOutlet weak var upper_sound_label: UILabel!
    @IBOutlet weak var upper_alert_label: UILabel!
    // sound func
    @IBAction func sound_quiet(_ sender: Any) {
        do {
            musicPlayer_sound40 = try AVAudioPlayer(contentsOf: musicPath_sound_quiet)
            musicPlayer_sound40.numberOfLoops = -1
            if flag_sound40 == false {
                musicPlayer_sound40.play()
                flag_sound40 = true
            } else {
                musicPlayer_sound40.stop()
                flag_sound40 = false
            }
            upper_sound_label.text = String(flag_sound40)
        } catch {
            print("sound40 エラー")
        }
    }
    // alert func
    @IBAction func alert_quiet(_ sender: Any) {
        do {
            musicPlayer_alert40 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert40.numberOfLoops = -1
            if flag_alert40 == false {
                musicPlayer_alert40.play()
                flag_alert40 = true
            } else {
                musicPlayer_alert40.stop()
                flag_alert40 = false
            }
            upper_alert_label.text = String(flag_alert40)
        } catch {
            print("alert40 エラー")
        }
    }

    //
    // --------------------- 50dB ------------------------------
    //
    var musicPlayer_sound50 = AVAudioPlayer()
    var musicPlayer_alert50 = AVAudioPlayer()
    var flag_sound50 = false
    var flag_alert50 = false
    @IBOutlet weak var sound50_label: UILabel!
    @IBOutlet weak var alert50_label: UILabel!
    @IBAction func sound50_click(_ sender: Any) {
        do {
            musicPlayer_sound50 = try AVAudioPlayer(contentsOf: musicPath_sound_quiet)
            musicPlayer_sound50.numberOfLoops = -1
            if flag_sound50 == false {
                musicPlayer_sound50.play()
                flag_sound50 = true
            } else {
                musicPlayer_sound50.stop()
                flag_sound50 = false
            }
            sound50_label.text = String(flag_sound50)
        } catch {
            print("sound50 エラー")
        }
    }
    @IBAction func alert50_click(_ sender: Any) {
        do {
            musicPlayer_alert50 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert50.numberOfLoops = -1
            if flag_alert50 == false {
                musicPlayer_alert50.play()
                flag_alert50 = true
            } else {
                musicPlayer_alert50.stop()
                flag_alert50 = false
            }
            alert50_label.text = String(flag_alert50)
        } catch {
            print("alert50 エラー")
        }
    }

    //
    // --------------------- 60dB ------------------------------
    //
    var musicPlayer_sound60 = AVAudioPlayer()
    var musicPlayer_alert60 = AVAudioPlayer()
    var flag_sound60 = false
    var flag_alert60 = false
    @IBOutlet weak var sound60_label: UILabel!
    @IBOutlet weak var alert60_label: UILabel!
    @IBAction func sound60_click(_ sender: Any) {
        do {
            musicPlayer_sound60 = try AVAudioPlayer(contentsOf: musicPath_sound_noisy)
            musicPlayer_sound60.numberOfLoops = -1
            if flag_sound60 == false {
                musicPlayer_sound60.play()
                flag_sound60 = true
            } else {
                musicPlayer_sound60.stop()
                flag_sound60 = false
            }
            sound60_label.text = String(flag_sound60)
        } catch {
            print("sound60 エラー")
        }
    }
    @IBAction func alert60_click(_ sender: Any) {
        do {
            musicPlayer_alert60 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert60.numberOfLoops = -1
            if flag_alert60 == false {
                musicPlayer_alert60.play()
                flag_alert60 = true
            } else {
                musicPlayer_alert60.stop()
                flag_alert60 = false
            }
            alert60_label.text = String(flag_alert60)
        } catch {
            print("alert60 エラー")
        }
    }
    
    
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
        time_data.text = format.string(from: Date())
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
        if flag_output == true {
            dataList = dataList + format.string(from: Date()) + "," + String(data.attitude.pitch) + "," + String(flag_alert40) + "\n"
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
        // 50dB
        sound50_label.text = String(flag_sound50)
        alert50_label.text = String(flag_alert50)
        // 60dB
        sound60_label.text = String(flag_sound60)
        alert60_label.text = String(flag_alert60)
        
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
}

