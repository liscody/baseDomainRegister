# Solidity API

## DomainsRegistry

### DOMAIN_NAME_SEPARATOR

```solidity
string DOMAIN_NAME_SEPARATOR
```

### MAX_DOMAIN_NAME_LENGTH

```solidity
uint8 MAX_DOMAIN_NAME_LENGTH
```

### registrationFee

```solidity
uint256 registrationFee
```

### subdomainPrice

```solidity
uint256 subdomainPrice
```

### domainOwners

```solidity
mapping(string => address) domainOwners
```

### rewards

```solidity
mapping(address => mapping(address => uint256)) rewards
```

### SubdomainPriceSet

```solidity
event SubdomainPriceSet(uint256 subdomainPrice)
```

### RegistrationFeeSet

```solidity
event RegistrationFeeSet(uint256 registrationFee)
```

### DomainRegistered

```solidity
event DomainRegistered(string domainName, address owner)
```

### InsufficientFundsToRegisterDomain

```solidity
error InsufficientFundsToRegisterDomain()
```

### DomainAlreadyRegistered

```solidity
error DomainAlreadyRegistered()
```

### SubdomainShouldBeRegistered

```solidity
error SubdomainShouldBeRegistered()
```

### IvalidLength

```solidity
error IvalidLength()
```

### EmptyDomainNameProhibited

```solidity
error EmptyDomainNameProhibited()
```

### ZeroSubdomainPrice

```solidity
error ZeroSubdomainPrice()
```

### ZeroRegistrationFee

```solidity
error ZeroRegistrationFee()
```

### initialize

```solidity
function initialize(uint256 registrationFee_, uint256 subdomainPrice_) external
```

### registerDomain

```solidity
function registerDomain(string[] domainName, address currency) external payable
```

Registers a domain with the specified name and currency.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| domainName | string[] | The array of strings representing the domain name. |
| currency | address | The address of the currency used for registration. |

### setSubdomainPrice

```solidity
function setSubdomainPrice(uint256 subdomainPrice_) public
```

### setRegistrationFee

```solidity
function setRegistrationFee(uint256 registrationFee_) public
```

### _makePayment

```solidity
function _makePayment(address _currency, uint256 baseAmount) internal
```

### _getFullDomen

```solidity
function _getFullDomen(string[] _domainName, uint256 _length, address _currency) internal returns (string)
```

