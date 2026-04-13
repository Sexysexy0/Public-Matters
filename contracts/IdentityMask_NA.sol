// IdentityMask_NA.sol
pragma solidity ^0.8.0;

contract IdentityMask_NA {
    string public constant SYSTEM_ID = "N/A";
    address private immutable supremeAdmin;

    constructor() {
        supremeAdmin = msg.sender;
    }

    function getCallerIdentity() public pure returns (string memory) {
        // Kahit sino ang mag-query, ito lang ang lalabas.
        return SYSTEM_ID;
    }

    modifier onlyNA() {
        require(msg.sender == supremeAdmin, "Access Denied: Identity Unknown");
        _;
    }
}
