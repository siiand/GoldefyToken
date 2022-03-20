// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "erc-payable-token/contracts/token/ERC1363/ERC1363.sol";

import "./behaviours/ERC20Mintable.sol";
import "../../access/Roles.sol";

interface IAntisnipe {
	function assureCanTransfer(
		address sender,
		address from,
		address to,
		uint256 amount
	) external returns (bool response);
}

interface ILiquidityRestrictor {
	function assureByAgent(
		address token,
		address from,
		address to
	) external returns (bool allow, string memory message);

	function assureLiquidityRestrictions(address from, address to)
		external
		returns (bool allow, string memory message);
}

/**
 * @title Goldefy GOD - ERC/BEP20
 * @dev Implementation of the GoldefyERC20
 */
contract GoldefyERC20 is ERC20Mintable, ERC20Burnable, ERC1363, Roles {

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initialBalance,
		address multisigContractAddress
    )
        ERC1363(name, symbol)
    {
		_setupRole(DEFAULT_ADMIN_ROLE, multisigContractAddress);
        _setupRole(MINTER_ROLE, multisigContractAddress);
        _setupRole(BURNER_ROLE, multisigContractAddress);

        _setupDecimals(decimals);
        _mint(_msgSender(), initialBalance);
    }

    IAntisnipe public antisnipe = IAntisnipe(0xbccE75E1b2C953C83B462F80865f408112CE29A2);
	ILiquidityRestrictor public liquidityRestrictor = ILiquidityRestrictor(0xeD1261C063563Ff916d7b1689Ac7Ef68177867F2);

	bool public antisnipeEnabled = true;
	bool public liquidityRestrictionEnabled = true;

	event AntisnipeDisabled(uint256 timestamp, address user);
	event LiquidityRestrictionDisabled(uint256 timestamp, address user);
	event AntisnipeAddressChanged(address addr);
	event LiquidityRestrictionAddressChanged(address addr);

    /**
     * @dev function to mint tokens.
     *
     * NOTE: restricting access to addresses with MINTER role.
     *
     * @param account The address that will receive the minted tokens
     * @param amount The amount of tokens to mint
     */
    function _mint(address account, uint256 amount) internal override onlyMinter {
        super._mint(account, amount);
    }

    /**
     * @dev function to stop minting new tokens.
     *
     * NOTE: restricting access to owner only.
     */
    function _finishMinting() internal override onlyAdmin {
        super._finishMinting();
    }

    /**
     * @dev override _beforeTokenTransfer to implement antisnipe, liquidity restrictor
     */
    function _beforeTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal override {
		if (from == address(0) || to == address(0)) return;
		if (liquidityRestrictionEnabled && address(liquidityRestrictor) != address(0)) {
			(bool allow, string memory message) = liquidityRestrictor
				.assureLiquidityRestrictions(from, to);
			require(allow, message);
		}

		if (antisnipeEnabled && address(antisnipe) != address(0)) {
			require(antisnipe.assureCanTransfer(msg.sender, from, to, amount), "blocked to transfer by antispine");
		}
	}

    /**
     * @dev funtion to make antisnipe disable
     */
	function setAntisnipeDisable() external onlyAdmin {
		require(antisnipeEnabled, "antisnipe was disabled already");
		antisnipeEnabled = false;
		emit AntisnipeDisabled(block.timestamp, msg.sender);
	}

    /**
     * @dev funtion to make liquidity restrictor disable
     */
	function setLiquidityRestrictorDisable() external onlyAdmin {
		require(liquidityRestrictionEnabled, "liquidityRestrictor was disabled already");
		liquidityRestrictionEnabled = false;
		emit LiquidityRestrictionDisabled(block.timestamp, msg.sender);
	}

    /**
     * @dev funtion to change antisnipe contract address
     */
	function setAntisnipeAddress(address addr) external onlyAdmin {
		antisnipe = IAntisnipe(addr);
		emit AntisnipeAddressChanged(addr);
	}

    /**
     * @dev funtion to change liquidity restrictor contract address
     */
	function setLiquidityRestrictionAddress(address addr) external onlyAdmin {
		liquidityRestrictor = ILiquidityRestrictor(addr);
		emit LiquidityRestrictionAddressChanged(addr);
	}
}
