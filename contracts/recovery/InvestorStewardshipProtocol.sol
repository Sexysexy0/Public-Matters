// SPDX-License-Identifier: Steward-License
pragma solidity ^0.8.19;

contract InvestorStewardshipProtocol {
    struct StewardShare {
        address investor;
        string sanctumTag;
        uint256 shareAmount;
        string emotionalTag;
        string roleTag;
    }

    StewardShare[] public shares;
    address public registrar;

    event ShareLogged(address investor, string sanctumTag, uint256 shareAmount, string emotionalTag, string roleTag);

    constructor() {
        registrar = msg.sender;
    }

    function logShare(string memory sanctumTag, uint256 shareAmount, string memory emotionalTag, string memory roleTag) public {
        shares.push(StewardShare(msg.sender, sanctumTag, shareAmount, emotionalTag, roleTag));
        emit ShareLogged(msg.sender, sanctumTag, shareAmount, emotionalTag, roleTag);
    }

    function totalShares() public view returns (uint256) {
        return shares.length;
    }
}
