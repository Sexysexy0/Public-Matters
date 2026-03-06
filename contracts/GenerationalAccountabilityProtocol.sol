// GenerationalAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract GenerationalAccountabilityProtocol {
    struct Lesson {
        uint256 id;
        string history;    // e.g. "Colonial exploitation"
        string application;// e.g. "Shape future governance reforms"
        uint256 timestamp;
    }

    uint256 public lessonCount;
    mapping(uint256 => Lesson) public lessons;

    event LessonLogged(uint256 id, string history, string application);

    function logLesson(string memory history, string memory application) public {
        lessonCount++;
        lessons[lessonCount] = Lesson(lessonCount, history, application, block.timestamp);
        emit LessonLogged(lessonCount, history, application);
    }
}
