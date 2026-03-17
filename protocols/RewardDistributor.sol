// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ReputationNFT {
    function getTokens(address owner) external view returns (uint[] memory);
}

contract RewardDistributor {
    address public fund;
    ReputationNFT public reputation;

    constructor(address _fund, address _reputation) {
        fund = _fund;
        reputation = ReputationNFT(_reputation);
    }

    function distribute(address[] memory holders) public payable {
        uint total = holders.length;
        require(total > 0, "No holders");
        uint share = msg.value / total;

        for (uint i = 0; i < holders.length; i++) {
            payable(holders[i]).transfer(share);
        }
    }
}
