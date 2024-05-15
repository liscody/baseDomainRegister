/* eslint-disable */
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract DomainsRegistry is Initializable, OwnableUpgradeable {
    // _______________ Libraries _______________
    using SafeERC20 for IERC20;

    // _______________ Constants _______________
    string public constant DOMAIN_NAME_SEPARATOR = ".";
    uint8 public constant MAX_DOMAIN_NAME_LENGTH = 3;

    // _______________ Variables _______________
    uint256 public registrationFee;
    uint256 public subdomainPrice;

    // _______________ Mappings _______________
    mapping(string domainName => address owner) public domainOwners;
    mapping(address domainOwner => mapping(address currency => uint256 balance)) public rewards;

    // _______________ Events _______________
    event SubdomainPriceSet(uint256 indexed subdomainPrice);
    event RegistrationFeeSet(uint256 indexed registrationFee);
    event DomainRegistered(string indexed domainName, address indexed owner);

    // _______________ Errors _______________
    error InsufficientFundsToRegisterDomain();
    error DomainAlreadyRegistered();
    error SubdomainShouldBeRegistered();
    error IvalidLength();
    error EmptyDomainNameProhibited();
    error ZeroSubdomainPrice();
    error ZeroRegistrationFee();

    // _______________ Structs _______________

    // _______________ Initializer _______________
    function initialize(uint256 registrationFee_, uint256 subdomainPrice_) external initializer {
        __Ownable_init(msg.sender);

        setRegistrationFee(registrationFee_);
        setSubdomainPrice(subdomainPrice_);
    }

    /**
     * @notice Registers a domain with the specified name and currency.
     * @param domainName The array of strings representing the domain name.
     * @param currency The address of the currency used for registration.
     */
    function registerDomain(string[] calldata domainName, address currency) external payable {
        uint256 length = domainName.length;
        // validate domain array length
        if (length == 0 || length > MAX_DOMAIN_NAME_LENGTH) revert IvalidLength();

        if (length == 1) {
            // check for empty string domain
            if (bytes(domainName[0]).length == 0) revert EmptyDomainNameProhibited();
            // check if domain already registered
            if (domainOwners[domainName[domainName.length - 1]] != address(0)) revert DomainAlreadyRegistered();

            domainOwners[domainName[0]] = msg.sender;

            rewards[owner()][currency] += registrationFee;

            _makePayment(currency, registrationFee);

            emit DomainRegistered(domainName[0], msg.sender);
        } else {
            string memory curentDomainName = _getFullDomen(domainName, length, currency);

            // check if domain already registered
            if (domainOwners[curentDomainName] != address(0)) revert DomainAlreadyRegistered();

            // connect domain with owner
            domainOwners[curentDomainName] = msg.sender;

            rewards[owner()][currency] += registrationFee;

            _makePayment(currency, (length - 1) * subdomainPrice + registrationFee);

            emit DomainRegistered(curentDomainName, msg.sender);
        }
    }

    function setSubdomainPrice(uint256 subdomainPrice_) public onlyOwner {
        if (subdomainPrice_ == 0) revert ZeroSubdomainPrice();
        subdomainPrice = subdomainPrice_;

        emit SubdomainPriceSet(subdomainPrice_);
    }

    function setRegistrationFee(uint256 registrationFee_) public onlyOwner {
        if (registrationFee_ == 0) revert ZeroRegistrationFee();
        registrationFee = registrationFee_;

        emit RegistrationFeeSet(registrationFee_);
    }

    // _______________ External functions _______________
    // _______________ External view functions _______________
    // _______________ Public functions _______________
    // _______________ Public view functions _______________
    // _______________ Internal functions _______________
    function _makePayment(address _currency, uint256 baseAmount) internal {
        //  check value of registration fee if currency is address(0)
        if (_currency == address(0)) {
            if (msg.value < baseAmount && _currency == address(0)) revert InsufficientFundsToRegisterDomain();
        } else {
            IERC20(_currency).safeTransferFrom(msg.sender, address(this), baseAmount);
        }
    }

    function _getFullDomen(
        string[] calldata _domainName,
        uint256 _length,
        address _currency
    ) internal returns (string memory) {
        string memory parrentDomainName;
        // this loop will create subdomain without first element
        for (uint256 i = 1; i < _length; ++i) {
            // check for empty string domain
            if (bytes(_domainName[i]).length == 0) revert EmptyDomainNameProhibited();
            parrentDomainName = string.concat(parrentDomainName, _domainName[i]);
            // add subdomain owner reward
            rewards[domainOwners[parrentDomainName]][_currency] += subdomainPrice;
            if (i + 1 != _length) {
                parrentDomainName = string.concat(parrentDomainName, DOMAIN_NAME_SEPARATOR);
            }
        }
        // check if parrent domain already registered
        if (domainOwners[parrentDomainName] == address(0)) revert SubdomainShouldBeRegistered();
        // create full domain name
        return string.concat(_domainName[0], DOMAIN_NAME_SEPARATOR, parrentDomainName);
    }

    // _______________ Internal view functions _______________
    // _______________ Private functions _______________
    // _______________ Private view functions _______________
}
