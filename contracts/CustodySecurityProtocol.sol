pragma solidity ^0.8.20;

contract CustodySecurityProtocol {
    address public admin;

    struct Custody {
        string custodian;    // e.g. Qualified bank, trust company
        string method;       // e.g. Multi-sig, Encrypted storage
        uint256 timestamp;
    }

    Custody[] public custodies;

    event CustodyLogged(string custodian, string method, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCustody(string calldata custodian, string calldata method) external onlyAdmin {
        custodies.push(Custody(custodian, method, block.timestamp));
        emit CustodyLogged(custodian, method, block.timestamp);
    }

    function totalCustodies() external view returns (uint256) {
        return custodies.length;
    }
}
