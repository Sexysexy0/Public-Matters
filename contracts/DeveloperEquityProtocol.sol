pragma solidity ^0.8.0;

contract DeveloperEquityProtocol {
    event EquityViolation(address studio, string issue);

    function checkRevenueSplit(address studio, uint256 studioShare, uint256 providerShare) public {
        if (providerShare > studioShare * 2) {
            emit EquityViolation(studio, "Unfair revenue split detected");
        }
    }
}
