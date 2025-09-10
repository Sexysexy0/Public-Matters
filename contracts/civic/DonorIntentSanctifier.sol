// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract DonorIntentSanctifier {
    struct Intent {
        address donor;
        string purpose;
        string emotionalTag;
        uint256 amount;
        uint256 timestamp;
        bool sanctified;
    }

    Intent[] public intents;
    address public steward;

    event IntentSanctified(address indexed donor, string purpose, string emotionalTag, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a sanctum steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function sanctifyIntent(address _donor, string memory _purpose, string memory _emotionalTag, uint256 _amount) public onlySteward {
        intents.push(Intent(_donor, _purpose, _emotionalTag, _amount, block.timestamp, true));
        emit IntentSanctified(_donor, _purpose, _emotionalTag, _amount);
    }

    function getSanctifiedIntents() public view returns (Intent[] memory) {
        return intents;
    }

    function totalSanctified() public view returns (uint256 sum) {
        for (uint i = 0; i < intents.length; i++) {
            sum += intents[i].amount;
        }
    }
}
