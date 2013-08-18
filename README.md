# Iap Example App

A rails app example to handle the In-App Purchase(IAP)

## Structure

### Files

application.yml - the file to store your secrets, you should not commit it into your source repository

### Models

Item - define what you want to sell, ex: coins used in a RPG game

Sku - define the item, amount and price to sell, ex: $1.99 to buy 100 coins

InAppPurchase - record the IAP information

### Controllers

IapsController - receive the IAP requests from the native app and call IapHandler methods to handle them

### Modules and Classes

IapHandler - a module to handle the IAP.

IapStore - a module to use the IapStore based classes

IapStore::Base - a base class to define the interface which a IapStore-based class should implement

IapStore::AppStore - a IapStore-based class which handle the IASs from iOS AppStore

IapStore::GooglePlay - a IapStore-based class which handle the IASs from Goolge Play

## References

Don't steal coins in my app - Handle the In-App Purchases verification from the server side (Chinese)

## Authors

Sibevin Wang

## Copyright

Copyright (c) 2013 Sibevin Wang. Released under the MIT license.
