// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.0;

/**
 * @title UNIT
 * @dev UNIT serves as the native currency for the METAUNI project, providing a decentralized and transparent medium of exchange within the ecosystem.
 *
 * @notice Visit [metauni.club/unit](https://metauni.club/unit) for detailed information on UNIT and its functionalities.
 * @notice For insights into the governance and management of UNIT, refer to [metauni.club/dao](https://metauni.club/dao).
 *
 * @dev This ERC-20 compliant token enables seamless transactions, facilitates access to premium features, and plays a pivotal role in the METAUNI community.
 */

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);

    function transfer(address to, uint256 tokens) external returns (bool success);
    function approve(address spender, uint256 tokens) external returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
}

contract UNIT is ERC20Interface, ApproveAndCallFallBack {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 public _totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    mapping(address => bool) public metaAccess;  // Added for access control

    event UnitTransfer(address indexed from, address indexed to, uint256 tokens);
    event UnitApproval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event MetaAccessGranted(address indexed unitHolder);
    event ApprovalReceived(address indexed from, uint256 tokens);  // Added event

    constructor() {
        symbol = "UNIT";
        name = "UNIT";
        decimals = 12;
        _totalSupply = 1_000_000_000_000_000_000_000_000;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens, "Insufficient funds");
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit UnitTransfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit UnitApproval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        require(balances[from] >= tokens, "Insufficient funds");
        require(allowed[from][msg.sender] >= tokens, "Insufficient permission");

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit UnitTransfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view override returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit UnitApproval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }

    function receiveApproval(address from, uint256 tokens, address token,   bytes calldata data) external override {
        require(token == address(this), "Invalid token type");
        require(msg.sender == from, "Unauthorized sender");  // Use the sender directly

        // Check if holds at least 1 token to grant metaaccess
        if (tokens >= 1) {
            // Grant access to premium content or features
            grantMetaAccess(from);
        }

        // Emit an event or perform other actions as needed
        emit ApprovalReceived(from, tokens);
    }

    function grantMetaAccess(address unitHolder) internal {
        // Check if token balance is at least 1
        require(balances[unitHolder] >= 1, "Insufficient UNIT tokens for metaaccess");

        // Update access
        metaAccess[unitHolder] = true;

        // Emit access
        emit MetaAccessGranted(unitHolder);
    }

    receive() external payable {}

    fallback() external payable {
        revert("Fallback function not allowed");
    }
}
