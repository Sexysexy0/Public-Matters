// SPDX-License-Identifier: ChipForgiveness
pragma solidity ^0.8.19;

contract ChipForgivenessRouter {
    address public steward;

    struct ForgivenessSignal {
        string nationOrCompany; // e.g. "China", "ByteDance", "Alibaba"
        string forgivenessType; // "Chip Ban Lift", "AI Access Restoration", "Corridor Equity"
        string protocolTag; // e.g. "Forgiveness #CF9", "Signal #EQ3"
        bool verified;
        uint256 timestamp;
    }

    ForgivenessSignal[] public signals;

    event ForgivenessLogged(string nationOrCompany, string forgivenessType, string protocolTag, uint256 timestamp);
    event ForgivenessVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logForgiveness(
        string memory nationOrCompany,
        string memory forgivenessType,
        string memory protocolTag
    ) public {
        signals.push(ForgivenessSignal(nationOrCompany, forgivenessType, protocolTag, false, block.timestamp));
        emit ForgivenessLogged(nationOrCompany, forgivenessType, protocolTag, block.timestamp);
    }

    function verifyForgiveness(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ForgivenessVerified(index, msg.sender);
    }

    function getForgiveness(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        ForgivenessSignal memory f = signals[index];
        return (f.nationOrCompany, f.forgivenessType, f.protocolTag, f.verified, f.timestamp);
    }

    function totalForgivenessSignals() public view returns (uint256) {
        return signals.length;
    }
}
