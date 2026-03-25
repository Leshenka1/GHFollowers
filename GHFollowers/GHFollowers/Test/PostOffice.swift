//
//  PostOffice.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 26.02.26.
//

import UIKit

protocol PostOfficeControllerProtocol: AnyObject {
    func handleErrorOccurred(_ error: String)
    func handleDeliveryFinish(successfullySentMails: String)
}

protocol PostOfficeInteractorProtocol {
    func sendMessages(_ messages: [String], recipientId: String)
}

protocol PostOfficeRepresenterProtocol {
    func prepareSendMailResult(result: Result<Int, Error>)
}


class PostOfficeViewController: UIViewController, PostOfficeControllerProtocol {

    var postOfficeInteractor: PostOfficeInteractorProtocol?
    
    let recipientId: String
    let messagesToSend: [String]
    
    init(
        recipientId: String,
        messagesToSend: [String]
    ) {
        self.recipientId = recipientId
        self.messagesToSend = messagesToSend
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        postOfficeInteractor?.sendMessages(messagesToSend, recipientId: recipientId)
    }

    func handleErrorOccurred(_ error: String) {
        /* Shows UIAlertController with error */
    }

    func handleDeliveryFinish(successfullySentMails: String) {
        /* Shows number of successfully sent mails in UILabel */
    }
}


class PostOfficeInteractor: PostOfficeInteractorProtocol {
    struct Mail {
        let message: String
        let date: Date
    }
    
    var postOfficeRepresenter: PostOfficeRepresenterProtocol?
    let networkService: NetworkServiceProtocol
        
    let formatter = DateFormatter()
    
    init(
        networkService: NetworkServiceProtocol
    ) {
        self.networkService = networkService
    }
    
    func sendMessages(_ messages: [String], recipientId: String) {
        let package = messages.map { message in
            Mail(message: message, date: Date())
        }
        sendMailPackage(package, recipientId: recipientId)
    }

    func sendMailPackage(_ package: [Mail], recipientId: String) {
        var successfullySentMails = 0
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        
        for mail in package {
            let payload = formatPayload(with: mail)
            
            group.enter()
            networkService.sendMail(payload: payload, recipientId: recipientId) { result in
                switch result {
                case let .failure(error):
                    self.postOfficeRepresenter?.prepareSendMailResult(result: .failure(error))
                case let .success(successResponse):
                    serialQueue.sync {
                        successfullySentMails += 1
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.postOfficeRepresenter?.prepareSendMailResult(result: .success(successfullySentMails))
        }
    }
    
    func formatPayload(with mail: Mail) -> String {
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDate = formatter.string(from: mail.date)
        return "\(formattedDate): \(mail.message)"
    }
}

class PostOfficeRepresenter: PostOfficeRepresenterProtocol {
    weak var postOfficeController: PostOfficeControllerProtocol?
    
    func prepareSendMailResult(result: Result<Int, Error>) {
        switch result {
        case .success(let sendCount):
            let successfullySentMailsMessage = "successfullySentMails count: \(sendCount)"
            self.postOfficeController?.handleDeliveryFinish(successfullySentMails: successfullySentMailsMessage)
        case .failure(let failure):
            let errorMessage = "Error occured: \(failure)"
            self.postOfficeController?.handleErrorOccurred(errorMessage)
        }
    }
}

struct SuccessResponse: Decodable {
    /* Some decodable response fields... */
}

enum NetworkError: String, Error {
    case invalidData = "invalidData"
    case invalidResponse = "invalidResponse"
    case invalidURL = "invalidURL"

}

protocol NetworkServiceProtocol {
    func sendMail(
        payload: String,
        recipientId: String,
        completion: @escaping (Result<SuccessResponse, NetworkError>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    func sendMail(
        payload: String,
        recipientId: String,
        completion: @escaping (Result<SuccessResponse, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "ww.tbank.ru/sendMail?recipient=\(recipientId)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        if let data = payload.data(using: .utf8) {
            request.httpMethod = "POST"
            request.httpBody = data
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let succesResponse = try JSONDecoder().decode(SuccessResponse.self, from: data)
                completion(.success(succesResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}

class PostOfficeAssembly {
    static func assembly(viewController: PostOfficeViewController) {
        let networkService = NetworkService()
        let interactor = PostOfficeInteractor(networkService: networkService)
        let representer = PostOfficeRepresenter()
        
        viewController.postOfficeInteractor = interactor
        interactor.postOfficeRepresenter = representer
        representer.postOfficeController = viewController
    }
}
