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
                username: $('#user').val(),
                api_token: token
            },
            method: 'POST'
        }).done(function(data){
            $('#msgBox').text(data.result);
        }).fail(function(xhr){
        })
    });
})();
