# alumni-smart-contract

Based on the [ERC-721] standard, this smart contract allows the creation of a non-fungible token (NFT) that represents a student's degree. The NFT is minted by the university and sent to the student's wallet. The student can then transfer the NFT to a potential employer, who can verify the student's degree by checking the NFT's metadata.

### Prerequisites

- [Node.js](https://nodejs.org/en/)
- [Truffle](https://www.trufflesuite.com/truffle)
- [Ganache](https://www.trufflesuite.com/ganache)
- [Metamask](https://metamask.io/)
- [OpenZeppelin](https://openzeppelin.com/)
- [Infura](https://infura.io/)

### Installation

1. Clone the repo
   ```sh
   git clone
   ```
2. Install NPM packages
   ```sh
   npm install
   ```
3. Copy the .env.example file and rename it to .env
   ```sh
   cp .env.example .env
   ```
4. Fill in the .env file with your Infura project ID and your Metamask mnemonic
   ```sh
   INFURA_PROJECT_ID=your_infura_project_id
   MNEMONIC=your_metamask_mnemonic
   ```
5. Compile the smart contract
   ```sh
   $truffle compile or $npm run compile
   ```
6. Start Ganache
	 ```sh
	 $ganache
	 ```
7. Migrate the smart contract to the blockchain
   ```sh
   $truffle migrate or $npm run migrate
   ```
8. Run the tests
   ```sh
   $truffle test or $npm run test
   ```

### Deployment to Sepolia testnet

1. Create a new project on [Infura](https://infura.io/)
2. Copy the project ID and paste it in the .env file
	 ```sh
	 INFURA_PROJECT_ID=your_infura_project_id
	 ```
3. Create a new wallet on [Metamask](https://metamask.io/)
4. Copy the mnemonic and paste it in the .env file
	 ```sh
	 MNEMONIC=your_metamask_mnemonic
	 ```
5. Enable the Sepolia testnet network in truffle-config.js
6. Run 
	 ```sh
	 truffle deploy --network sepolia
	 ```


<!-- USAGE EXAMPLES -->
## Usage

### Interacting with the smart contract on the Sepolia testnet

In your terminal, run the following command to start the truffle console:
```sh
$truffle console --network sepolia
```
In the truffle console, run the following commands to interact with the smart contract:
```sh
truffle(sepolia)> let instance = await DiplomaToken.deployed()
```
