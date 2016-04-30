import Foundation
import Result

protocol DataParser {
    associatedtype ParsedObject
    associatedtype ParseError: ErrorType

    func parse(data: NSData) -> Result<ParsedObject, ParseError>
}
