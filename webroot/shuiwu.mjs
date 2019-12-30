let vmrun = require('./libs/vmrun.mjs');

let vmx = 'D:\\vMachine\\Windows7\\Windows7.vmx';

let cmd = process.argv[2];

if (['stat', 'start', 'stop'].includes(cmd)) {
    return vmrun[cmd](vmx);
}

console.log('error cmd');
