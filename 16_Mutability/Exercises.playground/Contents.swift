struct Person {
    var name: String
    var age: Int
    
    func speak() -> String {
        return "Hi! My name is \(name), I am \(age) years old."
    }
    
    mutating func increase() {
        age += 1
    }
}

var peter = Person(name: "Peter", age: 30)
peter.speak()
peter.increase()
peter.speak()

var john = Person(name: "John", age: 20)
john.speak()
john.increase()
john.speak()
