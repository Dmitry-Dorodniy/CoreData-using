//
//  Router.swift
//  iOS6-HW26-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 28.08.2022.
//

import UIKit

// MARK: - Assembly protocol

protocol AssemblyType {

    var storage: StorageManagerType { get set }
    func createMainViewController(router: RouterType) -> UIViewController
    func createDetailViewController(person: Person) -> UIViewController
}

// MARK: - Assembly

class Assembly: AssemblyType {

    var storage: StorageManagerType = StorageManager()

    func createMainViewController(router: RouterType) -> UIViewController {
        let presenter = MainPresenter(router: router,
                                      storage: storage)
        let mainVC = MainViewController()
        mainVC.presenter = presenter
        return mainVC
    }

   func createDetailViewController(person: Person) -> UIViewController {
       let presenter = DetailPresenter(person: person,
                                       storage: storage)
        let detailVC = DetailViewController()
        detailVC.presenter = presenter
        return detailVC
    }
}
