import XCTest

class AccessibleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanLoadJSON() {
        let obj = loadJSON()
        XCTAssertNotNil(obj)
        XCTAssertEqual(obj.count, 100)
        
        let firstObj = obj.first
        XCTAssertNotNil(firstObj)
        XCTAssertNotNil(firstObj!.name)
        XCTAssertNotNil(firstObj!.address)
        XCTAssertNotNil(firstObj!.age)
        XCTAssertNotNil(firstObj!.zip)
        XCTAssertNotNil(firstObj!.city)
        XCTAssertNotNil(firstObj!.country)
        XCTAssertNotNil(firstObj!.favorite)
        XCTAssertNotNil(firstObj!.id)
        XCTAssertNotNil(firstObj!.location)
    }
}
