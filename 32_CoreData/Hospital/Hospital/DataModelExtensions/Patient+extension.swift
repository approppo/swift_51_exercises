import Foundation

extension Patient {
    public override var description: String {
        return "\(firstName!) \(lastName!)"
    }
    
    static func random() -> (String, String, Int32) {
        let names = [
            ("Karen", "Stark"),
            ("Valerie", "Cross"),
            ("Evelyn", "Monroe"),
            ("Miles", "Miles"),
            ("Edmond", "Drake"),
            ("Alfonso", "Hawkins"),
            ("Shane", "Skinner"),
            ("Rodney", "Berry"),
            ("Grace", "Sweeney"),
            ("Alfredo", "Bruce"),
            ("Hubert", "Schultz"),
            ("Leona", "Davidson"),
            ("Connie", "Chapman"),
            ("Bonnie", "Joseph"),
            ("Rick", "Patrick"),
            ("Chasity", "Jackson"),
            ("Booker", "Frank"),
            ("Lily", "Dixon"),
            ("Jenna", "Jensen"),
            ("Kathryn", "Salinas"),
            ("Jerri", "Frederick"),
            ("Dollie", "Jones"),
            ("Mayra", "Booker"),
            ("Nadine", "Keith"),
            ("Teddy", "Nixon"),
            ("Quinton", "Gilliam"),
            ("Amber", "Boyd"),
            ("Gerard", "Whitley"),
            ("Edgar", "Vaughan"),
            ("Susan", "Goodman"),
            ("Charmaine", "Mendez"),
            ("Selma", "Dotson"),
            ("Constance", "Mccullough"),
            ("Sherrie", "Mcmillan"),
            ("Emil", "Ortiz"),
            ("Tabatha", "Higgins"),
            ("Jame", "Foster"),
            ("Shawna", "Clark"),
            ("Preston", "Tran"),
            ("Ethan", "Burks"),
            ("Frank", "Summers"),
            ("Roosevelt", "Nunez"),
            ("Gale", "Martin"),
            ("Mitchell", "Howe"),
            ("Evan", "Cobb"),
            ]
        let randomIndex = Int(arc4random_uniform(UInt32(names.count)))
        let randomAge = Int32(arc4random_uniform(100))
        let name = names[randomIndex]
        return (name.0, name.1, randomAge)
    }
}
