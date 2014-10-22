(function(){
    $('#auth').bind('click', function(){
        $.ajax({
            url: '/config/list_tokens/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                username: $('#id').val(),
                password: $('#pass').val()
            },
            method: 'GET'
        }).done(function(data){
             if(data.code == "200"){
                 $('#authMsg').text("ログイン成功です。");
                 localStorage.setItem('apiToken', data.result[0]);
             } else {
                 $('#authMsg').text(data.result);
             }
        }).fail(function(xhr){
        })
    });
    $('#logout').bind('click', function(){
        localStorage.clear();
    });
})();
