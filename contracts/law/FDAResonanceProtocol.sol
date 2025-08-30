// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract FDAResonanceProtocol {
    struct Product {
        string name;
        string batchHash;
        bool purityAudit;
        bool emotionalResonance;
        bool approved;
    }

    mapping(string => Product) public products;

    event ProductCertified(string name, bool approved);

    function certifyProduct(
        string memory _name,
        string memory _batchHash,
        bool _purityAudit,
        bool _emotionalResonance
    ) public {
        bool _approved = _purityAudit && _emotionalResonance;
        products[_name] = Product(_name, _batchHash, _purityAudit, _emotionalResonance, _approved);
        emit ProductCertified(_name, _approved);
    }

    function checkProduct(string memory _name) public view returns (Product memory) {
        return products[_name];
    }
}
