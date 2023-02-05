//
//  YellowViewController.swift
//  FindNumber
//
//  Created by Александр Борисов on 15.03.2022.
//

import UIKit

class YellowViewController: UIViewController {

//MARK: -  ниже рассмотрим три метода, которые вызываются, когда контроллер только показывается на экране

//MARK: - viewDidLoad - Этот метод вызывается один раз при создании. Здесь можно обращаться ко всем аутлетам

    override func viewDidLoad() {
        super.viewDidLoad()

        print("YellowViewController viewDidLoad")
    }

//MARK: - viewWillAppear - Этот метод активируется перед появлением экрана, те каждый раз. Отличное место для вызова функций обновления

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("YellowViewController viewWillAppear")
    }

//MARK: - viewDidAppear - Этот метод активируется, когда экран только отобразился, тут можно делать анимацию или энерго емкие процессы

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("YellowViewController viewDidAppear")
    }




//MARK: -  ниже рассмотрим два метода, которые вызываются, когда контроллер уходит с экрана


//MARK: - viewWillDisappear - Этот метод вызывается в том случае, когда контроллер будет скрыт с экрана, те сейчас отображается, но будет скрыт

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("YellowViewController viewWillDisappear")
    }

//MARK: - viewDidDisappear - Этот метод вызывется, когда экран уже скрылся и будет уничтожен, если на этот контроллер нет стронг ссылок.

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print("YellowViewController viewDidDisappear")
    }


//MARK: - deinit вызывается, когда экземпляр класса уничтожается, те нет стронг ссылок

    deinit {
        print("YellowViewController deinit")
    }


    @IBAction func goToBlueController(_ sender: Any) {
        performSegue(withIdentifier: "goToBlue", sender: "Test String")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToBlue":
            if let blueVC = segue.destination as? BlueViewController {
                if let string = sender as? String {
                    blueVC.textForLabel = string
                }

            }
        default:
            break
        }
    }

}
