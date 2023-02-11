//
//  TableViewController.swift
//  Напоминания
//
//  Created by Nikita Stepanov on 10.09.2022.
//

import UIKit
import CoreData
import UserNotifications

class TableViewController: UITableViewController {
    let mainTable = UITableView()
    var reminds = [Reminds]()
    let dateFormater = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        //dateFormater settings
        dateFormater.dateStyle = .full
        dateFormater.timeZone = .current
        dateFormater.timeStyle = .none
        //table settings
        mainTable.register(TableViewCell.self, forCellReuseIdentifier: "ID1")
        view.addSubview(mainTable)
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mainTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), mainTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10), mainTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10), mainTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Reminds.fetchRequest() as NSFetchRequest<Reminds>
        do {
            reminds = try context.fetch(fetchRequest)
            print(reminds)
        } catch let error {
            print("Не удалось загрузить данные из-за ошибки: \(error).") }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTable.dequeueReusableCell(withIdentifier: "ID1", for: indexPath) as? TableViewCell else {
            fatalError()
        }
        cell.name.text = reminds[indexPath.row].name ?? ""
        cell.dateLabel.text = dateFormater.string(from: reminds[indexPath.row].date!)
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if reminds.count > indexPath.row {
            let remind = reminds[indexPath.row]
            if let identifier = remind.id{
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: 
                   [identifier])
            }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(remind)
        reminds.remove(at: indexPath.row)
            do {try context.save()
            } catch let error {
                print("Не удалось сохранить из-за ошибки \(error).")
            }
            tableView.deleteRows(at:[indexPath],with: .fade)
            
        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   

}



