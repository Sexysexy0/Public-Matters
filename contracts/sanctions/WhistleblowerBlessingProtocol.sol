// WhistleblowerBlessingProtocol.sol
pragma solidity ^0.8.19;

contract WhistleblowerBlessingProtocol {
    address public steward;

    struct Whistle {
        string name;
        string reportLink;
        bool verified;
        bool rewarded;
    }

    Whistle[] public reports;

    event WhistleBlessed(string name);

    constructor() {
        steward = msg.sender;
    }

    function submitReport(string memory name, string memory reportLink) public {
        reports.push(Whistle(name, reportLink, false, false));
    }

    function verifyAndBless(uint index) public {
        require(msg.sender == steward, "Only steward may bless");
        Whistle storage w = reports[index];
        w.verified = true;
        w.rewarded = true;
        emit WhistleBlessed(w.name);
    }

    function getReports() public view returns (Whistle[] memory) {
        return reports;
    }
}
