pragma solidity 0.5.16;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./EthAddressLib.sol";

contract FlashExchange is Ownable {
    using SafeMath for uint256;

    uint256 constant FLASHLOAN_LP_YIELD = 18; //18 bps flashloan yield
    uint256 constant FLASHLOAN_LP_YIELD_BASE = 1000; //basis points

    mapping(address => bool) flashboys;

    mapping(address => uint256) assetsMaxYield;

    modifier onlyFlashboys {
        require(flashboys[msg.sender], "Only flashboys can call this function");
        _;
    }

    function addFlashboys(address[] memory _flashboys) public onlyOwner {
        for (uint256 i = 0; i < _flashboys.length; i++) {
            flashboys[_flashboys[i]] = true;
        }
    }

    function addAsset(address _asset, uint256 _maxYield) public onlyOwner {
        assetsMaxYield[_asset] = _maxYield;
    }

    function exchange(address _asset, uint256 _amount)
        public
        payable
        onlyFlashboys
    {
        uint256 yield = _amount.mul(FLASHLOAN_LP_YIELD).div(
            FLASHLOAN_LP_YIELD_BASE
        );

        require(yield <= assetsMaxYield[_asset], "Flashloan is too big");

        if (_asset == EthAddressLib.ethAddress()) {
            require(msg.value == _amount, "The value sent is not enough");
            msg.sender.transfer(_amount.add(yield));
        } else {
            //simulating exchange pulling funds from the wallet
            require(
                IERC20(_asset).transferFrom(msg.sender, address(this), _amount)
            );
            require(IERC20(_asset).transfer(msg.sender, _amount.add(yield)));
        }
    }

    function() external payable {}

    function withdraw(address _asset) public onlyOwner {
        if (_asset == EthAddressLib.ethAddress()) {
            msg.sender.transfer(address(this).balance);
        } else {
            //simulating exchange pulling funds from the wallet
            require(
                IERC20(_asset).transfer(
                    msg.sender,
                    IERC20(_asset).balanceOf(address(this))
                )
            );
        }
    }
}
