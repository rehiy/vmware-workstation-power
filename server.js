#!/usr/bin/env node

if (process.argv[2] == null) {
    process.argv[2] = '127.0.0.1:8011';
    process.argv[3] = __dirname + '\\webroot';
}

require('webox-node');
