import UIKit
import AVFoundation
import CoreMotion
import Foundation

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    var alert40_count: Int = 0
    @IBOutlet weak var alert40_count_label: UILabel!
    @IBAction func alert_quiet(_ sender: Any) {
        do {
            musicPlayer_alert40 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert40.numberOfLoops = -1
            musicPlayer_alert40.volume = 0.2
            if flag_alert40 == false {
                musicPlayer_alert40.play()
                flag_alert40 = true
                alert40_count += 1
                alert40_count_label.text = String(alert40_count)
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
    var alert50_count: Int = 0
    @IBOutlet weak var alert50_count_label: UILabel!
    @IBAction func alert50_click(_ sender: Any) {
        do {
            musicPlayer_alert50 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert50.numberOfLoops = -1
            musicPlayer_alert50.volume = 0.5
            if flag_alert50 == false {
                musicPlayer_alert50.play()
                flag_alert50 = true
                alert50_count += 1
                alert50_count_label.text = String(alert50_count)
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
    var alert60_count: Int = 0
    @IBOutlet weak var alert60_count_label: UILabel!
    @IBAction func alert60_click(_ sender: Any) {
        do {
            musicPlayer_alert60 = try AVAudioPlayer(contentsOf: musicPath_alert)
            musicPlayer_alert60.numberOfLoops = -1
            musicPlayer_alert60.volume = 1.5
            if flag_alert60 == false {
                musicPlayer_alert60.play()
                flag_alert60 = true
                alert60_count += 1
                alert60_count_label.text = String(alert60_count)
            } else {
                musicPlayer_alert60.stop()
                flag_alert60 = false
            }
            alert60_label.text = String(flag_alert60)
        } catch {
            print("alert60 エラー")
        }
    }
    // alert_count reset
    @IBAction func alert_count_reset(_ sender: Any) {
        alert40_count = 0
        alert50_count = 0
        alert60_count = 0
        alert40_count_label.text = String(alert40_count)
        alert50_count_label.text = String(alert50_count)
        alert60_count_label.text = String(alert60_count)
    }
    
    
    //
    // --------------------- csv ---------------------------------
    //
    var flag_output = false
    let header =  "time" + "," + "head pitch" + "," + "alert status" + "\n"
    var dataList = String()
    var csvPath:String = ""
    var num: Int = 0
    @IBOutlet weak var csv_status: UILabel!
    @IBAction func output_start(_ sender: Any) {
        if flag_output == false {
            csvPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + pickerSelected
            flag_output = true
            num += 1
            do {
                try FileManager.default.removeItem(atPath: csvPath)
                csv_status.text = "start" + String(num)
            } catch {
                csv_status.text = "失敗" + String(num)
            }
        }
    }
    // dataListをcsvに出力する
    @IBAction func output_end(_ sender: Any) {
        if flag_output == true {
            flag_output = false
            do {
                dataList = header + dataList
                try dataList.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                print(dataList)
                dataList = String()
                csv_status.text = "end" + String(num)
            } catch {
                print("dataList.write error")
            }
        }
    }
    
    // pickerView
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
    var pickerSelected:String = ""
    let pickerData = [
        "/0_base.csv",
        "--------------------",
        "/1.0_reading_40.csv",
        "/1.0_reading_50.csv",
        "/1.0_reading_65.csv",
        "/1.1_reading_40.csv",
        "/1.1_reading_50.csv",
        "/1.1_reading_65.csv",
        "--------------------",
        "/2.0_listening_40.csv",
        "/2.0_listening_50.csv",
        "/2.0_listening_65.csv",
        "/2.1_listening_40.csv",
        "/2.1_listening_50.csv",
        "/2.1_listening_65.csv",
    ]
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        pickerLabel.text = pickerData[row]
        pickerSelected = pickerData[row]
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
            dataList = dataList + format.string(from: Date()) + "," + String(data.attitude.pitch) + "," + String(flag_alert40) + "," + String(flag_alert50) + "," + String(flag_alert60) + "\n"
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
        
        // csv
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerSelected = pickerData[0]
        pickerLabel.text = pickerSelected
    }
}

