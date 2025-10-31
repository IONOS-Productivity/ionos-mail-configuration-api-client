# IONOS\MailConfigurationAPI\Client\MailConfigurationAPIApi

All URIs are relative to https://API_HOST/nextcloud, except if the operation defines another base path.

| Method | HTTP request | Description |
| ------------- | ------------- | ------------- |
| [**createMailbox()**](MailConfigurationAPIApi.md#createMailbox) | **POST** /addons/{brand}/{extRef}/mail | Creates a mailbox on IONOS plattform that is used for nextcloud user |
| [**deleteAppPassword()**](MailConfigurationAPIApi.md#deleteAppPassword) | **DELETE** /addons/{brand}/{extRef}/mail/{nextcloudUserId}/apppwd/{appname} | Deletes the app credentials for the given appname |
| [**deleteMailbox()**](MailConfigurationAPIApi.md#deleteMailbox) | **DELETE** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | Deletes mailbox for given nextcloud user |
| [**getAllFunctionalAccounts()**](MailConfigurationAPIApi.md#getAllFunctionalAccounts) | **GET** /addons/{brand}/{extRef}/mail | Returns all functional mailboxes for the given brand and extRef |
| [**getFunctionalAccount()**](MailConfigurationAPIApi.md#getFunctionalAccount) | **GET** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | Returns all functional mailboxes for the given brand and extRef |
| [**patchMailbox()**](MailConfigurationAPIApi.md#patchMailbox) | **PATCH** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | update maildata |
| [**setAppPassword()**](MailConfigurationAPIApi.md#setAppPassword) | **POST** /addons/{brand}/{extRef}/mail/{nextcloudUserId}/apppwd/{appname} | A new password for provided appname will be set and returned |


## `createMailbox()`

```php
createMailbox($brand, $extRef, $mailCreateData): \IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse
```

Creates a mailbox on IONOS plattform that is used for nextcloud user

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$mailCreateData = new \IONOS\MailConfigurationAPI\Client\Model\MailCreateData(); // \IONOS\MailConfigurationAPI\Client\Model\MailCreateData

try {
    $result = $apiInstance->createMailbox($brand, $extRef, $mailCreateData);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->createMailbox: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **mailCreateData** | [**\IONOS\MailConfigurationAPI\Client\Model\MailCreateData**](../Model/MailCreateData.md)|  | |

### Return type

[**\IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse**](../Model/MailAccountResponse.md)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `deleteAppPassword()`

```php
deleteAppPassword($brand, $extRef, $nextcloudUserId, $appname)
```

Deletes the app credentials for the given appname

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$nextcloudUserId = 'nextcloudUserId_example'; // string
$appname = 'appname_example'; // string

try {
    $apiInstance->deleteAppPassword($brand, $extRef, $nextcloudUserId, $appname);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->deleteAppPassword: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUserId** | **string**|  | |
| **appname** | **string**|  | |

### Return type

void (empty response body)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `deleteMailbox()`

```php
deleteMailbox($brand, $extRef, $nextcloudUserId)
```

Deletes mailbox for given nextcloud user

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$nextcloudUserId = 'nextcloudUserId_example'; // string

try {
    $apiInstance->deleteMailbox($brand, $extRef, $nextcloudUserId);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->deleteMailbox: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUserId** | **string**|  | |

### Return type

void (empty response body)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `getAllFunctionalAccounts()`

```php
getAllFunctionalAccounts($brand, $extRef): \IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse
```

Returns all functional mailboxes for the given brand and extRef

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string

try {
    $result = $apiInstance->getAllFunctionalAccounts($brand, $extRef);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->getAllFunctionalAccounts: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |

### Return type

[**\IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse**](../Model/MailAccountResponse.md)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `getFunctionalAccount()`

```php
getFunctionalAccount($brand, $extRef, $nextcloudUserId): \IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse
```

Returns all functional mailboxes for the given brand and extRef

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$nextcloudUserId = 'nextcloudUserId_example'; // string

try {
    $result = $apiInstance->getFunctionalAccount($brand, $extRef, $nextcloudUserId);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->getFunctionalAccount: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUserId** | **string**|  | |

### Return type

[**\IONOS\MailConfigurationAPI\Client\Model\MailAccountResponse**](../Model/MailAccountResponse.md)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `patchMailbox()`

```php
patchMailbox($brand, $extRef, $nextcloudUserId, $patchMailRequest)
```

update maildata

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$nextcloudUserId = 'nextcloudUserId_example'; // string
$patchMailRequest = new \IONOS\MailConfigurationAPI\Client\Model\PatchMailRequest(); // \IONOS\MailConfigurationAPI\Client\Model\PatchMailRequest

try {
    $apiInstance->patchMailbox($brand, $extRef, $nextcloudUserId, $patchMailRequest);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->patchMailbox: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUserId** | **string**|  | |
| **patchMailRequest** | [**\IONOS\MailConfigurationAPI\Client\Model\PatchMailRequest**](../Model/PatchMailRequest.md)|  | |

### Return type

void (empty response body)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `setAppPassword()`

```php
setAppPassword($brand, $extRef, $nextcloudUserId, $appname): string
```

A new password for provided appname will be set and returned

### Example

```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');


// Configure HTTP basic authorization: basicAuth
$config = IONOS\MailConfigurationAPI\Client\Configuration::getDefaultConfiguration()
              ->setUsername('YOUR_USERNAME')
              ->setPassword('YOUR_PASSWORD');



$apiInstance = new IONOS\MailConfigurationAPI\Client\Api\MailConfigurationAPIApi(
    // If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
    // This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$brand = 'brand_example'; // string
$extRef = 'extRef_example'; // string
$nextcloudUserId = 'nextcloudUserId_example'; // string
$appname = 'appname_example'; // string

try {
    $result = $apiInstance->setAppPassword($brand, $extRef, $nextcloudUserId, $appname);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->setAppPassword: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUserId** | **string**|  | |
| **appname** | **string**|  | |

### Return type

**string**

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `text/plain`, `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)
