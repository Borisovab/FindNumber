//
//  Game.swift
//  FindNumber
//
//  Created by Александр Борисов on 11.03.2022.
//

import Foundation

enum StatusGame {                                                            //создаем перечисление вне класса, чтобы его было видно и в ViewController
    case start
    case win
    case lose
}


class Game {

    struct Item {
        var title: String
        var isFound = false
        var isError = false
    }

    private let data = Array(1...99)

    var items:[Item] = []

    private var countItems: Int

    var nextItem: Item?                                                      //опционал, потому что, когда цифры закончатся - будет nil

    var isNewRecord = false

    var status: StatusGame = .start {                                        //по умодчанию - start, а менять будем в функции check
        didSet {
            if status != .start {                                            // если статус меняется - останавливается таймер
                if status == .win {
                    let newRecord = timeForGame - secondsGame

                    let record = UserDefaults.standard.integer(forKey: KeyUserDefaults.recordGame)

                    if record == 0 || newRecord < record {
                        UserDefaults.standard.set(newRecord, forKey: KeyUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }

    private var timeForGame: Int

    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status, secondsGame)
        }
    }

    private var timer: Timer?
    private var updateTimer: ( (StatusGame, Int) -> Void)
                                                                            // добавляем @escaping потому что, вызываем функцию в init
                                                                            //, а вызывать будем позже, те не в init, а в timeForGame

    init(countItems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> Void ) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }


    private func setupGame() {
        isNewRecord = false
        var digits = data.shuffled()

        items.removeAll()                                                   // игра всегда будет начинатся с нулевыми items

        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }

        nextItem = items.shuffled().first                                   // .shuffled() позволит перемешать цифры, а не идти по порядку

        updateTimer(status, secondsGame)                                    // вызыввем функцию сразу при запуске иры
                                                                            // , чтобы обновить UI и таймер, у которого задержка в 1 сек, работал верно

        if Settings.shared.currentSettings.timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.secondsGame -= 1
                print("Timer")
            })
        }
    }

                                                                            // тк мы обращаемся к self, self нужно сделать weak self
                                                                            //, чтобы не было утечек памяти, и тогда self становиться опионалом - self?


    func newGame() {

        status = .start
        self.secondsGame = self.timeForGame
        setupGame()


    }

    func check(index: Int) {                                                //передаем индекс

        guard status == .start else {return}                                //если игра закончена, прерываем все действия, например нажатие кнопок

        if items[index].title == nextItem?.title {                          //если мы верно нажали на кнопку, те items совпал с выпадающим номером
            items[index].isFound = true                                     // то будем скрывать текущий items по индексу
            nextItem = items.shuffled().first(where: { (item) -> Bool in    // обновляем следующий items, перемешиваем, берем первый, но с условием
                item.isFound == false                                       // таким, чтобы у нас не было уже выпадающих цифр
            })
        } else {
            items[index].isError = true                                     // когда происходит неверное нажатие, далее меняем подсветку в updateUI()
        }

        if nextItem == nil {
            status = .win                                                   //если цифр не осталось, меняем статус на win. Переходим на ViewController
        }
    }

    func stopGame() {
        timer?.invalidate()                                                 //остановка таймера в случае помебы или проинрыша
    }
}

                                                                            // форматируем строку времени. Затем идем в lazy var game и меняем self.timeLabel
extension Int {
    func secondsToString() -> String {
        let minutes = self / 60
        let seconds = self % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}
