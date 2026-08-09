// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ITrustIntegrator.sol";

/**
 * @title EducationCredential
 * @dev Unforgeable digital diplomas issued by accredited training centers.
 *      Automatically updates the Trust Index when a new credential is issued.
 */
contract EducationCredential is ERC721, Ownable {
    uint256 public nextTokenId;
    ITrustIntegrator public trustIntegrator;

    struct Credential {
        address student;
        uint256 graduationDate;
        string courseName;
        string institution;
        bytes32 transcriptHash;
        bool isValid;
    }

    mapping(uint256 => Credential) public credentials;
    mapping(address => uint256[]) public studentCredentials;

    event CredentialIssued(uint256 indexed id, address student, string course, string institution);
    event CredentialRevoked(uint256 indexed id);
    event TrustIntegratorUpdated(address newIntegrator);

    constructor(address _trustIntegrator) ERC721("Education Credential", "EDU") Ownable(msg.sender) {
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function issueCredential(
        address _student,
        string memory _courseName,
        string memory _institution,
        bytes32 _transcriptHash
    ) external onlyOwner returns (uint256) {
        require(_student != address(0), "Invalid student");
        require(bytes(_courseName).length > 0, "Course required");

        uint256 tokenId = nextTokenId++;
        _safeMint(_student, tokenId);

        credentials[tokenId] = Credential({
            student: _student,
            graduationDate: block.timestamp,
            courseName: _courseName,
            institution: _institution,
            transcriptHash: _transcriptHash,
            isValid: true
        });

        studentCredentials[_student].push(tokenId);

        // Boost the Trust Index when a new diploma is issued
        trustIntegrator.logPositiveAction(10);

        emit CredentialIssued(tokenId, _student, _courseName, _institution);
        return tokenId;
    }

    function revokeCredential(uint256 _tokenId) external onlyOwner {
        require(credentials[_tokenId].isValid, "Already revoked");
        credentials[_tokenId].isValid = false;
        emit CredentialRevoked(_tokenId);
    }

    function getCredential(uint256 _tokenId) external view returns (
        address student,
        uint256 graduationDate,
        string memory courseName,
        string memory institution,
        bytes32 transcriptHash,
        bool isValid
    ) {
        Credential memory c = credentials[_tokenId];
        return (c.student, c.graduationDate, c.courseName, c.institution, c.transcriptHash, c.isValid);
    }

    function getStudentCredentials(address _student) external view returns (uint256[] memory) {
        return studentCredentials[_student];
    }

    function setTrustIntegrator(address _newIntegrator) external onlyOwner {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
        emit TrustIntegratorUpdated(_newIntegrator);
    }
}
