// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';
import 'https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol';
import 'https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol';

contract borrower is FlashLoanReceiverBase {
        PoolAddressesProvider provider;
        address dai; //the address of the dai provider
        
        constructor(address _provider, address _dai) FlashLoanReceiverBase(_provider)  public {
            provider = PoolAddressesProvider(_provider);
            dai = _dai;
        }

        function startLoan(uint amount, bytes calldata _params) external {
            IPool lendingPool = IPool(provider.getPool());
            lendingPool.flashLoan(address(this), dai, amount, _params);
        }

        function executeOperation(
            address _reserve,
            uint _amount,
            uint _fee,
            bytes memory _params
        ) external {
            //write your arbitrage code here
            transferFundsBackToPoolInternal(_reserve, amount + fee);

        }
}

