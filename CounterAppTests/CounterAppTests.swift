import XCTest
@testable import CounterApp

final class CounterAppTests: XCTestCase {
    func testCounterIncrement() {
        let view = ContentView()
        XCTAssertEqual(view.count, 0)
        
        // Simulate increment button tap
        view.count += 1
        XCTAssertEqual(view.count, 1)
    }
    
    func testCounterDecrement() {
        let view = ContentView()
        XCTAssertEqual(view.count, 0)
        
        // Simulate decrement button tap
        view.count -= 1
        XCTAssertEqual(view.count, -1)
    }
    
    func testCounterMultipleOperations() {
        let view = ContentView()
        XCTAssertEqual(view.count, 0)
        
        // Test multiple operations
        view.count += 5
        XCTAssertEqual(view.count, 5)
        
        view.count -= 2
        XCTAssertEqual(view.count, 3)
        
        view.count += 10
        XCTAssertEqual(view.count, 13)
    }
} 