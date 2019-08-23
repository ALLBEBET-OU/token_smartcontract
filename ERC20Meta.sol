pragma solidity ^0.5.2;
import "./ERC20X.sol";
import "./ECRecover.sol";
 
/**
 * @title Meta transactions wrapper around ERC20X
 *  Rewards relayer with native tokens
 */
contract ERC20Meta is ERC20X, ECRecover {

    function metaApproveAndCall(bytes memory _signature, uint _nonce, address _spender, uint _value, bytes memory _data, uint _reward)
    public returns (bool) 
    {   
        require(_spender != address(0), "Invalid spender address");

        bytes32 messageHash = metaApproveAndCallHash(_nonce, _spender, _value, _data, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);

        _approveAndCall(signer, _spender, _value, _data);

        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);
            
        return true;
    }

    function metaTransfer(bytes memory _signature, uint _nonce, address _to, uint _value, uint _reward) 
    public returns (bool) 
    {
        bytes32 messageHash = metaTransferHash(_nonce, _to, _value, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);
        _transfer(signer, _to, _value);

        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);
        
        return true;
    }

    function metaTransferFrom(bytes memory _signature, uint _nonce, address _from, address _to, uint _value, uint _reward) 
    public returns (bool) 
    {
        bytes32 messageHash = metaTransferFromHash(_nonce, _from, _to, _value, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);

        _allowed[_from][signer] = _allowed[_from][signer].sub(_value); //error
        _transfer(_from, _to, _value);
        emit Approval(_from, signer, _allowed[_from][signer]);

        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);
        
        return true;
    }

    function metaApprove(bytes memory _signature, uint _nonce, address _spender, uint _value, uint _reward) 
    public returns (bool) 
    {
        require(_spender != address(0), "Invalid spender address");

        bytes32 messageHash = metaApproveHash(_nonce, _spender, _value, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);
    
        _allowed[signer][_spender] = _value;
       
        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);

        emit Approval(signer, _spender, _value);
        return true;
    }

    function metaIncreaseAllowance(bytes memory _signature, uint _nonce, address _spender, uint256 _addedValue, uint _reward) 
    public returns (bool) 
    {
        require(_spender != address(0), "Invalid spender address");

        bytes32 messageHash = metaIncreaseAllowanceHash(_nonce, _spender, _addedValue, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);

        _allowed[signer][_spender] = _allowed[signer][_spender].add(_addedValue);

        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);

        emit Approval(signer, _spender, _allowed[signer][_spender]);
        return true;
    }

    function metaDecreaseAllowance(bytes memory _signature, uint _nonce, address _spender, uint256 _subtractedValue, uint _reward) 
    public returns (bool) 
    {
        require(_spender != address(0), "Invalid spender address");

        bytes32 messageHash = metaDecreaseAllowanceHash(_nonce, _spender, _subtractedValue, _reward);
        address signer = recoverSigner(messageHash, _signature);
        validateNonceForSigner(signer, _nonce);

        _allowed[signer][_spender] = _allowed[signer][_spender].sub(_subtractedValue);

        if (_reward > 0) 
            _transfer(signer, msg.sender, _reward);
        
        emit Approval(signer, _spender, _allowed[signer][_spender]);
        return true;
    }

    function metaTransferHash(uint _nonce, address _to, uint _value, uint _reward) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaTransfer", _nonce, _to, _value, _reward)); 
    }

    function metaApproveAndCallHash(uint _nonce, address _spender, uint _value, bytes memory _data, uint _reward) 
    public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaApproveAndCall", _nonce, _spender, _value, _data, _reward)); 
    }

    function metaTransferFromHash(uint _nonce, address _from, address _to, uint _value, uint _reward) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaTransferFrom", _nonce, _from, _to, _value, _reward)); 
    }

    function metaApproveHash(uint _nonce, address _spender, uint _value, uint _reward) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaApprove", _nonce, _spender, _value, _reward)); 
    }

    function metaIncreaseAllowanceHash(uint _nonce, address _spender, uint256 _addedValue, uint _reward) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaIncreaseAllowance", _nonce, _spender, _addedValue, _reward));
    }

    function metaDecreaseAllowanceHash(uint _nonce, address _spender, uint256 _subtractedValue, uint _reward) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaDecreaseAllowance", _nonce, _spender, _subtractedValue, _reward));
    }
    
}