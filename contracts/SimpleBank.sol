/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

pragma solidity ^0.6.12;

contract SimpleBank {

    //
    // State variables
    //
    address public owner;
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    
    //
    // Events - publicize actions to external listeners
    //
    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint amount);
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Functions
    //
    constructor() public {
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    fallback() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        require(balances[msg.sender] == 0);
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
          require(enrolled[msg.sender] == true);
          balances[msg.sender] += msg.value;
          emit LogDepositMade(msg.sender, msg.value);
          return this.getBalance();
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event    
    function withdraw(uint withdrawAmount) external returns (uint) {
           require(balances[msg.sender] >= withdrawAmount);
           balances[msg.sender] -= withdrawAmount;
           emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
           return this.getBalance();
    }

}
