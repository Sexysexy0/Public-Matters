// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract FundUnfreezeProtocol {
    struct FrozenFund {
        string source;           // Origin of the fund (e.g. agency, grant, donor)
        string intendedUse;      // Purpose (e.g. relief, education, sanctum restoration)
        uint256 amount;          // Amount frozen
        bool isFrozen;           // Status flag
        uint256 timestamp;       // When it was frozen
        address steward;         // Who logged it
    }

    FrozenFund[] public funds;

    event FundFrozen(string source, string intendedUse, uint256 amount, address indexed steward);
    event FundUnfrozen(string source, uint256 amount, address indexed steward);

    function logFreeze(
        string memory source,
        string memory intendedUse,
        uint256 amount
    ) public {
        funds.push(FrozenFund(source, intendedUse, amount, true, block.timestamp, msg.sender));
        emit FundFrozen(source, intendedUse, amount, msg.sender);
    }

    function unfreeze(uint256 index) public {
        require(index < funds.length, "Invalid index");
        require(funds[index].isFrozen, "Already unfrozen");

        funds[index].isFrozen = false;
        emit FundUnfrozen(funds[index].source, funds[index].amount, msg.sender);
    }

    function getAllFunds() public view returns (FrozenFund[] memory) {
        return funds;
    }

    function getFrozenFunds() public view returns (FrozenFund[] memory) {
        uint256 count;
        for (uint256 i = 0; i < funds.length; i++) {
            if (funds[i].isFrozen) count++;
        }

        FrozenFund[] memory frozen = new FrozenFund[](count);
        uint256 j;
        for (uint256 i = 0; i < funds.length; i++) {
            if (funds[i].isFrozen) {
                frozen[j] = funds[i];
                j++;
            }
        }
        return frozen;
    }
}
