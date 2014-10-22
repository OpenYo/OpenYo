(function(){
    $('#yo').bind('click', function(){
        var token = localStorage.getItem("apiToken");
        if(token === undefined){
            $('#msgBox').text("ログインしてください。");
            return;
        }
        $.ajax({
            url: '/yo/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                username: $('#to').val(),
                api_token: token
            },
            method: 'POST'
        }).done(function(data){
            $('#msgBox').text(data.result);
        }).fail(function(xhr){
        })
    });
    $('#yoAll').bind('click', function(){
        var token = localStorage.getItem("apiToken");
        if(token === undefined){
            $('#msgBox').text("ログインしてください。");
            return;
        }
        $.ajax({
            url: '/yoall/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                api_token: token
            },
            method: 'POST'
        }).done(function(data){
            $('#YoAllMsgBox').text(data.result);
        }).fail(function(xhr){
        })
    });})();
