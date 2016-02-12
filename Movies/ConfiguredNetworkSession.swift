import Foundation

protocol NetworkSession {
    func dataTaskWithRequest(
        request: NSURLRequest,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void
    )
}

struct ConfiguredNetworkSession: NetworkSession {
    func dataTaskWithRequest(
        request: NSURLRequest,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        NSURLSession.sharedSession()
            .dataTaskWithRequest(request, completionHandler: completionHandler)
            .resume()
    }
}
