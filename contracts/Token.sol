// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import './openzeppelin/erc20/ERC20.sol';
import './openzeppelin/AccessControl.sol';

contract Token is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
    bool public onlyWhitelist;

    constructor(string memory name, string memory symbol, address owner, bool whitelistState) ERC20(name, symbol) {
        require(owner != address(0), "No Owner");
        onlyWhitelist = whitelistState;
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(MINTER_ROLE, owner);
        _setupRole(WHITELIST_ROLE, owner);
    }

    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "NO MINTER_ROLE");
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        // Can only transfer to whitelisted users if in onlyWhitelist mode
        if (onlyWhitelist == true) {
            require(hasRole(WHITELIST_ROLE, _msgSender()), "NO WHITELIST_ROLE");
        }
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        _approve(account, _msgSender(), currentAllowance - amount);
        _burn(account, amount);
    }
}
