                                     Shitzu Token 

An ERC20-like fungible token built in "Solidity 0.8.28" with extended functionality such as pausing, freezing, minting, burning, capped supply, and ownership control.  

This project is deployed and tested using "Hardhat".



Token Details

- Name: Shitzu  
- Symbol: SHIT  
- Decimals: 18  
- Cap (Max Supply): 20,000,000 SHIT  
- Initial Supply: 20,000,000 SHIT (minted to deployer/owner)  
- Standard: Custom ERC20 Implementation (not using OpenZeppelin)


 Features
- ✅ ERC20 Core Functions   (`transfer`, `approve`, `transferFrom`)  
- ✅ Allowance Management   (`increaseAllowance`, `decreaseAllowance`)  
- ✅ Burnable  (`burnFrom`)  
- ✅ Mintable   (internal `_mint`) – restricted by supply cap  
- ✅ Pausable  (owner can pause/unpause transfers)  
- ✅ Freezable  (owner can freeze/unfreeze accounts)  
- ✅ Ownership Control  (transfer/renounce ownership)  
- ✅ Capped Supply  (cannot mint beyond 20M SHIT)


 Installation & Setup=

Clone the repository and install dependencies:

```bash
git clone https://github.com/Hafsah-Ahmad/ERC-20-TOKEN-WITHOUT-OPENZEPPELIN
cd ERC-20-TOKEN-WITHOUT-OPENZEPPELIN
npm install

-Compile the contract:

npx hardhat compile


-Run tests:

npx hardhat test


-Deploy locally (Hardhat Network):

npx hardhat run scripts/deploy.js --network localhost


-Deploy to testnet (example: Sepolia):

npx hardhat run scripts/deploy.js --network sepolia

-Contract Overview

State Variables=

name, symbol, decimals → token metadata

totalSupply → circulating supply

cap → maximum supply (20,000,000 )

balances → mapping of account balances

allowances → mapping of approvals

paused → global pause toggle

frozenAccounts → tracks frozen accounts

owner → contract owner

-Modifiers=

onlyOwner → restricts functions to owner

whenNotPaused / whenPaused → restricts based on pause state

notFrozen(account) → prevents transfers if account is frozen

-Key Functions

transfer(address to, uint256 amount) → transfer SHIT tokens

approve(address spender, uint256 amount) → approve spending

transferFrom(address from, address to, uint256 amount) → transfer via allowance

increaseAllowance / decreaseAllowance → manage allowance

burnFrom(address account, uint256 amount) → burn tokens using allowance

pause() / unpause() → pause/unpause all transfers

freeze(address account) / unfreeze(address account) → freeze/unfreeze accounts

transferOwnership(address newOwner) → transfer contract ownership

renounceOwnership() → remove owner forever


This project is licensed under the UNLICENSED SPDX identifier (no restrictions).

👩‍💻 Author
Created by Hafsa Ahmad 
📧 Email: hafsa.ahmad043@gmail.com  
🌐 GitHub: [Hafsah-Ahmad](https://github.com/Hafsah-Ahmad)

updates
updates
