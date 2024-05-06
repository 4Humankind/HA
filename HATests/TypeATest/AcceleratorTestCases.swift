//
//  TypeATestCases.swift
//  HATests
//
//  Created by Porori on 5/5/24.
//

import XCTest
import CoreMotion
@testable import HA

final class AcceleratorTestCases: XCTestCase {
    var motionManager: CMMotionManager!
    
    // 테스트 케이스 생성 시
    override func setUp() {
        super.setUp()
        motionManager = CMMotionManager()
    }
    
    // 테스트 케이스 완료 이후
    override func tearDown() {
        motionManager = nil
    }
    
    func testAccelerometerData() {
        // arrange
        let expected = XCTestExpectation(description: "데이터를 가져올 수 있음")
        
        // act
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            // assert
            XCTAssertNotNil("가속도계 != nil")
            expected.fulfill()
        }
    }
}
