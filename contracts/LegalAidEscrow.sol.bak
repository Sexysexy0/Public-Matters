// LegalAidEscrow.sol
pragma solidity ^0.8.0;

contract LegalAidEscrow {
    struct Representation {
        address lawyer;
        address client;
        uint256 appearances;
        bool caseClosed;
    }

    mapping(uint256 => Representation) public legalAidRegistry;

    function releaseLegalFee(uint256 _caseId) public {
        require(legalAidRegistry[_caseId].appearances >= 5, "Insufficient work logged");
        require(legalAidRegistry[_caseId].caseClosed, "Case must be closed or reached milestone");
        
        // Logic for transferring funds to lawyer's wallet
        payable(legalAidRegistry[_caseId].lawyer).transfer(address(this).balance);
    }
}
