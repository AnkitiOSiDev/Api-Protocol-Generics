//
//  Queue.swift
//  ApiCall
//
//  Created by Ankit on 25/07/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation
typealias NetworkCompletionHandler = (_ result: Result<Data, Error>) -> Void

class QueueManager {
    /// The Lazily-instantiated queue
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        return queue;
    }()
    
    /// The Singleton Instance
    static let sharedInstance = QueueManager()
    
    /// Add a single operation
    /// - Parameter operation: The operation to be added
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
    
    
    /// Add an array of operations
    /// - Parameter operations: The Array of Operation to be added
    func addOperations(_ operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: true)
    }
}



class DecodingOperation<T:Decodable>: Operation {
    var dataFetched: Data?
    var error: Error?
    var decodedURL: URL?
    var completionHandler: (responseHandler<T>)?

    override func main() {
        guard let dataFetched = dataFetched else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let content = try decoder.decode(T.self, from: dataFetched)
            completionHandler?(.success(content))
        } catch {
            self.error = error
            completionHandler?(.failure(ApiError.invalidResponse))
        }
    }
}

class NetworkOperation: Operation {
    
    
    /// The completionHandler that is run when the operation is complete
    var completionHandler: (NetworkCompletionHandler)?
    
    /// Stte stored as an enum
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    /// Start the NSOperation
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        if !isExecuting {
            state = .executing
        }
        main()
    }
    
    /// Move to the finished state
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    /// Called to indicate that the operation is complete, and then call the opional completion handler
    /// - Parameter result: The result type
    func complete(result: Result<Data, Error>) {
        finish()
        if !isCancelled {
            completionHandler?(result)
        }
    }
    
    /// Cancels the Operation
    override func cancel() {
        super.cancel()
        finish()
    }
}


class ApiOperation<T: APIResourse>: NetworkOperation {
    var dataFetched: Data?
    
    var error: Error?
    var apiResource : T
    var networkManager: ApiCallerProtocol
    
    init (apiResource: T,networkManager: ApiCallerProtocol = NetworkManager.manager) {
        self.apiResource = apiResource
        self.networkManager = networkManager
    }
       
    override func main() {
        networkManager.getData(resourse: apiResource,completion: { data in
                    switch data {
                    case .failure(let error):
                        self.error = error
                        self.complete(result: data)
                    case .success(let successdata):
                        self.dataFetched = successdata
                        self.complete(result: data)
                    }
                })
    }
}
