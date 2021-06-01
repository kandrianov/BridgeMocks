// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract AtomicaProductETH {

    event LogApplied(uint256 marketId, address premiumToken, uint256 depositAmount, uint256 coverage, address buyer);

    address public premiumToken;

    struct ApplyForPolicyParams {
        uint256 marketId;
        uint256 depositAmount;
        uint256 coverage;
        address buyer;
    }

    constructor(address premiumToken_) {
        premiumToken = premiumToken_;
    }

    function quote(uint256 marketId, uint256 coverage) external view returns (uint256) {
        return 1E5;
    }

    function applyForPolicy(ApplyForPolicyParams memory params_) external {
        // transfer premium token
        // apply for policy or decline

        emit LogApplied(params_.marketId, premiumToken, params_.depositAmount, params_.coverage, params_.buyer);
    }
}
