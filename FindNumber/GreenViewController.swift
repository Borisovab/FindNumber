//
//  GreenViewController.swift
//  FindNumber
//
//  Created by Александр Борисов on 15.03.2022.
//

import UIKit

class GreenViewController: UIViewController {


    @IBOutlet weak var testLabel: UILabel!
    
    var textForLabel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = textForLabel

    }
    

    @IBAction func goToRoot(_ sender: Any) {

//        self.navigationController?.popToRootViewController(animated: true)

        if let viewControllers = self.navigationController?.viewControllers {

            for vc in viewControllers {
                if vc is YellowViewController {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }

}
