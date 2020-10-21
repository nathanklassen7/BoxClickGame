//
//  Leaderboard.swift
//  NathansFirstApp
//
//  Created by Nathan Klassen on 2020-10-07.
//

import UIKit

class Leaderboard: UIViewController {

    @IBOutlet weak var Names: UILabel!
    @IBOutlet weak var Scores: UILabel!
    
    let timerInterval = 0.02
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLeaderboard()
        
    }
    func buildLeaderboard() {
        let defaults = UserDefaults.standard
        var myScoreString = ""
        var myNameString = ""
        for i in 1...10 {
            let myScore = Double(defaults.integer(forKey: "Score"+String(i)))*timerInterval
            let myName = defaults.string(forKey: "Name" + String(i)) ?? ""
            if (myScore == 0) {
                myScoreString += "\n"
                myNameString += "\n"
            }
            else if (myName == "") {
                myScoreString += String(NSString(format: "%0.02f",myScore)) + "\n"
                myNameString += "Unnamed \n"
            }
            else {
                myScoreString += String(NSString(format: "%0.02f",myScore)) + "\n"
                myNameString += myName + "\n"
            }
        }
        Names.text = myNameString
        Scores.text = myScoreString
    }
}
