// SPDX-License-Identifier: InferenceSanctum
pragma solidity ^0.8.19;

contract AIInferenceEquityRouter {
    struct InferenceSignal {
        string chipModel;
        string vendor;
        uint256 price;
        bool termsAccepted;
        string stewardNote;
    }

    mapping(string => InferenceSignal) public inferenceRegistry;

    event InferenceTagged(string chipModel, string vendor);
    event TermsAccepted(string chipModel);

    function tagInference(string memory chipModel, string memory vendor, uint256 price, string memory stewardNote) public {
        inferenceRegistry[chipModel] = InferenceSignal(chipModel, vendor, price, false, stewardNote);
        emit InferenceTagged(chipModel, vendor);
    }

    function acceptTerms(string memory chipModel) public {
        require(bytes(inferenceRegistry[chipModel].vendor).length > 0, "Chip not tagged");
        inferenceRegistry[chipModel].termsAccepted = true;
        emit TermsAccepted(chipModel);
    }

    function getInferenceStatus(string memory chipModel) public view returns (InferenceSignal memory) {
        return inferenceRegistry[chipModel];
    }
}
