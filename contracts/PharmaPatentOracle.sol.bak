// PharmaPatentOracle.sol
pragma solidity ^0.8.0;

contract PharmaPatentOracle {
    struct DrugPatent {
        string drugName;
        address developer;
        bool isPublicDataUsed;
        uint256 subsidizedPrice;
    }

    mapping(uint256 => DrugPatent) public patentRegistry;

    function registerPatent(uint256 _id, string memory _name, bool _isPublic) public {
        uint256 price = _isPublic ? 100 : 5000; // Cap price if data was public
        patentRegistry[_id] = DrugPatent(_name, msg.sender, _isPublic, price);
    }
}
