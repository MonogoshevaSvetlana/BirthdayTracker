//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Света on 13.10.2021.
//

import UIKit
import CoreData
import UserNotifications

// Данная модель копирует модель из  Core Data чтобы не было опционалов так легче работать в таблице
struct BirthdayModel {

    var emoji: String
    var birthdate: Date
    var birthdayId: String
    var firstName: String
    var lastName: String

}

class BirthdaysTableViewController: UITableViewController {

    var birthdays = [BirthdayModel]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Birthday viewDidLoad")
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        tableView.register(BirthdayNewTableViewCell.self, forCellReuseIdentifier: "birthdayCell")
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "birthdayCell")
        tableView.rowHeight = 110

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Birthday viewWillAppear")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        let sortDiscriptior1 = NSSortDescriptor (key: "lastName", ascending: true)
        let sortDiscriptior2 = NSSortDescriptor (key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDiscriptior1, sortDiscriptior2]
        
        do {
            let birthdays = try contex.fetch(fetchRequest)
            self.birthdays = []
            
            birthdays.forEach { coreDataBirthday in
                guard let emoji = coreDataBirthday.emoji else {
                    return
                }
                guard let birthdate = coreDataBirthday.birthdate else {
                    return
                }
                guard let birthdayId = coreDataBirthday.birthdayId else {
                    return
                }
                guard let firstName = coreDataBirthday.firstName else {
                    return
                }
                guard let lastName = coreDataBirthday.lastName else {
                    return
                }
                print("Did fetch \(birthdayId)")
                self.birthdays.append(BirthdayModel(emoji: emoji, birthdate: birthdate, birthdayId: birthdayId, firstName: firstName, lastName: lastName))
                
            }
        } catch let error {
            print("Не удалось загрузить даные из-за ошибки: \(error) .")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Birthday viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Birthday viewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Birthday viewDidDisappear")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCell", for: indexPath) as! BirthdayNewTableViewCell
        let birthday = birthdays[indexPath.row]
        cell.emojiLable.text = birthday.emoji
        cell.firstNameLabel.text = birthday.firstName
        cell.lastNameLabel.text = birthday.lastName
        cell.birthdataLabel.text = dateFormatter.string(from: birthday.birthdate)
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row {
            let birthday = birthdays[indexPath.row]
            
            
            //Получаем доступ к контексту управляемого объекта для делегата приложения
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let birthdayCoreData = Birthday(context: context)
            birthdayCoreData.firstName = birthday.firstName
            birthdayCoreData.lastName = birthday.lastName
            birthdayCoreData.birthdate = birthday.birthdate as Date?
            birthdayCoreData.birthdayId = UUID().uuidString
            context.delete(birthdayCoreData) //Контекст уддаляется из объекта
            
            //удаляем уведомление
            if let identifier = birthdayCoreData.birthdayId {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            birthdays.remove(at: indexPath.row)
            do {
                try context.save()
            } catch let error {
                print("Не удалось сохранить из-за ошибки \(error).")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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

    
    
    // MARK: - AddBirthdayViewControllerDelegate
    
//    func addBirthdayViewController(_ addBirthdayViewController: AddBirthdayViewController, didAddBirthday birthday: Birthday) {
//        birthdays.append(birthday)
//        tableView.reloadData()
//    }
}
