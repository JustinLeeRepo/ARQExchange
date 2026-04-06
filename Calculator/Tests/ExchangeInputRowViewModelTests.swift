//
//  ExchangeInputRowViewModelTests.swift
//  Calculator
//
//  Created by Justin Lee on 4/5/26.
//

import XCTest
import Combine
import Models
import SwiftUI
@testable import Calculator

extension Binding {
    static func mock(_ value: Value) -> Binding<Value> {
        var stored = value
        return Binding(get: { stored }, set: { stored = $0 })
    }
}

final class ExchangeInputRowViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    private var buySellSwapSubject: PassthroughSubject<BuySellSwapEvent, Never>!
    private var foreignCurrencySelectionSubject: PassthroughSubject<ForeignCurrencySelectionEvent, Never>!
    private var rateSubject: CurrentValueSubject<Rate?, Never>!
    private var focusDismissSubject: PassthroughSubject<Void, Never>!
    private var amountBinding: Binding<Double?>!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        buySellSwapSubject = PassthroughSubject()
        foreignCurrencySelectionSubject = PassthroughSubject()
        rateSubject = CurrentValueSubject(nil)
        focusDismissSubject = PassthroughSubject()
        amountBinding = .mock(nil)
    }

    override func tearDown() {
        cancellables.removeAll()
        buySellSwapSubject = nil
        foreignCurrencySelectionSubject = nil
        rateSubject = nil
        focusDismissSubject = nil
        amountBinding = nil
        super.tearDown()
    }

    // MARK: - Factory

    private func makeSUT(currency: Currency = .cop) -> ExchangeInputRowViewModel {
        ExchangeInputRowViewModel(
            currency: currency,
            buySellSwapEventPublisher: buySellSwapSubject.eraseToAnyPublisher(),
            foreignCurrencySelectionSubject: foreignCurrencySelectionSubject,
            ratePublisher: rateSubject.eraseToAnyPublisher(),
            binding: amountBinding,
            focusDismissPublisher: focusDismissSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Initialization Tests

    func test_init_withUSD_isLocked() {
        let sut = makeSUT(currency: .usd)
        XCTAssertTrue(sut.isLocked)
    }

    func test_init_withForeignCurrency_isNotLocked() {
        let sut = makeSUT(currency: .cop)
        XCTAssertFalse(sut.isLocked)
    }

    func test_init_currencyCode_matchesCurrency() {
        let sut = makeSUT(currency: .cop)
        XCTAssertEqual(sut.currencyCode, Currency.cop.code)
    }

    func test_init_usdCurrencyCode() {
        let sut = makeSUT(currency: .usd)
        XCTAssertEqual(sut.currencyCode, Currency.usd.code)
    }

    func test_init_bindingIsAssigned() {
        amountBinding = .mock(42.0)
        let sut = makeSUT()
        XCTAssertEqual(sut.amount.wrappedValue, 42.0)
    }

    func test_init_flagViewModel_lockedCurrencyHasNoSelectionPublisher() {
        let sut = makeSUT(currency: .usd)
        // FlagViewModel for USD (locked) should be initialized with nil publisher
        XCTAssertNotNil(sut.flagViewModel)
        XCTAssertNil(sut.flagViewModel.foreignCurrencySelectionPublisher)
    }

    func test_init_flagViewModel_foreignCurrencyHasSelectionPublisher() {
        let sut = makeSUT(currency: .cop)
        XCTAssertNotNil(sut.flagViewModel)
        XCTAssertNotNil(sut.flagViewModel.foreignCurrencySelectionPublisher)
    }

    // MARK: - Currency Code Tests

    func test_currencyCode_updatesOnForeignCurrencySelection() {
        let sut = makeSUT(currency: .cop)
        XCTAssertEqual(sut.currencyCode, Currency.cop.code)

        foreignCurrencySelectionSubject.send(.selected(.mxn))

        XCTAssertEqual(sut.currencyCode, Currency.mxn.code)
    }

    func test_currencyCode_doesNotUpdateForLockedCurrency() {
        let sut = makeSUT(currency: .usd)
        let originalCode = sut.currencyCode

        foreignCurrencySelectionSubject.send(.selected(.mxn))

        XCTAssertEqual(sut.currencyCode, originalCode)
    }

    func test_currencyCode_ignoresOpenEvent() {
        let sut = makeSUT(currency: .cop)
        let originalCode = sut.currencyCode

        foreignCurrencySelectionSubject.send(.open)

        XCTAssertEqual(sut.currencyCode, originalCode)
    }

    func test_currencyCode_updatesOnMultipleSelections() {
        let sut = makeSUT(currency: .cop)

        foreignCurrencySelectionSubject.send(.selected(.mxn))
        XCTAssertEqual(sut.currencyCode, Currency.mxn.code)

        foreignCurrencySelectionSubject.send(.selected(.brl))
        XCTAssertEqual(sut.currencyCode, Currency.brl.code)
    }

    // MARK: - openCurrencySelectionSheet Tests

    func test_openCurrencySelectionSheet_sendsOpenEvent() {
        let sut = makeSUT(currency: .cop)
        var receivedEvent: ForeignCurrencySelectionEvent?

        foreignCurrencySelectionSubject
            .sink { receivedEvent = $0 }
            .store(in: &cancellables)

        sut.openCurrencySelectionSheet()

        XCTAssertEqual(receivedEvent, .open)
    }

    // MARK: - convertedAmount Tests

    func test_convertedAmount_withNoRate_returnsZero() {
        let sut = makeSUT()
        // rateSubject starts as nil
        let result = sut.convertedAmount(from: 100)
        XCTAssertEqual(result, 0)
    }

    func test_convertedAmount_defaultIsSelling_usesAskRate() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 180.0, accuracy: 0.001)
    }

    func test_convertedAmount_whenBuying_usesBidRate() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)
        buySellSwapSubject.send(.buy)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 150.0, accuracy: 0.001)
    }

    func test_convertedAmount_whenSelling_usesAskRate() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)
        buySellSwapSubject.send(.sell)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 180.0, accuracy: 0.001)
    }

    func test_convertedAmount_afterSwapFromBuyToSell_usesAskRate() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)

        buySellSwapSubject.send(.buy)
        buySellSwapSubject.send(.sell)

        let result = sut.convertedAmount(from: 100)
        XCTAssertEqual(result, 180.0, accuracy: 0.001)
    }

    func test_convertedAmount_withInvalidBidRate_returnsZero() {
        let sut = makeSUT()
        rateSubject.send(.mockRate(bid: "invalid", ask: "1.8"))
        buySellSwapSubject.send(.buy)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 0)
    }

    func test_convertedAmount_withInvalidAskRate_returnsZero() {
        let sut = makeSUT()
        rateSubject.send(.mockRate(bid: "1.5", ask: "N/A"))
        // selling (default)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 0)
    }

    func test_convertedAmount_withZeroUsdAmount_returnsZero() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)

        let result = sut.convertedAmount(from: 0)

        XCTAssertEqual(result, 0)
    }

    func test_convertedAmount_rateUpdateReflectedImmediately() {
        let sut = makeSUT()
        rateSubject.send(.mockRate(bid: "1.0", ask: "1.0"))

        let firstResult = sut.convertedAmount(from: 100)
        XCTAssertEqual(firstResult, 100.0, accuracy: 0.001)

        rateSubject.send(.mockRate(bid: "2.0", ask: "2.0"))

        let secondResult = sut.convertedAmount(from: 100)
        XCTAssertEqual(secondResult, 200.0, accuracy: 0.001)
    }

    func test_convertedAmount_rateNilAfterBeingSet_returnsZero() {
        let sut = makeSUT()
        rateSubject.send(.mockTestRate)
        rateSubject.send(nil)

        let result = sut.convertedAmount(from: 100)

        XCTAssertEqual(result, 0)
    }

    func test_convertedAmount_withNegativeAmount() {
        let sut = makeSUT()
        rateSubject.send(.mockRate(bid: "1.5", ask: "2.0"))

        let result = sut.convertedAmount(from: -50)

        XCTAssertEqual(result, -100.0, accuracy: 0.001)
    }

    // MARK: - focusDismissPublisher Tests

    func test_focusDismissPublisher_isExposed() {
        let sut = makeSUT()
        var received = false

        sut.focusDismissPublisher
            .sink { received = true }
            .store(in: &cancellables)

        focusDismissSubject.send()

        XCTAssertTrue(received)
    }
}
