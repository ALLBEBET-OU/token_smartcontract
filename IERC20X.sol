pragma solidity ^0.5.2;

/**
 * @title ERC20 Extended interface
 */
interface IERC20X {

    function approveAndCall(address _spender, uint _value, bytes calldata _data) external returns (bool);
    event ApprovalAndCall(address indexed owner, address indexed spender, uint value, bytes data);
    
}
