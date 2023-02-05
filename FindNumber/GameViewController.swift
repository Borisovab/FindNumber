//
//  GameViewController.swift
//  FindNumber
//
//  Created by Александр Борисов on 11.03.2022.
//

import UIKit

class GameViewController: UIViewController {

    //MARK: - PROPERTIES

    @IBOutlet var buttons: [UIButton]!

    @IBOutlet weak var nextDigit: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var newGameButton: UIButton!

    // тк мы обращаемся к self, self нужно сделать weak self, чтобы не было утечек памяти, и тогда self становиться опионалом - self?
    // чтобы не ставить опционал, делаем проверку с помощью - guard let self = self else {return}

    lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        guard let self = self else {return}

//        self.timerLabel.text = "\(time)"      после создания расширения extension Int, заменяем на time.secondsToString()
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)

    }

    //MARK: - LIFE CYCLE

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()                                                    // вызываем функцию в viewDidLoad
    }

    @IBAction func pressButton(_ sender: UIButton) {
        
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}      // ищем индекс текущей кнопки, если такой нет - выходим
        game.check(index: buttonIndex)                   // после будем обращатся к нашей моделе, где создадим функцию check, куда будем передавать index

        updateUI()                                                      //вызываем функцию после нажатия на кнопку

//        sender.isHidden = true
//        print(sender.currentTitle)
    }

    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }


    private func setupScreen() {

        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)      // сменили цифру на кнопку

//            buttons[index].isHidden = false                           // показать на эеране в случае новой игры

            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }

        nextDigit.text = game.nextItem?.title                         //обновляем nextDigit на экране
    }

    private func updateUI() {                                         // создаем функцию, которая обновляет наш экран

        for index in game.items.indices {                             // пробегаем по массиву items в Game, также по индексам
            
//            buttons[index].isHidden = game.items[index].isFound     // по индексу достаем все кнопки и будем скрывать их с экрана, если items = true, те найден

            buttons[index].alpha = game.items[index].isFound ? 0 : 1  // если ответ верный, кнопка не исчезает, а делается невидимой
            buttons[index].isEnabled = !game.items[index].isFound      // отключаем кнопку, если она отработала верно

            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red        // если нажатие неверное, подсвечивается красным
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = .white      // затем, после отжатия, возвращается в белый цвет
                    self?.game.items[index].isError = false            // убираем статус Error
                }

            }



        }
        nextDigit.text = game.nextItem?.title                         //обновляем nextDigit

        updateInfoGame(with: game.status)



//        if game.status == .win {
//            statusLabel.text = "Вы выиграли!"                       // это мы убираем, тк написали func updateInfoGame
//            statusLabel.textColor = .green                          // и заменяем на вызов этой функции - updateInfoGame(with: game.status)

        }

    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Игра началась!"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы выиграли!"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            if game.isNewRecord {
                showAlert()
            } else {
                showAlertActionSheet()
            }

        case .lose:
            statusLabel.text = "Вы проиграли!"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }

    private func showAlert() {

        let alert = UIAlertController(title: "Поздравляем!", message: "Вы установили новый рекорд!", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    private func showAlertActionSheet() {
        let alert = UIAlertController(title: "Что вы хотите сделать дальше?", message: nil, preferredStyle: .actionSheet)

        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }

        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self] (_) in

            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }

        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)

        if let popover = alert.popoverPresentationController {
            popover.sourceView = statusLabel
//            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }

        present(alert, animated: true, completion: nil)
    }
}

