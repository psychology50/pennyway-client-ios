

import Alamofire
import Foundation

enum AuthRouter: URLRequestConvertible {
    case signup(dto: SignUpRequestDto)
    case receiveVerificationCode(dto: VerificationCodeRequestDto, type: VerificationType)
    case verifyVerificationCode(dto: VerificationRequestDto)
    case checkDuplicateUserName(dto: CheckDuplicateRequestDto)
    case login(dto: LoginRequestDto)
    case linkAccountToOAuth(dto: LinkAccountToOAuthRequestDto)
    case findUserName(dto: FindUserNameRequestDto)
    case logout, refresh
    case requestResetPw(dto: RequestResetPwDto)
    case receivePwVerifyVerificationCode(dto: VerificationRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .signup, .receiveVerificationCode, .verifyVerificationCode, .login, .linkAccountToOAuth, .receivePwVerifyVerificationCode:
            return .post
        case .checkDuplicateUserName, .findUserName, .logout, .refresh:
            return .get
        case .requestResetPw:
            return .patch
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "v1/auth/sign-up"
        case .receiveVerificationCode:
            return "v1/phone"
        case .verifyVerificationCode:
            return "v1/auth/phone/verification"
        case .checkDuplicateUserName:
            return "v1/duplicate/username"
        case .login:
            return "v1/auth/sign-in"
        case .linkAccountToOAuth:
            return "v1/auth/link-oauth"
        case .findUserName:
            return "v1/find/username"
        case .logout:
            return "v1/sign-out"
        case .requestResetPw:
            return "v1/find/password"
        case .receivePwVerifyVerificationCode:
            return "v1/find/password/verification"
        case .refresh:
            return "v1/auth/refresh"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .signup(dto):
            return try? dto.asDictionary()
        case let .receiveVerificationCode(dto, _):
            return try? dto.asDictionary()
        case let .verifyVerificationCode(dto):
            return try? dto.asDictionary()
        case let .login(dto):
            return try? dto.asDictionary()
        case let .linkAccountToOAuth(dto):
            return try? dto.asDictionary()
        case let .findUserName(dto):
            return try? dto.asDictionary()
        case let .requestResetPw(dto):
            return try? dto.asDictionary()
        case let .receivePwVerifyVerificationCode(dto):
            return try? dto.asDictionary()
        case .checkDuplicateUserName, .logout, .refresh:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .signup, .verifyVerificationCode, .login, .linkAccountToOAuth, .receivePwVerifyVerificationCode, .requestResetPw:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
            
        case let .receiveVerificationCode(_, type):
            let queryParameters = [URLQueryItem(name: "type", value: type.rawValue)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case let .checkDuplicateUserName(dto):
            let queryParameters = [URLQueryItem(name: "username", value: dto.username)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
            
        case let .findUserName(dto):
            let queryParameters = [URLQueryItem(name: "phone", value: dto.phone), URLQueryItem(name: "code", value: dto.code)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
            
        case .logout:
            request = URLRequest.createURLRequest(url: url, method: method)
            
        case .refresh:
            
            request = URLRequest.createURLRequest(url: url, method: method)
            
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader
                
                Log.debug(KeychainHelper.loadAccessToken())
                Log.debug(cookieHeader)
            }
        }
        return request
    }
}
