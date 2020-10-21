//
//  MainScreen.swift
//  App
//
//  Created by Nathan Klassen on 2020-10-03.
//

import UIKit
import AudioToolbox

class MainScreen: UIViewController {
    let defaults = UserDefaults.standard
    var dsElapsed = 0;
    var clicks = 0;
    let clicksToWin = 10;
    var finalTime = 0;
    var timer = Timer()
    var clicktime = 0;
    var hapticResponse = false;
    let timerInterval = 0.02;
    var myHighScore = 1000000;
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var splash: UILabel!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var MenuStack: UIStackView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var HighScoreView: UIView!
    @IBOutlet weak var DoneEnterName: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hapticResponse = (defaults.integer(forKey: "feedbackOn") != 0)
        myButton.backgroundColor = defaults.color(forKey: "boxColor") ?? UIColor.green
        splash.isHidden = true
        myButton.isHidden = true
        timerLabel.isHidden = true
        ResetButton.isHidden = true
        timerLabel.adjustsFontSizeToFitWidth = true
        highscoreLabel.isHidden = true
        splash.transform = CGAffineTransform(rotationAngle: -0.5)
    }
    
    func hideMenu() {
        splash.isHidden = false
        StartButton.isHidden = true
        MenuButton.isHidden = true
        ResetButton.isHidden = false
        MenuStack.isUserInteractionEnabled = false
    }
    
    func showMenu() {
        ResetButton.isHidden = true
        splash.isHidden = true
        StartButton.isHidden = false
        MenuButton.isHidden = false
        MenuStack.isUserInteractionEnabled = true
    }
    
    @IBAction func ResetGame(_ sender: UIButton) {
        timer.invalidate()
        highscoreLabel.text = "HighScore: " + String(NSString(format: "%0.02f", Double(myHighScore)*timerInterval))
        myButton.isHidden = true
        showMenu()
        highscoreLabel.isHidden = false
        return
    }
    
    @IBAction func StartButton(_ sender: UIButton) {
        splash.text = ""
        hideMenu()
        timerLabel.isHidden = false
        highscoreLabel.isHidden = true
        dsElapsed = 0
        clicks = 0
        clicktime = 0

        myHighScore = defaults.integer(forKey: "Score1")
        if (myHighScore == 0) {
            myHighScore = 10000000
        }
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        let screenSize = UIScreen.main.bounds
        let screenW = screenSize.width-50
        let screenH = screenSize.height-50
        
        let myx = Int.random(in:0...Int(screenW))
        let myy = Int.random(in:80...Int(screenH))
        
        myButton.frame.origin = CGPoint(x: myx, y: myy)
        myButton.isHidden = false
        myButton.setTitle("1", for: .normal)
    }
    
    func updateLeaderboard(myScore: Int) {
        for i in 1...10 {
            let thisScore = defaults.integer(forKey: "Score"+String(i))
            if (thisScore > myScore || thisScore == 0) {
                if (thisScore != 0 && i != 10) {
                    
                    for j in ((i+1)...10).reversed() {
                        defaults.set(defaults.integer(forKey: "Score"+String(j-1)),forKey: "Score"+String(j))
                        defaults.set(defaults.string(forKey: "Name"+String(j-1)),forKey: "Name"+String(j))
                    }
                }
                defaults.set(myScore, forKey: "Score"+String(i))
                HighScoreView.isHidden = false
                DoneEnterName.tag = i
                return
            }
        }
    }
    
    @IBAction func DoneEnterName(_ sender: UIButton) {
        let myName = NameField.text
        NameField.endEditing(true)
        defaults.set(myName, forKey: "Name"+String(DoneEnterName.tag))
        HighScoreView.isHidden = true
    }
    @IBAction func myButton(_ sender: UIButton) {
        if(hapticResponse) {
            AudioServicesPlaySystemSound(1520)
        }
        if (clicks == clicksToWin-1) {
            finalTime = dsElapsed
            timer.invalidate()
            updateLeaderboard(myScore: finalTime)
            if (finalTime < myHighScore) {
                myHighScore = finalTime
                timerLabel.text = "New High Score!"
                myHighScore = finalTime
            }

            highscoreLabel.text = "HighScore: " + String(NSString(format: "%0.02f", Double(myHighScore)*timerInterval))
            myButton.isHidden = true
            showMenu()
            highscoreLabel.isHidden = false
            return
        }
        splash.text = checkPace(time: clicktime,highscore: myHighScore)
        clicktime = 0
        let screenSize = UIScreen.main.bounds
        let screenW = screenSize.width-50
        let screenH = screenSize.height-50
        
        let myx = Int.random(in:0...Int(screenW))
        let myy = Int.random(in:100...Int(screenH))
        
        myButton.frame.origin = CGPoint(x: myx, y: myy)
        clicks = clicks + 1;
        myButton.setTitle(String(clicks+1),for: .normal)
    }
    
    func checkPace(time: Int, highscore: Int) -> String {
        let paceIndex = (Double(time)/(Double(highscore)/10.0))
        if (1.5 <= paceIndex) {
            return "Garbage."
        }
        else if (1.2 <= paceIndex) {
            return "Mediocre."
        }
        else if (1 <= paceIndex) {
            return "Good!"
        }
        else if (0.8 <= paceIndex) {
            return "Great!"
        }
        else if (0.6 <= paceIndex) {
            return "Crazy!"
        }
        else {
            return "Insane!"
        }
    }

    @objc func fireTimer() {
        dsElapsed += 1
        clicktime += 1
        timerLabel.text = String(NSString(format: "%0.02f", Double(dsElapsed)*timerInterval))
    }
}
