//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/**
 * @title Position Options Token
 */
abstract contract PositionOptionsToken is ERC1155Supply {
    string public name = "Position Options Token";
    string public symbol = "POT";
    uint8 public decimals = 18;

    struct FlashLoanFeeRate {
        uint128 providerFeeRate;
        uint128 protocolFeeRate;
    }

    struct Position {
        uint256 stakedAmount;       // Amount of Staked token
        uint256 principalValue;     // The constant value of the principal, measured in native tokens
        uint256 amountInPT;         // Amount of PTs generated
        uint256 deadline;
    }

    mapping(uint256 positionId => Position) public positions;
    
    function burn(address account, uint256 id, uint256 value) public {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()), 
            ERC1155MissingApprovalForAll(_msgSender(), account)
        );

        _burn(account, id, value);
    }

    function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()), 
            ERC1155MissingApprovalForAll(_msgSender(), account)
        );

        _burnBatch(account, ids, values);
    }
}