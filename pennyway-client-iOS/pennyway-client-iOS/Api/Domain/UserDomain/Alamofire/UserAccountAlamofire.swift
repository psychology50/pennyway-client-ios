
import Alamofire
import Foundation
import os.log

class UserAccountAlamofire {
    static let shared = UserAccountAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getUserProfile(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - getUserProfile() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.getUserProfile, completion: completion)
    }
    
    func deleteUserAccount(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - deleteUserAccount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.deleteUserAccount, completion: completion)
    }
    
    func registDeviceToken(_ dto: FcmTokenDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - registDeviceToken() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.registDeviceToken(dto: dto), completion: completion)
    }
    
    func settingOnAlarm(type: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - settingOnAlarm() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.settingOnAlarm(type: type), completion: completion)
    }
    
    func settingOffAlarm(type: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - settingOffAlarm() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.settingOffAlarm(type: type), completion: completion)
    }
    
    func validatePw(_ dto: ValidatePwRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - validatePw() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.validatePw(dto: dto), completion: completion)
    }
    
    func resetMyPw(_ dto: ResetMyPwRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - resetMyPw() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.resetMyPw(dto: dto), completion: completion)
    }
    
    func editUserId(dto: CheckDuplicateRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - editUserId() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.editUserId(dto: dto), completion: completion)
    }
    
    func editUserPhoneNumber(dto: VerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - editUserPhoneNumber() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.editUserPhoneNumber(dto: dto), completion: completion)
    }
    
    func editUserName(dto: EditNameRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - editUserName() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.editUserName(dto: dto), completion: completion)
    }
    
    func deleteProfileImage(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - deleteProfileImage() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.deleteProfileImage, completion: completion)
    }
 
    func uploadProfileImage(dto: UploadProfileImageRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - uploadProfileImage() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.uploadProfileImage(dto: dto), completion: completion)
    }
    
    func getNotificationList(dto: GetNotificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - getNotificationList() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.getNotificationList(dto: dto), completion: completion)
    }

    func readNotifications(dto: ReadNotificationsRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - readNotifications() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.readNotifications(dto: dto), completion: completion)
    }
    
    func checkUnReadNotifications(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - checkUnReadNotifications() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.checkUnReadNotifications, completion: completion)
    }
    
    func deleteDeviceToken(_ dto: FcmTokenDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - deleteDeviceToken() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.deleteDeviceToken(dto: dto), completion: completion)
    }
}
