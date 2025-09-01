// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BudgetBlessingRegistry {
    struct Blessing {
        string agency;
        string purpose;
        uint256 amount;
        uint256 emotionalAPR; // 0–100
        uint256 barangayImpactScore; // 0–100
        bool verified;
    }

    Blessing[] public blessings;
    address public steward;

    event BlessingLogged(string agency, string purpose, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(
        string memory _agency,
        string memory _purpose,
        uint256 _amount,
        uint256 _emotionalAPR,
        uint256 _barangayImpactScore
    ) external onlySteward {
        blessings.push(Blessing(_agency, _purpose, _amount, _emotionalAPR, _barangayImpactScore, false));
        emit BlessingLogged(_agency, _purpose, _amount);
    }

    function verifyBlessing(uint256 _id) external onlySteward {
        require(_id < blessings.length, "Invalid blessing ID");
        blessings[_id].verified = true;
    }

    function getBlessing(uint256 _id) external view returns (Blessing memory) {
        return blessings[_id];
    }

    function getBlessingCount() external view returns (uint256) {
        return blessings.length;
    }
}
