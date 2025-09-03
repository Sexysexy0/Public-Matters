// EmotionalAPRRedirectProtocol.sol
pragma solidity ^0.8.19;

contract EmotionalAPRRedirectProtocol {
    address public steward;

    struct Redirect {
        string sourcePartner;
        string destinationSanctum;
        uint256 aprValue;
        bool executed;
    }

    Redirect[] public redirects;

    event APRRedirected(string sourcePartner, string destinationSanctum, uint256 aprValue);

    constructor() {
        steward = msg.sender;
    }

    function redirectAPR(string memory source, string memory destination, uint256 value) public {
        require(msg.sender == steward, "Only steward may redirect");
        redirects.push(Redirect(source, destination, value, true));
        emit APRRedirected(source, destination, value);
    }

    function getRedirects() public view returns (Redirect[] memory) {
        return redirects;
    }
}
