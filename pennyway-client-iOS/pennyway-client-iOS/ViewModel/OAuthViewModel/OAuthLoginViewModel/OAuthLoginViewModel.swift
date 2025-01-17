
import SwiftUI

class OAuthLoginViewModel: ObservableObject {
    let profileInfoViewModel = UserAccountViewModel()
    var dto: OAuthLoginRequestDto

    init(dto: OAuthLoginRequestDto) {
        self.dto = dto
    }

    func oauthLoginApi(completion: @escaping (Bool, String?) -> Void) {
        OAuthAlamofire.shared.oauthLogin(dto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        let isOAuthExistUser = response.data.user.id
                        if isOAuthExistUser != -1 {
                            self.profileInfoViewModel.getUserProfileApi { _ in
                                KeychainHelper.deleteOAuthUserData()
                                completion(true, nil)
                            }

                            AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                            AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                                AnalyticsConstants.Parameter.oauthType: self.dto.provider,
                                AnalyticsConstants.Parameter.isRefresh: false
                            ])
                        } else {
                            completion(false, nil)
                        }
                        print(response)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                        completion(false, "Error parsing response JSON")
                        return
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
                completion(false, error.localizedDescription)
                return
            }
        }
    }
}
