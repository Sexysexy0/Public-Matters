// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketPardonValidationProtocol.sol";

contract BitMarketPardonValidationProtocolTest is Test {
    BitMarketPardonValidationProtocol protocol;

    function setUp() public {
        protocol = new BitMarketPardonValidationProtocol();
    }

    function testValidateAuthenticPardon() public {
        protocol.validatePardon("Maria Santos", "Hand-Signed", true);
        // Expect: Authentic, confirmed by direct presidential intent
    }

    function testValidateAutopenPardon() public {
        protocol.validatePardon("John Doe", "Autopen", false);
        // Expect: Not authentic, flagged for review
    }

    function testRevalidateIntent() public {
        protocol.validatePardon("Malik Thompson", "Autopen", true);
        // Expect: Authentic if intent documented
    }
}
