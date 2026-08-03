// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignTransitProtocol {
    address public immutable osg;
    uint256 public driverSharePercentage = 80; // 80% sa tsuper, 20% sa operator

    struct Operator {
        bool isAuthorized;
        uint256 strikeCount;
    }

    struct Driver {
        address operatorWallet;
        bool isLicensed;
    }

    mapping(address => Operator) public operators;
    mapping(address => Driver) public drivers;

    constructor() { osg = msg.sender; }

    function registerOperator(address _operator) external {
        require(msg.sender == osg, "Only OSG can register operators");
        operators[_operator] = Operator(true, 0);
    }

    function registerDriver(address _driver, address _operator) external {
        require(msg.sender == osg, "Only OSG can register drivers");
        require(operators[_operator].isAuthorized, "Operator unauthorized");
        drivers[_driver] = Driver(_operator, true);
    }

    function payFare(address _driverWallet) external payable {
        Driver memory d = drivers[_driverWallet];
        require(d.isLicensed, "Unlicensed driver");
        require(operators[d.operatorWallet].isAuthorized, "Operator suspended");

        uint256 driverShare = (msg.value * driverSharePercentage) / 100;
        uint256 operatorShare = msg.value - driverShare;

        // P2P Routing: Walang hahawak na middleman, diretso agad sa wallets!
        (bool dSuccess, ) = _driverWallet.call{value: driverShare}("");
        require(dSuccess, "Driver payment failed");

        (bool oSuccess, ) = d.operatorWallet.call{value: operatorShare}("");
        require(oSuccess, "Operator payment failed");
    }

    function penalizeOperator(address _operator) external {
        require(msg.sender == osg, "Only OSG can penalize");
        operators[_operator].strikeCount += 1;
        
        // 3-Strike Rule Execution
        if(operators[_operator].strikeCount >= 3) {
            operators[_operator].isAuthorized = false;
        }
    }
}
