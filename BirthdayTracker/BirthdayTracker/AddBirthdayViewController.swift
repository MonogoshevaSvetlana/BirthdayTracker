//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Света on 09.10.2021.
//

import UIKit
import CoreData
import UserNotifications


class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var emojiTextField: UITextField!
    @IBOutlet var firstNameTextField:  UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
    }

    @IBAction func saveTapped(_sender: UIBarButtonItem) {
        
        let emoji = emojiTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.emoji = emoji
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayId = UUID().uuidString
        if let uniqueID = newBirthday.birthdayId {
        print("birthdayId: \(uniqueID)")
        }
        do {
            try context.save()
            let message = "Сегодня \(firstName) \(lastName) празднует день рождения!"
            let content = UNMutableNotificationContent ()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour = 8
            dateComponents.minute = 1
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId {
                content.categoryIdentifier = identifier
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error) .")
        }
        
        dismiss()

    }
    
    @IBAction func cancelTapped(_sender: UIBarButtonItem) {
        dismiss(animated: true) {
            self.dismiss2("fuck")
        }
    }
    
    var dismiss2: ((String) -> Void) = { myString in
        print("Did dismiss \(myString)")
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

