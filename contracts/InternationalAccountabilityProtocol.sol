// InternationalAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract InternationalAccountabilityProtocol {
    struct Agreement {
        uint256 id;
        string treaty;     // e.g. "Universal Declaration of Human Rights"
        string safeguard;  // e.g. "Align with global human rights standards"
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
