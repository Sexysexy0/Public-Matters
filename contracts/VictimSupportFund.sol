pragma solidity ^0.8.0;

contract VictimSupportFund {
    event SupportActivation(string victim, uint256 aidAmount);

    function provideAid(string memory victim, uint256 aidAmount) public {
        emit SupportActivation(victim, aidAmount);
    }
}
