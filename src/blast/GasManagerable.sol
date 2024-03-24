//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import "./IBlast.sol";

abstract contract GasManagerable {
    IBlast public constant BLAST = IBlast(0x4300000000000000000000000000000000000002);

    address private _gasManager;

    error UnauthorizedAccount(address account);

    error InvalidGasManager(address gasManager);

    event ClaimMaxGas(address indexed recipient, uint256 gasAmount);

    event GasManagerTransferred(address indexed previousGasManager, address indexed newGasManager);

    constructor(address initialGasManager) {
        if (initialGasManager == address(0)) {
            revert InvalidGasManager(address(0));
        }
        _transferGasManager(initialGasManager);

        BLAST.configureClaimableGas();
    }

    modifier onlyGasManager() {
        address msgSender = msg.sender;
        if (gasManager() != msgSender) {
            revert UnauthorizedAccount(msgSender);
        }
        _;
    }

    function gasManager() public view virtual returns (address) {
        return _gasManager;
    }

    /**
     * @dev Read all gas remaining balance 
     */
    function readGasBalance() external view onlyGasManager returns (uint256) {
        (, uint256 gasBanlance, , ) = BLAST.readGasParams(address(this));
        return gasBanlance;
    }

    /**
     * @dev Claim max gas of this contract
     * @param recipient - Address of receive gas
     */
    function claimMaxGas(address recipient) external onlyGasManager returns (uint256 gasAmount) {
        gasAmount = BLAST.claimMaxGas(address(this), recipient);
        emit ClaimMaxGas(recipient, gasAmount);
    }

    function transferGasManager(address newGasManager) public virtual onlyGasManager {
        if (newGasManager == address(0)) {
            revert InvalidGasManager(address(0));
        }
        _transferGasManager(newGasManager);
    }

    function _transferGasManager(address newGasManager) internal virtual {
        address oldGasManager = _gasManager;
        _gasManager = newGasManager;
        emit GasManagerTransferred(oldGasManager, newGasManager);
    }
}