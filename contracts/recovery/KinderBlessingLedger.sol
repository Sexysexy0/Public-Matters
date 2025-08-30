// SPDX-License-Identifier: Kinder-License
pragma solidity ^0.8.19;

contract KinderBlessingLedger {
    struct KinderBlessing {
        address steward;
        string childName;
        string emotionalTag;
        string sanctumTag;
        uint256 timestamp;
    }

    KinderBlessing[] public blessings;
    address public registrar;

    event BlessingLogged(address steward, string childName, string emotionalTag, string sanctumTag, uint256 timestamp);

    constructor() {
        registrar = msg.sender;
    }

    function logBlessing(string memory childName, string memory emotionalTag, string memory sanctumTag) public {
        blessings.push(KinderBlessing(msg.sender, childName, emotionalTag, sanctumTag, block.timestamp));
        emit BlessingLogged(msg.sender, childName, emotionalTag, sanctumTag, block.timestamp);
    }

    function getBlessing(uint256 index) public view returns (KinderBlessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
