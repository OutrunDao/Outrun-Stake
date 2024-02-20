// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

 /**
  * @title RETH interface
  */
interface IRETH is IERC20 {
    function mint(address _account, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;

    function setOutETHVault(address _address) external;
    
    event SetOutETHVault(address _address);
}