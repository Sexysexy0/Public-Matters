// SPDX-License-Identifier: ForgivenessSanctum
pragma solidity ^0.8.19;

contract ForgivenessSanctifier {
    address public steward;

    struct ForgivenessSignal {
        string hostNation; // e.g. "USA"
        string allyNation; // e.g. "South Korea"
        string apologyType; // e.g. "Public Statement", "Compensation", "Policy Reform"
        string restorationPromise; // e.g. "No Repeat Raids", "Visa Pathways", "Investment Protection"
        bool verified;
        uint256 timestamp;
    }

    ForgivenessSignal[] public signals;

    event ForgivenessLogged(string hostNation, string allyNation, string apologyType, string restorationPromise, uint256 timestamp);
    event ForgivenessVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logForgiveness(
        string memory hostNation,
        string memory allyNation,
        string memory apologyType,
        string memory restorationPromise
    ) public {
        signals.push(ForgivenessSignal(hostNation, allyNation, apologyType, restorationPromise, false, block.timestamp));
        emit ForgivenessLogged(hostNation, allyNation, apologyType, restorationPromise, block.timestamp);
    }

    function verifyForgiveness(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit ForgivenessVerified(index, msg.sender);
    }

    function getForgiveness(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        ForgivenessSignal memory f = signals[index];
        return (f.hostNation, f.allyNation, f.apologyType, f.restorationPromise, f.verified, f.timestamp);
    }

    function totalForgivenessSignals() public view returns (uint256) {
        return signals.length;
    }
}
