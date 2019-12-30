let exec = require('child_process').exec;

let vmdir = 'C:\\Program Files (x86)\\VMware\\VMware Workstation';

let vmrun = function (cmd) {
    return exec(`"${vmdir}\\vmrun.exe" ${cmd}`, {
        windowsHide: true,
        timeout: 60000
    });
}

exports.stat = function (vmx) {

    let rs = '';
    let pf = vmrun('list');

    pf.stdout.on('data', function (data) {
        rs += data.includes(vmx) ? 'done' : 'stop';
    });

    pf.stderr.on('data', function (data) {
        rs += data || 'stderr';
    });

    pf.on('exit', function (code) {
        console[code == 0 ? 'log' : 'error'](rs);
    });
};

exports.start = function (vmx) {

    let rs = '';
    let pf = vmrun(`start ${vmx}`);

    pf.stdout.on('data', function (data) {
        if (data && data.includes('Error:')) {
            rs = data.split(':')[1];
        } else {
            rs = data;
        }
    });

    pf.stderr.on('data', function (data) {
        rs = data || 'stderr';
    });

    pf.on('exit', function (code) {
        if (!rs && code == 0) {
            return exports.stat(vmx);
        }
        console[code == 0 ? 'log' : 'error'](rs);
    });
};

exports.stop = function (vmx) {

    let rs = '';
    let pf = vmrun(`stop ${vmx}`);

    pf.stdout.on('data', function (data) {
        if (data && data.includes('Error:')) {
            rs = data.split(':')[1];
        } else {
            rs = data;
        }
    });

    pf.stderr.on('data', function (data) {
        rs = data || 'stderr';
    });

    pf.on('exit', function (code) {
        rs = !rs && code == 0 ? 'done' : rs;
        console[code == 0 ? 'log' : 'error'](rs);
    });
};
