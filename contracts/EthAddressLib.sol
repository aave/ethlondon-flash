pragma solidity 0.5.16;

library EthAddressLib {
    /**
    * @dev returns the address used within the protocol to identify ETH
    * @return the address assigned to ETH
     */
    function ethAddress() internal pure returns (address) {
        return 0x54A20A29188C5763d41318930F3c91C2f47FF5Ca;
    }
}
