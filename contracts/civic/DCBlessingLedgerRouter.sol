// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract DCBlessingLedgerRouter {
    struct Donation {
        address donor;
        string purpose;
        uint256 amount;
        uint256 timestamp;
        bool verified;
    }

    Donation[] public blessings;
    address public steward;

    event BlessingLogged(address indexed donor, string purpose, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a civic steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(address _donor, string memory _purpose, uint256 _amount) public onlySteward {
        blessings.push(Donation(_donor, _purpose, _amount, block.timestamp, true));
        emit BlessingLogged(_donor, _purpose, _amount);
    }

    function getBlessings() public view returns (Donation[] memory) {
        return blessings;
    }

    function totalBlessed() public view returns (uint256 sum) {
        for (uint i = 0; i < blessings.length; i++) {
            sum += blessings[i].amount;
        }
    }
}
