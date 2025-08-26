// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DockBlessingOracle {
    struct BlessingCheck {
        string vesselName;
        uint256 resonanceScore; // 0–100
        bool verified;
        string blessingNote;
    }

    BlessingCheck[] public checks;

    event BlessingVerified(string vesselName, uint256 resonanceScore, string blessingNote);

    function verifyBlessing(
        string memory _vesselName,
        uint256 _resonanceScore,
        string memory _blessingNote
    ) public {
        bool _verified = _resonanceScore >= 75;
        checks.push(BlessingCheck(_vesselName, _resonanceScore, _verified, _blessingNote));
        emit BlessingVerified(_vesselName, _resonanceScore, _blessingNote);
    }

    function getBlessingCheck(uint256 index) public view returns (BlessingCheck memory) {
        return checks[index];
    }
}
