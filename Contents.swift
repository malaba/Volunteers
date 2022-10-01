import Foundation

let JSON = """
{
"questions": [
    {
        "id": "0",
        "title": "how do i install vs code",
        "tags": ["mac", "vs code"]
    },
    {
        "id": "1",
        "title": "my program is too slow please help",
        "tags": ["python", "ai"]
    },
    {
        "id": "2",
        "title": "why is the hitbox off by 2 pixels",
        "tags": ["c#", "game"]
    },
    {
        "id": "3",
        "title": "my dependency injection stack trace is strange",
        "tags": ["java", "oop"]
    },
    {
        "id": "4",
        "title": "socket.recv is freezing",
        "tags": ["python", "networking"]
    },
    {
        "id": "5",
        "title": "i have a memory leak",
        "tags": ["c++", "networking"]
    }
],
"volunteers": [
    {
        "id": "sam5k",
        "tags": ["python", "networking"]
    },
    {
        "id": "djpat",
        "tags": ["ai"]
    },
    {
        "id": "jessg",
        "tags": ["java", "networking"]
    },
    {
        "id": "rayo",
        "tags": ["java", "networking"]
    }
]
}
""".data(using: .utf8)!

struct Question: Codable, Identifiable {
    let id: String
    let title: String
    let tags: Set<String>
}

struct Volunteer: Codable, Identifiable {
    let id: String
    let tags: Set<String>
}

struct Frankenstein: Codable {
    let questions: [Question]
    let volunteers: [Volunteer]
}

let decoder = JSONDecoder()
let frankenstein = try decoder.decode(Frankenstein.self, from: JSON)

let volunteers = frankenstein.volunteers
let questions = frankenstein.questions

let questionsDict = questions.reduce(into: [:]) { $0[$1.id] = $1 }

struct Assignment {
    let questionId: String
    let volunteerId: String
}

struct Response {
    var leftOverQuestions: [String : Question]
    var assignments: [Assignment]
}

let response =
volunteers.reduce(into: Response(leftOverQuestions: questionsDict, assignments: [])) { response, volunteer in
    if let (questionId, _) = response.leftOverQuestions.first(where: {
        !$1.tags.intersection(volunteer.tags).isEmpty
    }) {
        let assignment = Assignment(questionId: questionId, volunteerId: volunteer.id)
        response.assignments.append(assignment)
        response.leftOverQuestions.removeValue(forKey: questionId)
    }
}

response
