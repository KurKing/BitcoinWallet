#!/bin/bash

mockolo \
  --sourcedirs BitcoinWallet \
  --destination BitcoinWalletTests/Mocks/GeneratedMocks.swift \
  --testable-imports BitcoinWallet \
  --enable-args-history
