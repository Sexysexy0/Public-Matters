// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignTransitProtocol {
    
    address public immutable solicitorGeneral;
    
    // Ang porsyento ng pasahe na mapupunta diretso sa driver (hal. 80%)
    uint256 public driverSharePercentage = 80; 

    struct Operator {
        bool isAuthorized;
        uint256 requiredActiveUnits;
        uint256 strikeCount;
    }

    struct Driver {
        address operatorWallet;
        bool isLicensed;
    }

    mapping(address => Operator) public operators;
    mapping(address => Driver) public drivers;

    event FranchiseGranted(address operator, uint256 requiredUnits);
    event FranchiseRevoked(address operator, string reason);
    event FarePaid(address driver, uint256 driverShare, uint256 operatorShare);
    event OperatorPenalized(address operator, uint256 newStrikeCount);

    constructor() {
        solicitorGeneral = msg.sender;
    }

    modifier onlyOSG() {
        require(msg.sender == solicitorGeneral, "Execution Denied: OSG clearance required.");
        _;
    }

    /**
     * @dev Nirerehistro ng OSG ang mga transport operators (bus/jeepney fleets)
     * na may requirement na minimum active units para hindi sila pwedeng mag-hoard ng prangkisa.
     */
    function grantFranchise(address _operator, uint256 _requiredActiveUnits) external onlyOSG {
        operators[_operator] = Operator({
            isAuthorized: true,
            requiredActiveUnits: _requiredActiveUnits,
            strikeCount: 0
        });
        emit FranchiseGranted(_operator, _requiredActiveUnits);
    }

    /**
     * @dev Nirerehistro ng operator ang kanilang mga lehitimong tsuper.
     */
    function registerDriver(address _driverWallet) external {
        require(operators[msg.sender].isAuthorized, "Only authorized operators can register drivers.");
        
        drivers[_driverWallet] = Driver({
            operatorWallet: msg.sender,
            isLicensed: true
        });
    }

    /**
     * @dev Ang Smart Fare System: Kapag nagbayad ang pasahero, wasak na ang "Boundary System".
     * Awtomatikong hahatiin ng smart contract ang pera: malaking porsyento diretso sa tsuper, ang natira sa operator.
     */
    function payFare(address _driverWallet) external payable {
        Driver memory d = drivers[_driverWallet];
        require(d.isLicensed, "Unlicensed driver.");
        require(operators[d.operatorWallet].isAuthorized, "Operator franchise is currently suspended.");

        uint256 driverShare = (msg.value * driverSharePercentage) / 100;
        uint256 operatorShare = msg.value - driverShare;

        // P2P Transfer: Diretso sa bulsa nang walang middleman
        payable(_driverWallet).transfer(driverShare);
        payable(d.operatorWallet).transfer(operatorShare);

        emit FarePaid(_driverWallet, driverShare, operatorShare);
    }

    /**
     * @dev Auto-Revoke Protocol: Kapag nag-strike ang operator o hindi dineploy ang required units,
     * ang OSG ay pwedeng mag-issue ng strike. Sa 3 strikes, automatic revoked ang prangkisa.
     */
    function penalizeOperator(address _operator) external onlyOSG {
        require(operators[_operator].isAuthorized, "Operator not found or already revoked.");
        
        operators[_operator].strikeCount += 1;
        emit OperatorPenalized(_operator, operators[_operator].strikeCount);

        if (operators[_operator].strikeCount >= 3) {
            operators[_operator].isAuthorized = false;
            emit FranchiseRevoked(_operator, "Revoked: 3 Strikes Reached. Failure to serve public interest.");
        }
    }
}
