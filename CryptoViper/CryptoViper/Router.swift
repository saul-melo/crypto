//
//  Router.swift
//  CryptoViper
//
//  Created by melo on 3/2/23.
//

import Foundation
import UIKit

// Class, protocol
// EntryPoint

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get }
    static func startExecution() -> AnyRouter
}

class CryptoRouter: AnyRouter {
    var entry: EntryPoint?
    static func startExecution() -> AnyRouter {
        var view: AnyView = CryptoViewController()
        var interactor: AnyInteractor = CryptoInteractor()
        var presenter: AnyPresenter = CryptoPresenter()
        let router = CryptoRouter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view as? EntryPoint
         
        return router
    }
}
