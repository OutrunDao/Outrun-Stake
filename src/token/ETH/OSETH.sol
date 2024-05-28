// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./interfaces/IOSETH.sol";
import "../../blast/GasManagerable.sol";
import "../../utils/Initializable.sol";

/**
 * @title Outrun staked ETH
 */
contract OSETH is IOSETH, ERC20, Initializable, Ownable, GasManagerable {
    address private _orETHStakeManager;

    modifier onlyORETHStakeManager() {
        if (msg.sender != _orETHStakeManager) {
            revert PermissionDenied();
        }
        _;
    }

    constructor(address owner, address gasManager) ERC20("Outrun staked ETH", "osETH") Ownable(owner) GasManagerable(gasManager) {}

    function ORETHStakeManager() external view override returns (address) {
        return _orETHStakeManager;
    }

    /**
     * @dev Initializer
     * @param stakeManager_ - Address of orETHStakeManager
     */
    function initialize(address stakeManager_) external override initializer {
        setORETHStakeManager(stakeManager_);
    }

    /**
     * @dev Only orETHStakeManager can mint when the user stake orETH
     * @param _account Address who stake orETH 
     * @param _amount The amount of deposited orETH
     */
    function mint(address _account, uint256 _amount) external override onlyORETHStakeManager{
        _mint(_account, _amount);
    }

    /**
     * @dev Only orETHStakeManager can burn when the user redempt the orETH 
     * @param _account Address who redempt the orETH
     * @param _amount The amount of redempt orETH
     */
    function burn(address _account, uint256 _amount) external override onlyORETHStakeManager {
        _burn(_account, _amount);
    }

    function setORETHStakeManager(address _stakeManager) public override onlyOwner {
        _orETHStakeManager = _stakeManager;
        emit SetORETHStakeManager(_stakeManager);
    }
}