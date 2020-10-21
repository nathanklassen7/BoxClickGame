//
//  CustomizeScreen.swift
//  NathansFirstApp
//
//  Created by Nathan Klassen on 2020-10-10.
//

import UIKit
import AudioToolbox

class CustomizeScreen: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var midStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    @IBOutlet var boxes : [UIButton]!
    @IBOutlet weak var swatch: UILabel!
    @IBOutlet weak var tapticButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapticButton.isOn = (defaults.integer(forKey: "feedbackOn") != 0)
        swatch.backgroundColor = defaults.color(forKey: "boxColor")
        var uiColorArray = [UIColor]()
        uiColorArray = [.green,.red,.blue,.systemIndigo,.orange,.brown,.cyan,.white,.magenta,.black,.purple,.yellow]
        var iterator = 0
        for button in boxes {
            button.setTitle("", for: .normal)
            button.backgroundColor = uiColorArray[iterator]
            iterator += 1
            button.addTarget(self, action: #selector(colorClicked), for: .touchUpInside)
        }
    }

    @objc func colorClicked(sender: UIButton!) {
        swatch.backgroundColor = sender.backgroundColor
        defaults.set(sender.backgroundColor,forKey: "boxColor")
    }
    @IBAction func switchFlipped(_ sender: UISwitch) {
        if tapticButton.isOn {
            AudioServicesPlaySystemSound(1520)
        }
        defaults.set(tapticButton.isOn,forKey: "feedbackOn")
    }
}

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}
