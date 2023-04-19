//
//  Presenter.swift
//  CryptoViper
//
//  Created by melo on 3/2/23.
//

import Foundation

// Class, protocol
// talks to -> interactor, router, view

enum NetworkError: Error {
    case NetworkFailed
    case ParsingFailed
}

protocol AnyPresenter {
    var view: AnyView? { get set }
    var interactor: AnyInteractor? { get set }
    var router: AnyRouter? { get set }
    
    func interactorDidDownloadCrypto(result: Result<[Crypto],Error>)
}

class CryptoPresenter: AnyPresenter {
    var view: AnyView?
    var interactor: AnyInteractor? {
        didSet {
            interactor?.downloadCryptos()
        }
    }
    var router: AnyRouter?
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], Error>) {
        switch result {
        case.success(let cryptos):
            view?.update(with: cryptos)
        case .failure(_):
            view?.update(with: "try again later...")
        }
    }
}
