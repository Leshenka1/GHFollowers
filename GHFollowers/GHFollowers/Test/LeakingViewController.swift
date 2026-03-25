//
//  LeakingViewController.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 24.02.26.
//

import UIKit

class LeakingViewController: UIViewController {

    // Класс, который будет удерживать ссылку на контроллер
    class Service {
        var action: (() -> Void)?
    }

    let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Memory Leak Screen"
        print(title)
        
        // ОШИБКА ЗДЕСЬ:
        // Мы передаем замыкание, которое захватывает 'self' сильно (strong).
        // self (VC) держит service, а service держит замыкание, которое держит self.
        service.action = {
            self.doSomething()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func doSomething() {
        print("Action performed")
    }

    deinit {
        // Если утечки нет, этот принт должен сработать при нажатии "Назад"
        print("🟢 LeakingViewController выгрузился из памяти")
    }
}
