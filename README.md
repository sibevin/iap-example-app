# Iap Example App

A rails app example to handle the In-App Purchase(IAP)

## How to run it

1. Copy config/application.example.yml to config/application.yml
2. Copy config/database.example.yml to config/database.yml
3. Fill the information in config/application.yml
4. Run rake db:create && rake db:migrate && rake db:seed
5. Run rails s

## How to test it

Just run

    rake spec

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

IapHandler - a module to handle the IAP

IapStore - a module to use the IapStore based classes

IapStore::Base - the base class to define the interface which a IapStore-based class should implement

IapStore::AppStore - an IapStore-based class which handle the IAPs from iOS AppStore

IapStore::GooglePlay - an IapStore-based class which handle the IAPs from Goolge Play

AppError - a module to define the exception used in app

AppError::Base - the base class to define the interface which a AppError-based class should implement

AppError::IapError - an AppError-based class which handle the errors in the IAP checking flow

AppError::IapAppStoreError - an AppError-based class which handle the errors in the AppStore IAP checking flow

## References

Don't steal coins in my app - Handle the In-App Purchases verification from the server side (Chinese)

## Authors

Sibevin Wang

## Copyright

Copyright (c) 2013 Sibevin Wang. Released under the MIT license.
