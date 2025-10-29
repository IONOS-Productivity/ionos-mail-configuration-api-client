<!--
SPDX-FileCopyrightText: 2025 STRATO GmbH
SPDX-License-Identifier: AGPL-3.0-or-later
-->

# IONOSMailConfigurationHandler

This is the API client for the Mail Configuration API


## Installation & Usage

### Requirements

PHP 8.1 and later.

### Composer

To install the bindings via [Composer](https://getcomposer.org/), add the following to `composer.json`:

```json
{
  "repositories": [
    {
      "type": "vcs",
      "url": "https://github.com/ionos-productivity/ionos-mail-configuration-api-client.git"
    }
  ],
  "require": {
    "ionos-productivity/ionos-mail-configuration-api-client": "*@dev"
  }
}
```

Then run `composer install`

### Manual Installation

Download the files and include `autoload.php`:

```php
<?php
require_once('/path/to/IONOSMailConfigurationHandler/vendor/autoload.php');
```

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

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

## API Endpoints

All URIs are relative to *http://localhost:8080*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*MailConfigurationAPIApi* | [**createMailbox**](docs/Api/MailConfigurationAPIApi.md#createmailbox) | **POST** /addons/{brand}/{extRef}/mail | Creates a mailbox on IONOS plattform that is used for nextcloud user
*MailConfigurationAPIApi* | [**deleteAppPassword**](docs/Api/MailConfigurationAPIApi.md#deleteapppassword) | **DELETE** /addons/{brand}/{extRef}/mail/{nextcloudUserId}/apppwd/{appname} | Deletes the app credentials for the given appname
*MailConfigurationAPIApi* | [**deleteMailbox**](docs/Api/MailConfigurationAPIApi.md#deletemailbox) | **DELETE** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | Deletes mailbox for given nextcloud user
*MailConfigurationAPIApi* | [**getAllFunctionalAccounts**](docs/Api/MailConfigurationAPIApi.md#getallfunctionalaccounts) | **GET** /addons/{brand}/{extRef}/mail | Returns all functional mailboxes for the given brand and extRef
*MailConfigurationAPIApi* | [**getFunctionalAccount**](docs/Api/MailConfigurationAPIApi.md#getfunctionalaccount) | **GET** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | Returns all functional mailboxes for the given brand and extRef
*MailConfigurationAPIApi* | [**patchMailbox**](docs/Api/MailConfigurationAPIApi.md#patchmailbox) | **PATCH** /addons/{brand}/{extRef}/mail/{nextcloudUserId} | update maildata
*MailConfigurationAPIApi* | [**setAppPassword**](docs/Api/MailConfigurationAPIApi.md#setapppassword) | **POST** /addons/{brand}/{extRef}/mail/{nextcloudUserId}/apppwd/{appname} | A new password for provided appname will be set and returned

## Models

- [ErrorMessage](docs/Model/ErrorMessage.md)
- [Imap](docs/Model/Imap.md)
- [MailAccountResponse](docs/Model/MailAccountResponse.md)
- [MailCreateData](docs/Model/MailCreateData.md)
- [MailServer](docs/Model/MailServer.md)
- [PatchMailRequest](docs/Model/PatchMailRequest.md)
- [Smtp](docs/Model/Smtp.md)

## Authorization

Authentication schemes defined for the API:
### basicAuth

- **Type**: HTTP basic authentication

## Mock Server

This project includes a mock server configuration for local development and testing using [Prism](https://stoplight.io/open-source/prism).

### Starting the Mock Server

To start the mock server, run:

```bash
npm install
npm run mock
```

The mock server will start on `http://localhost:4010` by default.

### Authentication

All requests to the mock server require HTTP Basic Authentication. You can use any username and password for testing:

```bash
-u "test:test"
```

### Testing Different Response Codes

The POST endpoint `/addons/{brand}/{extRef}/mail` has been configured with multiple example responses for different scenarios. You can use Prism's `Prefer` header to select specific status codes and examples.

#### Success Response (200)
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=200, example=success" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

Response:
```json
{
  "password": "aB3x!9kLmPq2wR5t",
  "email": "testuser@example.com",
  "nextcloudUserId": "nc_1234567890abcdef",
  "server": {
    "imap": {
      "host": "imap.ionos.com",
      "port": 993,
      "sslMode": "SSL"
    },
    "smtp": {
      "host": "smtp.ionos.com",
      "port": 587,
      "sslMode": "STARTTLS"
    }
  }
}
```

#### Bad Request Examples (400)

**Invalid local part:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=400, example=invalidLocalPart" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "invalid@@user",
    "domainPart": "example.com"
  }'
```

**Invalid domain:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=400, example=invalidDomain" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "invalid-domain"
  }'
```

**Missing required fields:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=400, example=missingFields" \
  -d '{}'
```

#### Not Found Examples (404)

**External reference not found:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/unknown123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=404, example=extRefNotFound" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

**Brand not found:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/UNKNOWN/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=404, example=brandNotFound" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

#### Conflict Examples (409)

**Mailbox already exists:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=409, example=mailboxExists" \
  -d '{
    "nextcloudUserId": "nc_existing_user",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

**Email address already in use:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=409, example=emailAddressExists" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "existing",
    "domainPart": "example.com"
  }'
```

#### Precondition Failed Examples (412)

**Context state conflict:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=412, example=stateConflict" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

**Quota exceeded:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=412, example=quotaExceeded" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

#### Internal Server Error Examples (500)

**Internal error:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=500, example=internalError" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

**Database error:**
```bash
curl -u "test:test" -X POST http://localhost:4010/addons/IONOS/test123/mail \
  -H "Content-Type: application/json" \
  -H "Prefer: code=500, example=databaseError" \
  -d '{
    "nextcloudUserId": "nc_1234567890abcdef",
    "localPart": "testuser",
    "domainPart": "example.com"
  }'
```

### Dynamic Response Selection

By default, Prism will return the success response (200). You can force specific status codes by using:
```bash
-H "Prefer: code=400"  # Returns any 400 error example
```

Or combine with a specific example:
```bash
-H "Prefer: code=400, example=invalidLocalPart"  # Returns specific 400 error example
```

## Tests

To run the tests, use:

```bash
composer install
vendor/bin/phpunit
```

## Author



## About this package

This PHP package is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: `2.0.0-SNAPSHOT`
    - Generator version: `7.14.0`
- Build package: `org.openapitools.codegen.languages.PhpClientCodegen`
