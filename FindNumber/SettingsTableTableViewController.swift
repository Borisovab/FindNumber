//
//  SettingsTableTableViewController.swift
//  FindNumber
//
//  Created by Александр Борисов on 16.03.2022.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {


    @IBOutlet weak var switchTimer: UISwitch!

    @IBOutlet weak var timeGameLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }

    @IBAction func changeTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }

    func loadSettings() {
        timeGameLabel.text = "\(Settings.shared.currentSettings.timeForGame) сек"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
    }

    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.resetSettings()
        loadSettings()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController {
                vc.data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 120]
            }
        default:
            break
        }
    }
}
