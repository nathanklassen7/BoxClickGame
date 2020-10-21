//
//  HomePage.swift
//  NathansFirstApp
//
//  Created by Nathan Klassen on 2020-10-05.
//

import UIKit

class HomePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func ResetHighScore(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        for i in 1...10 {
            defaults.set(0, forKey: "Score"+String(i))
            defaults.set("", forKey: "Name"+String(i))
        }
    }
}
