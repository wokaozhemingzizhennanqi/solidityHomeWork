// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

contract Loop{
    uint public  showI;
    function loop() public {
        uint i =0;
        for(i;i<10;i++){
               if (i == 3) {
                // Skip to next iteration with continue
                continue;
            }
            if (i == 5) {
                // Exit loop with break
                showI=i;
                break;
            }
        }
    }
}