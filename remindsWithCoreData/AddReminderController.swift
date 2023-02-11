//
//  ViewController.swift
//  Напоминания
//
//  Created by Nikita Stepanov on 10.09.2022.
//

import UIKit
import CoreData
import UserNotifications

class AddReminderController: UIViewController {
    
    //textField's
    let nameField = UITextField()
    let describeField = UITextField()
    let dataPicker = UIDatePicker()
    let makeButton = UIButton()
    //delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        //textField's labels
        let nameLabel = Lable(name: "Название:")
        let describeLabel = Lable(name: "Описание:")
        let dataLabel = Lable(name: "Дата уведомления:")
        //textField's settings
        nameField.placeholder = "Введите сюда название..."
        describeField.placeholder = "Введите сюда описание..."
        nameField.keyboardType = .twitter
        describeField.keyboardType = .twitter
        nameField.delegate = self
        describeField.delegate = self
        nameField.borderStyle = .roundedRect
        describeField.borderStyle = .roundedRect
        dataPicker.timeZone = .autoupdatingCurrent
        dataPicker.minimumDate = Date()
        makeButton.setTitle(" Добавить напоминание", for: .normal)
        makeButton.layer.backgroundColor = UIColor.link.cgColor
        makeButton.setTitleColor(.white, for: .normal)
        makeButton.layer.cornerRadius = 15
        makeButton.setTitleColor(.blue, for: .highlighted)
        makeButton.addTarget(self, action: #selector(saveButtonFunt), for: .touchUpInside)
        let makeButtonImage = UIImage(systemName: "plus.circle")
        makeButtonImage?.withTintColor(UIColor.white)
        makeButton.setImage(makeButtonImage, for: .normal)
        [nameLabel, describeLabel, dataLabel, nameField, describeField, dataPicker, makeButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40), nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     
                                     nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20), nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     
                                     describeLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20), describeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     
                                     describeField.topAnchor.constraint(equalTo: describeLabel.bottomAnchor, constant: 20), describeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), describeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     
                                     dataLabel.topAnchor.constraint(equalTo: describeField.bottomAnchor, constant: 20), dataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), dataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     
                                     dataPicker.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 30), dataPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     
                                     makeButton.topAnchor.constraint(equalTo: dataPicker.bottomAnchor, constant: 35), makeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), makeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), makeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                                     
                                    ])
    }
    @objc func saveButtonFunt() {
        if nameField.text != "" && describeField.text != "" {
            let name = nameField.text
            self.navigationController?.popToRootViewController(animated: true)
            let description = describeField.text
            let date = dataPicker.date
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let new = Reminds(context: context)
            new.name = name
            new.discription = description
            new.date = date
            new.id = UUID().uuidString
            do{
                try context.save()
                let message = "Не забудьте про \(new.name)! Детали: \(new.description)"
                let content = UNMutableNotificationContent()
                content.body = message
                content.sound = UNNotificationSound.default
                let dateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                if let identifier = new.id {
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler: nil)
                }
                }
            catch let error {
                print("Не удалось сохранить из-за ошибки \(error).")
            }
            if let uniqueId = new.id {
                print("id is: \(uniqueId)")
            }
            dismiss(animated: true)
        }
        
    }
    @objc func closeView(){
        dismiss(animated: true)
    }
}
class Lable: UILabel {
    init(name: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.text = name
        self.font = UIFont(name: "Arial", size: 20)
        self.textColor = .black
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AddReminderController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if describeField.isEditing {
            describeField.resignFirstResponder()
        }
        else {
            describeField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == describeField {
            print (textField.text as Any)
            print (dataPicker.date)
        }
    }
}


