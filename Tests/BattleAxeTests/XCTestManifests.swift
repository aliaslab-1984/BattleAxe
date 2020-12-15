import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BattleAxeTests.allTests),
        testCase(RotatorTests.allTests)
    ]
}
#endif
