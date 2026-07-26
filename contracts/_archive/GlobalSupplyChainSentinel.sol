pragma solidity ^0.8.0;

contract GlobalSupplyChainSentinel {
    event Alert(string chokepoint, string action);

    function trigger(string memory chokepoint) public {
        emit Alert(chokepoint, "Activate PH contingency plan");
    }
}
