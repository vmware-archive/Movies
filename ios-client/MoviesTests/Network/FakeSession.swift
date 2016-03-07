import Foundation

@testable import Movies

class FakeSession: NetworkSession {
    var dataTaskWithRequest_request = NSURLRequest()
    var dataTaskWithReqeust_completionHandler = {
        (maybeData: NSData?, maybeResponse: NSURLResponse?, maybeError: NSError?) in
        // no-op
        print("No op! Nothing to do.")
    }
    func dataTaskWithRequest(
        request: NSURLRequest,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        dataTaskWithRequest_request = request
        dataTaskWithReqeust_completionHandler = completionHandler
    }

}