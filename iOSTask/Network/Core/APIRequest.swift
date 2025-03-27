
import Alamofire
import Combine
import Foundation
import Swime

// MARK: - APIRequestProtocols

protocol APIRequestProtocols {
    func request(_ endpoint: URLRequestConvertible) -> AnyPublisher<Data, AFError>
    func uploadRequest(_ endpoint: URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void) -> AnyPublisher<Data, AFError>
    
    func request(_ endpoint: URLRequestConvertible) async throws -> DataResponse<Data, AFError>
    func uploadRequest(_ endpoint: URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void)  async throws -> DataResponse<Data, AFError>
}

// MARK: - APIRequest

class APIRequest {
    // MARK: Lifecycle

    init() {
        let config = URLSessionConfiguration.af.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        self.sessionManager = Session(configuration: config, interceptor: Interceptor(adapter: NetworkAdapter(), retrier: NetworkRetrier(limit: 2, delay: 30)))
    }
    
    deinit{
        debugPrint("APIRequest deinited")
    }

    // MARK: Private

    private var sessionManager: Session
    private let queue = DispatchQueue(label: "network-queue", qos: .userInitiated, attributes: .concurrent)
}

// MARK: APIRequestProtocols

extension APIRequest: APIRequestProtocols {
    
    func uploadRequest(_ endpoint: Alamofire.URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void) async throws -> Alamofire.DataResponse<Data, Alamofire.AFError> {
        let urlRequest = try endpoint.asURLRequest()
        let request = sessionManager.upload(multipartFormData: { multiPart in
            guard let file = file else {
                return
            }
            guard let type = Swime.mimeType(data: file) else {
                return
            }
            multiPart.append(file, withName: fileName ?? "file", mimeType: type.mime)
        }, with: urlRequest)
        
        return await request
            .validate()
            .uploadProgress(closure: { progress in
                progressCompletion(progress.fractionCompleted)
            })
            .serializingData()
            .response
    }
    //
    func uploadRequest(_ endpoint: URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void) -> AnyPublisher<Data, AFError>{
        do {
            let urlRequest = try endpoint.asURLRequest()
            let request = sessionManager.upload(multipartFormData: { multiPart in
                guard let file = file else {
                    return
                }
                guard let type = Swime.mimeType(data: file) else {
                    return
                }
                multiPart.append(file, withName: fileName ?? "file", mimeType: type.mime)
            }, with: urlRequest)
            return request
                .validate()
                .uploadProgress(closure: { progress in
                    progressCompletion(progress.fractionCompleted)
                })
                .publishData()
                .value()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()

        } catch {
            return Fail(error: AFError.createURLRequestFailed(error: error)).eraseToAnyPublisher()
        }
    }

    func request(_ endpoint: URLRequestConvertible) -> AnyPublisher<Data, AFError> {
        do {
            let urlRequest = try endpoint.asURLRequest()
            print(urlRequest.url ?? "")
            let request = sessionManager.request(urlRequest, interceptor: Interceptor(adapter: NetworkAdapter(), retrier: NetworkRetrier(limit: 2, delay: 30)))
            return request
                .validate()
                .publishData()
                .value()
                .subscribe(on: queue)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: AFError.createURLRequestFailed(error: error)).eraseToAnyPublisher()
        }
    }
    
    func request(_ endpoint: URLRequestConvertible) async throws -> DataResponse<Data, AFError> {
            let urlRequest = try endpoint.asURLRequest()
        print(urlRequest.url ?? "")
            let request = sessionManager.request(urlRequest, interceptor: Interceptor(adapter: NetworkAdapter(), retrier: NetworkRetrier(limit: 2, delay: 30)))
            return await request
                .validate()
                .serializingData()
                .response
    }
}
