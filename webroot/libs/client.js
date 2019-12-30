var $ = function (s) {
    return document.querySelector(s);
};

var xhrGet = function (url, fn) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            try {
                fn && fn.call(xhr, xhr.responseText);
            } catch (err) {
                console && console.warn(err);
            }
        }
    };
    xhr.open('GET', url, true);
    xhr.send(null);
};

/////////////////////////////////////////////////////////////////////////////////////////////

var vmid, vmdo, vmrun = {};

vmrun.stat = function () {
    $('.stat em').innerHTML = '正在刷新...';
    vmdo || xhrGet(vmid + '.mjs?stat', function (data) {
        if (data.trim() == 'done') {
            $('.stat em').innerHTML = '已开机';
            $('.start button').disabled = true;
            $('.stop button').disabled = false;
        } else {
            $('.stat em').innerHTML = '已关机';
            $('.start button').disabled = false;
            $('.stop button').disabled = true;
        }
    });
}

vmrun.start = function () {
    if (vmdo) {
        return false;
    }
    vmdo = 'start';
    $('.start button').disabled = true;
    $('.start em').innerHTML = '正在操作...';
    xhrGet(vmid + '.mjs?start', function (data) {
        $('.start em').innerHTML = data;
        setTimeout(function () {
            $('.start em').innerHTML = '';
            vmdo = '';
        }, 15000);
    });
}

vmrun.stop = function () {
    if (vmdo) {
        return false;
    }
    vmdo = 'stop';
    $('.stop button').disabled = true;
    $('.stop em').innerHTML = '正在操作...';
    xhrGet(vmid + '.mjs?stop', function (data) {
        $('.stop em').innerHTML = data;
        setTimeout(function () {
            $('.stop em').innerHTML = '';
            vmdo = '';
        }, 10000);
    });
}
