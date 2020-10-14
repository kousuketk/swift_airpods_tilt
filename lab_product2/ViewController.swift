import UIKit
import AVFoundation
import CoreMotion

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
    // timeInterval func
    @objc func update(tm: Timer) {
        //この関数を繰り返す、repeat this function
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        time_data.text = format.string(from: Date())
    }
    
    //
    // --------------------- AirPods ----------------------------
    //
    //setting
    let APP = CMHeadphoneMotionManager()
    //setting label
    @IBOutlet weak var pitch_label: UILabel!
    @IBOutlet weak var roll_label: UILabel!
    @IBOutlet weak var yaw_label: UILabel!
    
    func printData(_ data: CMDeviceMotion) {
        pitch_label.text = String(data.attitude.pitch)
        roll_label.text = String(data.attitude.roll)
        yaw_label.text = String(data.attitude.yaw)
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
        // timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        // AirPods
        APP.delegate = self
        guard APP.isDeviceMotionAvailable else { return }
        APP.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error in guard let motion = motion, error == nil else { return }
            self?.printData(motion)
        })
    }
}

