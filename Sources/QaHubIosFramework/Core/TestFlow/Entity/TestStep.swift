import Foundation

public class TestStep: Codable {
    var name: String
    var id: String
    var parentId: String
    var steps: [TestStep]
    var result: String

    init(name: String, id: String, parentId: String, steps: [TestStep], result: String = "failure") {
        self.name = name
        self.id = id
        self.parentId = parentId
        self.steps = steps
        self.result = result
    }
}
