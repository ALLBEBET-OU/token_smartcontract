pragma solidity >= 0.5.0;

import "./openzeppelin-solidity/token/ERC20/ERC20Detailed.sol";
import "./openzeppelin-solidity/token/ERC20/SafeERC20.sol";
import "./Token.sol";

/**
 * @title Allbebet Token Contract
 *  Fully compatible with ERC20 standard
 *  Supports native meta transactions
 */
contract ALBToken is Token, ERC20Detailed {
    using SafeERC20 for ERC20;

    uint256 startdate;

    address beneficiary1;
    address beneficiary2;
    address beneficiary3;
    address beneficiary4;
    address beneficiary5;

    constructor() public ERC20Detailed("ALLBEBET", "ALB", 0) {
        uint256 amount = 1000000000 * (10 ** uint256(decimals()));
        _mint(address(this), amount);

        startdate = 1566766800;

        beneficiary1 = 0x5A9215ef09BeC521c9B262d76D240876111D07e5;
        beneficiary2 = 0x8F06CEDA61783943281c39e9a5C815c601C048b4;
        beneficiary3 = 0xC26E68628bD473153de037eFd9B8976D1D69B18F;
        beneficiary4 = 0x17040a1ca8B599E0da7d63A0bEF5d968eec40a3b;
        beneficiary5 = 0x9a5058548C5DE03d038aD1706A16e2FDA4080Ff9;

        _freezeTo(address(this), beneficiary1, totalSupply().mul(375).div(1000), uint64(startdate + 183 days));
        _freezeTo(address(this), beneficiary1, totalSupply().mul(375).div(1000),uint64(startdate + 365 days));
        _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(1000), uint64(startdate + 183 days));
        _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(1000), uint64(startdate + 365 days));
        _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100), uint64(startdate + 183 days));
        _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100), uint64(startdate + 365 days));

        _transfer(address(this), beneficiary4, totalSupply().mul(9).div(100));
        _transfer(address(this), beneficiary5, totalSupply().mul(3).div(100));
    }
}
