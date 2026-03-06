// DisarmamentAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract DisarmamentAccountabilityProtocol {
    struct Agreement {
        uint256 id;
        string treaty;     // e.g. "Nuclear Non-Proliferation Treaty"
        string safeguard;  // e.g. "Reduce WMDs and enforce peace agreements"
        uint256 timestamp;
    }

    uint256 public agreementCount;
    mapping(uint256 => Agreement) public agreements;

    event AgreementLogged(uint256 id, string treaty, string safeguard);

    function logAgreement(string memory treaty, string memory safeguard) public {
        agreementCount++;
        agreements[agreementCount] = Agreement(agreementCount, treaty, safeguard, block.timestamp);
        emit AgreementLogged(agreementCount, treaty, safeguard);
    }
}
