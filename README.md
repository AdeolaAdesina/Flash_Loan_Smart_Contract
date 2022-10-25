# Flash_Loan_Smart_Contract
Here's a simple smart contract that takes a flash loan from the Aave protocol.

What are flash loans? 

Flash loans are uncollateralized loans without borrowing limits in which a user borrows funds and returns them in the same transaction. 

If the user can't repay the loan before the transaction is completed, a smart contract cancels the transaction and returns the money to the lender.

First you should write your basic pragma solidity and license line:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
```

Then define the borrower contract:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract borrower {
    
}
```

Now we will go to the Aave github repo to copy the Aave address provider smart contract so we can interact with it.

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';

contract borrower {

}
```

Now we will define variables in our borrower contract and define a constructor:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';

contract borrower {
        PoolAddressesProvider provider;
        address dai; //the address of the dai provider
        
        constructor(address _provider, address _dai) public {
            provider = PoolAddressesProvider(_provider);
            dai = _dai;
        }
}
```

Now we will create a function to initiate the borrowing process, it will take in two parameters:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';

contract borrower {
        PoolAddressesProvider provider;
        address dai; //the address of the dai provider
        
        constructor(address _provider, address _dai) public {
            provider = PoolAddressesProvider(_provider);
            dai = _dai;
        }

        function startLoan(uint amount, bytes calldata _params) external {
            address lendingPool = provider.getPool();

       }
}
```

We also need the interface of the getPool(), we'll get that at ```https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol```

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';
import 'https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol';

contract borrower {
        PoolAddressesProvider provider;
        address dai; //the address of the dai provider
        
        constructor(address _provider, address _dai) public {
            provider = PoolAddressesProvider(_provider);
            dai = _dai;
        }

        function startLoan(uint amount, bytes calldata _params) external {
            IPool lendingPool = IPool(provider.getPool());
        }
}
```

To initiate the flashloan, we'll call lendingPool.flashloan, input the address of the receiver, then the address of the token you want to borrow, then the amount:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol';
import 'https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol';

contract borrower {
        PoolAddressesProvider provider;
        address dai; //the address of the dai provider
        
        constructor(address _provider, address _dai) public {
            provider = PoolAddressesProvider(_provider);
            dai = _dai;
        }

        function startLoan(uint amount, bytes calldata _params) external {
            IPool lendingPool = IPool(provider.getPool());
            lendingPool.flashLoan(address(this), dai, amount, _params);
        }
}
```

To be able to receive this flasloan, we need to inherit from another Aave smart contract - ```https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol```

Now our borrower contract will inherit from FlashLoanRecieverBase and also add it to the constructor like this:

```
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
}
```

Then we will create a function to recieve the loan and this will receive 4 arguments. Then we will write a function to return the loan and the function comes from flashloanreceiverbase.


```
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
```



