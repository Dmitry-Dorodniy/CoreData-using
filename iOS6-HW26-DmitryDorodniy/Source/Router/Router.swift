//
//  Router.swift
//  iOS6-HW26-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 28.08.2022.
//

import UIKit

// MARK: - Router protocol

protocol RouterType {

    var navigationController: UINavigationController? { get set }
    var assembly: AssemblyType? { get }
    init(navigationController: UINavigationController,
         assembly: AssemblyType)
    func pushDetail(person: Person?)
    func setRootVC()
}

// MARK: - Router

class Router: RouterType {
    
    func setRootVC() {

        guard let navigationConroller = navigationController else { return }
        guard let mainVC = assembly?.createMainViewController(router: self) else { return }
        navigationConroller.viewControllers = [mainVC]
        
    }

    func pushDetail(person: Person?) {

        guard let navigationConroller = navigationController, let person = person else { return }
        guard let detailVC = assembly?.createDetailViewController(person: person) else { return }

        navigationConroller.pushViewController(detailVC, animated: true)
    }

    var navigationController: UINavigationController?
    var assembly: AssemblyType?

    required init(navigationController: UINavigationController, assembly: AssemblyType) {

        self.navigationController = navigationController
        self.assembly = assembly
    }
}

