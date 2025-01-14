// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { OutrunERC20 } from "../common/OutrunERC20.sol";
import { Initializable } from "../common/Initializable.sol";
import { IPrincipalToken } from "./interfaces/IPrincipalToken.sol";

contract OutrunPrincipalToken is IPrincipalToken, OutrunERC20, Ownable, Initializable {
    address public POT;
    address public UPT;
    bool public UPTConvertiblestatus;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address owner_
    ) OutrunERC20(name_, symbol_, decimals_) Ownable(owner_) {}

    modifier onlyAuthorized() {
        require(msg.sender == POT || (msg.sender == UPT && UPTConvertiblestatus), PermissionDenied());
        _;
    }

    /**
     * @dev Initializer
     * @param _POT - Address of positionOptionContract
     */
    function initialize(address _POT) external virtual override onlyOwner initializer {
        POT = _POT;
    }

    /**
     * @dev Update UPT convertible status
     * @param _UPT - Address of UPT
     * @param _status - UPT convertible status
     */
    function updateConvertibleStatus(address _UPT, bool _status) external override onlyOwner {
        UPT = _UPT;
        UPTConvertiblestatus = _status;

        emit UpdateConvertibleStatus(_UPT, _status);
    }

    /**
     * @dev Only authorized contract can mint
     * @param account - Address who receive PT 
     * @param amount - The amount of minted PT
     */
    function mint(address account, uint256 amount) external override onlyAuthorized {
        _mint(account, amount);
    }

    /**
     * @dev Only authorized contract can burn
     * @param account - The address of the account that owns the PT that have been burned
     * @param amount - The amount of burned PT
     */
    function burn(address account, uint256 amount) external override onlyAuthorized {
        _burn(account, amount);
    }
}
