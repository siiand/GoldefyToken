// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol";

// mock class using IERC1363Spender
contract ERC1363SpenderMock is IERC1363Spender {
    bytes4 private _retval;
    bool private _reverts;

    event Approved(
        address sender,
        uint256 amount,
        bytes data,
        uint256 gas
    );

    constructor(bytes4 retval, bool reverts) {
        _retval = retval;
        _reverts = reverts;
    }

    function onApprovalReceived(address sender, uint256 amount, bytes memory data) public override returns (bytes4) {
        require(!_reverts, "ERC1363SpenderMock: throwing");
        emit Approved(sender, amount, data, gasleft());
        return _retval;
    }
}
