import Foundation

func getPhoneViaTimestamp() -> String {
    let timestamp = String(NSDate().timeIntervalSince1970)
    let phone = String(timestamp.replacingOccurrences(of: ".", with: "").suffix(10))

    autotestLog("GENERATED PHONE: " + phone)
    return phone
}

func getRandomString(_ minLength: Int,
                            _ maxLength: Int,
                            letters: String = "abcdefghijklmnopqrstuvwxyz" ) -> String {
    let length = Int.random(in: minLength...maxLength)

    return String((1...length).map { _ in
        let randomElement = letters.randomElement() ?? "a"

        return randomElement
    })
}


func getRandomName(_ minLength: Int = 6,
                          _ maxLength: Int = 9) -> String {
    getRandomString(1, 1).uppercased() + getRandomString(minLength - 1, maxLength - 1)
}


func getRandomName(length: Int = 6) -> String {
    getRandomString(1, 1).uppercased() + getRandomString(length - 1, length - 1)
}



func getRandomNumber(prefix: Int = Int.random(in: 1...9), length: Int = 10) -> String {

    let numbers = "1234567890"
    let genLength = length - String(prefix).count
    let randomNumber = String(prefix) + String((1...genLength).map { _ in
        let randomElement = numbers.randomElement() ?? "1"

        return randomElement
    })

    autotestLog("GENERATED NUMBER: " + randomNumber)

    return randomNumber
}
