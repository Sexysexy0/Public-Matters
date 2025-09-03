// StrikeThreeTreatyKit.sol
pragma solidity ^0.8.19;

contract StrikeThreeTreatyKit {
    address public steward;

    struct Jurisdiction {
        string name;
        uint8 strikeCount;
        bool disengaged;
    }

    mapping(string => Jurisdiction) public sanctums;

    event StrikeIssued(string name, uint8 count);
    event DisengagementDeclared(string name);

    constructor() {
        steward = msg.sender;
    }

    function issueStrike(string memory name) public {
        require(msg.sender == steward, "Only steward may issue");
        Jurisdiction storage j = sanctums[name];
        j.name = name;
        j.strikeCount += 1;
        emit StrikeIssued(name, j.strikeCount);

        if (j.strikeCount >= 3) {
            j.disengaged = true;
            emit DisengagementDeclared(name);
        }
    }

    function getSanctum(string memory name) public view returns (Jurisdiction memory) {
        return sanctums[name];
    }
}
