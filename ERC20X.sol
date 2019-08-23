pragma solidity ^0.5.2;
import "./openzeppelin-solidity/token/ERC20/ERC20.sol";
import "./IERC20X.sol";
import "./ITokenReceiver.sol";

/**
 * @title ERC20 Extended
 * Adds support for approveAndCall function
 */
contract ERC20X is IERC20X, ERC20 {

    function approveAndCall(address _spender, uint _value, bytes memory _data) public returns (bool) {
        _approveAndCall(msg.sender, _spender, _value, _data);
        return true;
    }

    function _approveAndCall(address _owner, address _spender, uint _value, bytes memory _data) internal {
        require(_spender != address(0), "Spender cannot be address(0)");

        _allowed[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);

        ITokenReceiver(_spender).receiveApproval(_owner, _value, address(this), _data);
        emit ApprovalAndCall(_owner, _spender, _value, _data);
    }
    
}