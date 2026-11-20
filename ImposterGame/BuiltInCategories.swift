import Foundation

enum BuiltInCategories {
    static let idPrefix = "builtin."

    static let all: [WordCategory] = [
        make("food", "Food", [
            "Pizza", "Burger", "Sushi", "Pasta", "Tacos", "Shawarma", "Falafel", "Hummus",
            "Manakish", "Tabbouleh", "Ice Cream", "Pancakes", "Croissant", "Salad", "Steak",
            "Fried Chicken", "French Fries", "Hot Dog", "Sandwich", "Soup", "Chocolate",
            "Cake", "Donut", "Popcorn", "Omelette", "Waffles",
        ]),
        make("places", "Places", [
            "Beach", "Airport", "Hospital", "School", "Library", "Cinema", "Restaurant",
            "Supermarket", "Gym", "Bank", "Museum", "Zoo", "Park", "Hotel", "Mall", "Stadium",
            "Police Station", "Train Station", "Swimming Pool", "Office", "Farm", "Desert",
            "Mountain", "Nightclub", "Bakery", "Pharmacy", "Prison", "Space Station",
        ]),
        make("animals", "Animals", [
            "Dog", "Cat", "Lion", "Tiger", "Elephant", "Giraffe", "Monkey", "Horse", "Cow",
            "Sheep", "Chicken", "Eagle", "Penguin", "Dolphin", "Shark", "Whale", "Snake",
            "Crocodile", "Frog", "Bear", "Rabbit", "Camel", "Kangaroo", "Owl", "Bee", "Spider",
        ]),
        make("jobs", "Jobs", [
            "Doctor", "Teacher", "Chef", "Pilot", "Police Officer", "Firefighter", "Lawyer",
            "Engineer", "Dentist", "Nurse", "Farmer", "Mechanic", "Barber", "Photographer",
            "Singer", "Actor", "Waiter", "Taxi Driver", "Astronaut", "Programmer", "Plumber",
            "Architect", "Journalist", "Soldier", "Banker",
        ]),
        make("sports", "Sports", [
            "Football", "Basketball", "Tennis", "Swimming", "Boxing", "Volleyball", "Golf",
            "Baseball", "Skiing", "Cycling", "Running", "Karate", "Surfing", "Table Tennis",
            "Badminton", "Rugby", "Ice Hockey", "Wrestling", "Gymnastics", "Bowling",
            "Formula 1", "Horse Riding", "Fencing", "Rock Climbing",
        ]),
        make("objects", "Household Objects", [
            "Chair", "Table", "Bed", "Lamp", "Mirror", "Fridge", "Oven", "Microwave",
            "Television", "Sofa", "Pillow", "Blanket", "Toothbrush", "Towel", "Umbrella",
            "Clock", "Key", "Phone", "Laptop", "Remote Control", "Washing Machine", "Fan",
            "Vacuum Cleaner", "Candle", "Scissors",
        ]),
        make("transport", "Transportation", [
            "Car", "Bus", "Train", "Airplane", "Helicopter", "Bicycle", "Motorcycle", "Boat",
            "Submarine", "Taxi", "Truck", "Scooter", "Skateboard", "Tram", "Rocket",
            "Cruise Ship", "Hot Air Balloon", "Ambulance", "Tractor", "Cable Car", "Jet Ski",
        ]),
        make("countries", "Countries", [
            "Lebanon", "France", "Italy", "USA", "Brazil", "Japan", "China", "Egypt", "Mexico",
            "Spain", "Germany", "United Kingdom", "Canada", "Australia", "India", "Russia",
            "Turkey", "Greece", "Argentina", "South Korea", "Saudi Arabia", "UAE",
            "Switzerland", "Morocco", "Portugal",
        ]),
    ]

    private static func make(_ id: String, _ name: String, _ words: [String]) -> WordCategory {
        WordCategory(id: idPrefix + id, name: name, words: words)
    }
}
