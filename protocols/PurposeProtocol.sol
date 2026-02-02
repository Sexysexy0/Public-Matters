// PurposeProtocol.sol
pragma solidity ^0.8.0;

contract PurposeProtocol {
    struct Purpose {
        uint256 id;
        string statement;   // e.g. "Customer-first innovation", "Sustainable growth"
        address author;
        uint256 timestamp;
    }

    uint256 public purposeCount;
    mapping(uint256 => Purpose) public purposes;

    event PurposeLogged(uint256 id, string statement, address author, uint256 timestamp);
    event PurposeDeclared(string message);

    function logPurpose(string memory statement) public {
        purposeCount++;
        purposes[purposeCount] = Purpose(purposeCount, statement, msg.sender, block.timestamp);
        emit PurposeLogged(purposeCount, statement, msg.sender, block.timestamp);
    }

    function declarePurpose() public {
        emit PurposeDeclared("Purpose Protocol: mission arcs encoded into communal dignity.");
    }
}
