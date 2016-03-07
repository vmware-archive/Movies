import Foundation
import BrightFutures

protocol Http {
    func get(url: String) -> Future<NSData, HttpError>
}

enum HttpError: ErrorType {
    case BadRequest // 400
}

struct NetworkHttp {
    let session: NetworkSession
}

extension NetworkHttp: Http {
    func get(url: String) -> Future<NSData, HttpError> {
        let promise = Promise<NSData, HttpError>()
        let request = NSURLRequest(URL: NSURL(string: url)!)

        session.dataTaskWithRequest(request) { (
            maybeData: NSData?,
            maybeResponse: NSURLResponse?,
            maybeError: NSError?) in

            if
                maybeError == nil,
                let response = maybeResponse as? NSHTTPURLResponse where response.statusCode < 400,
                let data = maybeData
            {
                promise.success(data)
            } else {
                promise.failure(.BadRequest)
            }
        }

        return promise.future
    }
}