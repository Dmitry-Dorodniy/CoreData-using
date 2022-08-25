//
//  ViewController.swift
//  iOS6-HW26-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 15.08.2022.
//

import UIKit
import SnapKit
import CoreData

class MainViewController: UIViewController {

    var contacts = [Contact]()


    func createContextManager() {
//        Ссылка на AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

//        Создаём контекст
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//        Описание сущности
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context) else {return}
//        Создаём объект
//        let managedObject = NSManagedObject(entity: entityDescription, insertInto: context)
        let managedObject = Person(entity: entityDescription, insertInto: context)
//Установка значений атрибутов
        let currentDate = Date()
//        managedObject.setValue("Яна Пупкина", forKey: "name")
//        managedObject.setValue(currentDate, forKey: "dateOfBirth")
//        managedObject.setValue("female", forKey: "gender")
        managedObject.name = "Яна Пупкина"
        managedObject.dateOfBirth = currentDate
        managedObject.gender = "female"

//        let name = managedObject.value(forKey: "name")
//        сохранение данных
//        appDelegate.saveContext()
//  Извлекаем данные
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [Person] {
                let name = result.name
                let date = result.dateOfBirth
                let gender = result.gender

                contacts.append(Contact(name: name,
                                        dateOfBirth: date,
                                        gender: gender))

                print("name: \(name), date: \(date), gender: \(gender)")
            }
    } catch {
        print(error)
    }

        // Удаление ВСЕХ данных

        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                context.delete(result)

            }
        } catch {
            print(error)
        }

        appDelegate.saveContext()
    }



    // MARK: - Private Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var enterTextField: UITextField = {
        let textField = UITextField()

        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.5
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGroupedBackground.cgColor

//        textField.backgroundColor = .systemGroupedBackground
        textField.placeholder = "Enter your name here..."
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .center
        config.title = "Press"
        button.configuration = config
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
        createContextManager()
    }

    // MARK: - Private functions

    private func setupView() {
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        view.addSubview(enterTextField)
        view.addSubview(button)
        view.addSubview(tableView)
    }

    private func setupLayout() {

        enterTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.width.equalTo(tableView)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(40)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(enterTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(40)

        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view)
//            make.trailing.equalTo(view)
//            make.bottom.equalTo(view)
        }
    }

    @objc func buttonAction() {
        guard enterTextField.text != "" else {return}
        print(enterTextField.text)
        if let text = enterTextField.text {

            contacts.append(Contact(name: text))
//            tableView.reloadData()
            tableView.insertRows(at: [IndexPath(row: contacts.count - 1, section: 0)], with: .automatic)
            enterTextField.text = nil
        }
    }


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
//        content.image = UIImage(systemName: "play")
        content.text = contacts[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
