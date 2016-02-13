import Foundation
import BrightFutures

@testable import Movies

class FakeHttp: Http {
    var get_args = ""
    var get_returnValue = Future<NSData, HttpError>()
    func get(url: String) -> Future<NSData, HttpError> {
        get_args = url
        return get_returnValue
    }
}