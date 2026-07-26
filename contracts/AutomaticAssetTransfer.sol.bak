// AutomaticAssetTransfer.sol
pragma solidity ^0.8.0;

contract AutomaticAssetTransfer {
    address public owner;
    bool public isOwnerDeceased;

    struct Distribution {
        address beneficiary;
        uint256 percentage;
    }

    Distribution[] public inheritancePlan;

    function triggerTransfer() public {
        // Verified by a trusted Oracle or multi-sig from board members
        require(isOwnerDeceased, "Owner is still active.");
        for (uint i = 0; i < inheritancePlan.length; i++) {
            payable(inheritancePlan[i].beneficiary).transfer(inheritancePlan[i].percentage);
        }
    }
}
