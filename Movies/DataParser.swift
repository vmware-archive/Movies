import Foundation
import Result

protocol DataParser {
    typealias ParsedObject
    typealias ParseError: ErrorType

    func parse(data: NSData) -> Result<ParsedObject, ParseError>
}
