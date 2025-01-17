

public struct OAuthSignUpRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let name: String
    let username: String
    let phone: String
    let code: String
    let provider: String

    public init(
        oauthId: String,
        idToken: String,
        nonce: String,
        name: String,
        username: String,
        phone: String,
        code: String,
        provider: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.nonce = nonce
        self.name = name
        self.username = username
        self.phone = phone
        self.code = code
        self.provider = provider
    }
}
