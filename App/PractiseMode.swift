//
//  PractiseMode.swift
//  NathansFirstApp
//
//  Created by Nathan Klassen on 2020-10-08.
//

import UIKit
import AudioToolbox
import AVFoundation

class PractiseMode: UIViewController {
    let defaults = UserDefaults.standard
    
    var timer = Timer()
    var dsElapsed = 0
    let timerInterval = 0.02
    var arrayPos = 0;
    var hiScorePace = 0;
    var lastTen = Array(repeating: 50, count: 10)
    var hapticResponse = false;
    var sound1 = AVAudioPlayer();
    var sound2 = AVAudioPlayer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundPath = Bundle.main.path(forResource: "death", ofType: "mp3")
        do {
            sound1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
            sound2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
        }
        catch {
            print("uh oh cant load my sound!")
        }
        hapticResponse = (defaults.integer(forKey: "feedbackOn") != 0)
        myButton.backgroundColor = defaults.color(forKey: "boxColor") ?? UIColor.green
        hiScoreLabel.isHidden = true
        TimerLabel.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var hiScoreLabel: UILabel!
    
    @IBAction func MenuButton(_ sender: UIButton) {
        timer.invalidate()
    }
    @IBAction func practiseButton(_ sender: UIButton) {
        if(hapticResponse) {
            AudioServicesPlaySystemSound(1520)
        }
        if(sound1.isPlaying){
            sound2.play()
        }
        else {
            sound1.play()
        }
        let screenSize = UIScreen.main.bounds
        let screenW = screenSize.width-50
        let screenH = screenSize.height-50
        
        let myx = Int.random(in:0...Int(screenW))
        let myy = Int.random(in:100...Int(screenH))
        
        myButton.frame.origin = CGPoint(x: myx, y: myy)
        lastTen[arrayPos] = dsElapsed
        dsElapsed = 0
        arrayPos += 1
        if (arrayPos == 10) {
            hiScoreLabel.isHidden = false
            TimerLabel.isHidden = false
            arrayPos = 0
        }
        var arraySum = 0
        for i in 0...9 {
            arraySum += lastTen[i]
        }
        if(hiScorePace == 0 || arraySum < hiScorePace)
        {
            hiScorePace = arraySum
            hiScoreLabel.text = String(NSString(format: "%0.02f", Double(hiScorePace)*timerInterval))
        }
        TimerLabel.text = String(NSString(format: "%0.02f", Double(arraySum)*timerInterval))
    }
    
    @objc func fireTimer() {
        dsElapsed += 1
    }
}
