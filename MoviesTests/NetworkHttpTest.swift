import XCTest

@testable import Movies

class NetworkHttpTest: XCTestCase {
    func test_get_configuresRequestURL() {
        let fakeSession = FakeSession()
        let http = NetworkHttp(session: fakeSession)


        http.get("http://example.com/")


        let expectedRequest = NSURLRequest(
            URL: NSURL(string: "http://example.com/")!
        )
        let actualRequest = fakeSession.dataTaskWithRequest_request

        XCTAssertEqual(expectedRequest, actualRequest)
    }

    func test_get_resolvesWithResponseData_forSuccessfulRequests() {
        let fakeSession = FakeSession()
        let http = NetworkHttp(session: fakeSession)
        let expectation = self.expectationWithDescription("Promise is resolved")

        var actualData: NSData = NSData()


        http.get("http://example.com/").onSuccess { data in
            actualData = data
            expectation.fulfill()
        }


        let sampleData = "{\"message\": \"Hi there!\"}".dataUsingEncoding(
            NSUTF8StringEncoding
        )
        let successfulResponse = NSHTTPURLResponse(
            URL: NSURL(string: "http://example.com/")!,
            statusCode: 200,
            HTTPVersion: nil,
            headerFields: nil
        )
        fakeSession.dataTaskWithReqeust_completionHandler(
            sampleData,
            successfulResponse,
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualData, sampleData)
    }

    func test_get_resolvesWithError_forFailedRequests() {
        let fakeSession = FakeSession()
        let http = NetworkHttp(session: fakeSession)
        let expectation = self.expectationWithDescription("Promise is resolved")

        var actualError: HttpError = HttpError.BadRequest


        http.get("http://example.com/").onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        let badRequest = NSHTTPURLResponse(
            URL: NSURL(string: "http://example.com/")!,
            statusCode: 400,
            HTTPVersion: nil,
            headerFields: nil
        )
        fakeSession.dataTaskWithReqeust_completionHandler(
            nil,
            badRequest,
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualError, HttpError.BadRequest)
    }

    func test_get_resolvesWithError_forFailedRequestsWithDataInBody() {
        let fakeSession = FakeSession()
        let http = NetworkHttp(session: fakeSession)
        let expectation = self.expectationWithDescription("Promise is resolved")

        var actualError: HttpError = HttpError.BadRequest


        http.get("http://example.com/").onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        let badRequest = NSHTTPURLResponse(
            URL: NSURL(string: "http://example.com/")!,
            statusCode: 400,
            HTTPVersion: nil,
            headerFields: nil
        )
        fakeSession.dataTaskWithReqeust_completionHandler(
            NSData(),
            badRequest,
            nil
        )

        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(actualError, HttpError.BadRequest)
    }
}
