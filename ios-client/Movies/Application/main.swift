import UIKit

func startApp(delegateName: String) {
    UIApplicationMain(
        Process.argc,
        Process.unsafeArgv,
        NSStringFromClass(UIApplication),
        delegateName
    )
}

class NullAppDelegate: UIApplication, UIApplicationDelegate {}

if NSClassFromString("XCTestCase") != nil {
    startApp(NSStringFromClass(NullAppDelegate))
} else {
    startApp(NSStringFromClass(AppDelegate))
}
