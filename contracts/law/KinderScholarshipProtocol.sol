// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderScholarshipProtocol {
    address public steward;

    struct Scholarship {
        string scholarName;
        string barangay;
        uint256 amount;
        string purpose; // e.g., "Tuition", "Supplies", "Emotional Mentorship"
        bool damayTagged;
        uint256 timestamp;
    }

    Scholarship[] public scholarships;

    event ScholarshipDeployed(string scholarName, string barangay, uint256 amount, string purpose, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployScholarship(
        string memory scholarName,
        string memory barangay,
        uint256 amount,
        string memory purpose,
        bool damayTagged
    ) public onlySteward {
        Scholarship memory newScholarship = Scholarship({
            scholarName: scholarName,
            barangay: barangay,
            amount: amount,
            purpose: purpose,
            damayTagged: damayTagged,
            timestamp: block.timestamp
        });

        scholarships.push(newScholarship);
        emit ScholarshipDeployed(scholarName, barangay, amount, purpose, block.timestamp);
    }

    function getScholarship(uint256 index) public view returns (Scholarship memory) {
        require(index < scholarships.length, "Invalid index");
        return scholarships[index];
    }

    function totalScholarships() public view returns (uint256) {
        return scholarships.length;
    }
}
