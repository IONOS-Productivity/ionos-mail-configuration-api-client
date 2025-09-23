# IONOS\MailConfigurationAPI\Client\MailConfigurationAPIApi

All URIs are relative to http://localhost:8080, except if the operation defines another base path.

| Method | HTTP request | Description |
| ------------- | ------------- | ------------- |
| [**createMailbox()**](MailConfigurationAPIApi.md#createMailbox) | **POST** /addons/{brand}/{extRef}/mail | Creates a mailbox on IONOS plattform that is used for nextcloud user |
| [**deleteMailbox()**](MailConfigurationAPIApi.md#deleteMailbox) | **DELETE** /addons/{brand}/{extRef}/mail/user | Deletes mailbox for given nextcloud user |
| [**patchMailbox()**](MailConfigurationAPIApi.md#patchMailbox) | **PATCH** /addons/{brand}/{extRef}/mail/user | update maildata |


## `createMailbox()`

```php
createMailbox($brand, $extRef, $mailCreateData)
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
    $apiInstance->createMailbox($brand, $extRef, $mailCreateData);
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

void (empty response body)

### Authorization

[basicAuth](../../README.md#basicAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`

[[Back to top]](#) [[Back to API list]](../../README.md#endpoints)
[[Back to Model list]](../../README.md#models)
[[Back to README]](../../README.md)

## `deleteMailbox()`

```php
deleteMailbox($brand, $extRef, $nextcloudUsername)
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
$nextcloudUsername = 'nextcloudUsername_example'; // string

try {
    $apiInstance->deleteMailbox($brand, $extRef, $nextcloudUsername);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->deleteMailbox: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUsername** | **string**|  | |

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

## `patchMailbox()`

```php
patchMailbox($brand, $extRef, $nextcloudUsername, $patchMailRequest)
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
$nextcloudUsername = 'nextcloudUsername_example'; // string
$patchMailRequest = new \IONOS\MailConfigurationAPI\Client\Model\PatchMailRequest(); // \IONOS\MailConfigurationAPI\Client\Model\PatchMailRequest

try {
    $apiInstance->patchMailbox($brand, $extRef, $nextcloudUsername, $patchMailRequest);
} catch (Exception $e) {
    echo 'Exception when calling MailConfigurationAPIApi->patchMailbox: ', $e->getMessage(), PHP_EOL;
}
```

### Parameters

| Name | Type | Description  | Notes |
| ------------- | ------------- | ------------- | ------------- |
| **brand** | **string**|  | |
| **extRef** | **string**|  | |
| **nextcloudUsername** | **string**|  | |
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
