// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DistributorBSC is Ownable, AccessControl {
    using Counters for Counters.Counter;

    IERC20 public premiumToken;
    Counters.Counter private _policyID;
    ApplyForPolicyParams[] private _policies;

    struct ApplyForPolicyParams {
        uint256 marketId;
        uint256 depositAmount;
        uint256 coverage;
        address buyer;
    }

    event LogApplied(uint256 marketId, address indexed premiumToken, uint256 depositAmount, uint256 coverage, address indexed buyer);
    event PremiumTokenChanged(address indexed oldValue, address indexed newValue);

    constructor(
        address premiumToken_
    )
    {
        premiumToken = IERC20(premiumToken_);
    }

    function changePremiumToken(
        address newToken_
    )
        external
        onlyOwner
    {
        require(newToken_ != address(0), "DistributorBSC#changePremiumToken: ZERO_ADDRESS");
        address oldToken = address(premiumToken);
        premiumToken = IERC20(newToken_);

        emit PremiumTokenChanged(oldToken, newToken_);
    }

    function applyForPolicy(
        ApplyForPolicyParams memory policy_
    )
        external
    {
        require(policy_.depositAmount > 0, "DistributorBSC#applyForPolicy: DEPOSIT_AMOUNT_NULL");
        require(premiumToken.balanceOf(policy_.buyer) >= policy_.depositAmount, "DistributorBSC#applyForPolicy: INSUFFICIENT_FUNDS");

        premiumToken.transferFrom(policy_.buyer, address(this), policy_.depositAmount);

        _policyID.increment();
        uint256 id = _policyID.current();
        _policies[id] = policy_;

        // convert using bridge

        emit LogApplied(policy_.marketId, address(premiumToken), policy_.depositAmount, policy_.coverage, policy_.buyer);
    }

    function transferToReceiver(
        uint256 amount
    )
        external
        onlyOwner
    {
        require(premiumToken.balanceOf(address(this)) >= amount, "DistributorBSC#applyForPolicy: INSUFFICIENT_FUNDS");
        // cross-chain transfer from BSC to Ethereum
    }
}
