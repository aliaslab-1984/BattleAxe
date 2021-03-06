import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RotatorTests.allTests),
        testCase(RotatorConfigurationTests.allTests),
        testCase(ExtensionsTest.allTests),
        testCase(LogServiceTests.allTests),
        testCase(LogSeverityTest.allTests)
    ]
}
#endif
