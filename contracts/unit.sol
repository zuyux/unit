// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";  

/**
 * @title UNIT
 * @dev UNIT serves as the native currency for the METAUNI project
 */
contract UNIT is ERC20, Ownable {
    // Optional Mapping for Meta Access
    mapping (address => bool) public metaAccess;  

    event MetaAccessGranted(address indexed user);
    event MetaAccessRevoked(address indexed user);
    
    constructor() ERC20("UNIT", "UNIT") {
        // Mint the initial supply
        _mint(msg.sender, 1_000_000_000_000_000_000_000_000); 
    }

    // Function to burn tokens (optional)
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Function to burn tokens from another address (optional)
    function burnFrom(address account, uint256 amount) public {
        _spendAllowance(account, msg.sender, amount);
        _burn(account, amount);
    }
    
    // Functions to manage meta access
    function grantMetaAccess(address user) public onlyOwner {
        require(balanceOf(user) >= 1, "User must hold at least 1 UNIT");
        metaAccess[user] = true;
        emit MetaAccessGranted(user);
    }

    function revokeMetaAccess(address user) public onlyOwner {
        metaAccess[user] = false;
        emit MetaAccessRevoked(user);
    }

    // Function to check if a user has meta access (optional)
    function hasMetaAccess(address user) public view returns (bool) {
        return metaAccess[user];
    }

    // Function to check the token balance of a specific address
    function balanceOfAddress(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Function to check the token balances of multiple addresses (optional)
    function balancesOfAddresses(address[] memory accounts) public view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; i++) {
            balances[i] = balanceOf(accounts[i]);
        }
        return balances;
    }
}
