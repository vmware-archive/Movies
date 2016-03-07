import XCTest

@testable import Movies

class NetworkHttpTest: XCTestCase {
    let fakeSession = FakeSession()
    var networkHttp: NetworkHttp!

    override func setUp() {
        networkHttp = NetworkHttp(session: fakeSession)
    }

    func test_get_configuresRequestURL() {
        networkHttp.get("http://example.com/")


        let expectedRequest = NSURLRequest(
            URL: NSURL(string: "http://example.com/")!
        )
        let actualRequest = fakeSession.dataTaskWithRequest_request

        XCTAssertEqual(expectedRequest, actualRequest)
    }

    func test_get_resolvesWithResponseData_forSuccessfulRequests() {
        let expectation = self.expectationWithDescription("Promise is resolved")
        var actualData: NSData!


        networkHttp.get("http://example.com/").onSuccess { data in
            actualData = data
            expectation.fulfill()
        }


        let sampleData = "{\"message\": \"Hi there!\"}".dataUsingEncoding(
            NSUTF8StringEncoding
        )
        fakeSession.dataTaskWithReqeust_completionHandler(
            sampleData,
            buildResponse("http://example.com", statusCode: 200),
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualData, sampleData)
    }

    func test_get_resolvesWithError_forFailedRequests() {
        let expectation = self.expectationWithDescription("Promise is resolved")
        var actualError: HttpError!


        networkHttp.get("http://example.com/").onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        fakeSession.dataTaskWithReqeust_completionHandler(
            nil,
            buildResponse("http://example.com/", statusCode: 400),
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualError, HttpError.BadRequest)
    }

    func test_get_resolvesWithError_forFailedRequestsWithDataInBody() {
        let expectation = self.expectationWithDescription("Promise is resolved")
        var actualError: HttpError!


        networkHttp.get("http://example.com/").onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        fakeSession.dataTaskWithReqeust_completionHandler(
            NSData(),
            buildResponse("http://example.com/", statusCode: 400),
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualError, HttpError.BadRequest)
    }

    private func buildResponse(url: String, statusCode: Int) -> NSHTTPURLResponse {
        if let response = NSHTTPURLResponse(
            URL: NSURL(string: url)!,
            statusCode: statusCode,
            HTTPVersion: nil,
            headerFields: nil
            )
        {
                return response
        }

        return NSHTTPURLResponse()
    }
}
