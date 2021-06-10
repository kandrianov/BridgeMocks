// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

contract AtomicaProductBSC {

    event LogApplied(uint256 marketId, address premiumToken, uint256 depositAmount, uint256 coverage, address buyer);

    address public premiumToken;

    struct ApplyForPolicyParams {
        uint256 marketId;
        uint256 depositAmount;
        uint256 coverage;
    }

    constructor(address premiumToken_) {
        premiumToken = premiumToken_;
    }

    function applyForPolicy(ApplyForPolicyParams memory params_) external {
        // transfer premium token
        // convert using bridge

        emit LogApplied(params_.marketId, premiumToken, params_.depositAmount, params_.coverage, msg.sender);
    }
}
