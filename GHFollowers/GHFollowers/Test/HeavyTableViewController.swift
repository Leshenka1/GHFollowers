//
//  HeavyTableViewController.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 24.02.26.
//

import UIKit

class HeavyTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // ОШИБКА ЗДЕСЬ: Тяжелые вычисления на главном потоке прямо при отрисовке ячейки
        let heavyResult = heavyCalculation()
        
        cell.textLabel?.text = "Row \(indexPath.row) - \(heavyResult)"
        
        // ДОПОЛНИТЕЛЬНАЯ ОШИБКА: Добавление теней без shadowPath (убивает GPU)
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        
        return cell
    }
    
    func heavyCalculation() -> Int {
        // Имитация тяжелой работы
        var count = 0
        for i in 1..<5_0000 {
            count += i
            for i in 1..<5 {
                    count -= i/2 + Int(log2(CGFloat(Float(i)))) + Int(log10(CGFloat(Float(i)))) + Int(log2(CGFloat(Float(i))))
            }
        }
        return count
    }
}
