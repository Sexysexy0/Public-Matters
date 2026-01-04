pragma solidity ^0.8.20;

contract FutureGenerationsProtocol {
    address public admin;

    struct Promise {
        string domain;       // e.g. climate, education, healthcare
        string commitment;   // e.g. net-zero, universal access, equity
        uint256 timestamp;
    }

    Promise[] public promises;

    event PromiseLogged(string domain, string commitment, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPromise(string calldata domain, string calldata commitment) external onlyAdmin {
        promises.push(Promise(domain, commitment, block.timestamp));
        emit PromiseLogged(domain, commitment, block.timestamp);
    }

    function totalPromises() external view returns (uint256) {
        return promises.length;
    }
}
