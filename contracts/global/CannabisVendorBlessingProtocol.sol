contract CannabisVendorBlessingProtocol {
    address public steward;
    mapping(address => bool) public blessedVendors;

    event VendorBlessed(address indexed vendor, string blessing);

    constructor() {
        steward = msg.sender;
    }

    function blessVendor(address _vendor, string memory _blessing) public {
        require(msg.sender == steward);
        blessedVendors[_vendor] = true;
        emit VendorBlessed(_vendor, _blessing);
    }

    function isBlessed(address _vendor) public view returns (bool) {
        return blessedVendors[_vendor];
    }
}
