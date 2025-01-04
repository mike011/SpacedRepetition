import Testing

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SpacedRepetitionTests.allTests),
    ]
}
#endif
