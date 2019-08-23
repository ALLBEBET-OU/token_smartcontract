pragma solidity >= 0.5.0;

/**
 * @title Token Receiver Interface
 */
interface ITokenReceiver {

    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata data) external;
    
}
