//
//  GHFollowersTests.swift
//  GHFollowersTests
//
//  Created by Алексей Зубель on 24.02.26.
//

import XCTest
@testable import GHFollowers

final class CalculatorTests: XCTestCase {
    var sut: Calculator!
    
    override func setUp() {
        sut = Calculator()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSumCorrect() {
        let (a, b) = (1, 2)
        
        XCTAssertEqual(sut.getSum(a: a, b: b), 3, "Sum of 1 and 2 should be 3")
    }
}

enum NetworkError: Error {
    case serverUnavailable
}

class CurrencyService {
    var isServerAlive = true
    
    func fetchUSDRate() async throws -> Double {
        
        try await Task.sleep(nanoseconds: 100_000_000)
                
        if isServerAlive {
            return 92.5
        } else {
            throw NetworkError.serverUnavailable
        }
    }
}

final class CurrencyServiceTests: XCTestCase {

    var sut: CurrencyService!

    override func setUp() {
        super.setUp()
        sut = CurrencyService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchUSDRateSuccess() async throws {
        let rate = try await sut.fetchUSDRate()
        
        XCTAssertEqual(rate, 92.5, "Курс доллара должен быть 92.5")
    }
    
    func testFetchUSDRateThrowError() async {
        sut.isServerAlive = false
        do {
            _ = try await sut.fetchUSDRate()

            XCTFail("Метод должен был упасть с ошибкой, но вернул результат")
        } catch {
            XCTAssertEqual(error as? NetworkError, .serverUnavailable, "Ошибка должна быть serverUnavailable")
        }
     }
}
