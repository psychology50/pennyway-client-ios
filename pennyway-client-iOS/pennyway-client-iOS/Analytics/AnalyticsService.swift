//
//  AnalyticsService.swift
//  pennyway-client-iOS
//
//  Created by 양재서 on 7/30/24.
//

import SwiftUI

// MARK: - AnalyticsService

protocol AnalyticsService {
    /// SDK를 초기화한다.
    /// > 이 메서드는 AppDelegate application:didFinishLaunchingWithOptions: 메서드 내에서 반드시 호출되어야 한다.
    func initialize(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

    /// 앱 내에서 이벤트를 추적한다.
    func track(_ event: AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]?)

    /// 사용자 정보를 설정한다.
    ///
    /// - Parameters:
    ///   - userId: 사용자 식별자 정보 (고유값)
    ///   - properties: 사용자 추가 정보 (옵션)
    func setUser(_ userId: String, _ properties: [String: String]?)

    /// 구독할 이벤트의 목록을 제공하는 변수.
    ///
    /// - Note: 이 변수는 구독할 이벤트의 배열을 반환합니다. 구독할 이벤트를 설정하려면 이 변수를 구현하는 클래스 또는 구조체에서 배열을 반환하도록 해야 합니다.
    var subscribedEvents: [AnalyticsEvent.Type] { get }
}

// MARK: Default Behavior

extension AnalyticsService {
    var subscribedEvents: [AnalyticsEvent.Type] {
        return []
    }
}

// MARK: Convenience Methods

extension AnalyticsService {
    /// 이벤트가 구독된 이벤트 목록에 포함되어 있는지 확인한다.
    ///
    /// - Parameter event: 확인하려는 `AnalyticsEventDefinition`
    /// - Returns: 이벤트가 구독된 목록에 포함되어 있으면 `true`, 그렇지 않으면 `false`
    func shouldSubscribeEvent(event: AnalyticsEvent) -> Bool {
        return subscribedEvents.contains(where: { type(of: event) == $0 })
    }

    /// 이벤트를 추적하는 편의용 메서드.
    /// 구독된 이벤트인 경우에만 추적을 수행한다.
    ///
    /// - Note: 이 메서드는 내부에서 `shouldSubscribeEvent(_:)` 메서드를 호출하여 이벤트가 구독된 이벤트인지 확인한다.
    ///       구독하지 않은 이벤트인 경우 추적을 수행하지 않는다.
    func trackEventIfSubscribed(_ event: AnalyticsEvent, additionalParams: [AnalyticsConstants.Parameter: Any]?) {
        if shouldSubscribeEvent(event: event) {
            track(event, additionalParams: additionalParams)
        }
    }
}
