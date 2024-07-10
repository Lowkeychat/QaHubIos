struct MailhogResponse: Codable {
    let total: Int
    let count: Int
    let start: Int
    let items: [MailhogMessage]
}


struct MailhogMessage: Codable {
    let ID: String
    
    let From: Email
    
    let To: [Email]
    
    let Content: MessageContent
    
    let Created: String
    
    let Raw: RawMessage}


struct Email: Codable {
    let Mailbox: String
    let Domain: String
}


struct MessageContent: Codable {
    let Body: String
}


struct RawMessage: Codable {
    let From: String
    let To: [String]
    let Data: String
}
