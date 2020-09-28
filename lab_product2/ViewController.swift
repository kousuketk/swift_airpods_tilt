//
//  ViewController.swift
//  lab_product2
//
//  Created by Takahashi on 2020/09/28.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let musicPath = Bundle.main.bundleURL.appendingPathComponent("sample.mp3")
    var musicPlayer = AVAudioPlayer()
    var flag = false

    @IBAction func sound_quiet(_ sender: Any) {
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicPath)
            if flag == false {
                musicPlayer.play()
                flag = true
            } else {
                musicPlayer.stop()
                flag = false
            }
        } catch {
            print("エラー")
        }
    }
    
    // labelの定義
    @IBOutlet weak var time_data: UILabel!
    
    // その他定義
    var timer: Timer!
    let format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //3秒ごとに繰り返す、repeat every 3 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func update(tm: Timer) {
        //この関数を繰り返す、repeat this function
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        time_data.text = format.string(from: Date())
    }
}

